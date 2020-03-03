	la r25, QMC ;
	la r22, BOT ;
	la r26, PC ;
	la r24, RC ;
	la r21, RCT ;
	la r20, DL ;
	la r23, WC ;
	la r22, RA ;	READ ADDRESS, uses r3 for counter, r4 length, r5 address
	la r31, TOP ;
	la r30, -32 ;	TX_BUSY_FLAG
	la r29, -28 ;	TX_DATA
	la r28, -24 ;	RX_DATA_FLAG
	la r27, -20 ;	RX_DATA

TOP:	ld r1, 0(r28);	put rx_data_flag into r1
	brzr r31, r1 ;  branch to top if r1 is zero
	ld r1, 0(r27) ;		put rx_data into r1
	addi r2, r1, -63 ; 	put ? ascii check into r2
	brzr r25, r2 ;		go to ? assembly if difference is zero
	addi r3, r1, -112 ;	put p ascii into r3
	brzr r26, r3 ;		go to p assembly if equal to rx_data
	addi r4, r1, -114 ;	put r ascii into r4
	brzr r24, r4 ;		go to r assembly if equal to rx_data
	addi r5, r1, -119 ;	put w ascii into r5
	brzr r23, r5 ;		go to w assembly if equal to rx_data
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
DL:	addi r5, r0, 1000 ;		r6 holds count to delay, r5 holds counter, r4 for comparison, r15 for pc
	addi r19, r20, 8 ;
	ld r1, 0(r30) ;		r25
	brnz r25, r1 ;		wait until tx_busy_flag is low
	addi r5, r5, -1 ;
	brnz r19, r5 ;
	br r15 ;
RC:	ld r1, 0(r28) ;	put rx_data_flag into r1		
	brzr r24, r1 ;  branch to RC if r1 is zero
	ld r1, 0(r27) ;		put rx_data into r1
	addi r2, r1, -32 ; 	put _ ascii check into r2
	brnz r31, r2 ;		exit if not _
	ld r3, (r0) ;		put zero into r3 (counter)
	ld r5, (r0) ;		zero out address
RA:	ld r1, 0(r28) ;
	brzr r22, r1 ;  	branch to RA if r1 is zero
	ld r1, 0(r27) ;		put rx_data into r1
	shl r5, r5, 8 ;
	or r5, r5, r1 ;
	addi r3, r3, 1 ;
	addi r4, r3, -4 ;	r4 negative if 
	brmi r22, r4 ; 
	st r3, (r29) ;
	ld r2, 0(r5) ;		load from memory
RCT:	ld r1, 0(r30) ;		r25
	brnz r21, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		store in tx_data
	br r31 ;