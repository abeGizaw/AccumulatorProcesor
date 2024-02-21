def hexToBinary(rawHex, bits):
    # Convert hex to integer if it is a string
    if isinstance(rawHex, str):
        num = int(rawHex, 16)
    else:
        num = rawHex

    # Check if the number is negative
    if num < 0:
        # Compute two's complement for negative numbers
        num = (1 << bits) + num

    # Convert the number to binary and ensure it's of the correct length
    binaryString = bin(num)[2:].zfill(bits)

    return binaryString


def decimalToBinary(num, bits):
    """
    Convert a number to signed binary value
    """
    if isinstance(num, str):
        num = int(num, 10)

    # Check if the number is negative
    if num < 0:
        # Compute two's complement for negative numbers
        num = (1 << bits) + num
    # Format the number as binary with the specified number of bits, padding with zeros if necessary
    binary_format = '{:0' + str(bits) + 'b}'
    return binary_format.format(num)


def isDecimal(s):
    if not isinstance(s, str):
        return False

    try:
        int(s, 10)
        return True
    except ValueError:
        return False


def isHex(s):
    if not isinstance(s, str):
        return False
    try:
        int(s, 10)
        return False
    except ValueError:
        return True


def withinBitLength(value, bits, base):
    # signed values range from -2^(bits-1) to 2^(bits-1) - 1.
    minVal = pow(2, bits - 1) * -1
    maxVal = pow(2, bits - 1) - 1

    if base == 10:
        if isinstance(value, str):
            value = int(value, 10)
    elif base == 16:
        if isinstance(value, str):
            value = int(value, 16)
    elif base == 2:
        if isinstance(value, str):
            value = int(value, 2)

    print(f'min: {minVal} max: {maxVal} val:{value}')


    return minVal <= value <= maxVal


# Given 2 hex values, preceded with 0x, returned the num of lines between them
def diffLinesHexValues(origin, target):
    diffInAddy = int(target, 16) - int(origin, 16)
    # Account for the quartus code to add 2 to pc it jumps. So jump one line less
    return (int(diffInAddy / 2)) - 1
