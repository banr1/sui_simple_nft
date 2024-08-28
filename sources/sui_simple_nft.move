module sui_simple_nft::simple_nft {
    use std::string;
    use sui::event;

    /// An example NFT that can be minted by anybody
    public struct SimpleNFT has key, store {
        id: UID,
        /// Name for the token
        name: string::String,
        /// Description of the token
        description: string::String,
    }

    // ===== Events =====

    public struct NFTMinted has copy, drop {
        // The Object ID of the NFT
        object_id: ID,
        // The creator of the NFT
        creator: address,
        // The name of the NFT
        name: string::String,
    }

    // ===== Public view functions =====

    /// Get the NFT's `name`
    public fun name(nft: &SimpleNFT): &string::String {
        &nft.name
    }

    /// Get the NFT's `description`
    public fun description(nft: &SimpleNFT): &string::String {
        &nft.description
    }

    // ===== Entrypoints =====

    #[allow(lint(self_transfer))]
    /// Create a new NFT and mint it to the sender
    public fun mint_to_sender(ctx: &mut TxContext) {
        let sender = ctx.sender();
        let nft = SimpleNFT {
            id: object::new(ctx),
            name: string::utf8(b"Simple NFT"),
            description: string::utf8(b"This is a simple NFT."),
        };

        event::emit(NFTMinted {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });

        transfer::public_transfer(nft, sender);
    }

    /// Transfer `nft` to `recipient`
    public fun transfer(
        nft: SimpleNFT, recipient: address, _: &mut TxContext
    ) {
        transfer::public_transfer(nft, recipient)
    }
}
