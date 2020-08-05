#include "textflag.h"

// func PospopcntRegCSA7(counts *[8]int32, buf []byte)
TEXT ·PospopcntRegCSA7(SB),NOSPLIT,$0-32
	MOVQ counts+0(FP), DI
	MOVQ buf_base+8(FP), SI		// SI = &buf[0]
	MOVQ buf_len+16(FP), CX		// CX = len(buf)

	// load counts into register R8--R15
	MOVL 4*0(DI), R8
	MOVL 4*1(DI), R9
	MOVL 4*2(DI), R10
	MOVL 4*3(DI), R11
	MOVL 4*4(DI), R12
	MOVL 4*5(DI), R13
	MOVL 4*6(DI), R14
	MOVL 4*7(DI), R15

	SUBQ $7*32, CX			// pre-decrement CX
	JL vec3

vec7:	VMOVDQU 0*32(SI), Y0		// load 224 bytes from buf into Y0--Y6
	VMOVDQU 1*32(SI), Y1
	VMOVDQU 2*32(SI), Y2
	VMOVDQU 3*32(SI), Y3
	VMOVDQU 4*32(SI), Y4
	VMOVDQU 5*32(SI), Y5
	VMOVDQU 6*32(SI), Y6
	ADDQ $7*32, SI
	PREFETCHT0 10*32(SI)
	PREFETCHT0 12*32(SI)
	PREFETCHT0 14*32(SI)
	PREFETCHT0 16*32(SI)

	VPAND Y0, Y1, Y7		// Y7 = 0&1
	VPXOR Y0, Y1, Y0		// Y0 = 0^1
	VPAND Y2, Y3, Y1		// Y1 = 2&3
	VPXOR Y2, Y3, Y2		// Y2 = 2^3
	VPAND Y0, Y4, Y3		// Y3 = (0^1)&4
	VPXOR Y0, Y4, Y0		// Y0 = 0^1^4
	VPAND Y2, Y5, Y4		// Y4 = (2^3)&5
	VPXOR Y2, Y5, Y2		// Y2 = 2^3^5
	VPOR Y3, Y7, Y3			// Y3 = 0&1|(0^1)&4 = carry(0+1+4)
	VPOR Y1, Y4, Y1			// Y1 = 2&3|(2^3)&5 = carry(2+3+5)
	VPAND Y0, Y6, Y4		// Y4 = (0^1^4)&6
	VPXOR Y0, Y6, Y0		// Y0 = 0^1^4^6
	VPAND Y0, Y2, Y5		// Y5 = (0^1^4^6)&(2^3^5)
	VPXOR Y0, Y2, Y0		// Y0 = 0^1^2^3^4^5^6
	VPOR Y4, Y5, Y2			// Y2 = (0^1^4)&6|(0^1^4^6)&(2^3^5) = carry((0^1^4)+(2^3^5)+6)
	VPAND Y1, Y3, Y4		// Y4 = carry(2+3+5)&carry(0+1+4)
	VPXOR Y1, Y3, Y1		// Y1 = carry(2+3+5)^carry(0+1+4)
	VPAND Y1, Y2, Y3		// Y3 = (carry(2+3+5)^carry(0+1+4))&carry((0^1^4)+(2^3^5)+6)
	VPXOR Y1, Y2, Y1		// Y1 = carry1(0+1+2+3+4+5+6)
	VPOR Y3, Y4, Y2			// Y2 = carry2(0+1+2+3+4+5+6)
					// Y2:Y1:Y0 = Y0+Y1+Y2+Y3+Y4+Y5+Y6

	VPMOVMSKB Y0, AX
	VPADDB Y0, Y0, Y0
	POPCNTL AX, AX
	VPMOVMSKB Y1, BX
	VPADDB Y1, Y1, Y1
	POPCNTL BX, BX
	VPMOVMSKB Y2, DX
	VPADDB Y2, Y2, Y2
	POPCNTL DX, DX
	LEAL (AX)(BX*2), AX
	LEAL (AX)(DX*4), AX
	ADDL AX, R15

	VPMOVMSKB Y0, AX
	VPADDB Y0, Y0, Y0
	POPCNTL AX, AX
	VPMOVMSKB Y1, BX
	VPADDB Y1, Y1, Y1
	POPCNTL BX, BX
	VPMOVMSKB Y2, DX
	VPADDB Y2, Y2, Y2
	POPCNTL DX, DX
	LEAL (AX)(BX*2), AX
	LEAL (AX)(DX*4), AX
	ADDL AX, R14

	VPMOVMSKB Y0, AX
	VPADDB Y0, Y0, Y0
	POPCNTL AX, AX
	VPMOVMSKB Y1, BX
	VPADDB Y1, Y1, Y1
	POPCNTL BX, BX
	VPMOVMSKB Y2, DX
	VPADDB Y2, Y2, Y2
	POPCNTL DX, DX
	LEAL (AX)(BX*2), AX
	LEAL (AX)(DX*4), AX
	ADDL AX, R13

	VPMOVMSKB Y0, AX
	VPADDB Y0, Y0, Y0
	POPCNTL AX, AX
	VPMOVMSKB Y1, BX
	VPADDB Y1, Y1, Y1
	POPCNTL BX, BX
	VPMOVMSKB Y2, DX
	VPADDB Y2, Y2, Y2
	POPCNTL DX, DX
	LEAL (AX)(BX*2), AX
	LEAL (AX)(DX*4), AX
	ADDL AX, R12

	VPMOVMSKB Y0, AX
	VPADDB Y0, Y0, Y0
	POPCNTL AX, AX
	VPMOVMSKB Y1, BX
	VPADDB Y1, Y1, Y1
	POPCNTL BX, BX
	VPMOVMSKB Y2, DX
	VPADDB Y2, Y2, Y2
	POPCNTL DX, DX
	LEAL (AX)(BX*2), AX
	LEAL (AX)(DX*4), AX
	ADDL AX, R11

	VPMOVMSKB Y0, AX
	VPADDB Y0, Y0, Y0
	POPCNTL AX, AX
	VPMOVMSKB Y1, BX
	VPADDB Y1, Y1, Y1
	POPCNTL BX, BX
	VPMOVMSKB Y2, DX
	VPADDB Y2, Y2, Y2
	POPCNTL DX, DX
	LEAL (AX)(BX*2), AX
	LEAL (AX)(DX*4), AX
	ADDL AX, R10

	VPMOVMSKB Y0, AX
	VPADDB Y0, Y0, Y0
	POPCNTL AX, AX
	VPMOVMSKB Y1, BX
	VPADDB Y1, Y1, Y1
	POPCNTL BX, BX
	VPMOVMSKB Y2, DX
	VPADDB Y2, Y2, Y2
	POPCNTL DX, DX
	LEAL (AX)(BX*2), AX
	LEAL (AX)(DX*4), AX
	ADDL AX, R9

	VPMOVMSKB Y0, AX
	POPCNTL AX, AX
	VPMOVMSKB Y1, BX
	POPCNTL BX, BX
	VPMOVMSKB Y2, DX
	POPCNTL DX, DX
	LEAL (AX)(BX*2), AX
	LEAL (AX)(DX*4), AX
	ADDL AX, R8

	SUBQ $7*32, CX
	JGE vec7			// repeat as long as bytes are left

