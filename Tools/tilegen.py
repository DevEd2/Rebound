import sys, struct

def main(argv):
	argc = len(sys.argv)
	if argc == 1:
		PrintUsage()
		exit()
	try:
		infile = open(argv[0],'rb')
	except FileNotFoundError:
		print("ERROR: Input file \"%s\" doesn't exist!" % str(argv[0]))
		exit()
	except OSError:
		print("ERROR: Filename \"%s\" is invalid!" % str(argv[0]))
		exit()
	except IndexError:
		print("This should never happen")
		exit()
	try:
		outfile = open(argv[1],'wb')
	except OSError:
		print("ERROR: Filename \"%s\" is invalid!" % str(argv[0]))
		exit()
	except IndexError:
		PrintUsage()
		exit()
	
	i=0
	
	a = infile.read()
	print(str(a)+"\n")
	a = a + bytes(64)
	print(str(a)+"\n")
	infile.seek(0)
	
	for j in range(0,16):
		infile.seek(j*128)
		for i in range(0,16):
			print("tile {}".format(i + (j*16)))
			q=infile.tell()
			a = infile.read(4)
			infile.seek(60,1)
			a = a + (infile.read(4))
			infile.seek(q+4)
			print(a)
			outfile.write(a)

def PrintUsage():
	print("tilegen.py - Generate metatiles from SuperFamiconv map exports\nUSAGE: tilegen.py [input] [output]")

if __name__ == "__main__":
	main(sys.argv[1:])