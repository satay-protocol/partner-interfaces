module aries::oracle {

    use aries::decimal::Decimal;
    use aries::decimal;

    public fun get_price(): Decimal {
        decimal::zero()
    }
}
