module decimal::decimal {

    use decimal::u128_math;

    // Errors.

    /// When can't cast `Decimal` to `u64` (e.g. number too large).
    const EU64_OVERFLOW: u64 = 0;

    const EU128_OVERFLOW: u64 = 1;

    /// Max `u64` value.
    const U64_MAX: u128 = 18446744073709551615;
    /// Max `u128` value.
    const U128_MAX: u128 = 340282366920938463463374607431768211455;

    /// Scaling factor to preserve precision: 10 * 18.
    const SCALING_FACTOR: u128 = 1000000000000000000;

    /// Scaling factor to preserve precision for percentage: 10 * 16.
    const PERCENTAGE_SCALING_FACTOR: u128 = 10000000000000000;

    /// Scaling factor to preserve precision for bips-based numbers: 10 * 14
    const BIPS_SCALING_FACTOR: u128 = 100000000000000;

    /// Scaling factor to preserve precision for millionth-based numbers: 10 * 12.
    const MILLIONTH_SCALING_FACTOR: u128 = 1000000000000;

    /// The `Decimal` resource.
    /// Contains 4 u64 numbers inside in vector `ret`.
    struct Decimal has copy, drop, store {
        val: u128,
    }

    // Public functions.

    public fun zero(): Decimal {
        Decimal {val: 0 }
    }

    public fun hundredth(): Decimal {
        Decimal {val: PERCENTAGE_SCALING_FACTOR }
    }

    public fun tenth(): Decimal {
        Decimal {val: SCALING_FACTOR / 10}
    }

    public fun half(): Decimal {
        Decimal {val: SCALING_FACTOR / 2}
    }

    public fun one(): Decimal {
        Decimal {val: SCALING_FACTOR}
    }

    public fun from_u8(val: u8): Decimal {
        from_u128((val as u128))
    }

    public fun from_u64(val: u64): Decimal {
        from_u128((val as u128))
    }

    public fun from_u128(val: u128): Decimal {
        Decimal {val: SCALING_FACTOR * val}
    }

    public fun from_scaled_val(val: u128): Decimal {
        Decimal {val}
    }

    public fun from_percentage(pct: u128): Decimal {
        mul(from_u128(pct), hundredth())
    }

    public fun from_bips(bips: u128): Decimal {
        from_scaled_val(bips * BIPS_SCALING_FACTOR)
    }

    public fun from_millionth(val: u128): Decimal {
        from_scaled_val(val * MILLIONTH_SCALING_FACTOR)
    }

    public fun eq(a: Decimal, b: Decimal): bool {
        a.val == b.val
    }

    public fun lt(a: Decimal, b: Decimal): bool {
        a.val < b.val
    }

    public fun gt(a: Decimal, b: Decimal): bool {
        a.val > b.val
    }

    public fun lte(a: Decimal, b: Decimal): bool {
        a.val <= b.val
    }

    public fun gte(a: Decimal, b: Decimal): bool {
        a.val >= b.val
    }

    public fun max(a: Decimal, b: Decimal): Decimal {
        if (gte(a, b)) {
            return a
        };
        b
    }

    public fun min(a: Decimal, b: Decimal): Decimal {
        if (lte(a, b)) {
            return a
        };
        b
    }

    /// Adds two `Decimal` and returns sum.
    public fun add(a: Decimal, b: Decimal): Decimal {
        assert!(a.val + b.val <= U128_MAX, EU128_OVERFLOW);
        Decimal {val: a.val + b.val}
    }

    public fun sub(a: Decimal, b: Decimal): Decimal {
        Decimal {val: a.val - b.val}
    }

    public fun mul(a: Decimal, b: Decimal): Decimal {
        Decimal {
            val: u128_math::mul_div_u128(a.val, b.val, SCALING_FACTOR)
        }
    }

    public fun mul_u64(a: Decimal, b: u64): Decimal {
        mul_u128(a, (b as u128))
    }

    public fun mul_u128(a: Decimal, b: u128): Decimal {
        mul(a, from_u128(b))
    }

    public fun div(a: Decimal, b: Decimal): Decimal {
        Decimal {
            val: u128_math::mul_div_u128(a.val, SCALING_FACTOR, b.val)
        }
    }

    public fun div_u64(a: Decimal, b: u64): Decimal {
        div_u128(a, (b as u128))
    }

    public fun mul_div(mul_a: Decimal, mul_b: Decimal, div: Decimal): Decimal {
        from_scaled_val(u128_math::mul_div_u128(mul_a.val, mul_b.val, div.val))
    }

    public fun div_u128(a: Decimal, b: u128): Decimal {
        div(a, from_u128(b))
    }

    public fun as_u64(a: Decimal): u64 {
        let retu128 = as_u128(a);
        assert!(retu128 <= U64_MAX, EU64_OVERFLOW);
        (retu128 as u64)
    }

    /// Convert `Decimal` to `u128` value if possible (otherwise it aborts).
    public fun as_u128(a: Decimal): u128 {
        a.val / SCALING_FACTOR
    }

    public fun as_percentage(a: Decimal): u128 {
        a.val / PERCENTAGE_SCALING_FACTOR
    }

    public fun raw(a: Decimal): u128 {
        a.val
    }

    public fun floor(a: Decimal): Decimal {
        let a_frac = a.val % SCALING_FACTOR;
        sub(a, Decimal { val: a_frac })
    }

    public fun floor_u64(a: Decimal): u64 {
        as_u64(floor(a))
    }

    public fun ceil(a: Decimal): Decimal {
        let floor_a = floor(a);
        if (eq(a, floor_a)) {
            return a
        };
        add(floor_a, from_u64(1))
    }

    public fun ceil_u64(a: Decimal): u64 {
        as_u64(ceil(a))
    }

    public fun round(a: Decimal): Decimal {
        let floor_a = floor(a);
        let floor_a_succ = add(floor_a, from_u64(1));
        if (gte(a, div(add(floor_a, floor_a_succ), from_u64(2)))) {
            return floor_a_succ
        };
        floor_a
    }

    public fun round_u64(a: Decimal): u64 {
        as_u64(round(a))
    }
}
