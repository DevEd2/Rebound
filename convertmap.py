import sys, os, argparse, json
from datetime import datetime

parser = argparse.ArgumentParser(description = 'Convert Tilekit map exports to Game Boy format')
parser.add_argument('infile', metavar = '[input]', type = argparse.FileType('r'), help = 'Input file name')
parser.add_argument('-c', '--compress', help = "compress the map data using Walle Length Encoding", action = 'store_true')
argv = parser.parse_args()
infile=argv.infile


################################################################

# WLE encoding library by Pigu/AYCE
	
# 000x xxxx	  - literal short
# 001x xxxx X - literal long
# 010x xxxx	  - fill mem
# 011x xxxx Y - fill Y
# 100x xxxx	  - longest_inc mem
# 101x xxxx Y - longest_inc Y
# 11xx xxxx Y - copy Y for X
# 1111 1111	  - end

def writelit(buf, start, end):
	out = bytearray()
	while start < end:
		l = min(end - start, 8192) - 1
		if l > 31:
			out += bytearray([0x20 + (l >> 8), l & 255]) + buf[start : start + l + 1]
		else:
			out += bytearray([l]) + buf[start : start + l + 1]
		start += 8192
	return out

def encodeWLE(buf):
	out = bytearray()
	hold = 0
	lit = 0
	pos = 0
	while pos < len(buf):
		pos2 = pos
		while pos2 < min(len(buf), pos + 32) and buf[pos2] == buf[pos]:
			pos2 += 1
		longest_fill = pos2 - pos
		pos2 = pos
		curinc = buf[pos]
		while pos2 < min(len(buf), pos + 32) and buf[pos2] == curinc:
			curinc += 1
			pos2 += 1
		longest_inc = pos2 - pos
		if buf[pos] == hold:
			longest_fill += 1
			longest_inc += 1
		copies = []
		for j in range(max(pos - 256, 0), pos):
			if buf[j] == buf[pos]:
				copies.append((j, 1))
		longest_copy = (-1, -1)
		while len(copies) > 0:
			longest_copy = copies.pop(0)
			cmdlen = longest_copy[1]
			if (
				pos + cmdlen < len(buf)
				and buf[longest_copy[0] + cmdlen] == buf[pos + cmdlen]
			):
				copies.append((longest_copy[0], cmdlen + 1))
		if longest_copy[1] > 63:
			longest_copy = (longest_copy[0], 63)
		cmd = max((longest_copy[1], 1), (longest_inc, 2), (longest_fill, 3))
		if cmd[0] > 2:
			if lit > 0:
				out += writelit(buf, pos - lit, pos)
			lit = 0
			cmdlen = cmd[0]
			if cmd[1] == 1:
				out += bytearray([0xC0 + cmdlen - 1, pos - longest_copy[0] - 1])
			elif cmd[1] == 2:
				if buf[pos] == hold:
					cmdlen -= 1
					out += bytearray([0x80 + cmdlen - 1])
				else:
					out += bytearray([0xA0 + cmdlen - 1, buf[pos]])
				hold = buf[pos] + cmdlen
			else:
				if buf[pos] == hold:
					cmdlen -= 1
					out += bytearray([0x40 + cmdlen - 1])
				else:
					out += bytearray([0x60 + cmdlen - 1, buf[pos]])
				hold = buf[pos]
			pos += cmdlen
		else:  # literal
			lit += 1
			pos += 1
	if lit > 0:
		out += writelit(buf, pos - lit, pos)
	out += b"\xff"	# end
	return out

################################################################

