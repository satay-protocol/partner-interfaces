module decimal::u128_math {
    /// When the result exceeds the maximum range of u128
    const EU128_MATH_OVERFLOW: u64 = 1;
    /// When we encountered a div zero error
    const EU128_MATH_DIV_ZERO: u64 = 2;

    public fun ascending_u128(a: u128, b: u128): (u128, u128) {
        if (a <= b) {
            (a, b)
        } else {
            (b, a)
        }
    }

    public fun tailing_zeros_u128(n: u128): u8 {
        let acc: u8 = 0;

        if (n >> 64 > 0) {
            acc = acc + 64;
            n = n >> 64;
        };

        if (n >> 32 > 0) {
            acc = acc + 32;
            n = n >> 32;
        };

        if (n >> 16 > 0) {
            acc = acc + 16;
            n = n >> 16
        };

        if (n >> 8 > 0) {
            acc = acc + 8;
            n = n >> 8;
        };

        if (n >> 4 > 0) {
            acc = acc + 4;
            n = n >> 4;
        };

        if (n >> 2 > 0) {
            acc = acc + 2;
            n = n >> 2;
        };

        acc = acc + (n / 2 as u8);

        acc
    }

    public fun leading_zeros_u128(n: u128): u8 {
        let acc: u8 = 128;

        if (n >> 64 > 0) {
            acc = acc - 64;
            n = n >> 64;
        };

        if (n >> 32 > 0) {
            acc = acc - 32;
            n = n >> 32;
        };

        if (n >> 16 > 0) {
            acc = acc - 16;
            n = n >> 16
        };

        if (n >> 8 > 0) {
            acc = acc - 8;
            n = n >> 8;
        };

        if (n >> 4 > 0) {
            acc = acc - 4;
            n = n >> 4;
        };

        if (n >> 2 > 0) {
            acc = acc - 2;
            n = n >> 2;
        };

        if (n >> 1 > 0) {
            acc - 2
        } else {
            acc - (n as u8)
        }
    }

    public fun bits_u128(n: u128): u8 {
        128 - leading_zeros_u128(n)
    }

    fun gcd_u128(m: u128, n: u128): u128 {
        if (m == 0) {
            n
        } else {
            gcd_u128(n % m, m)
        }
    }

    fun reduce_fraction_u128(m: u128, n: u128): (u128, u128) {
        let d = gcd_u128(m, n);
        (m / d, n / d)
    }

    fun mul_div_u128_when_overflow(a: u128, b: u128, d: u128): u128 {
        // In this case, we have to remove some tailing bits in both
        // the dividend and divisor. It could cause extra precision loss.
        let a_bits = (bits_u128(a) as u64);
        let b_bits = (bits_u128(b) as u64);
        let overflow_bits = a_bits + b_bits - 128;
        let a_drop_bits = overflow_bits * a_bits / (a_bits + b_bits);
        let b_drop_bits = overflow_bits - a_drop_bits;

        let overflow_bits = (overflow_bits as u8);
        let a_drop_bits = (a_drop_bits as u8);
        let b_drop_bits = (b_drop_bits as u8);

        if (d >> (overflow_bits) == 0) {
            abort(EU128_MATH_OVERFLOW)
        } else {
            (a >> a_drop_bits) * (b >> b_drop_bits) / (d >> overflow_bits)
        }
    }

    public fun mul_div_u128(mul_a: u128, mul_b: u128, divisor: u128): u128 {
        assert!(divisor != 0, EU128_MATH_DIV_ZERO);
        let (a, d) = reduce_fraction_u128(mul_a, divisor);
        let (b, d) = reduce_fraction_u128(mul_b, d);

        let a_bits = (bits_u128(a) as u64);
        let b_bits = (bits_u128(b) as u64);
        if (a_bits + b_bits <= 128) {
            a * b / d
        } else {
            let a_i = a / d;
            let a_f = a % d;
            let b_i = b / d;
            let b_f = b % d;

            assert!(is_mul_128_safe(a_i, b_i), EU128_MATH_OVERFLOW);
            assert!(is_mul_128_safe(a_i * b_i, d), EU128_MATH_OVERFLOW);
            let res = a_i * b_i * d + a_f * b_i + a_i * b_f;
            if ((bits_u128(a_f) as u64) + (bits_u128(b_f) as u64) <= 128) {
                res = res + a_f * b_f / d
            } else {
                res = res + mul_div_u128_when_overflow(a_f, b_f, d);
            };

            res
        }
    }

    fun is_mul_128_safe(a: u128, b: u128): bool {
        (bits_u128(a) as u64) + (bits_u128(b) as u64) <= 128
    }
}