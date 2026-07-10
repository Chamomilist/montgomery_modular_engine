import random


def montgomery_multiply(a, b, n, width=4, debug=True):
    """
    Reference Montgomery multiplication model.
    Mirrors the RTL datapath.
    """

    t = 0

    if debug:
        print("--------------------------------")
        print("Iteration Trace")
        print("--------------------------------")

    for i in range(width):
        current_bit = (b >> i) & 1

        if current_bit:
            t += a

        if t & 1:
            t += n

        t >>= 1

        if debug:
            print(f"Iter {i:3d} | Bit={current_bit} | T={t}")

    if t >= n:
        t -= n

    if debug:
        print("--------------------------------")
        print(f"Final Result = {t}")
        print("--------------------------------")

    return t


def generate_vector(width, rng):
    """
    Generate a single (a, b, n, expected) vector.

    n is forced odd, since Montgomery reduction requires gcd(n, 2) == 1
    (the algorithm divides by 2 each iteration). n's bit-length is randomized
    up to `width` so vectors exercise moduli of varying size, while the
    Montgomery radix R = 2^width stays fixed to match the RTL's fixed
    iteration count (bit_counter always counts 0..WIDTH-1 regardless of
    how many of N's bits are actually significant).
    """
    n_bits = rng.randint(2, width)
    n = rng.getrandbits(n_bits) | 1  # force odd
    n |= 1 << (n_bits - 1)  # force top bit of chosen length, avoid tiny/degenerate n
    if n <= 1:
        n = 3

    a = rng.randrange(0, n)
    b = rng.randrange(0, n)

    expected = montgomery_multiply(a, b, n, width=width, debug=False)
    return a, b, n, expected


def generate_vectors(
    num_vectors=100, width=256, seed=None, filename="generated_vectors.mem"
):
    """
    Generate `num_vectors` randomized test vectors and write them to `filename`
    in a format readable by SystemVerilog's $fscanf:

        <A hex> <B hex> <N hex> <EXPECTED hex>

    one vector per line, each field zero-padded to width/4 hex digits so
    $fscanf("%h %h %h %h", ...) reads consistent field widths.
    """
    rng = random.Random(seed)
    hex_digits = width // 4

    vectors = []
    with open(filename, "w") as f:
        for _ in range(num_vectors):
            a, b, n, expected = generate_vector(width, rng)
            f.write(
                f"{a:0{hex_digits}x} {b:0{hex_digits}x} "
                f"{n:0{hex_digits}x} {expected:0{hex_digits}x}\n"
            )
            vectors.append((a, b, n, expected))

    return vectors


def print_summary(vectors, width, filename):
    print("--------------------------------")
    print("Montgomery Random Vector Generation")
    print("--------------------------------")
    print(f"WIDTH           = {width}")
    print(f"Vectors written = {len(vectors)}")
    print(f"Output file     = {filename}")
    print("--------------------------------")
    print("Sample vectors (first 5):")
    for i, (a, b, n, expected) in enumerate(vectors[:5]):
        print(f"  [{i}] A=0x{a:x}  B=0x{b:x}  N=0x{n:x}  Expected=0x{expected:x}")
    if len(vectors) > 5:
        print(f"  ... ({len(vectors) - 5} more)")
    print("--------------------------------")


def run_demo():
    """Preserves the original single-vector illustrative demo."""
    a, b, n = 7, 11, 13
    result = montgomery_multiply(a, b, n, width=4, debug=True)

    print()
    print("--------------------------------")
    print("Python Montgomery Reference (demo)")
    print("--------------------------------")
    print(f"A      = {a}")
    print(f"B      = {b}")
    print(f"N      = {n}")
    print(f"Result = {result}")
    print("--------------------------------")


if __name__ == "__main__":
    # WIDTH must match the RTL's WIDTH parameter (see montgomery_engine_tb.sv / DUT instantiation)
    WIDTH = 256
    NUM_VECTORS = 100
    SEED = 12345  # fixed seed for reproducible regressions; set to None for fresh randomness
    OUTFILE = "generated_vectors.mem"

    vectors = generate_vectors(
        num_vectors=NUM_VECTORS,
        width=WIDTH,
        seed=SEED,
        filename=OUTFILE,
    )
    print_summary(vectors, WIDTH, OUTFILE)
