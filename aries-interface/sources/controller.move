module aries::controller {

    public entry fun register_user(_user: &signer, _seed: vector<u8>) {}

    public entry fun deposit<CoinType>(
        _account: &signer,
        _profile_name: vector<u8>,
        _amount: u64,
        _repay_only: bool,
    ) {}

    public entry fun withdraw<CoinType>(
        _account: &signer,
        _profile_name: vector<u8>,
        _amount: u64,
        _allow_borrow: bool,
    ){}

    public entry fun hippo_swap<
        InCoin, Y, Z, OutCoin, E1, E2, E3
    >(
        _account: &signer,
        _profile_name: vector<u8>,
        _allow_borrow: bool,
        _amount: u64,
        _minimum_out: u64,
        _num_steps: u8,
        _first_dex_type: u8,
        _first_pool_type: u64,
        _first_is_x_to_y: bool,
        _second_dex_type: u8,
        _second_pool_type: u64,
        _second_is_x_to_y: bool,
        _third_dex_type: u8,
        _third_pool_type: u64,
        _third_is_x_to_y: bool,
    ) {}

    public entry fun add_subaccount(
        _account: &signer,
        _profile_name: vector<u8>,
    ) {}
}
