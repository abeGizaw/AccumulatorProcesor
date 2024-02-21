import unittest

import main
from Assembler import Assembler

mainFilePath = (r"G:\My Drive\classes\232CompArch\project\rhit-csse232-2324b-project-pink-2324b-01"
                r"\implementation\assembler2\tests\relPrime.txt")

myAssembler = Assembler()
myAssembler.processFile(mainFilePath)

processAssembler = Assembler()
processAssembler.processFile(r"G:\My Drive\classes\232CompArch\project\rhit-csse232-2324b-project-pink-2324b-01"
                             r"\implementation\assembler2\tests\testTypes.txt")


class TestProcessingFile(unittest.TestCase):
    def test_dict(self):
        result = processAssembler.getDictionary()
        expected = {'temp': {'address': '0x1e00'}, 'result': {'address': '0x1e02'}, 'zero': {'address': '0x1e04'},
                    'one': {'address': '0x1e06'}, 'relPrime': {'address': '0x0'}, 'loop': {'address': '0x2'},
                    'exitRel': {'address': '0x8'}, 'gcd': {'address': '0xa'}, 'continue': {'address': '0xe'},
                    'while': {'address': '0x12'}, 'else': {'address': '0x16'}, 'check': {'address': '0x18'},
                    'exitGcd': {'address': '0x1a'}}

        self.assertEqual(result, expected)


class TestRTypes(unittest.TestCase):
    # R-types will add on 000 1111 to every address

    def RType_Helper(self, result, expectedAddy, expectedOp, expectedReggie):
        partsOfInstruction = result[0].split()
        opcode = partsOfInstruction[2]
        reggie = partsOfInstruction[1]
        addy = partsOfInstruction[0]

        self.assertEqual(opcode, expectedOp)
        self.assertEqual(reggie, expectedReggie)
        self.assertEqual(addy, expectedAddy)
        self.assertEqual(len(addy), 9)

    def test_RType_ADD(self):
        # addy = 0001 0000 0000 ->  1 0000 0000
        addCommand = "add r1 0x100"
        result = main.assembleInstruction(addCommand, myAssembler)
        self.RType_Helper(result, "100000000", "00000", "01")

    def test_RType_SUB(self):
        # addy = 0001 1111 1111 ->  1 0000 0000
        subCommand = "sub r0 0x1FF"
        result = main.assembleInstruction(subCommand, myAssembler)
        self.RType_Helper(result, "111111111", "00001", "00")

    def test_RType_XOR(self):
        # addy = 1111 0010 ->  0 1111 0010
        xorCommand = "xor r3 0xF2"
        result = main.assembleInstruction(xorCommand, myAssembler)
        self.RType_Helper(result, "011110010", "00010", "11")

    def test_RType_OR(self):
        # addy = 0001 ->  0 0000 0001
        orCommand = "or r2 0x1"
        result = main.assembleInstruction(orCommand, myAssembler)
        self.RType_Helper(result, "000000001", "00011", "10")

    def test_RType_AND(self):
        # addy = 1111 1111 ->  0 1111 1111
        andCommand = "and r0 0xFF"
        result = main.assembleInstruction(andCommand, myAssembler)
        self.RType_Helper(result, "011111111", "00100", "00")

    def test_RType_Sll(self):
        # 'temp': {'address': '0x1e00'} 0001 1110 0000 0000 -> 0 0000 0000
        sllCommand = "sll r0 temp"
        result = main.assembleInstruction(sllCommand, processAssembler)
        self.RType_Helper(result, "000000000", "00101", "00")

    def test_RType_SLT(self):
        # 0001 1101 1010 -> 1 1101 1010
        sltCommand = "slt r0 0x1DA"
        result = main.assembleInstruction(sltCommand, myAssembler)
        self.RType_Helper(result, "111011010", "01111", "00")

    def test_RType_LOAD_STORE(self):
        # 0001 0111 0111 -> 1 0111 0111
        # 0001 0101 0101 -> 1 0101 0101
        storeCommand = "store r0 0x177"
        loadCommand = "load r0 0x155"
        resultS = main.assembleInstruction(storeCommand, myAssembler)
        resultL = main.assembleInstruction(loadCommand, myAssembler)
        self.RType_Helper(resultS, "101110111", "10110", "00")
        self.RType_Helper(resultL, "101010101", "10101", "00")

    def test_RType_ADD_TooBig(self):
        # 10 1111 1111 should error. 0x1FF is max
        addCommand = "add r1 0x2FF"
        with self.assertRaises(ValueError):
            main.assembleInstruction(addCommand, myAssembler)

    def test_RType_ADD_decimal(self):
        addCommand = "add r1 10"
        with self.assertRaises(ValueError):
            main.assembleInstruction(addCommand, myAssembler)


