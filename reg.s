#include "textflag.h"

// func PospopcntReg(counts *[8]int32, buf []byte)
TEXT ·PospopcntReg(SB),NOSPLIT,$0-32
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

	SUBQ $32, CX			// pre-subtract 32 bit from CX
	JL scalar

vector:	VMOVDQU (SI), Y0		// load 32 bytes from buf
	PREFETCHT0 384(SI)		// prefetch some data
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

	SHRL $1, AX			// CF=LSB, shift byte to the right
	ADCL $0, R8			// add CF to R8

	SHRL $1, AX
	ADCL $0, R9			// add CF to R9

	SHRL $1, AX
	ADCL $0, R10			// add CF to R10

	SHRL $1, AX
	ADCL $0, R11			// add CF to R11

	SHRL $1, AX
	ADCL $0, R12			// add CF to R12

	SHRL $1, AX
	ADCL $0, R13			// add CF to R13

	SHRL $1, AX
	ADCL $0, R14			// add CF to R14

	SHRL $1, AX
	ADCL $0, R15			// add CF to R15

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
