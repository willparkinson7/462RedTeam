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
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 73 ;	I
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 67 ;	C
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 72 ;	H
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 65 ;	A
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 82 ;	R
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 68 ;	D
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 85 ;	U
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 73 ;	I
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 78 ;	N
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 79 ;	O
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 32 ;	_
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 86 ;	V
	st r2, (r29) ;		write to tx_data
	addi r2, r0, 50 ;	2
	st r2, (r29) ;		write to tx_data
	br r31 ;	