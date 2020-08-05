#include "textflag.h"

// func PospopcntRegCSA(counts *[8]int32, buf []byte)
TEXT ·PospopcntRegCSA(SB),NOSPLIT,$0-32
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

	SUBQ $96, CX			// pre-subtract 32 bit from CX
	JL scalar

vector:	VMOVDQU (SI), Y0		// load 96 bytes from buf into Y0--Y2
	VMOVDQU 32(SI), Y1
	VMOVDQU 64(SI), Y2
	ADDQ $96, SI			// advance SI past them
	PREFETCHT0 320(SI)
	PREFETCHT0 384(SI)

	VPXOR Y0, Y1, Y3		// first adder: sum
	VPAND Y0, Y1, Y0		// first adder: carry out
	VPAND Y2, Y3, Y1		// second adder: carry out
	VPXOR Y2, Y3, Y2		// second adder: sum (full sum)
	VPOR Y0, Y1, Y0			// full adder: carry out

	VPMOVMSKB Y0, AX		// MSB of carry out bytes
	VPMOVMSKB Y2, DX		// MSB of sum bytes
	VPADDB Y0, Y0, Y0		// shift carry out bytes left
	VPADDB Y2, Y2, Y2		// shift sum bytes left
	POPCNTL AX, AX			// carry bytes population count
	POPCNTL DX, DX			// sum bytes population count
	LEAL (DX)(AX*2), AX		// sum popcount plus 2x carry popcount
	ADDL AX, R15

	VPMOVMSKB Y0, AX		// MSB of carry out bytes
	VPMOVMSKB Y2, DX		// MSB of sum bytes
	VPADDB Y0, Y0, Y0		// shift carry out bytes left
	VPADDB Y2, Y2, Y2		// shift sum bytes left
	POPCNTL AX, AX			// carry bytes population count
	POPCNTL DX, DX			// sum bytes population count
	LEAL (DX)(AX*2), AX		// sum popcount plus 2x carry popcount
	ADDL AX, R14

	VPMOVMSKB Y0, AX		// MSB of carry out bytes
	VPMOVMSKB Y2, DX		// MSB of sum bytes
	VPADDB Y0, Y0, Y0		// shift carry out bytes left
	VPADDB Y2, Y2, Y2		// shift sum bytes left
	POPCNTL AX, AX			// carry bytes population count
	POPCNTL DX, DX			// sum bytes population count
	LEAL (DX)(AX*2), AX		// sum popcount plus 2x carry popcount
	ADDL AX, R13

	VPMOVMSKB Y0, AX		// MSB of carry out bytes
	VPMOVMSKB Y2, DX		// MSB of sum bytes
	VPADDB Y0, Y0, Y0		// shift carry out bytes left
	VPADDB Y2, Y2, Y2		// shift sum bytes left
	POPCNTL AX, AX			// carry bytes population count
	POPCNTL DX, DX			// sum bytes population count
	LEAL (DX)(AX*2), AX		// sum popcount plus 2x carry popcount
	ADDL AX, R12

	VPMOVMSKB Y0, AX		// MSB of carry out bytes
	VPMOVMSKB Y2, DX		// MSB of sum bytes
	VPADDB Y0, Y0, Y0		// shift carry out bytes left
	VPADDB Y2, Y2, Y2		// shift sum bytes left
	POPCNTL AX, AX			// carry bytes population count
	POPCNTL DX, DX			// sum bytes population count
	LEAL (DX)(AX*2), AX		// sum popcount plus 2x carry popcount
	ADDL AX, R11

	VPMOVMSKB Y0, AX		// MSB of carry out bytes
	VPMOVMSKB Y2, DX		// MSB of sum bytes
	VPADDB Y0, Y0, Y0		// shift carry out bytes left
	VPADDB Y2, Y2, Y2		// shift sum bytes left
	POPCNTL AX, AX			// carry bytes population count
	POPCNTL DX, DX			// sum bytes population count
	LEAL (DX)(AX*2), AX		// sum popcount plus 2x carry popcount
	ADDL AX, R10

	VPMOVMSKB Y0, AX		// MSB of carry out bytes
	VPMOVMSKB Y2, DX		// MSB of sum bytes
	VPADDB Y0, Y0, Y0		// shift carry out bytes left
	VPADDB Y2, Y2, Y2		// shift sum bytes left
	POPCNTL AX, AX			// carry bytes population count
	POPCNTL DX, DX			// sum bytes population count
	LEAL (DX)(AX*2), AX		// sum popcount plus 2x carry popcount
	ADDL AX, R9

	VPMOVMSKB Y0, AX		// MSB of carry out bytes
	VPMOVMSKB Y2, DX		// MSB of sum bytes
	POPCNTL AX, AX			// carry bytes population count
	POPCNTL DX, DX			// sum bytes population count
	LEAL (DX)(AX*2), AX		// sum popcount plus 2x carry popcount
	ADDL AX, R8

	SUBQ $96, CX
	JGE vector			// repeat as long as bytes are left

scalar:	ADDQ $96, CX			// undo last subtraction
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
