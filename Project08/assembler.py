# Template by Bruce A. Maxwell, 2015
#
# implements a simple assembler for the following assembly language
#
# - One instruction or label per line.
#
# - Blank lines are ignored.
#
# - Comments start with a # as the first character and all subsequent
# - characters on the line are ignored.
#
# - Spaces delimit instruction elements.
#
# - A label ends with a colon and must be a single symbol on its own line.
#
# - A label can be any single continuous sequence of printable
# - characters; a colon or space terminates the symbol.
#
# - All immediate and address values are given in decimal.
#
# - Address values must be positive
#
# - Negative immediate values must have a preceeding '-' with no space
# - between it and the number.
#

# Language definition:
#
# LOAD D A   - load from address A to destination D
# LOADA D A  - load using the address register from address A + RE to destination D
# STORE S A  - store value in S to address A
# STOREA S A - store using the address register the value in S to address A + RE
# BRA L      - branch to label A
# BRAZ L     - branch to label A if the CR zero flag is set
# BRAN L     - branch to label L if the CR negative flag is set
# BRAO L     - branch to label L if the CR overflow flag is set
# BRAC L     - branch to label L if the CR carry flag is set
# CALL L     - call the routine at label L
# RETURN     - return from a routine
# HALT       - execute the halt/exit instruction
# PUSH S     - push source value S to the stack
# POP D      - pop form the stack and put in destination D
# OPORT S    - output to the global port from source S
# IPORT D    - input from the global port to destination D
# ADD A B C  - execute C <= A + B
# SUB A B C  - execute C <= A - B
# AND A B C  - execute C <= A and B  bitwise
# OR  A B C  - execute C <= A or B   bitwise
# XOR A B C  - execute C <= A xor B  bitwise
# SHIFTL A C - execute C <= A shift left by 1
# SHIFTR A C - execute C <= A shift right by 1
# ROTL A C   - execute C <= A rotate left by 1
# ROTR A C   - execute C <= A rotate right by 1
# MOVE A C   - execute C <= A where A is a source register
# MOVEI V C  - execute C <= value V
#

# 2-pass assembler
# pass 1: read through the instructions and put numbers on each instruction location
#         calculate the label values
#
# pass 2: read through the instructions and build the machine instructions
#

import sys

# converts d to an 8-bit 2-s complement binary value
def dec2comp8( d, linenum ):
    try:
        if d > 0:
            l = d.bit_length()
            v = "00000000"
            v = v[0:8-l] + format( d, 'b')
        elif d < 0:
            dt = 128 + d
            l = dt.bit_length()
            v = "10000000"
            v = v[0:8-l] + format( dt, 'b')[:]
        else:
            v = "00000000"
            
    except:
        print ('Invalid decimal number on line %d' % (linenum))
        exit()

    return v

# converts d to an 8-bit unsigned binary value
def dec2bin8( d, linenum ):
    if d > 0:
        l = d.bit_length()
        v = "00000000"
        v = v[0:8-l] + format( d, 'b' )
    elif d == 0:
        v = "00000000"
    else:
        print ('Invalid address on line %d: value is negative' % (linenum))
        exit()
    return v


# Tokenizes the input data, discarding white space and comments
# returns the tokens as a list of lists, one list for each line.
#
# The tokenizer also converts each character to lower case.
def tokenize( fp ):
    tokens = []

    # start of the file
    fp.seek(0)

    lines = fp.readlines()

    # strip white space and comments from each line
    for line in lines:
        ls = line.strip()
        uls = ''
        for c in ls:
            if c != '#':
                uls = uls + c
            else:
                break

        # skip blank lines
        if len(uls) == 0:
            continue

        # split on white space
        words = uls.split()

        newwords = []
        for word in words:
            newwords.append( word.lower() )

        tokens.append( newwords )
    return tokens


# reads through the file and returns a dictionary of all location
# labels with their line numbers
def pass1( tokens ):
    labelDict = {}
    for i in tokens:
        if (i[0].endswith(":")):
            labelDict[i[0][0:-1]] = tokens.index(i)
            loop = i #necessary to remove strange deletion error
            tokens.remove(loop)
    return labelDict

