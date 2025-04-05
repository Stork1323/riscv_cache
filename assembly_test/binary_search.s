	#ecall
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
kernel: 
	addi	zero,zero,0
	addi	ra,zero,0
	#addi	sp,zero,1536
    addi    sp,zero,2047
    addi    sp,sp,509
    #########
	addi	gp,zero,0
	addi	tp,zero,0
	addi	t0,zero,0
	addi	t1,zero,0
	addi	t2,zero,0
	addi	s0,zero,0
	addi	a0,zero,0
	addi	a1,zero,0
	addi	a2,zero,0
	addi	s3,zero,0
	addi	a4,zero,0
	addi	a5,zero,0
	addi	a6,zero,0
	addi	a7,zero,0
	addi	s2,zero,0
	addi	s3,zero,0
	addi	s4,zero,0
	addi	s5,zero,0
	addi	s6,zero,0
	addi	s7,zero,0
	addi	s8,zero,0
	addi	s9,zero,0
	addi	s10,zero,0
	addi	s11,zero,0
	addi	t3,zero,0
	addi	t4,zero,0
	addi	t5,zero,0
	addi	t6,zero,0
	call	main
	addi	zero,zero,0
	mv	    s1,a0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	j 		_exit
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
binary_search:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	a2,-44(s0)
	sw	a3,-48(s0)
	lw	a4,-48(s0)
	lw	a5,-44(s0)
	sub	a5,a4,a5
	srli	a4,a5,31
	add	a5,a4,a5
	srai	a5,a5,1
	mv	a4,a5
	lw	a5,-44(s0)
	add	a5,a5,a4
	sw	a5,-20(s0)
	lw	a4,-44(s0)
	lw	a5,-48(s0)
	ble	a4,a5,.L2
	li	a5,-1
	j	.L3
.L2:
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	lw	a4,-40(s0)
	bne	a4,a5,.L4
	lw	a5,-20(s0)
	j	.L3
.L4:
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	lw	a4,-40(s0)
	bge	a4,a5,.L5
	lw	a5,-20(s0)
	addi	a5,a5,-1
	mv	a3,a5
	lw	a2,-44(s0)
	lw	a1,-40(s0)
	lw	a0,-36(s0)
	call	binary_search
	mv	a5,a0
	j	.L3
.L5:
	lw	a5,-20(s0)
	addi	a5,a5,1
	lw	a3,-48(s0)
	mv	a2,a5
	lw	a1,-40(s0)
	lw	a0,-36(s0)
	call	binary_search
	mv	a5,a0
.L3:
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
search:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	sw	a2,-28(s0)
	lw	a5,-28(s0)
	addi	a5,a5,-1
	mv	a3,a5
	li	a2,0
	lw	a1,-24(s0)
	lw	a0,-20(s0)
	call	binary_search
	mv	a5,a0
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
sort:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	zero,-20(s0)
	j	.L9
.L13:
	sw	zero,-24(s0)
	j	.L10
.L12:
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,0(a5)
	lw	a5,-24(s0)
	slli	a5,a5,2
	lw	a3,-36(s0)
	add	a5,a3,a5
	lw	a5,0(a5)
	bge	a4,a5,.L11
	lw	a5,-24(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	sw	a5,-28(s0)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a4,a4,a5
	lw	a5,-24(s0)
	slli	a5,a5,2
	lw	a3,-36(s0)
	add	a5,a3,a5
	lw	a4,0(a4)
	sw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,-28(s0)
	sw	a4,0(a5)
.L11:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L10:
	lw	a4,-40(s0)
	lw	a5,-20(s0)
	sub	a5,a4,a5
	addi	a5,a5,-1
	lw	a4,-24(s0)
	blt	a4,a5,.L12
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L9:
	lw	a5,-40(s0)
	addi	a5,a5,-1
	lw	a4,-20(s0)
	blt	a4,a5,.L13
	nop
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra

main:
	addi	sp,sp,-64
	sw	ra,60(sp)
	sw	s0,56(sp)
	addi	s0,sp,64
    li  a7, 0
	sw	a7,-52(s0)
    li  a6, 6
	sw	a6,-48(s0)
    li  a0, 8
	sw	a0,-44(s0)
    li  a1, 4
	sw	a1,-40(s0)
    li  a2, 3
	sw	a2,-36(s0)
    li  a3, 9
	sw	a3,-32(s0)
    li  a4, 7
	sw	a4,-28(s0)
    li  a5, 5
	sw	a5,-24(s0)
	addi	a5,s0,-52
	li	a1,8
	mv	a0,a5
	call	sort
	addi	a5,s0,-52
	li	a2,8
    #testing
	li	a1,5
    #li a1, 8
    ############
	mv	a0,a5
	call	search
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	mv	a0,a5
	lw	ra,60(sp)
	lw	s0,56(sp)
	addi	sp,sp,64
	jr	ra
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	auipc	ra,0x0
	jalr	ra,ra,0x0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
	addi	zero,zero,0
_exit:
	#ebreak