from helpers import decimalToBinary, hexToBinary, isHex, isDecimal, withinBitLength, diffLinesHexValues


class Assembler:
    def __init__(self):
        self.currentAddress = 0x0000
        # static starts at 0x1E00 = 0001 1110 0000 0000. 0001 111 will always be hard coded
        self.staticAddress = 0x1e00
        self.dynamicAddress = 0x2000
        self.symbolDictionary = {}
        self.instructions = ["add", "sub", "xor", "or", "and", "sll", "set", "stop",
                             "ori", "xori", "andi", "addi", "slli", "srli", "srai", "slt",
                             "beq", "bne", "blt", "bge", "jal", "load", "store",
                             "storesp", "loadsp", "movesp",
                             "input", "lui", "jb", "swap", "alter", "output"]
        self.reggieMap = {"r0": "00", "r1": "01", "r2": "10", "r3": "11"}
        self.alterOperations = {
                                "+": "00000",
                                "-": "00001",
                                ">>>": "00110",
                                ">>": "00111",
                                "L0": "01101",
                                "L1": "01110"
                                }

    def processFile(self, filePath):
        with open(filePath, 'r') as file:
            for line in file:
                instruction = line.strip()
                # Ignore empty lines and comments//
                if instruction and not line.startswith('//'):
                    instruction = instruction.strip(',')
                    parts = instruction.split()
                    # If we are declaring a static variable
                    if ".word" in instruction:
                        self.symbolDictionary[parts[0].strip(':')] = {"address": hex(self.staticAddress)}
                        self.staticAddress += 0x0002
                    # If we are not on an instruction (Start of procedure)
                    elif not self.instructions.__contains__(parts[0]):
                        self.symbolDictionary[parts[0].strip(':')] = {"address": hex(self.currentAddress)}
                    else:
                        self.currentAddress += 0x0002
            self.currentAddress = -0x0002

    def getDictionary(self):
        return self.symbolDictionary

    def setCurrentAddy(self, newAddy):
        self.currentAddress = newAddy

    def getAddressOfSymbol(self, symbol):
        if symbol not in self.symbolDictionary:
            raise ValueError(f"symbol '{symbol}' does not exist.")
        return self.symbolDictionary[symbol]["address"]

    def handleRType(self, operands, binary):
        """
        Handle R type instructions
        ex: add r2 0x11 -> R[2] += 0x1E11 -> 00000 10 0001110000000000
        ex: add r2 zero
        """
        self.currentAddress += 0x0002
        reggie = operands[0]
        address = operands[1]
        if not self.isReggie(reggie):
            raise ValueError(f"reggie '{reggie}' does not exist.")
        if isDecimal(address):
            raise ValueError(f"R wont take decimal value '{address}")
        elif not isHex(address) and address not in self.symbolDictionary:
            raise ValueError(f"address '{address}' can't be accessed")

        if address not in self.symbolDictionary:
            if address.startswith("-"):
                raise ValueError(f"can't have a negative address passed into an R type {address}")
            if int(address, 16) > 511:
                raise ValueError(f"address {address} is more than 11 bits")
            address = hexToBinary(address, 9)
        else:
            address = decimalToBinary(int(self.symbolDictionary[address]['address'], 16), 9)

        if not withinBitLength(address, 11, 2):
            cutOff = len(address) - 9
            address = address[cutOff:]

        binary = f"{address} {self.reggieMap[reggie]} {binary}"

        # Return the binary, address and any comments that were in the instruction
        return binary, hex(self.currentAddress), operands[2:] if len(operands) > 2 else ""

    def handleIType(self, operands, binary):
        """
        Handle I type instructions
        ex: addi r2 0x10   -> R[2] += 2 -> 01011 10 000001010
        ex: subi r2 1
        """
        self.currentAddress += 0x0002
        reggie = operands[0]
        if not self.isReggie(reggie):
            raise ValueError(f"reggie '{reggie}' does not exist.")

        number = operands[1]
        if isHex(number) and withinBitLength(number, 9, 16):
            binaryNumber = hexToBinary(number, 9)
        elif isDecimal(number) and withinBitLength(number, 9, 10):
            binaryNumber = decimalToBinary(int(number), 9)
        else:
            raise ValueError(f"Invalid imm '{number}'")

        binary = f"{binaryNumber} {self.reggieMap[reggie]} {binary}"
        return binary, hex(self.currentAddress), operands[2:] if len(operands) > 2 else ""

    def handleBType(self, operands, binary):
        """
        Handle B type instructions
        ex: bne r0 r1 exit -> if r0 != r1, exit. 10001 00 01 exit(7 bits)
            bge r3 r0 0x6
        """
        self.currentAddress += 0x0002
        lhs = operands[0]
        rhs = operands[1]
        branching = operands[2]

        # Branching only takes addresses
        if isDecimal(branching):
            raise ValueError(f"branching wont take decimal value '{branching}")
        elif not isHex(branching) and branching not in self.symbolDictionary:
            raise ValueError(f"address '{branching}' can't be accessed")

        if branching in self.symbolDictionary:
            branching = self.symbolDictionary[branching]['address']

        # Immediate to calculate How far we are branching
        # print(f"Want to go to {branching} which is type {type(branching)} and are at {hex(self.currentAddress)} type "
        #       f"{type(hex(self.currentAddress))} command {operands}")

        linesToJump = diffLinesHexValues(hex(self.currentAddress), branching)
        if not withinBitLength(linesToJump, 7, 16):
            raise ValueError(
                f"Trying to branch to far away {hex(self.currentAddress)} -> {branching} is {linesToJump} lines "
                f"far. Can only branch back {pow(2, 7 - 1)} and forward {pow(2, 7 - 1) - 1} lines")

        if not self.isReggie(lhs) or not self.isReggie(rhs):
            raise ValueError(f"reggie '{lhs}' or reggie '{rhs}' does not exist.")

        binary = f"{decimalToBinary(linesToJump, 7)} {self.reggieMap[rhs]} {self.reggieMap[lhs]} {binary}"
        return binary, hex(self.currentAddress), operands[3:] if len(operands) > 3 else ""

    def handleJType(self, operands, binary):
        """
        Handle J type instructions
        ex: jal start
            jb 0
            jal 0x1000
            opensp 4 or open 0x4
            lui 100 or lui 0x7FF
        """
        self.currentAddress += 0x0002
        imm = operands[0]

        # if its jal
        if binary == '10100':
            if imm in self.symbolDictionary:
                imm = self.symbolDictionary[imm]['address']

            if isDecimal(imm):
                raise ValueError(f"Won't take decimal value for jal'{imm}'")

            # Immediate to calculate How far we are branching
            # print(f"Want to go to {imm} which is type {type(imm)} and are at {hex(self.currentAddress)} type "
            #       f"{type(hex(self.currentAddress))} command {operands}")
            dest = imm
            imm = diffLinesHexValues(hex(self.currentAddress), imm)

            if not withinBitLength(imm, 11, 16):
                raise ValueError(f"jumping {imm} lines is too far. going from {hex(self.currentAddress)} -> {dest}")
            imm = hexToBinary(imm, 11)

        # Every other J type
        else:
            if isDecimal(imm):
                if not withinBitLength(imm, 11, 10):
                    raise ValueError(f"Too Large of an imm {imm}")
                imm = decimalToBinary(imm, 11)
            elif isHex(imm):
                if not withinBitLength(imm, 11, 16):
                    raise ValueError(f"Too Large of an imm {imm}")
                imm = hexToBinary(imm, 11)
            else:
                raise ValueError(f"Invalid valur for Jtype: '{imm}'")



        binary = f"{imm} {binary}"
        return binary, hex(self.currentAddress), operands[1:] if len(operands) > 1 else ""

    def handleAType(self, operands, binary):
        """
        Handle A type instructions
        alter r1 r2 r3 +
        """
        self.currentAddress += 0x0002
        result = operands[0]
        arg1 = operands[1]
        arg2 = operands[2]

        if not self.isReggie(result) or not self.isReggie(arg1) or not self.isReggie(arg2):
            raise ValueError(f"reggie '{result}' or reggie '{arg1}' or '{arg2}' does not exist.")

        result = self.reggieMap[operands[0]]
        arg1 = self.reggieMap[operands[1]]
        arg2 = self.reggieMap[operands[2]]

        operation = operands[3]
        if operation not in self.alterOperations:
            raise ValueError(f"The operation '{operation}' at '{self.currentAddress}' does not exist")

        operationOpcode = self.alterOperations[operation]
        binary = f"{operationOpcode} {result} {arg2} {arg1} {binary}"
        return binary, hex(self.currentAddress), operands[4:] if len(operands) > 4 else ""

    def handleCType(self, operands, binary):
        """
        Handle C type instructions
        ex: swap r1 r0 -> swapOp 01 00 0000000
        """
        self.currentAddress += 0x0002
        reg1 = operands[0]
        reg2 = operands[1]
        if not self.isReggie(reg1) or not self.isReggie(reg2):
            raise ValueError(f"Reggie '{reg1}' or reggie '{reg2}' does not exist")
        binary = f"0000000 {self.reggieMap[reg2]} {self.reggieMap[reg1]} {binary}"
        return binary, hex(self.currentAddress), operands[2:] if len(operands) > 2 else ""

    def isReggie(self, reg):
        if reg not in self.reggieMap:
            return False
        return True