if __name__ == "__main__":
	# open files
	inname = os.path.splitext(infile.name)[0]
	mapfile1 = open(inname + "-01.bin", "wb")
	mapfile2 = open(inname + "-02.bin", "wb")
	mapfile3 = open(inname + "-03.bin", "wb")
	mapfile4 = open(inname + "-04.bin", "wb")
	hdrfile = open(inname + ".inc", "w")
	
	# parse JSON tags
	mapdata = json.loads(infile.read())
	# check for Tiled Map Editor export
	try:
		tv=mapdata['tiledversion']
		print("Converting " + inname + " (Tiled Map Editor format)...")
		map = mapdata['layers'][0]['data']
		obj = mapdata['layers'][1]['objects']
	# if the above fails, we have a Tilekit export
	except KeyError:
		tv = -1
		print("Converting " + inname + " (TileKit format)...")
		map = mapdata['map']
		obj = mapdata['objects']
	
	objlist = []
	objcount = 0
	
	# initialize level properties
	for x in range(0, len(obj)):
		if obj[x]['name'] == "LevelProperties":
			if tv == -1:
				try:
					tileset = obj[x]['Tileset']
				except KeyError:
					print("ERROR: Tileset not set! (Ensure LevelProperties object has Tileset tag set)")
					exit(1)
				try:
					music = obj[x]['Music']
				except KeyError:
					print("ERROR: Level music not set! (Ensure LevelProperties object has Music tag set)")
					exit(1)
				try:
					background = obj[x]['Background']
				except KeyError:
					print("ERROR: Background not set! (Ensure LevelProperties object has Background tag set)")
					exit(1)
				try:
					palette = obj[x]['Palette']
				except KeyError:
					print("ERROR: Palette not set! (Ensure LevelProperties object has Palette tag set)")
					exit(1)
			else:
				r = 0
				for q in range(0,len(obj[x]['properties'])):
					if obj[x]['properties'][q]['name'] == "Tileset":
						tileset = obj[x]['properties'][q]['value']
						r += 1
					elif obj[x]['properties'][q]['name'] == "Music":
						music = obj[x]['properties'][q]['value']
						r += 1
					elif obj[x]['properties'][q]['name'] == "Background":
						background = obj[x]['properties'][q]['value']
						r += 1
					elif obj[x]['properties'][q]['name'] == "Palette":
						palette = obj[x]['properties'][q]['value']
						r += 1
				if r != 4:
					print("ERROR: Some level properties weren't set! (Ensure LevelProperties object has the Tileset, Music, Background, and Palette tags set)")
					exit(1)
		elif obj[x]['name'] == "PlayerStart":
			try:
				px = int(obj[x]['x']) // 16
				py = int(obj[x]['y']) // 16
				ps = int(obj[x]['x']) // 256
				pa = int(obj[x]['y']) // 256
			except KeyError:
				print("Error: PlayerStart object doesn't exist!")
				exit(1)
		else:
			try:
				a1 = obj[x]['name']
				a2 = ((int(obj[x]['x'])+8) // 256) + ((int(obj[x]['y'])+8) // 256 << 4)
				a3 = (int(obj[x]['x'])+8) % 256
				a4 = (int(obj[x]['y'])+8) % 256
				objlist.append([a1, a2, a3, a4])
			except KeyError:
				print("Error: Object " + obj[x]['name'] + " is missing tags! (Enusre id, x, and y tags are present)")
				exit(1)
			
		
	# validate map data
	if tv == -1:
		if(map['w'] %16 != 0):
			print("Error: Map width must be a multiple of 16.")
			infile.close()
			mapfile.close()
			exit(1)
		if(map['h'] %16 != 0):
			print("Error: Map height must be a multiple of 16.")
			infile.close()
			mapfile.close()
			exit(1)
		if(map['w'] // 16 > 16):
			print("Error: Too many screens! (max 16, current = " + str((map['w'] // 16) + 1) + ")")
			infile.close()
			outfile.close()
			exit(1)
		if(map['h'] // 16 > 4):
			print("Error: Too many subareas! (max 4, current = " + str((map['h'] // 16) + 1) + ")")
			infile.close()
			outfile.close()
			exit(1)
	else:
		if(mapdata['width'] %16 != 0):
			print("Error: Map width must be a multiple of 16.")
			infile.close()
			mapfile.close()
			exit(1)
		if(mapdata['height'] %16 != 0):
			print("Error: Map height must be a multiple of 16.")
			infile.close()
			mapfile.close()
			exit(1)
		if(mapdata['width'] // 16 > 16):
			print("Error: Too many screens! (max 16, current = " + str((map['w'] // 16) + 1) + ")")
			infile.close()
			outfile.close()
			exit(1)
		if(mapdata['height'] // 16 > 4):
			print("Error: Too many subareas! (max 4, current = " + str((map['h'] // 16) + 1) + ")")
			infile.close()
			outfile.close()
			exit(1)
	
	if tv == -1:
		now=datetime.now()
		hdrfile.write("; This file was generated by convertmap.py on " + now.strftime("%d/%m/%Y %H:%M:%S") + "\n; DO NOT EDIT!!!\n\n")
		hdrfile.write("section \"Map_" + inname + "\",romx\n\nMap_" + inname + "::\n")
		hdrfile.write(".width      db       " + str((map['w'] // 16) - 1) + "\n")
		hdrfile.write(".height     db       " + str((map['h'] // 16) - 1) + "\n")
		hdrfile.write(".startxy    db       " + str((px << 4) | py) + "\n")
		hdrfile.write(".startsa    db       " + str((pa << 4) | ps) + "\n")
		hdrfile.write(".music      db       " + music + "\n")
		hdrfile.write(".tileset    bankptr  " + tileset + "\n")
		hdrfile.write(".palette    bankptr  " + palette + "\n")
		hdrfile.write(".background bankptr  " + background + "\n")
		hdrfile.write(".sub1       dw       .data1\n")
		hdrfile.write(".sub2       dw       .data2\n")
		hdrfile.write(".sub3       dw       .data3\n")
		hdrfile.write(".sub4       dw       .data4\n")
		hdrfile.write(".objptr     dw       .objdata\n")
		
		sa = (map['h'] // 16)
		
		for i in range(0, sa):
			hdrfile.write(".data" + str(i + 1) + "       incbin  \"Levels/" + inname + "-0" + str(i + 1) + ".bin")
			if argv.compress:
				hdrfile.write(".wle")
				hdrfile.write("\"\n")
		if sa == 1:
			hdrfile.write(".data2\n.data3\n.data4       db       $ff\n")
		if sa == 2:
			hdrfile.write(".data3\n.data4       db       $ff\n")
		if sa == 3:
			hdrfile.write(".data4       db       $ff\n")
		
		hdrfile.write(".objdata     include \"Levels/ObjectLayouts/" + inname + "_Objects.inc\"\n")
		hdrfile.close()
	else:
		now=datetime.now()
		hdrfile.write("; This file was generated by convertmap.py on " + now.strftime("%d/%m/%Y %H:%M:%S") + "\n; DO NOT EDIT!!!\n\n")
		hdrfile.write("section \"Map_" + inname + "\",romx\n\nMap_" + inname + "::\n")
		hdrfile.write(".width      db       " + str((mapdata['width'] // 16) - 1) + "\n")
		hdrfile.write(".height     db       " + str((mapdata['height'] // 16) - 1) + "\n")
		hdrfile.write(".startxy    db       " + str((px << 4) | py) + "\n")
		hdrfile.write(".startsa    db       " + str((pa << 4) | ps) + "\n")
		hdrfile.write(".music      db       " + music + "\n")
		hdrfile.write(".tileset    bankptr  " + tileset + "\n")
		hdrfile.write(".palette    bankptr  " + palette + "\n")
		hdrfile.write(".background bankptr  " + background + "\n")
		hdrfile.write(".sub1       dw       .data1\n")
		hdrfile.write(".sub2       dw       .data2\n")
		hdrfile.write(".sub3       dw       .data3\n")
		hdrfile.write(".sub4       dw       .data4\n")
		hdrfile.write(".objptr     dw       .objdata\n")
		
		sa = (mapdata['height'] // 16)
		
		for i in range(0, sa):
			hdrfile.write(".data" + str(i + 1) + "       incbin  \"Levels/" + inname + "-0" + str(i + 1) + ".bin")
			if argv.compress:
				hdrfile.write(".wle")
				hdrfile.write("\"\n")
		if sa == 1:
			hdrfile.write(".data2\n.data3\n.data4       db       $ff\n")
		if sa == 2:
			hdrfile.write(".data3\n.data4       db       $ff\n")
		if sa == 3:
			hdrfile.write(".data4       db       $ff\n")
		
		hdrfile.write(".objdata     include \"Levels/ObjectLayouts/" + inname + "_Objects.inc\"\n")
		hdrfile.close()
	
	# write object data
	
	# determine which directory delimiter to use	
	if os.name == ("nt"): # Windows
		objfile = open(".\\ObjectLayouts\\" + inname + "_Objects.inc","w")
	else: # All other OSes
		objfile = open("./ObjectLayouts/" + inname + "_Objects.inc","w")
	
	objfile.write("; This file was generated by convertmap.py on " + now.strftime("%d/%m/%Y %H:%M:%S") + "\n; DO NOT EDIT!!!\n\n" + inname + "_Objects:\n    ")
	for x in range(0,len(objlist)):
		objfile.write("db      " + str(objlist[x][0]) + ", " + str(objlist[x][1]) + ", " + str(objlist[x][2]) + ", " + str(objlist[x][3]) + "\n    ")
	objfile.write("db      MONSTER_NULL, 0, 0, 0 ; end of list\n")
	objfile.close()
	
	if tv == -1:
		mw = map['w']
		md = map['data']
	else:
		mw = mapdata['width']
		md = map
	
	# write actual map data
	if sa > 0:
		for y in range(0, mw):
			for c in range(0, 16):
				try:
					mapfile1.write(bytes([(md[c * (mw) + y] - 1)]))
				except ValueError:
					mapfile1.write(bytes([0]))
	if sa > 1:
		for y in range(0, mw):
			for c in range(16, 32):
				try:
					mapfile2.write(bytes([(md[c * (mw) + y] - 1)]))
				except ValueError:
					mapfile2.write(bytes([0]))
	if sa > 2:
		for y in range(0, mw):
			for c in range(32, 48):
				try:
					mapfile3.write(bytes([(md[c * (mw) + y] - 1)]))
				except ValueError:
					mapfile3.write(bytes([0]))
	if sa > 3:
		for y in range(0, mw):
			for c in range(48, 64):
				try:
					mapfile4.write(bytes([(md[c * (mw) + y] - 1)]))
				except ValueError:
					mapfile4.write(bytes([0]))
	
	mapfile1.close()
	mapfile2.close()
	mapfile3.close()
	mapfile4.close()
	infile.close()
	
	
	# compress file if specified
	if argv.compress:
		for i in range(0, sa):
			infile = open(inname + "-0" + str(i + 1) + ".bin", "rb")
			outfile = open(inname + "-0" + str(i + 1) + ".bin.wle", "wb")
			outfile.write(encodeWLE(infile.read()))
			infile.close()
			outfile.close()
			