vec3:	ADDQ $7*32, CX			// undo last subtraction
	SUBQ $32, CX			// pre-subtract 32 bit from CX
	JL scalar

vector:	VMOVDQU (SI), Y0		// load 32 bytes from buf
	ADDQ $32, SI			// advance SI past them

	VPMOVMSKB Y0, AX		// move MSB of Y0 bytes to AX
	POPCNTL AX, AX			// count population of AX
	ADDL AX, R15			// add to counter
	VPADDD Y0, Y0, Y0		// shift Y0 left by one place

	VPMOVMSKB Y0, AX		// move MSB of Y0 bytes to AX
	POPCNTL AX, AX			// count population of AX
	ADDL AX, R14			// add to counter
	VPADDD Y0, Y0, Y0		// shift Y0 left by one place

	VPMOVMSKB Y0, AX		// move MSB of Y0 bytes to AX
	POPCNTL AX, AX			// count population of AX
	ADDL AX, R13			// add to counter
	VPADDD Y0, Y0, Y0		// shift Y0 left by one place

	VPMOVMSKB Y0, AX		// move MSB of Y0 bytes to AX
	POPCNTL AX, AX			// count population of AX
	ADDL AX, R12			// add to counter
	VPADDD Y0, Y0, Y0		// shift Y0 left by one place

	VPMOVMSKB Y0, AX		// move MSB of Y0 bytes to AX
	POPCNTL AX, AX			// count population of AX
	ADDL AX, R11			// add to counter
	VPADDD Y0, Y0, Y0		// shift Y0 left by one place

	VPMOVMSKB Y0, AX		// move MSB of Y0 bytes to AX
	POPCNTL AX, AX			// count population of AX
	ADDL AX, R10			// add to counter
	VPADDD Y0, Y0, Y0		// shift Y0 left by one place

	VPMOVMSKB Y0, AX		// move MSB of Y0 bytes to AX
	POPCNTL AX, AX			// count population of AX
	ADDL AX, R9			// add to counter
	VPADDD Y0, Y0, Y0		// shift Y0 left by one place

	VPMOVMSKB Y0, AX		// move MSB of Y0 bytes to AX
	POPCNTL AX, AX			// count population of AX
	ADDL AX, R8			// add to counter

	SUBQ $32, CX
	JGE vector			// repeat as long as bytes are left

scalar:	ADDQ $32, CX			// undo last subtraction
	JE done				// if CX=0, there's nothing left

loop:	MOVBLZX (SI), AX		// load a byte from buf
	INCQ SI				// advance past it

	SHRL $1, AX			// is bit 0 set?
	ADCL $0, R8			// add it to R8

	SHRL $1, AX			// is bit 0 set?
	ADCL $0, R9			// add it to R9

	SHRL $1, AX			// is bit 0 set?
	ADCL $0, R10			// add it to R10

	SHRL $1, AX			// is bit 0 set?
	ADCL $0, R11			// add it to R11

	SHRL $1, AX			// is bit 0 set?
	ADCL $0, R12			// add it to R12

	SHRL $1, AX			// is bit 0 set?
	ADCL $0, R13			// add it to R13

	SHRL $1, AX			// is bit 0 set?
	ADCL $0, R14			// add it to R14

	SHRL $1, AX			// is bit 0 set?
	ADCL $0, R15			// add it to R15

	DECQ CX				// mark this byte as done
	JNE loop			// and proceed if any bytes are left

	// write R8--R15 back to counts
done:	MOVL R8, 4*0(DI)
	MOVL R9, 4*1(DI)
	MOVL R10, 4*2(DI)
	MOVL R11, 4*3(DI)
	MOVL R12, 4*4(DI)
	MOVL R13, 4*5(DI)
	MOVL R14, 4*6(DI)
	MOVL R15, 4*7(DI)

	VZEROUPPER			// restore SSE-compatibility
	RET