class TestITypes(unittest.TestCase):

    def IType_Helper(self, result, imm, op, reg):
        partsOfInstruction = result[0].split()
        addy = partsOfInstruction[0]
        reggie = partsOfInstruction[1]
        opcode = partsOfInstruction[2]
        self.assertEqual(len(addy), 9)
        self.assertEqual(addy, imm)
        self.assertEqual(opcode, op)
        self.assertEqual(reggie, reg)

    def test_IType_ADDI(self):
        addiCommand = "addi r1 12"
        result = main.assembleInstruction(addiCommand, myAssembler)
        self.IType_Helper(result, '000001100', '01011', '01')

    def test_IType_LOADSP(self):
        loadSPCommand = "loadsp r1 0xFF"
        result = main.assembleInstruction(loadSPCommand, myAssembler)
        self.IType_Helper(result, '011111111', '11000', '01')

    def test_IType_STORESP(self):
        storeSPCommand = "storesp r1 0x1"
        result = main.assembleInstruction(storeSPCommand, myAssembler)
        self.IType_Helper(result, '000000001', '10111', '01')

    def test_IType_SET(self):
        setCommand = "set r1 0"
        result = main.assembleInstruction(setCommand, myAssembler)
        self.IType_Helper(result, '000000000', '00110', '01')

    def test_IType_ADDI_BigH(self):
        addiCommand = "addi r1 0xFFFF"
        with self.assertRaises(ValueError):
            main.assembleInstruction(addiCommand, myAssembler)

    def test_IType_ADDI_BigD(self):
        addiCommand = "addi r1 9999999"
        with self.assertRaises(ValueError):
            main.assembleInstruction(addiCommand, myAssembler)


