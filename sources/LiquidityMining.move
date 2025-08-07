module hrithvika_addr::LiquidityMining {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    struct LiquidityPool has store, key {
        total_liquidity: u64,        
        reward_rate: u64,            
        total_rewards: u64,          
        emission_blocks: u64,        
        start_block: u64,            
    }

    struct UserPosition has store, key {
        liquidity_amount: u64,       
        rewards_earned: u64,         
        last_claim_block: u64,       
    }

    public fun create_mining_pool(
        creator: &signer, 
        reward_rate: u64,
        emission_duration: u64
    ) {
        let pool = LiquidityPool {
            total_liquidity: 0,
            reward_rate,
            total_rewards: 0,
            emission_blocks: emission_duration,
            start_block: 0,
        };
        move_to(creator, pool);
    }

    public fun provide_liquidity(
        user: &signer,
        pool_address: address,
        liquidity_amount: u64
    ) acquires LiquidityPool {
        let pool = borrow_global_mut<LiquidityPool>(pool_address);
        pool.total_liquidity = pool.total_liquidity + liquidity_amount;
        
        let user_rewards = (liquidity_amount * pool.reward_rate) / 100;
        pool.total_rewards = pool.total_rewards + user_rewards;

        let position = UserPosition {
            liquidity_amount,
            rewards_earned: user_rewards,
            last_claim_block: 0,
        };
        move_to(user, position);
    }

}