def pass2( tokens, labels ):
    regDict = {"ra":"000","rb":"001","rc":"010","rd":"011","re":"100","sp":"101","zeros":"110","pc":"110","ones":"111","cr":"111","ir":"111"}
    opDict = {"load":"0000","loada":"0000","store":"0001","storea":"0001","bra":"0010","braz":"0011","bran":"0011","brao":"0011","brac":"0011","call":"0011","return":"0011","halt":"0011","push":"0100","pop":"0101","oport":"0110","iport":"0111","add":"1000","sub":"1001","and":"1010","or":"1011","xor":"1100","shiftl":"1101","shiftr":"1101","rotl":"1110","rotr":"1110","move":"1111","movei":"1111",}
    instDict = {}
    pos = 0
    for i in tokens:
        try:
            if (i[0] in opDict):
                if (opDict[i[0]] == "0000"):
                    if(i[0].endswith("a")): #loada
                        instDict[pos] = opDict[i[0]] + "0" + regDict[i[1]] + dec2bin8(int(i[2]), tokens.index(i))
                    else: #load
                        instDict[pos] = opDict[i[0]] + "1" + regDict[i[1]] + dec2bin8(int(i[2]), tokens.index(i))
                elif (opDict[i[0]] == "0001"):
                    if(i[0].endswith("a")): #storea
                        instDict[pos] = opDict[i[0]] + "0" + regDict[i[1]] + dec2bin8(int(i[2]), tokens.index(i))
                    else: #store
                        instDict[pos] = opDict[i[0]] + "1" + regDict[i[1]] + dec2bin8(int(i[2]), tokens.index(i))
                elif (opDict[i[0]] == "0010"): #bra
                        instDict[pos] = opDict[i[0]] + "0000" + dec2bin8(labels[i[1]], tokens.index(i))
                elif (opDict[i[0]] == "0011"):
                    if(i[0].endswith("an")): #bran
                        instDict[pos] = opDict[i[0]] + "0010" + dec2bin8(labels[i[1]], tokens.index(i))
                    elif(i[0].endswith("o")): #brao
                        instDict[pos] = opDict[i[0]] + "0001" + dec2bin8(labels[i[1]], tokens.index(i))
                    elif(i[0].endswith("c")): #brac
                        instDict[pos] = opDict[i[0]] + "0011" + dec2bin8(labels[i[1]], tokens.index(i))
                    elif(i[0].endswith("z")): #braz
                        instDict[pos] = opDict[i[0]] + "0000" + dec2bin8(labels[i[1]], tokens.index(i))
                    elif(i[0].endswith("l")): #call
                        instDict[pos] = opDict[i[0]] + "0100" + dec2bin8(labels[i[1]], tokens.index(i))
                    elif(i[0].endswith("rn")): #return
                        instDict[pos] = opDict[i[0]] + "100000000000"
                    elif(i[0].endswith("t")): #halt
                        instDict[pos] = opDict[i[0]] + "110000000000"
                elif (opDict[i[0]] == "0100"): #push
                    instDict[pos] = opDict[i[0]] + regDict[i[1]] + "000000000"
                elif (opDict[i[0]] == "0101"): #pop
                    instDict[pos] = opDict[i[0]] + regDict[i[1]] + "000000000"
                elif (opDict[i[0]] == "0110"): #oport
                    instDict[pos] = opDict[i[0]] + regDict[i[1]] + "000000000"
                elif (opDict[i[0]] == "0111"): #iport
                    instDict[pos] = opDict[i[0]] + regDict[i[1]] + "000000000"
                elif (opDict[i[0]] == "1000"): #add
                    instDict[pos] = opDict[i[0]] + regDict[i[1]] + regDict[i[2]] + "000" + regDict[i[3]]
                elif (opDict[i[0]] == "1001"): #sub
                    instDict[pos] = opDict[i[0]] + regDict[i[1]] + regDict[i[2]] + "000" + regDict[i[3]]
                elif (opDict[i[0]] == "1010"): #and
                    instDict[pos] = opDict[i[0]] + regDict[i[1]] + regDict[i[2]] + "000" + regDict[i[3]]
                elif (opDict[i[0]] == "1011"): #or
                    instDict[pos] = opDict[i[0]] + regDict[i[1]] + regDict[i[2]] + "000" + regDict[i[3]]
                elif (opDict[i[0]] == "1100"): #xor
                    instDict[pos] = opDict[i[0]] + regDict[i[1]] + regDict[i[2]] + "000" + regDict[i[3]]
                elif (opDict[i[0]] == "1101"):
                    if(i[0].endswith("l")): #shiftl
                        instDict[pos] = "0" + opDict[i[0]] + regDict[i[1]] + "00000" + regDict[i[2]]
                    else: #shiftr
                        instDict[pos] = "1" + opDict[i[0]] + regDict[i[1]] + "00000" + regDict[i[2]]
                elif (opDict[i[0]] == "1110"):
                    if(i[0].endswith("l")): #rotl
                        instDict[pos] = "0" + opDict[i[0]] + regDict[i[1]] + "00000" + regDict[i[2]]
                    else: #rotr
                        instDict[pos] = "1" + opDict[i[0]] + regDict[i[1]] + "00000" + regDict[i[2]]
                elif (opDict[i[0]] == "1111"):
                    if(i[0].endswith("i")): #movei
                        instDict[pos] = opDict[i[0]] + "1" + dec2comp8(int(i[1]), tokens.index(i)) + regDict[i[2]]
                    else:
                        instDict[pos] = opDict[i[0]] + "0" + regDict[i[1]] + "00000" + regDict[i[2]]
                pos+=1
            else:
                print("Error: Does not contain a usable argument... " + str(i))
                exit()
        except (IndexError, ValueError, KeyError):
            print("Contains incorrect number of arguments or incorrect argument value... " + str(i))
            exit()
    return instDict

def main( argv ):
    if len(argv) < 2:
        #print 'Usage: python %s <filename>' % (argv[0])
        exit()

    fp = open( argv[1], 'r' )

    tokens = tokenize( fp )
    fp.close()
    
    # execute pass1 and pass2 then print it out as an MIF file
    labelDict = pass1(tokens)
    instDict = pass2(tokens, labelDict)
    f = open("test.mif", "w")
    f.write("DEPTH = 256;\nWIDTH = 16;\nADDRESS_RADIX = HEX;\nDATA_RADIX = BIN;\nCONTENT\nBEGIN\n")
    for i in instDict:
        f.write("%02X : %s;\n" % (i, instDict.get(i)))
    f.write("[%02X..FF] : 1111111111111111;\n" % (len(instDict)))
    f.write("END\n")
    return


if __name__ == "__main__":
    main(sys.argv)
    