class TestBTypes(unittest.TestCase):

    def test_BType_BGE(self):
        # if r1 >= r2, branch to 0x10. If at 0x00 that is 8 lines ahead
        # 000 1000
        myAssembler.setCurrentAddy(-0x0002)
        bgeCommand = "bge r1 r2 0x10"
        result = main.assembleInstruction(bgeCommand, myAssembler)
        partsOfInstruction = result[0].split()
        opcode = partsOfInstruction[3]
        reggie1 = partsOfInstruction[2]
        reggie2 = partsOfInstruction[1]
        numLinesToJump = partsOfInstruction[0]

        self.assertEqual(len(numLinesToJump), 7)
        self.assertEqual(numLinesToJump, "0000111")
        self.assertEqual(reggie2, "10")
        self.assertEqual(reggie1, "01")
        self.assertEqual(opcode, "10011")

    def test_BType_BEQ(self):
        # if r1 == r2, branch to 0x10. If at 0x14 that is 2 lines back
        # 000 0010
        myAssembler.setCurrentAddy(0x0014)
        beqCommand = "beq r1 r2 0x10"
        result = main.assembleInstruction(beqCommand, myAssembler)
        partsOfInstruction = result[0].split()
        opcode = partsOfInstruction[3]
        reggie1 = partsOfInstruction[2]
        reggie2 = partsOfInstruction[1]
        numLinesToJump = partsOfInstruction[0]

        self.assertEqual(len(numLinesToJump), 7)
        self.assertEqual(numLinesToJump, "1111100")
        self.assertEqual(reggie2, "10")
        self.assertEqual(reggie1, "01")
        self.assertEqual(opcode, "10000")

    def test_BType_BNE(self):
        # continue addy = 0x000E which is 14 lines ahead
        # expect imm = 7 = 000 0111
        processAssembler.setCurrentAddy(-0x0002)
        bneCommand = "bne r1 r2 continue"
        result = main.assembleInstruction(bneCommand, processAssembler)
        partsOfInstruction = result[0].split()
        opcode = partsOfInstruction[3]
        reggie1 = partsOfInstruction[2]
        reggie2 = partsOfInstruction[1]
        numLinesToJump = partsOfInstruction[0]

        self.assertEqual(len(numLinesToJump), 7)
        self.assertEqual(numLinesToJump, "0000110")
        self.assertEqual(reggie2, "10")
        self.assertEqual(reggie1, "01")
        self.assertEqual(opcode, "10001")

    def test_BType_BLT(self):
        # relPrime addy = 0x0000 which is 7 lines back
        # expect imm = -7 = 111 1001
        processAssembler.setCurrentAddy(0x000c)
        bltCommand = "blt r1 r2 relPrime"
        result = main.assembleInstruction(bltCommand, processAssembler)
        partsOfInstruction = result[0].split()
        opcode = partsOfInstruction[3]
        reggie1 = partsOfInstruction[2]
        reggie2 = partsOfInstruction[1]
        numLinesToJump = partsOfInstruction[0]

        self.assertEqual(len(numLinesToJump), 7)
        self.assertEqual(numLinesToJump, "1111000")
        self.assertEqual(reggie2, "10")
        self.assertEqual(reggie1, "01")
        self.assertEqual(opcode, "10010")

    def test_BType_BranchToFar(self):
        bltCommand = "blt r1 r2 0xFFF"
        with self.assertRaises(ValueError):
            main.assembleInstruction(bltCommand, processAssembler)


class TestJTypes(unittest.TestCase):
    # movesp, input, output, jb, jal, lui, stop?
    def JType_Helper(self, result, expectedOp, expectedImm):
        partsOfInstruction = result[0].split()

        opcode = partsOfInstruction[1]
        imm = partsOfInstruction[0]

        self.assertEqual(len(imm), 11)
        self.assertEqual(imm, expectedImm)
        self.assertEqual(opcode, expectedOp)

    def test_JType_MOVESP(self):
        openspCommand = "movesp 0x32"
        result = main.assembleInstruction(openspCommand, myAssembler)
        self.JType_Helper(result, "11001", "00000110010")

    def test_JType_MOVESP_imm(self):
        openspCommand = "movesp 10"
        result = main.assembleInstruction(openspCommand, myAssembler)
        self.JType_Helper(result, "11001", "00000001010")

    def test_JType_MOVESP_neg_imm(self):
        openspCommand = "movesp -10"
        result = main.assembleInstruction(openspCommand, myAssembler)
        self.JType_Helper(result, "11001", "11111110110")

    def test_JType_MOVESP_neg_hex(self):
        openspCommand = "movesp -0x12"
        result = main.assembleInstruction(openspCommand, myAssembler)
        self.JType_Helper(result, "11001", "11111101110")

    def test_JType_MOVESP_TooBig(self):
        closespCommand = "movesp 0x8FF"
        with self.assertRaises(ValueError):
            main.assembleInstruction(closespCommand, myAssembler)

    def test_JType_LUI(self):
        luiCommand = "lui -0xFF"
        result = main.assembleInstruction(luiCommand, myAssembler)
        self.JType_Helper(result, "11011", "11100000001")

    def test_JType_LUI_imm(self):
        luiCommand = "lui 15"
        result = main.assembleInstruction(luiCommand, myAssembler)
        self.JType_Helper(result, "11011", "00000001111")

    def test_JType_JB(self):
        jbCommand = "jb 0x0"
        resultJB = main.assembleInstruction(jbCommand, myAssembler)
        self.JType_Helper(resultJB, "11100", "00000000000")

    def test_JType_INPUT(self):
        inputCommand = "input 0x0"
        resultInput = main.assembleInstruction(inputCommand, myAssembler)
        self.JType_Helper(resultInput, "11010", "00000000000")

    def test_JType_OUTPUT(self):
        outputCommand = "output 0x0"
        resultOutput = main.assembleInstruction(outputCommand, myAssembler)
        self.JType_Helper(resultOutput, "11111", "00000000000")

    def test_JType_JAL(self):
        myAssembler.setCurrentAddy(-0x0002)
        jalCommand = "jal 0x000A"
        result = main.assembleInstruction(jalCommand, myAssembler)
        partsOfInstruction = result[0].split()

        opcode = partsOfInstruction[1]
        imm = partsOfInstruction[0]

        self.assertEqual(len(imm), 11)
        self.assertEqual(imm, "00000000100")
        self.assertEqual(opcode, "10100")

    def test_JType_JAL_bw(self):
        myAssembler.setCurrentAddy(0x000A)  # c
        jalCommand = "jal 0x0002"
        result = main.assembleInstruction(jalCommand, myAssembler)
        partsOfInstruction = result[0].split()

        opcode = partsOfInstruction[1]
        imm = partsOfInstruction[0]

        self.assertEqual(len(imm), 11)
        self.assertEqual(imm, "11111111010")
        self.assertEqual(opcode, "10100")

    def test_JType_JAL_symbol(self):
        processAssembler.setCurrentAddy(-0x0002)
        jalCommand = "jal gcd"
        result = main.assembleInstruction(jalCommand, processAssembler)
        partsOfInstruction = result[0].split()

        opcode = partsOfInstruction[1]
        imm = partsOfInstruction[0]

        self.assertEqual(imm, "00000000100")
        self.assertEqual(len(imm), 11)
        self.assertEqual(opcode, "10100")

    def test_JType_JAL_decimal(self):
        processAssembler.setCurrentAddy(-0x0002)
        jalCommand = "jal 100"
        with self.assertRaises(ValueError):
            main.assembleInstruction(jalCommand, processAssembler)

    def test_JType_JAL_tooBig(self):
        processAssembler.setCurrentAddy(-0x0002)
        jalCommand = "jal 0xFFFF"
        with self.assertRaises(ValueError):
            main.assembleInstruction(jalCommand, processAssembler)


