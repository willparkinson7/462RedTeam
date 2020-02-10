	la r26, BOT ;
	la r31, TOP ;
	la r30, -32 ;
	la r29, -28 ;
	la r28, -24 ;
	la r27, -20 ;

TOP:	ld r1, 0(r28);
	brzr r31, r1 ;
	ld r3, 0(r27) ;
BOT:	ld r2, 0(r30) ;
	brnz r26, r2 ;
	st r3, 0(r29) ;
	br r31 ;