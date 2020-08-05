package pospopcnt

// vectorised positional popcount with counters in registers
func PospopcntReg(counts *[8]int32, buf []byte)

// vectorised positional popcount with counters in memory
func PospopcntMem(counts *[8]int32, buf []byte)

// scalar positional popcount with counters in registers
func PospopcntScalarReg(counts *[8]int32, buf []byte)

// scalar positional popcount with counters in memory
func PospopcntScalarMem(counts *[8]int32, buf []byte)

// positional popcount reference implementation
func PospopcntReference(counts *[8]int32, buf []byte) {
	for i := 0; i < len(buf); i++ {
		for j := 0; j < 8; j++ {
			(*counts)[j] += int32(buf[i]) >> j & 1
		}
	}
}