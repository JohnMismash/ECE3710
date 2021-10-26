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

    elif len(split) == 2: # NOT instruction
        if op != 'NOT':
            raise ValueError


        op = switch_op(op)
        Rdst = switch_reg(split[1])
        return_str = op + Rdst + '0000'

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
            Rsrc = switch_reg(Rdst)
            Rdst = imm_val

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
            Rsrc = switch_reg(Rsrc)
            Rdst = switch_reg(Rdst)


        val = op + Rdst + Rsrc
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
