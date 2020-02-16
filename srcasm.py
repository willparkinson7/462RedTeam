import sys

opcode = {
    "nop": 0,
    "ld": 1,
    "ldr": 2,
    "st": 3,
    "str": 4,
    "la": 5,
    "lar": 6,
    "br": 8,
    "brl": 9,
    "add": 12,
    "addi": 13,
    "sub": 14,
    "neg": 15,
    "and": 20,
    "andi": 21,
    "or": 22,
    "ori": 23,
    "not": 24,
    "shr": 26,
    "shra": 27,
    "shl": 28,
    "shc": 29
}

opcode_format = {
    "nop": 8,
    "ld": 1,
    "ldr": 2,
    "st": 1,
    "str": 2,
    "la": 1,
    "lar": 2,
    "br": 4,
    "brl": 5,
    "add": 6,
    "addi": 1,
    "sub": 6,
    "neg": 3,
    "and": 6,
    "andi": 1,
    "or": 6,
    "ori": 1,
    "not": 3,
    "shr": 7,
    "shra": 7,
    "shl": 7,
    "shc": 7
}


def readfile(filepath):
    list = []
    with open(filepath) as file: # open file to parse
        lines = file.readlines()
        for line in lines:
            if line != "\n":  # skips over "empty" lines
                # sanitizes string of , and : and ; to split
                line = line.replace(',', ' ')
                line = line.replace(':', '')
                line = line.split(';', 1)[0]

                list.append(line.split())
                print(line.split())
    file.close()

    return list


def assemble(assembly):
    address = 0
    labels = {}  # label : address (-1 if not known)
    for line in assembly:
        binary = ""
        opcode_found = False
        op = 0
        instr_format = 0
        instruction = 0
        params = []
        for i in range(0, len(line)):
            if line[i] == '.org':  # parses "org" assembler directives
                address = line[1]
            elif line[i] in opcode:
                opcode_found = True
                # binary = '{0}'.format(address.zfill(8)) + "\t"
                op = opcode[line[i]]
                instr_format = opcode_format[line[i]]
                #instruction = convert_opcode_bin(line[i])
            elif opcode_found:
                params.append(line[i])
            else:  # checks if label has been encountered, if not, wait for second pass
                label = line[i]
                if label not in labels:
                    labels[label] = -1
                else:
                    label_address = labels[label]
        binary = create_instruction(instr_format, op, params)

# creates a word instruction according to src formatting
# format - int 1-9 according to the 9 different src instruction formats
# params - instruction parameters
def create_instruction(format, opcode, params):
    instruction = ""
    try:
        if format == 0:
            return instruction.zfill(27)
        elif format == 1:


    except:
        print("{*} ERROR: your assembly is wrong")


def convert_opcode_bin(opcode_str):
    op = opcode[opcode_str]
    return format(op, 'b').zfill(5)


def main():
    print("Hello World!")
    filepath = ""
    if len(sys.argv) == 1:
        filepath = input("Enter assembly file path: ")
    else:
        filepath = sys.argv[1]

    readfile(filepath)


if __name__ == "__main__":
    main()
