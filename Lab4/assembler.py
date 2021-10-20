def main(assembly_file):
    with open(assembly_file) as fp:
        lines = fp.readlines()

        converted = []
        ln = 1
        for line in lines:
            try:
                converted.append(assemble(line))
                ln += 1

            except:
                print('Error found on line: ' + str(ln))
                print('---------------')
                print(line)
                return 1

    with open('test_file.txt', 'w') as fp:
        fp.writelines(converted)


def assemble(line):
    split = line.split()

    if len(split) != 3:
        raise ValueError

    op = split[0]
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
    
    return op + Rsrc + Rdst 


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
    reg_value = int(reg[1] + reg[2])

    bin_value = format(reg_value, 'b')

    return bin_value.zfill(4)

main('test.txt')
