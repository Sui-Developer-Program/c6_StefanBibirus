module tip_jar::tip_jar {

    use sui::coin::{Self, Coin};
    use sui::sui::SUI;

    public struct TipJar has key {
        id: object::UID,
        balance: u64,
        no_of_tips: u64,
        owner: address,
    }

    fun init(ctx: &mut tx_context::TxContext) {
        let tip_jar = TipJar {
            id: object::new(ctx),
            balance: 0,
            no_of_tips: 0,
            owner: tx_context::sender(ctx),
        };
        transfer::share_object(tip_jar);
    }

    public fun tip(tip_jar: &mut TipJar, payment: Coin<SUI>) {
        let amount = coin::value(&payment);
        tip_jar.balance = tip_jar.balance + amount;
        tip_jar.no_of_tips = tip_jar.no_of_tips + 1;
        transfer::public_transfer(payment, tip_jar.owner);
    }
}
