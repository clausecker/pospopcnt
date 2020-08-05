#include "textflag.h"

// func PospopcntScalarReg(counts *[8]int32, buf []byte)
TEXT ·PospopcntScalarReg(SB),NOSPLIT,$0-32
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

	TESTQ CX, CX
	JE done				// if CX=0, there's nothing left

loop:	MOVBLZX (SI), AX		// load a byte from buf
	INCQ SI				// advance past it

	BTL $0, AX			// is bit 0 set?
	ADCL $0, R8			// add it to R8

	BTL $1, AX			// is bit 1 set?
	ADCL $0, R9			// add it to R9

	BTL $2, AX			// is bit 2 set?
	ADCL $0, R10			// add it to R10

	BTL $3, AX			// is bit 3 set?
	ADCL $0, R11			// add it to R11

	BTL $4, AX			// is bit 4 set?
	ADCL $0, R12			// add it to R12

	BTL $5, AX			// is bit 5 set?
	ADCL $0, R13			// add it to R13

	BTL $6, AX			// is bit 6 set?
	ADCL $0, R14			// add it to R14

	BTL $7, AX			// is bit 7 set?
	ADCL $0, R15			// add it to R15

	DECQ CX				// mark this byte as done
	JNE loop			// and procced if any bytes are left

	// write R8--R15 back to counts
done:	MOVL R8, 4*0(DI)
	MOVL R9, 4*1(DI)
	MOVL R10, 4*2(DI)
	MOVL R11, 4*3(DI)
	MOVL R12, 4*4(DI)
	MOVL R13, 4*5(DI)
	MOVL R14, 4*6(DI)
	MOVL R15, 4*7(DI)

	RET

// func PospopcntScalarMem(counts *[8]int32, buf []byte)
TEXT ·PospopcntScalarMem(SB),NOSPLIT,$0-32
	MOVQ counts+0(FP), DI
	MOVQ buf_base+8(FP), SI		// SI = &buf[0]
	MOVQ buf_len+16(FP), CX		// CX = len(buf)

	TESTQ CX, CX
	JE done				// if CX=0, there's nothing left

loop:	MOVBLZX (SI), AX		// load a byte from buf
	INCQ SI				// advance past it

	BTL $0, AX			// is bit 0 set?
	ADCL $0, 4*0(DI)		// add it to the counters

	BTL $1, AX			// is bit 1 set?
	ADCL $0, 4*1(DI)		// add it to the counters

	BTL $2, AX			// is bit 2 set?
	ADCL $0, 4*2(DI)		// add it to the counters

	BTL $3, AX			// is bit 3 set?
	ADCL $0, 4*3(DI)		// add it to the counters

	BTL $4, AX			// is bit 4 set?
	ADCL $0, 4*4(DI)		// add it to the counters

	BTL $5, AX			// is bit 5 set?
	ADCL $0, 4*5(DI)		// add it to the counters

	BTL $6, AX			// is bit 6 set?
	ADCL $0, 4*6(DI)		// add it to the counters

	BTL $7, AX			// is bit 7 set?
	ADCL $0, 4*7(DI)		// add it to the counters

	DECQ CX				// mark this byte as done
	JNE loop			// and proceed if any bytes are left

done:	RET