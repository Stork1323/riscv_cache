# Application: input 16 bit from switches, convert input to decimal and display on 7 segment led

# 7segment common anode code 
# 0 : 0x40
# 1 : 0x79
# 2 : 0x24
# 3 : 0x30
# 4 : 0x19
# 5 : 0x12
# 6 : 0x02
# 7 : 0x78
# 8 : 0x00
# 9 : 0x10

# Address of data memory: from 2048->6140 (step=4)
    # 2048 -> 3068 : data
    # 3072 -> 3324 : output peripherals
    # 3328 -> 3580 : input peripherals
    # 3584 -> 6140 : data (reserved)

addi x1, x0, 1
addi x2, x0, 2
addi x3, x0, 3
addi x4, x0, 4
addi x5, x0, 5
addi x6, x0, 6
addi x7, x0, 7
addi x8, x0, 8
addi x9, x0, 9
addi x10, x0, 10
addi x31, x0, 2047

start:
lw x13, 1281(x31) # read value from switches
#addi x13, x0, 765
sw x13, 1057(x31)


# convert bin to bcd, x13 store value of bin number
#hex0
addi x19, x13, 0 #hex0
jal x11, mod10
jal x11, convert_code_7seg
sw x21, 1025(x31)
addi x16, x13, 0
jal x11, div10
#hex1
addi x19, x13, 0    #hex1
jal x11, mod10
jal x11, convert_code_7seg
sw x21, 1029(x31)
addi x16, x13, 0
jal x11, div10
#hex2
addi x19, x13, 0 #hex2
jal x11, mod10
jal x11, convert_code_7seg
sw x21, 1033(x31)
addi x16, x13, 0
jal x11, div10
#hex3
addi x19, x13, 0 #hex3
jal x11, mod10
jal x11, convert_code_7seg
sw x21, 1037(x31)
addi x16, x13, 0
jal x11, div10
addi x16, x13, 0
#hex4
addi x19, x13, 0    #hex4
jal x11, mod10
jal x11, convert_code_7seg
sw x21, 1041(x31)

addi x30, x0, 0x40
sw x30, 1045(x31)
sw x30, 1049(x31)
sw x30, 1053(x31)

# because hex0-hex7 are in set0 and set1 of l1 data cache, so need to fill set0 and set1 to push hex0-hex7 in RAM

    #set 0 ....
sw x3, 1(x31) #2048
sw x3, 5(x31) #2052
sw x3, 9(x31) #2047 + imm
sw x3, 13(x31)
    #one way had been filled
sw x3, 257(x31)
sw x3, 261(x31)
sw x3, 265(x31)
sw x3, 269(x31)
    #two way had been filled
sw x3, 513(x31)
sw x3, 517(x31)
sw x3, 521(x31)
sw x3, 525(x31)
    #...
sw x3, 769(x31)
sw x3, 773(x31)
sw x3, 777(x31)
sw x3, 781(x31)

sw x3, 65(x31)
sw x3, 69(x31)
sw x3, 73(x31)
sw x3, 77(x31)

sw x3, 321(x31)
sw x3, 325(x31)
sw x3, 329(x31)
sw x3, 333(x31)
    #six way had been filled
    
sw x3, 385(x31)
sw x3, 389(x31)
sw x3, 393(x31)
sw x3, 397(x31)
    #seven way had been filled

sw x3, 449(x31)
sw x3, 453(x31)
sw x3, 457(x31)
sw x3, 461(x31)
    #eight way had been filled
    #set0 ...
    
    #set1 ...
sw x3, 17(x31) #2064
sw x3, 21(x31) #2068
sw x3, 25(x31) #2047 + imm
sw x3, 29(x31)
    #one way had been filled
sw x3, 81(x31)
sw x3, 85(x31)
sw x3, 89(x31)
sw x3, 93(x31)
    #two way had been filled
sw x3, 145(x31)
sw x3, 149(x31)
sw x3, 153(x31)
sw x3, 157(x31)
    #...
