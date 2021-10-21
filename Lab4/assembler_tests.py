import unittest
from assembler import assemble, switch_op, switch_reg, main

class TestAssemblerMethods(unittest.TestCase):

    def test_switch_op_ADD(self):
        test_str = 'ADD' 
        self.assertEqual(switch_op(test_str), '00000000')

    def test_switch_reg_R0(self):
        test_str = 'R00' 
        self.assertEqual(switch_reg(test_str), '0000')

    def test_switch_reg_all(self):
        for i in range(0, 16):
            test_str = str(i)
            test_str = 'R' + test_str.zfill(2)

            val = switch_reg(test_str)

            correct = format(int(test_str[1:]), 'b')
            correct = correct.zfill(4)

            self.assertEqual(correct, val)


    def test_assemble_all(self):
        op_dict = {
            'ADD': '00000000',
            'ADDI': '00000001',
            'ADDU': '00000010',
            'ADDUI': '00000011',
            'ADDC': '00000100',
            'ADDCU': '00000101',
            'ADDCUI': '00000110',
            'ADDCI': '00000111',
            'SUB': '00001000',
            'SUBI': '00001001',
            'CMP': '00001010',
            'CMPI': '00001011',
            'CMPU': '00001100',
            'AND': '00001101',
            'OR': '00001110',
            'XOR': '00001111',
            'NOT': '00010000',
            'LSH': '00010001',
            'LSHI': '00010010',
            'RSH': '00010011',
            'RSHI': '00010100',
            'ALSH': '00010101',
            'ARSH': '00010110',
            'NOP': '00010111'
        }

        Rsrc_dict = {
            'R0,': '0000',
            'R1,': '0001',
            'R2,': '0010',
            'R3,': '0011',
            'R4,': '0100',
            'R5,': '0101',
            'R6,': '0110',
            'R7,': '0111',
            'R8,': '1000',
            'R9,': '1001',
            'R10,': '1010',
            'R11,': '1011',
            'R12,': '1100',
            'R13,': '1101',
            'R14,': '1110',
            'R15,': '1111'
        }
        
        Rdst_dict = {
            'R0': '0000',
            'R1': '0001',
            'R2': '0010',
            'R3': '0011',
            'R4': '0100',
            'R5': '0101',
            'R6': '0110',
            'R7': '0111',
            'R8': '1000',
            'R9': '1001',
            'R10': '1010',
            'R11': '1011',
            'R12': '1100',
            'R13': '1101',
            'R14': '1110',
            'R15': '1111'
        }

        for op in op_dict:
            for Rsrc in Rsrc_dict:
                for Rdst in Rdst_dict:
                    input_string = op + ' ' + Rsrc + ' ' +  Rdst 
                    correct_answer = op_dict[op] + Rdst_dict[Rdst] + Rsrc_dict[Rsrc]

                    answer = assemble(input_string)
                    
                    self.assertEqual(correct_answer, answer)


        def basic_inequality_test(self):
            s1 = 'ADD R0, R1'
            s2 = 'ADD R1, R0'

            ans1 = assemble(s1)
            ans2 = assemble(s2)

            self.assertFalse(ans1 == ans2)


if __name__ == '__main__':
    unittest.main()
