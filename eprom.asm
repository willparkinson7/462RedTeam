	la r25, QMC ;
	la r22, BOT ;
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
BOT:	ld r2, 0(r30) ;		
	brnz r22, r2 ;
	st r1, 0(r29) ;		spit letter back out
	br r31 ;		go to top and get new rx_data
QMC:    ld r1, 0(r30) ;
	brnz r25, r1 ;		wait until tx_busy_flag is low
	addi r2, r0, 82 ;	R	
	ld r1, 0(r30) ;
	addi r3, r25, 3 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 73 ;	I
	ld r1, 0(r30) ;
	addi r3, r25, 8 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 67 ;	C
	ld r1, 0(r30) ;
	addi r3, r25, 13 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 72 ;	H
	ld r1, 0(r30) ;
	addi r3, r25, 18 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 65 ;	A
	ld r1, 0(r30) ;
	addi r3, r25, 23 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 82 ;	R
	ld r1, 0(r30) ;
	addi r3, r25, 28 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 68 ;	D
	ld r1, 0(r30) ;
	addi r3, r25, 33 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 85 ;	U
	ld r1, 0(r30) ;
	addi r3, r25, 38 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 73 ;	I
	ld r1, 0(r30) ;
	addi r3, r25, 43 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 78 ;	N
	ld r1, 0(r30) ;
	addi r3, r25, 48 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 79 ;	O
	ld r1, 0(r30) ;
	addi r3, r25, 53 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 32 ;	_
	ld r1, 0(r30) ;
	addi r3, r25, 58 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 86 ;	V
	ld r1, 0(r30) ;
	addi r3, r25, 63 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 50 ;	2
	ld r1, 0(r30) ;
	addi r3, r25, 68 ;
	brnz r3, r1 ;		wait until tx_busy_flag is low
	st r2, (r29) ;		write to tx_data
	br r31 ;	