sw x3, 209(x31)
sw x3, 213(x31)
sw x3, 217(x31)
sw x3, 221(x31)

sw x3, 273(x31)
sw x3, 277(x31)
sw x3, 281(x31)
sw x3, 285(x31)

sw x3, 337(x31)
sw x3, 341(x31)
sw x3, 345(x31)
sw x3, 349(x31)
    #six way had been filled
    
sw x3, 401(x31)
sw x3, 405(x31)
sw x3, 409(x31)
sw x3, 413(x31)
    #seven way had been filled
    #set1 ...
    
    #fill set0 of L2 cache, using data reserved in Memory
sw x3, 1537(x31) #3584
sw x3, 1541(x31)
sw x3, 1545(x31)
sw x3, 1549(x31)

sw x3, 1793(x31) #3840
sw x3, 1797(x31)
sw x3, 1801(x31)
sw x3, 1805(x31)

lui x29, 1 # x29 = 4096
sw x3, 0(x29) #4096
sw x3, 4(x29)
sw x3, 8(x29)
sw x3, 12(x29)

sw x3, 256(x29) #4352
sw x3, 260(x29)
sw x3, 264(x29)
sw x3, 268(x29)

    # --------- 

# ---------- #

jal x12, start
jal x12, exit

#######################

# divide 10, x13=x13/10
div10:
addi x14, x0, 0 # divide 10
srli x15, x13, 1
add x14, x14, x15
srli x15, x13, 2
add x14, x14, x15
srli x15, x14, 4
add x14, x14, x15
srli x15, x14, 8
add x14, x14, x15
srli x15, x14, 16
add x14, x14, x15
srli x14, x14, 3
slli x15, x14, 2
add x15, x15, x14
slli x15, x15, 1
sub x13, x13, x15
blt x13, x10, temp_1
add x13, x14, x1
jal x12, out_div10
temp_1:
add x13, x14, x0
out_div10:
jalr x12, x11, 0
##########################3

# modulus 10, x18 = x19 % 10
mod10:
addi x18, x0, 0 # modulus 10

andi x20, x19, 0x0F # the first 4 bit 
add x18, x18, x20

srli x19, x19, 4
andi x20, x19, 0x0F # the second 4 bit 
add x18, x18, x20
andi x21, x20, 1
bne x21, x1, skip1
addi x18, x18, 5

skip1:
srli x19, x19, 4
andi x20, x19, 0x0F # the third 4 bit 
add x18, x18, x20
andi x21, x20, 1
bne x21, x1, skip2
addi x18, x18, 5

skip2:
srli x19, x19, 4
andi x20, x19, 0x0F # the forth 4 bit 
add x18, x18, x20
andi x21, x20, 1
bne x21, x1, skip3
addi x18, x18, 5

skip3:
blt x18, x10, out_mod10
addi x18, x18, -10
jal x12, skip3

out_mod10:
jalr x12, x11, 0
###################33


# x18 store value that need to convert, x21 return code
convert_code_7seg:
beq x18, x0, no0 #convert_code_7seg:
beq x18, x1, no1
beq x18, x2, no2
beq x18, x3, no3
beq x18, x4, no4
beq x18, x5, no5
beq x18, x6, no6
beq x18, x7, no7
beq x18, x8, no8
beq x18, x9, no9
jal x12, skip

no0:
addi x21, x0, 0x40
jal x12, skip

no1:
addi x21, x0, 0x79
jal x12, skip

no2:
addi x21, x0, 0x24
jal x12, skip

no3:
addi x21, x0, 0x30
jal x12, skip

no4:
addi x21, x0, 0x19
jal x12, skip

no5:
addi x21, x0, 0x12
jal x12, skip

no6:
addi x21, x0, 0x02
jal x12, skip

no7:
addi x21, x0, 0x78
jal x12, skip

no8:
addi x21, x0, 0x00
jal x12, skip

no9:
addi x21, x0, 0x10
jal x12, skip

skip:
jalr x12, x11, 0
###############################
nop
nop
exit:



