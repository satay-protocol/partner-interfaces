module aries::profile {

    use std::string::String;

    use aptos_std::type_info::TypeInfo;

    use aries::decimal::{Self, Decimal};

    /// A hot potato struct to make sure equity is checked for a given `Profile`.
    struct CheckEquity {
        /// The address of the user.
        user_addr: address,
        /// The name of the user's `Profile`.
        profile_name: String
    }

    public fun available_borrowing_power(_addr: address, _name: String): Decimal {
        decimal::zero()
    }

    public fun get_borrowed_amount(
        _user_addr: address,
        _profile_name: String,
        _coin_type: TypeInfo
    ): Decimal {
        decimal::zero()
    }

    public fun get_deposited_amount(
        _user_addr: address,
        _profile_name: String,
        _coin_type: TypeInfo
    ): u64 {
        0
    }
}