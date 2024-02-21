import unittest
from ..helpers import hexToBinary, decimalToBinary


class DecimalToBinary(unittest.TestCase):
    def test_positive_dec(self):
        self.assertEqual(decimalToBinary(5, 3), "101")

    def test_negative_dec(self):
        self.assertEqual(decimalToBinary(-10, 9), "111110110")


class TestHexToBinary(unittest.TestCase):
    def test_positive_hex(self):
        self.assertEqual(hexToBinary("0x1A", 8), "00011010")

    def test_negative_hex(self):
        self.assertEqual(hexToBinary("-0x1A", 8), "11100110")  # Example for 8-bit two's complement of -26

    def test_positive_large_hex(self):
        self.assertEqual(hexToBinary("0x1A2B", 16), "0001101000101011")

    def test_negative_large_hex(self):
        self.assertEqual(hexToBinary("-0x1A2B", 16), "1110010111010101")

    def test_max_positive_for_8_bits(self):
        self.assertEqual(hexToBinary("0xFF", 8), "11111111")

    def test_max_negative_for_8_bits(self):
        self.assertEqual(hexToBinary("-0x80", 8), "10000000")

    def test_zero_value(self):
        self.assertEqual(hexToBinary("0x0", 8), "00000000")


if __name__ == '__main__':
    unittest.main()
