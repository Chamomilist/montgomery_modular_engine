def montgomery_multiply(a, b, n, width=256, debug=True):
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


def run_demo():

    a = 7
    b = 11
    n = 13

    result = montgomery_multiply(a, b, n, debug=True)

    print()
    print("--------------------------------")
    print("Python Montgomery Reference")
    print("--------------------------------")
    print(f"A      = {a}")
    print(f"B      = {b}")
    print(f"N      = {n}")
    print(f"Result = {result}")
    print("--------------------------------")


if __name__ == "__main__":
    run_demo()
