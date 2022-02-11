1. Brainstorm some extra things we may want to add to this contract. Think about what might be problematic with this contract and how we could fix it.

    Idea #1: Do we really want everyone to be able to mint an NFT? (insert thinking emoji here). 
        We should make minting NFT an admin function , 
        we can put the minting function inside a resource which only stores in the contract account storage.

    Idea #2: If we want to read information about our NFTs inside our Collection, 
    right now we have to take it out of the Collection to do so. Is this good?
        We can have functions in the Collection (and also expose to the public) to return the reference to the ownedNFTs,
        so that when people want to get information of the ownedNFTs, they can borrow the reference.