class TestATypes(unittest.TestCase):

    def Alter_Helper(self, result, myRd, myR1, myR2, myAlterOp, myOpcode):
        partsOfInstruction = result[0].split()

        opcode = partsOfInstruction[4]
        rd = partsOfInstruction[1]
        r1 = partsOfInstruction[3]
        r2 = partsOfInstruction[2]
        alterOp = partsOfInstruction[0]

        self.assertEqual(rd, myRd)
        self.assertEqual(r1, myR1)
        self.assertEqual(r2, myR2)
        self.assertEqual(alterOp, myAlterOp)
        self.assertEqual(opcode, myOpcode)

    def test_AType_alter_ADD(self):
        alterCommand = "alter r0 r1 r2 +"
        result = main.assembleInstruction(alterCommand, myAssembler)
        self.Alter_Helper(result, "00", "01", "10", "00000", "11110")

    def test_AType_alter_load0(self):
        alterCommand = "alter r1 r3 r1 L0"
        result = main.assembleInstruction(alterCommand, myAssembler)
        self.Alter_Helper(result, "01", "11", "01", "01101", "11110")

    def test_AType_alter_SRA(self):
        sraCommand = "alter r1 r3 r1 >>"
        result = main.assembleInstruction(sraCommand, myAssembler)
        self.Alter_Helper(result, "01", "11", "01", "00111", "11110")


class TestCTypes(unittest.TestCase):
    def test_CType_swap(self):
        swapCommand = "swap r1 r2"
        result = main.assembleInstruction(swapCommand, myAssembler)
        partsOfInstruction = result[0].split()

        opcode = partsOfInstruction[3]
        reg1 = partsOfInstruction[2]
        reg2 = partsOfInstruction[1]

        self.assertEqual(reg1, "01")
        self.assertEqual(reg2, "10")
        self.assertEqual(opcode, "11101")


if __name__ == '__main__':
    unittest.main()
