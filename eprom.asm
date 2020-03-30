	la r25, QMC ;
	la r22, BOT ;
	la r21, RAS ; READ ADDRESS/LENGTH START
	la r20, DL ;
	la r24, PC ;
	la r22, RL ;	READ ADDRESS/LENGTH, uses r3 for counter, r4 length, r5 address
	la r31, TOP ;
	la r30, -32 ;	TX_BUSY_FLAG
	la r29, -28 ;	TX_DATA
	la r28, -24 ;	RX_DATA_FLAG
	la r27, -20 ;	RX_DATA
	la r23, 4096 ;	SRAM

TOP:	ld r1, 0(r28);	put rx_data_flag into r1
	brzr r31, r1 ;  branch to top if r1 is zero
	ld r1, 0(r27) ;		put rx_data into r1
	addi r2, r1, -63 ; 	put ? ascii check into r2
	brzr r25, r2 ;		go to ? assembly if difference is zero
	addi r3, r1, -112 ;	put p ascii into r3
	brzr r21, r3 ;		go to p assembly if equal to rx_data
;	addi r4, r1, -114 ;	put r ascii into r4
;	brzr r24, r4 ;		go to r assembly if equal to rx_data
;	addi r5, r1, -119 ;	put w ascii into r5
;	brzr r23, r5 ;		go to w assembly if equal to rx_data
BOT:	ld r2, 0(r30) ;
	brnz r22, r2 ;
	st r1, 0(r29) ;		spit letter back out
	br r31 ;		go to top and get new rx_data
QMC:    ld r1, 0(r30) ;		r25
	brnz r25, r1 ;		wait until tx_busy_flag is low
	addi r2, r0, 82 ;	R
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 73 ;	I
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 67 ;	C
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 72 ;	H
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 65 ;	A
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 82 ;	R
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 68 ;	D
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 85 ;	U
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 73 ;	I
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 78 ;	N
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 79 ;	O
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 32 ;	_
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 86 ;	V
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 50 ;	2
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	br r31 ;
DL:	ld r1, 0(r30) ;			wait until tx_busy_flag is low
	brnz r20, r1 ;
	br r15 ;
RAS:	la r3, 0 ;		put zero into r3 (counter)
	la r5, 0 ;		zero out address
;	addi r2, r0, 65 ;	A
;	brl r15, r20 ;
;	st r2, (r29) ;		write to tx_data
;	addi r2, r0, 58 ;	:
;	brl r15, r20 ;
;	st r2, (r29) ;		write to tx_data
RL:	ld r1, 0(r28) ;	check if rx_data has anything
	brzr r22, r1 ;  	branch to RA if r1 is zero
	ld r1, 0(r27) ;		put rx_data into r1
	st r1, 0(r29) ;		output rx_data (just to be sure)
	shl r5, r5, 8 ;
	or r5, r5, r1 ;
	addi r3, r3, 1 ;
	addi r4, r3, -4 ;	r4 negative if
	brmi r22, r4 ;

;	addi r2, r0, 68 ;	D
;	brl r15, r20 ;
;	st r2, (r29) ;		write to tx_data
;	addi r2, r0, 79 ;	O
;	brl r15, r20 ;
;	st r2, (r29) ;		write to tx_data
;	addi r2, r0, 78 ;	N
;	brl r15, r20 ;
;	st r2, (r29) ;		write to tx_data
;	addi r2, r0, 69 ;	E
;	brl r15, r20 ;
;	st r2, (r29) ;		write to tx_data
	br r15 ;			branch to program counter (P, as of right now)
PCS:la r23, 4096 ;	SRAM
	brl r15, r21 ;		read length into r5
	la r3, 0 ;			r2 is big counter
	neg r6, r5 ;		r6 is comparison
	addi r6, r6, -1 ; 	compensate for brmi not counting zero
PC:	ld r1, 0(r28) ;	check if rx_data has anything
	brzr r22, r1 ;  	branch to RA if r1 is zero
	ld r1, 0(r27) ;		put rx_data into r1
	st r1, 0(r29) ;		output rx_data (just to be sure)
	addi r23, r23, 8 ;
	st r1, (r23) ;
	addi r3, r3, 1 ;	one byte
	add r4, r3, r6;	r4 negative if
	brmi r24, r4 ;
	addi r2, r0, 69 ;	E
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 88 ;	X
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 73 ;	I
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 84 ;	T
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 80 ;	P
	brl r15, r20 ;
	st r2, (r29) ;		write to tx_data
	br r31 ;
