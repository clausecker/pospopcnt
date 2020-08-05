package pospopcnt

import "math/rand"
import "testing"
import "strconv"

// test sizes
var testSizes = []int{ 10, 32, 1000, 2000, 4000, 10000, 100000, 10000000, 1000000000 }

func TestScalarReg(t *testing.T) {
	testHarness(PospopcntScalarReg, t)
}

func TestScalarMem(t *testing.T) {
	testHarness(PospopcntScalarMem, t)
}

func TestReg(t *testing.T) {
	testHarness(PospopcntReg, t)
}

func TestRegCSA3(t *testing.T) {
	testHarness(PospopcntRegCSA3, t)
}

func TestMem(t *testing.T) {
	testHarness(PospopcntMem, t)
}

func BenchmarkReference(b *testing.B) {
	outerHarness(PospopcntReference, b)
}

func BenchmarkScalarReg(b *testing.B) {
	outerHarness(PospopcntScalarReg, b)
}

func BenchmarkScalarMem(b *testing.B) {
	outerHarness(PospopcntScalarMem, b)
}

func BenchmarkReg(b *testing.B) {
	outerHarness(PospopcntReg, b)
}

func BenchmarkRegCSA3(b *testing.B) {
	outerHarness(PospopcntRegCSA3, b)
}

func BenchmarkMem(b *testing.B) {
	outerHarness(PospopcntMem, b)
}


// test harness: make sure the function does the same thing as the reference.
func testHarness(pospopcnt func(*[8]int32, []byte), t *testing.T) {
	t.Helper()

	buf := make([]byte, 12345) // an intentionally odd nmber
	rand.Read(buf)

	refCounts := [8]int32{1234112, 12341234, 5635635, 423452345, 2345232, 32452345, 23452452, 2342542,}
	testCounts := refCounts

	PospopcntReference(&refCounts, buf)
	pospopcnt(&testCounts, buf)

	if refCounts != testCounts {
		t.Error("counts don't match")
	}
}

// outer harness: run benchmarks on pospopcnt for various data sizes.
func outerHarness(pospopcnt func(*[8]int32, []byte), b *testing.B) {
	for i := range testSizes {
		b.Run(strconv.Itoa(testSizes[i]), func(b *testing.B) {
			innerHarness(pospopcnt, b, testSizes[i])
		})
	}
}

// inner harness: benchmark harness for one test at one data size
func innerHarness(pospopcnt func(*[8]int32, []byte), b *testing.B, n int) {
	b.Helper()

	if n <= 0 {
		b.Errorf("buffer size must be positive: %d", n)
	}

	b.SetBytes(int64(n))

	buf := make([]byte, n)
	rand.Read(buf)

	var counts [8]int32

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		pospopcnt(&counts, buf)
	}
}
