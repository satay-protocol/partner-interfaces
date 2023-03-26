module oracle::oracle {

    use aptos_std::type_info::TypeInfo;

    use decimal::decimal::{Self, Decimal};

    public fun get_price(_type_info: TypeInfo): Decimal {
        decimal::zero()
    }
}
