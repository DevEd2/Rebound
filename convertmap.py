import sys, os, argparse, json
from datetime import datetime

parser = argparse.ArgumentParser(description = 'Convert Tilekit map exports to Game Boy format')
parser.add_argument('infile', metavar = '[input]', type = argparse.FileType('r'), help = 'Input file name')
parser.add_argument('-c', '--compress', help = "compress the map data using Walle Length Encoding", action = 'store_true')
argv = parser.parse_args()
infile=argv.infile


################################################################

# WLE encoding library by Pigu/AYCE
	
# 000x xxxx   - literal short
# 001x xxxx X - literal long
# 010x xxxx   - fill mem
# 011x xxxx Y - fill Y
# 100x xxxx   - longest_inc mem
# 101x xxxx Y - longest_inc Y
# 11xx xxxx Y - copy Y for X
# 1111 1111   - end

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
	out += b"\xff"  # end
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
	map = mapdata['map']
	obj = mapdata['objects']
	
	# initialize level properties
	for x in range(0, len(obj)):
		if obj[x]['name'] == "LevelProperties":
			tileset = obj[x]['Tileset']
			music = obj[x]['Music']
		if obj[x]['name'] == "PlayerStart":
			px = int(obj[x]['x']) // 16
			py = int(obj[x]['y']) // 16
			ps = int(obj[x]['x']) // 256
			pa = int(obj[x]['y']) // 256
	# HERE BE HACKS
	try:
		tileset
		music
	except NameError:
		print("Error: LevelProperties object not found!")
		exit()
	try:
		px
		py
		ps
		pa
	except NameError:
		print("Error: PlayerStart object not found!")
		
	# validate map data
	if(map['w'] %16 != 0):
		print("Error: Map width must be a multiple of 16.")
		infile.close()
		mapfile.close()
		exit()
	if(map['h'] %16 != 0):
		print("Error: Map height must be a multiple of 16.")
		infile.close()
		mapfile.close()
		exit()
	if(map['w'] // 16 > 16):
		print("Error: Too many screens! (max 16, current = " + str((map['w'] // 16) + 1) + ")")
		infile.close()
		outfile.close()
	if(map['h'] // 16 > 4):
		print("Error: Too many subareas! (max 4, current = " + str((map['h'] // 16) + 1) + ")")
		infile.close()
		outfile.close()
		
	now=datetime.now()
	hdrfile.write("; This file was generated by convertmap.py on " + now.strftime("%d/%m/%Y %H:%M:%S") + "\n; DO NOT EDIT!!!\n\n")
	hdrfile.write("section \"Map_" + inname + "\",romx\n\nMap_" + inname + "::\n")
	hdrfile.write(".width      db   " + str((map['w'] // 16) - 1) + "\n")
	hdrfile.write(".height     db   " + str((map['h'] // 16) - 1) + "\n")
	hdrfile.write(".startxy    db   " + str((px << 4) | py) + "\n")
	hdrfile.write(".startsa    db   " + str((pa << 6) | ps) + "\n")
	hdrfile.write(".tileset    db   " + tileset + "\n")
	hdrfile.write(".music      db   " + music + "\n")
	hdrfile.write(".sub1       dw   .data1\n")
	hdrfile.write(".sub2       dw   .data2\n")
	hdrfile.write(".sub3       dw   .data3\n")
	hdrfile.write(".sub4       dw   .data4\n")
	
	sa = (map['h'] // 16)
	
	for i in range(0, sa):
		hdrfile.write(".data" + str(i + 1) + "      incbin \"Levels/" + inname + "-0" + str(i + 1) + ".bin")
		if argv.compress:
			hdrfile.write(".wle")
			hdrfile.write("\"\n")
	if sa == 1:
		hdrfile.write(".data2\n.data3\n.data4      incbin \"Levels/Dummy.bin.wle\"\n")
	if sa == 2:
		hdrfile.write(".data3\n.data4      incbin \"Levels/Dummy.bin.wle\"\n")
	if sa == 3:
		hdrfile.write(".data4      incbin \"Levels/Dummy.bin.wle\"\n")
	
	hdrfile.close()
	
	# write actual map data
	if sa > 0:
		for y in range(0, map['w']):
			for c in range(0, 16):
				mapfile1.write(bytes([(map['data'][c * (map['w']) + y] - 1)]))
	if sa > 1:
		for y in range(0, map['w']):
			for c in range(16, 32):
				mapfile2.write(bytes([(map['data'][c * (map['w']) + y] - 1)]))
	if sa > 2:
		for y in range(0, map['w']):
			for c in range(32, 48):
				mapfile3.write(bytes([(map['data'][c * (map['w']) + y] - 1)]))
	if sa > 3:
		for y in range(0, map['w']):
			for c in range(48, 64):
				mapfile4.write(bytes([(map['data'][c * (map['w']) + y] - 1)]))
	
	
	
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
			