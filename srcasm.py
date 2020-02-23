import sys
import numpy as np

opcode = {
    "nop": 0,
    "ld": 1,
    "ldr": 2,
    "st": 3,
    "str": 4,
    "la": 5,
    "lar": 6,
    "br": 8,
    "brnv": 8,
    "brzr": 8,
    "brnz": 8,
    "brpl": 8,
    "brmi": 8,
    "brl": 9,
    "brlzr": 9,
    "brlnv": 9,
    "brlnz": 9,
    "brlpl": 9,
    "brlmi": 9,
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
    "shc": 29,
    "stop": 31,
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
    "brnv": 4,
    "brzr": 4,
    "brnz": 4,
    "brpl": 4,
    "brmi": 4,
    "brl": 5,
    "brlzr": 5,
    "brlnv": 5,
    "brlnz": 5,
    "brlpl": 5,
    "brlmi": 5,
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
    "shc": 7,
    "stop": 8
}

branch_condition = {
    "": 1,
    "nv": 0,
    "zr": 2,
    "nz": 3,
    "pl": 4,
    "mi": 5
}


def readfile(filepath):
    listl = []
    with open(filepath) as file: # open file to parse
        lines = file.readlines()
        for line in lines:
            if line != "\n":  # skips over "empty" lines
                # sanitizes string of , and : and ; to split
                line = line.replace(',', ' ')
                line = line.replace(':', '')
                line = line.split(';', 1)[0]

                listl.append(line.split())
                # print(line.split())
    file.close()

    return listl


def assemble(assembly):
    assembled = []
    address = 0
    labels = {}  # label : address (-1 if not known)
    begin = True

    # first pass, just looking at labels
    for line in assembly:
        if line:
            if line[0] == '.org' and begin:
                address = int(line[1])
                assembled.append(hex(address)[2:].zfill(8))
                begin = False
            elif line[0] == 'org':
                address = int(line[1])
            elif len(line) > 1 and line[1] == '.org':
                labels[line[0]] = address
                address = int(line[2])
            elif line[0] not in opcode:
                labels[line[0]] = address
                address += 4
            else:
                address += 4

    # second pass
    address = 0
    for line in assembly:
        opcode_found = False
        op_name = ""
        instr_format = 0
        params = []
        for i in range(0, len(line)):
            if line[i] == '.org':  # parses "org" assembler directives
                address = int(line[1])
                break
            elif len(line) > 1 and line[1] == '.org':
                address = int(line[2])
                break
            elif line[i] in opcode:
                opcode_found = True
                op_name = line[i]
                instr_format = opcode_format[line[i]]
            elif opcode_found:
                params.append(line[i])

        if opcode_found:
            instruction = create_instruction(instr_format, op_name, params, labels, address)
            instruction = (hex(int(instruction, 2))[2:]).zfill(8)
            binary = hex(address)[2:].zfill(8) + "\t" + instruction

            assembled.append(binary)
            address += 4

    return assembled


# creates a word instruction according to src formatting
# format - int 1-9 according to the 9 different src instruction formats
# params - instruction parameters
# labels - dictionary of labels (label name : address)
# address - current address of instruction
def create_instruction(instrformat, opcode_name, params, labels, address):
    instruction = ""
    try:
        if instrformat == 0:
            return instruction.zfill(27)
        elif instrformat == 1:  # ADDI, ANDI, ORI, LD, ST, LA
            ra = format_register_param(params[0])
            if 'r' in params[1]:
                rb = params[1]
                c2 = "00000000000000000"
                # handles displacement addressing
                if '(' in rb and ')' in rb:
                    displacement = rb.split('(')[0]
                    if displacement != '':
                        c2 = np.binary_repr(int(displacement), width=17)
                    rb = rb.split('(')[1]
                    rb = rb.replace(')', '')
                elif len(params) == 3:
                    c2 = np.binary_repr(int(params[2]), width=17)
                rb = format_register_param(rb)
            else:
                rb = "00000"
                c2 = params[1]
                if c2 in labels:
                    c2 = labels[params[1]]
                c2 = np.binary_repr(int(c2), width=17)[-17:]

            instruction = convert_opcode_bin(opcode_name) + ra + rb + c2
            return instruction
        elif instrformat == 2:  # LDR, STR, LAR
            ra = format_register_param(params[0])
            c2 = params[1]
            if c2 in labels:
                c2 = labels[params[1]]
            c2 = c2 - address - 4
            c2 = np.binary_repr(int(c2), width=22)[-22:]

            instruction = convert_opcode_bin(opcode_name) + ra + c2
            return instruction
        elif instrformat == 3:  # NEG, NOT
            ra = format_register_param(params[0])

            if len(params) == 2:
                rc = format_register_param(params[1])
            else:
                rc = "00000"

            instruction = convert_opcode_bin(opcode_name) + ra + "00000" + rc + "000000000000"
            return instruction
        elif instrformat == 4:  # BR
            rb = format_register_param(params[0])

            if len(params) == 2:
                rc = format_register_param(params[1])
            else:
                rc = "00000"

            # branch conditions
            cond = branch_conditions(opcode_name)

            instruction = convert_opcode_bin(opcode_name) + "00000" + rb + rc + "000000000" + cond
            return instruction
        elif instrformat == 5:  # BRL
            ra = format_register_param(params[0])
            rb = format_register_param(params[1])

            if len(params) == 3:
                rc = format_register_param(params[2])
            else:
                rc = "00000"

            # branch conditions
            cond = branch_conditions(opcode_name)

            instruction = convert_opcode_bin(opcode_name) + ra + rb + rc + "000000000" + cond
            return instruction
        elif instrformat == 6:  # ADD, SUB, AND, OR
            ra = format_register_param(params[0])
            rb = format_register_param(params[1])
            rc = format_register_param(params[2])

            instruction = convert_opcode_bin(opcode_name) + ra + rb + rc + "000000000000"
            return instruction
        elif instrformat == 7:  # SHR, SHRA, SHL, SHC
            ra = format_register_param(params[0])
            rb = format_register_param(params[1])

            if "r" in params[2]:  # 7b
                rc = format_register_param(params[2])

                instruction = convert_opcode_bin(opcode_name) + ra + rb + rc + "000000000000"
                return instruction
            else:  # 7a
                count = format(int(params[2]), 'b').zfill(5)

                instruction = convert_opcode_bin(opcode_name) + ra + rb + "000000000000" + count
                return instruction
        else:  # NOP, STOP
            instruction = convert_opcode_bin(opcode_name) + "000000000000000000000000000"
            return instruction

    except Exception as e:
        print("{*} ERROR: your assembly is wrong, probably")
        print(e)


# takes in branch instruction (brnz) and returns 3-bit condition
def branch_conditions(opcode_name):
    condition = ""
    if "nv" in opcode_name:
        condition = branch_condition["nv"]
    elif "zr" in opcode_name:
        condition = branch_condition["zr"]
    elif "nz" in opcode_name:
        condition = branch_condition["nz"]
    elif "pl" in opcode_name:
        condition = branch_condition["pl"]
    elif "mi" in opcode_name:
        condition = branch_condition["mi"]
    else:
        condition = branch_condition[""]

    return format(condition, 'b').zfill(3)


# accepts parameter like "r1" or "r2", formats into 5 bit binary
def format_register_param(reg):
    reg = reg.replace('r', '')

    return bin(int(reg))[2:].zfill(5)


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

    assembly = assemble(readfile(filepath))
    for i in assembly:
        print(i)


if __name__ == "__main__":
    main()
