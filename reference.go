package pospopcnt

// vectorised positional popcount with counters in registers
func PospopcntReg(counts *[8]int32, buf []byte)

// vectorised positional popcount with counters in registers
// and 3-way CSA reduction
func PospopcntRegCSA3(counts *[8]int32, buf []byte)

// vectorised positional popcount with counters in registers
// and 7-way CSA reduction
func PospopcntRegCSA7(counts *[8]int32, buf []byte)

// vectorised positional popcount with counters in registers
// and 15-way CSA reduction
func PospopcntRegCSA15(counts *[8]int32, buf []byte)

// vectorised positional popcount with counters in memory
// and 15-way CSA reduction
func PospopcntMemCSA15(counts *[8]int32, buf []byte)

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
