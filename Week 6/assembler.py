#!/usr/bin/env python3

import sys

# ----------------------------------------------------
# Opcodes
# ----------------------------------------------------

OPCODES = {
    "NOOP": 0b0000,
    "MOVE": 0b0010,
    "LOADI": 0b0011,
    "ADD": 0b0100,
    "ADDI": 0b0101,
    "SUB": 0b0110,
    "SUBI": 0b0111,
    "LOAD": 0b1000,
    "STORE": 0b1010,
    "CMP": 0b1101,
    "JUMP": 0b1110,
    # All branches share opcode 1111
    "BRANCH": 0b1111,
    "SHIFT": 0b1100,
    "INPUTC": 0b0001,
    "INPUTCF": 0b0001,
    "INPUTD": 0b0001,
    "INPUTDF": 0b0001,
    "LOADF": 0b1001,
    "STOREF": 0b1011,
}

# ----------------------------------------------------
# Registers
# ----------------------------------------------------

REG = {
    "A": 0,
    "B": 1,
    "C": 2,
    "D": 3,
}

# ----------------------------------------------------
# Encoders
# ----------------------------------------------------

BRANCH_TYPE = {
    "BRE": 0,
    "BRNE": 1,
    "BRG": 2,
    "BRGE": 3,
}


def encode_branch(kind, addr):
    return (OPCODES["BRANCH"] << 12) | (BRANCH_TYPE[kind] << 8) | (addr & 0xFF)


def encode_loadi(rd, imm):
    return (OPCODES["LOADI"] << 12) | (REG[rd] << 10) | (imm & 0xFF)


def encode_move(rd, rs):
    return (OPCODES["MOVE"] << 12) | (REG[rd] << 10) | (REG[rs] << 8)


def encode_add(rd, rs1, rs2):
    return (OPCODES["ADD"] << 12) | (REG[rd] << 10) | (REG[rs1] << 8) | (REG[rs2] << 6)


def encode_sub(rd, rs1, rs2):
    return (OPCODES["SUB"] << 12) | (REG[rd] << 10) | (REG[rs1] << 8) | (REG[rs2] << 6)


def encode_addi(rd, rs, imm):
    return (OPCODES["ADDI"] << 12) | (REG[rd] << 10) | (REG[rs] << 8) | (imm & 0xFF)


def encode_subi(rd, rs, imm):
    return (OPCODES["SUBI"] << 12) | (REG[rd] << 10) | (REG[rs] << 8) | (imm & 0xFF)


def encode_load(rd, addr):
    return (OPCODES["LOAD"] << 12) | (REG[rd] << 10) | (addr & 0xFF)


def encode_store(rs, addr):
    return (OPCODES["STORE"] << 12) | (REG[rs] << 10) | (addr & 0xFF)


def encode_jump(addr):
    return (OPCODES["JUMP"] << 12) | (addr & 0xFF)


def encode_cmp(rs1, rs2):
    return (OPCODES["CMP"] << 12) | (REG[rs1] << 8) | (REG[rs2] << 6)


def encode_shift(rd, rs, direction):
    r = REG[rs]

    return (
        (OPCODES["SHIFT"] << 12)
        | (REG[rd] << 10)
        | ((r >> 1) << 9)  # rs[1] -> bit9
        | (direction << 8)  # direction -> bit8
        | ((r & 1) << 7)  # rs[0] -> bit7
    )


def encode_input(rd, sub):
    return (OPCODES["INPUTC"] << 12) | (REG[rd] << 10) | (sub << 8)


def encode_loadf(rd, offset_reg, base):
    return (
        (OPCODES["LOADF"] << 12)
        | (REG[rd] << 10)
        | (REG[offset_reg] << 8)
        | (base & 0xFF)
    )


def encode_storef(rs, offset_reg, base):
    return (
        (OPCODES["STOREF"] << 12)
        | (REG[rs] << 10)
        | (REG[offset_reg] << 8)
        | (base & 0xFF)
    )


# ----------------------------------------------------
# Helpers
# ----------------------------------------------------


def clean(line):
    line = line.split("//")[0]
    line = line.split("#")[0]
    return line.strip()


def parse_number(x):
    return int(x, 0)


# ----------------------------------------------------
# Pass 1
# ----------------------------------------------------


def first_pass(lines):

    labels = {}
    pc = 0

    for line in lines:
        line = clean(line)

        if not line:
            continue

        if line.endswith(":"):
            labels[line[:-1].upper()] = pc
        else:
            pc += 1

    return labels


# ----------------------------------------------------
# Pass 2
# ----------------------------------------------------


def assemble(line, labels):

    line = clean(line)

    if not line:
        return None

    if line.endswith(":"):
        return None

    line = line.replace(",", " ")

    t = line.upper().split()

    op = t[0]

    if op == "NOOP":
        return 0

    elif op == "LOADI":
        return encode_loadi(t[1], parse_number(t[2]))

    elif op == "MOVE":
        return encode_move(t[1], t[2])

    elif op == "ADD":
        return encode_add(t[1], t[2], t[3])

    elif op == "SUB":
        return encode_sub(t[1], t[2], t[3])

    elif op == "ADDI":
        return encode_addi(t[1], t[2], parse_number(t[3]))

    elif op == "SUBI":
        return encode_subi(t[1], t[2], parse_number(t[3]))

    elif op == "LOAD":
        return encode_load(t[1], parse_number(t[2]))

    elif op == "STORE":
        return encode_store(t[1], parse_number(t[2]))

    elif op == "JUMP":
        target = t[1]

        if target.upper() in labels:
            addr = labels[target.upper()]
        else:
            addr = parse_number(target)

        return encode_jump(addr)

    elif op in ("BRE", "BRNE", "BRG", "BRGE"):
        target = t[1]

        if target.upper() in labels:
            addr = labels[target.upper()]
        else:
            addr = parse_number(target)

        return encode_branch(op, addr)

    elif op == "CMP":
        return encode_cmp(t[1], t[2])

    elif op == "SHIFTL":
        return encode_shift(t[1], t[2], 0)

    elif op == "SHIFTR":
        return encode_shift(t[1], t[2], 1)

    elif op == "INPUTC":
        return encode_input(t[1], 0)

    elif op == "INPUTCF":
        return encode_input(t[1], 1)

    elif op == "INPUTD":
        return encode_input(t[1], 2)

    elif op == "INPUTDF":
        return encode_input(t[1], 3)

    elif op == "LOADF":
        return encode_loadf(t[1], t[2], int(t[3]))

    elif op == "STOREF":
        return encode_storef(t[1], t[2], int(t[3]))

    else:
        raise ValueError(f"Unknown instruction: {op}")


# ----------------------------------------------------
# Main
# ----------------------------------------------------


def main():

    if len(sys.argv) != 2:
        print("Usage: python3 assembler.py program.asm")
        return

    with open(sys.argv[1]) as f:
        lines = f.readlines()

    labels = first_pass(lines)

    machine = []

    for line in lines:
        code = assemble(line, labels)

        if code is not None:
            machine.append(code)

    with open("program.mem", "w") as f:
        for inst in machine:
            f.write(f"{inst:04X}\n")

    # print("Labels:")
    # for k, v in labels.items():
    #     print(f"{k:10} -> {v}")

    print("\nGenerated program.mem\n")

    # for inst in machine:
    #     print(f"{inst:04X}")


if __name__ == "__main__":
    main()
