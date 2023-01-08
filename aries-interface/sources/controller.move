module aries_interface::controller {

    use std::signer;
    use std::string::String;

    use aptos_framework::coin::{Self, Coin};

    use aries_interface::profile::CheckEquity;
    use aries_interface::profile;
    use aptos_std::type_info;

    /// create an account for signing user
    /// @param user - the signing user
    /// @param _account - the return value of string::bytes() for the account name
    public entry fun register_user(
        _user: &signer,
        _account: vector<u8>
    ) {}

    /// deposit CoinType as collateral or as debt repayment
    /// @param user - the signing user
    /// @param _account - the return value of string::bytes() for the account name
    /// @param _amount - the amount of CoinType to deposit
    /// @param _isDebtPayment - true if the deposit is a debt repayment, false if it is collateral
    public entry fun deposit<CoinType>(
        _user: &signer,
        _account: vector<u8>,
        _amount: u64,
        _isDebtPayment: bool
    ) {}

    /// withdraw CoinType collateral or borrow CoinType
    /// @param user - the signing user
    /// @param _account - the return value of string::bytes() for the account name
    /// @param _amount - the amount of CoinType to withdraw
    /// @param _isBorrow - true if the withdraw is a borrow, false if it is collateral
    public entry fun withdraw<CoinType>(
        _user: &signer,
        _account: vector<u8>,
        _amount: u64,
        _isBorrow: bool
    ) {}

    /// open a flash loan for CoinType of amount for user's account
    /// @param user - the signing user
    /// @param account - the name of the account taking the loan
    /// @param amount - the amount of CoinType to flash loan
    public fun begin_flash_loan<CoinType>(
        user: &signer,
        account: String,
        amount: u64,
    ): (CheckEquity, Coin<CoinType>) {
        let (_, _, check_equity) = profile::withdraw_flash_loan(
            signer::address_of(user),
            account,
            type_info::type_of<CoinType>(),
            amount,
            false
        );
        (check_equity, coin::zero<CoinType>())
    }

    /// close a flash loan for CoinType of amount for user's account
    /// @param check_equity - the return value of begin_flash_loan
    /// @param coin - the coins initially borrowed
    public fun end_flash_loan<CoinType>(
        check_equity: CheckEquity,
        coin: Coin<CoinType>,
    ) {
        let (_user_addr, _account) = profile::read_check_equity_data(check_equity);
        coin::destroy_zero(coin);
    }
}
