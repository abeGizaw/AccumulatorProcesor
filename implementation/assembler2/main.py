import pandas as pd
from Assembler import Assembler
import os


def assembleInstruction(instruction, myAssembler):
    """
    Convert a single assembly instruction to bytecode.
    """
    if instruction is None or instruction == '' or str(instruction).lower() == 'nan':
        return None

    # Dictionary of opcodes. Similar to Hashmap in Java
    opcodes = {
        "add": {"type": "R", "binary": "00000"},
        "sub": {"type": "R", "binary": "00001"},
        "xor": {"type": "R", "binary": "00010"},
        "or": {"type": "R", "binary": "00011"},
        "and": {"type": "R", "binary": "00100"},
        "sll": {"type": "R", "binary": "00101"},
        "set": {"type": "I", "binary": "00110"},
        "stop": {"type": "J", "binary": "00111"},
        "ori": {"type": "I", "binary": "01000"},
        "xori": {"type": "I", "binary": "01001"},
        "andi": {"type": "I", "binary": "01010"},
        "addi": {"type": "I", "binary": "01011"},
        "slli": {"type": "I", "binary": "01100"},
        "srli": {"type": "I", "binary": "01101"},
        "srai": {"type": "I", "binary": "01110"},
        "slt": {"type": "R", "binary": "01111"},
        "beq": {"type": "B", "binary": "10000"},
        "bne": {"type": "B", "binary": "10001"},
        "blt": {"type": "B", "binary": "10010"},
        "bge": {"type": "B", "binary": "10011"},
        "jal": {"type": "J", "binary": "10100"},
        "load": {"type": "R", "binary": "10101"},
        "store": {"type": "R", "binary": "10110"},
        "storesp": {"type": "I", "binary": "10111"},
        "loadsp": {"type": "I", "binary": "11000"},
        "movesp": {"type": "J", "binary": "11001"},
        "input": {"type": "J", "binary": "11010"},
        "lui": {"type": "J", "binary": "11011"},
        "jb": {"type": "J", "binary": "11100"},
        "swap": {"type": "C", "binary": "11101"},
        "alter": {"type": "A", "binary": "11110"},
        "output": {"type": "J", "binary": "11111"},
    }

    # splits by spaces. "ADD A B" will return the list ["ADD", "A", "B"]
    instruction = instruction.replace(",", "")
    parts = instruction.split()
    command = parts[0]
    if command not in opcodes:
        addy = myAssembler.getAddressOfSymbol(command.strip(':'))
        return command, addy, ""

    # slice everything after command. ["ADD", "A", "B"] will be ["A", "B"]
    binary = opcodes[command]['binary']
    instructionType = opcodes[command]['type']
    operands = parts[1:]

    if operands:
        match instructionType:
            case "I":
                return myAssembler.handleIType(operands, binary)
            case "R":
                return myAssembler.handleRType(operands, binary)
            case "J":
                return myAssembler.handleJType(operands, binary)
            case "B":
                return myAssembler.handleBType(operands, binary)
            case "A":
                return myAssembler.handleAType(operands, binary)
            case "C":
                return myAssembler.handleCType(operands, binary)
            case _:
                raise ValueError(f"Invalid Type '{instructionType}'")



def processExcel(filePath):
    # Read the Excel file into a DataFrame
    # A DataFrame is a two-dimensional, size-mutable data structure with labeled axes (rows and columns).
    df = pd.read_excel(filePath, sheet_name="Instructions")
    readColumnName = getColumnName(df, "Enter the column name to process: ")
    writeColumnName = getColumnName(df, "Enter the column name to write to: ")

    # Creates a column named Bytecode in Excel
    df[writeColumnName] = df[readColumnName].apply(lambda x: assembleInstruction(x, Assembler()))

    with pd.ExcelWriter(filePath, engine='openpyxl', mode='a', if_sheet_exists='new') as writer:
        df.to_excel(writer, sheet_name='Assembler Results', index=False)


def getColumnName(df, inputString):
    while True:
        column_name = input(inputString)
        if column_name in df.columns:
            return column_name
        else:
            print(f"The column '{column_name}' does not exist. Please try again.")
    pass


def handleExcelFileType():
    filePath = input("Enter the absolute path to the Excel file: ")
    filePath = filePath.strip('"')
    processExcel(filePath)


def alterBytecode(inHex, detailed, param, assembler):
    hexBuilder = []

    # If we want to keep binary values or are at a tag
    if not inHex or param.strip(":") in assembler.symbolDictionary:
        return param.replace(" ", "") if not detailed else param

    # We want to keep spaces and convert to hex
    if detailed:
        parts = param.split()
        for part in parts:
            # Convert Binary -> decimal -> Hex
            hexVal = hex(int(part, 2))
            # Takes of the 0x
            hexBuilder.append(hexVal[2:])

        return ' '.join(hexBuilder)

    param = param.replace(" ", "")
    finalHexVal = hex(int(param, 2))[2:]
    return finalHexVal.zfill(4)


def handleTxtFileType():
    """
    Read assembly instructions from a file and convert them to bytecode.
    """

    # Ask the user for the file path. Only give the option to keep inline comments if they keep spacing
    filePath = input("Enter the absolute path to the assembly file: ")
    resultFilePath = r"tests\assemblerResult"
    resultFilePath = os.path.join(os.path.dirname(__file__), resultFilePath)

    detailed = False if input(
        "Do you want a detailed output (addresses, in-line comments, spacing)?(Y/N) ") == 'N' else True
    inHex = True if input("Do you want values in hex or Binary?(H/B)").upper() == 'H' else False

    filePath = filePath.strip('"')
    instructionOutput = []

    # Set up pre processing
    myAssembler = Assembler()
    myAssembler.processFile(filePath)

    # This line opens the file located at file_path for reading ('r'). It ensures that the file is properly closed after
    # its suite is finished, even if an error occurs.
    with open(filePath, 'r') as file:
        for line in file:
            instruction = line.strip()
            # Ignore empty lines and comments
            if instruction and not line.startswith('//'):
                # print(f"instruction going in is {instruction}")
                instructionInfo = assembleInstruction(instruction, myAssembler)
                instructionOutput.append(instructionInfo)

    with open(filePath, 'a') as file, open(resultFilePath, 'w') as writeFile:
        file.write("\n")
        file.write("\nHex:" if inHex else "\nBinary:")
        file.write("\n")
        for inst in instructionOutput:
            bytecode = alterBytecode(inHex, detailed, inst[0], myAssembler)
            address = int(inst[1], 16)
            comments = inst[2]
            # Calculate the number of spaces needed
            buffer = 26 - len(bytecode)

            if not detailed:
                if bytecode.strip(":") not in myAssembler.symbolDictionary:
                    file.write(f"{bytecode}\n")
                    writeFile.write(f"{bytecode}\n")
            else:
                comments = " ".join(comments)
                file.write(f"{bytecode}{' ' * buffer}~  {len(bytecode.replace(' ', ''))}{' ' * 10} {hex(address)}  "
                           f"{comments}\n")
                writeFile.write(
                    f"{bytecode}{' ' * buffer}~  {len(bytecode.replace(' ', ''))}{' ' * 10} {hex(address)}  "
                    f"{comments}\n")


def main():
    filetype = input("Excel or txt?(E,T)\n")
    if filetype.upper() == "E":
        handleExcelFileType()
    else:
        handleTxtFileType()


if __name__ == "__main__":
    main()
