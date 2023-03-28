addi $10, $0, 0x00000012  #3-20Ñ­»·18´Î
addi $5, $0, 1   #p
addi $6, $0, 1   #q
label0:
    beq $10, $0, label1
    add $7, $5, $6  #r = p + q
    add $6, $0, $5  #q = p
    add $5, $0, $7  #p = r
    sub $10, $10, 1
    j label0
label1:
    add $4, $0, $7
