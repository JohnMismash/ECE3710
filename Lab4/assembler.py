# Assembler for ECE 3710
# Written by Zach Phelan

import sys


def main(args):
    assembly_file = args[0]
    with open(assembly_file) as fp:
        lines = fp.readlines()

        converted = []
        ln = 1
        for line in lines:
            try:
                assembled = assemble(line)
                converted.append(assembled + '\n')
                print(assembled)
                ln += 1

            except:
                print('Error found on line: ' + str(ln))
                print('---------------')
                print(line)
                return 1

    with open('output.txt', 'w') as fp:
        fp.writelines(converted)


def assemble(line):
    split = line.split()

    if len(split) > 3:
        raise ValueError

    op = split[0]

    if len(split) == 1: # NOP instruction
        if op != 'NOP':
            raise ValueError
        return '0001011100000000'

    elif len(split) == 2: # NOT and jump instructions
        if op != 'NOT' and op[0] != 'J':
            raise ValueError

        if op == 'NOT':
            op = switch_op(op)
            Rdst = switch_reg(split[1])
            return_str = op + Rdst + '0000'

        else:
            op = switch_op(op)
           
            neg = False
            if split[1][0] == '-':
                neg = True
                split[1] = split[1][1:] # Remove negative sign

            bin_val = format(int(split[1]), 'b')
            bin_val = bin_val.zfill(8)

            if neg == True:
                bin_val = bin_val.replace('0', '2')
                bin_val = bin_val.replace('1', '0')
                bin_val = bin_val.replace('2', '1')

                bin_val = bin(int(bin_val, 2) + int('1', 2))
                bin_val = bin_val[2:]
                #bin_val = bin((1 * int(bin_val)) % 2**8)
                #bin_val = bin((-1 * int(bin_val))+(1<<8))

                #bin_val = bin_val.replace('0b', '')

                #bin_val = '1' * (8 - len(bin_val)) + bin_val
            
            return_str = op + bin_val

        return return_str

    else:
        imm = False
        if op == 'ADDI' or op == 'ADDUI' or op == 'ADDCUI' or op == 'ADDCI' or op == 'SUBI' or op == 'CMPI' or op == 'LSHI' or op == 'RSHI':
            imm = True

        if imm == True: # Case for immediate operations
            Rsrc = split[1][:-1]
            Rdst = split[2]

            imm_val = format(int(Rsrc), 'b')
            imm_val = imm_val.zfill(4)

            op = switch_op(op)
            A = switch_reg(Rdst)
            B = imm_val

        else: # All other operations
            Rsrc = split[1][:-1]
            Rdst = split[2]

            if len(Rsrc) > 3 or len(Rdst) > 3:
                raise ValueError

            if len(Rsrc) < 3:
                Rsrc = Rsrc[0] + '0' + Rsrc[1]

            if len(Rdst) < 3:
                Rdst = Rdst[0] + '0' + Rdst[1]

            op = switch_op(op)
            A = switch_reg(Rdst)
            B = switch_reg(Rsrc)


        val = op + A + B
        return val


def switch_op(op):
    if op == 'ADD':
        return '00000000'

    elif op == 'ADDI':
        return '00000001'

    elif op == 'ADDU':
        return '00000010'

    elif op == 'ADDUI':
        return '00000011'

    elif op == 'ADDC':
        return '00000100'

    elif op == 'ADDCU':
        return '00000101'

    elif op == 'ADDCUI':
        return '00000110'

    elif op == 'ADDCI':
        return '00000111'

    elif op == 'SUB':
        return '00001000'

    elif op == 'SUBI':
        return '00001001'

    elif op == 'CMP':
        return '00001010'

    elif op == 'CMPI':
        return '00001011'

    elif op == 'CMPU':
        return '00001100'

    elif op == 'AND':
        return '00001101'

    elif op == 'OR':
        return '00001110'

    elif op == 'XOR':
        return '00001111'

    elif op == 'NOT':
        return '00010000'

    elif op == 'LSH':
        return '00010001'

    elif op == 'LSHI':
        return '00010010'

    elif op == 'RSH':
        return '00010011'

    elif op == 'RSHI':
        return '00010100'

    elif op == 'ALSH':
        return '00010101'

    elif op == 'ARSH':
        return '00010110'

    elif op == 'NOP':
        return '00010111'

    elif op == 'JMP' or op == 'JUMP':
        return '01000000'

    elif op == 'JL':
        return '01000001'

    elif op == 'JG':
        return '01000010'

    elif op == 'JLE':
        return '01000011'

    elif op == 'JGE':
        return '01000100'

    elif op == 'JE':
        return '01000101'

    elif op == 'LOAD':
        return '10011001'

    elif op == 'STOR' or op == 'STORE':
        return '11011010'

    else:
        raise ValueError

def switch_reg(reg):
    if len(reg) == 2:
        reg_value = int(reg[1])

    elif len(reg) == 3:
        reg_value = int(reg[1] + reg[2])

    else:
        raise ValueError

    bin_value = format(reg_value, 'b')

    return bin_value.zfill(4)

if __name__ == '__main__':
    main(sys.argv[1:])
