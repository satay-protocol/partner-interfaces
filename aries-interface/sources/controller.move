module aries_interface::controller {

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
}
