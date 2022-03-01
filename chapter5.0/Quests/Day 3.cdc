1. What does "force casting" with as! do? Why is it useful in our Collection?

Answer : force casting "as!" means to force down cast a generic type to a sub-type.
If the sub-type cannot be casted, it will panic and abort.
It is used to ensure the NFT is of the specific type in the NFT Collection deposit function's case.

2. What does auth do? When do we use it?

Answer : as auth returns an authorized reference. To down cast a reference, you need an authorized reference.
You can use it like this
let nftRef : &NonFungibleToken.NFT = &NFT as auth &NonFungibleToken.NFT
let downCastedRef : &NFT = nftRef as ! &NFT


3. This last quest will be your most difficult yet. Take this contract:

import NonFungibleToken from 0x02
pub contract CryptoPoops: NonFungibleToken {
  pub var totalSupply: UInt64

  pub event ContractInitialized()
  pub event Withdraw(id: UInt64, from: Address?)
  pub event Deposit(id: UInt64, to: Address?)

  pub resource NFT: NonFungibleToken.INFT {
    pub let id: UInt64

    pub let name: String
    pub let favouriteFood: String
    pub let luckyNumber: Int

    init(_name: String, _favouriteFood: String, _luckyNumber: Int) {
      self.id = self.uuid

      self.name = _name
      self.favouriteFood = _favouriteFood
      self.luckyNumber = _luckyNumber
    }
  }

  pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
    pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

    pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
      let nft <- self.ownedNFTs.remove(key: withdrawID) 
            ?? panic("This NFT does not exist in this Collection.")
      emit Withdraw(id: nft.id, from: self.owner?.address)
      return <- nft
    }

    pub fun deposit(token: @NonFungibleToken.NFT) {
      let nft <- token as! @NFT
      emit Deposit(id: nft.id, to: self.owner?.address)
      self.ownedNFTs[nft.id] <-! nft
    }

    pub fun getIDs(): [UInt64] {
      return self.ownedNFTs.keys
    }

    pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
      return &self.ownedNFTs[id] as &NonFungibleToken.NFT
    }

    init() {
      self.ownedNFTs <- {}
    }

    destroy() {
      destroy self.ownedNFTs
    }
  }

  pub fun createEmptyCollection(): @NonFungibleToken.Collection {
    return <- create Collection()
  }

  pub resource Minter {

    pub fun createNFT(name: String, favouriteFood: String, luckyNumber: Int): @NFT {
      return <- create NFT(_name: name, _favouriteFood: favouriteFood, _luckyNumber: luckyNumber)
    }

    pub fun createMinter(): @Minter {
      return <- create Minter()
    }

  }

  init() {
    self.totalSupply = 0
    emit ContractInitialized()
    self.account.save(<- create Minter(), to: /storage/Minter)
  }
}

and add a function called borrowAuthNFT just like we did in the section called "The Problem" above. 
Then, find a way to make it publically accessible to other people so they can read our NFT's metadata. 
Then, run a script to display the NFTs metadata for a certain id.

You will have to write all the transactions to set up the accounts, mint the NFTs, 
and then the scripts to read the NFT's metadata. 
We have done most of this in the chapters up to this point, so you can look for help there :)


Ans:

Contract : 

import NonFungibleToken from 0x02
pub contract CryptoPoops: NonFungibleToken {
  pub var totalSupply: UInt64

  pub event ContractInitialized()
  pub event Withdraw(id: UInt64, from: Address?)
  pub event Deposit(id: UInt64, to: Address?)

  pub resource NFT: NonFungibleToken.INFT {
    pub let id: UInt64

    /* metadata specific for this NFT */
    pub let name: String
    pub let favouriteFood: String
    pub let luckyNumber: Int

    init(_name: String, _favouriteFood: String, _luckyNumber: Int) {
      self.id = self.uuid

      CryptoPoops.totalSupply = CryptoPoops.totalSupply + 1

      self.name = _name
      self.favouriteFood = _favouriteFood
      self.luckyNumber = _luckyNumber
    }
  }

  pub resource interface CollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowPoop(id: UInt64): &NFT 
  }

  pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, CollectionPublic {
    pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

    pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
      let nft <- self.ownedNFTs.remove(key: withdrawID) 
            ?? panic("This NFT does not exist in this Collection.")
      emit Withdraw(id: nft.id, from: self.owner?.address)
      return <- nft
    }

    pub fun deposit(token: @NonFungibleToken.NFT) {
      let nft <- token as! @NFT
      emit Deposit(id: nft.id, to: self.owner?.address)
      self.ownedNFTs[nft.id] <-! nft
    }

    pub fun getIDs(): [UInt64] {
      return self.ownedNFTs.keys
    }

    pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
      return &self.ownedNFTs[id] as &NonFungibleToken.NFT
    }

    /* Self Implemented Function for borrowing NFT reference for this contract */

    pub fun borrowPoop(id: UInt64): &NFT {
      let nftRef = &self.ownedNFTs[id] as auth &NonFungibleToken.NFT
      return nftRef as! &CryptoPoops.NFT
    }

    init() {
      self.ownedNFTs <- {}
    }

    destroy() {
      destroy self.ownedNFTs
    }
  }

  pub fun createEmptyCollection(): @NonFungibleToken.Collection {
    return <- create Collection()
  }

  pub resource Minter {

    pub fun createNFT(name: String, favouriteFood: String, luckyNumber: Int): @NFT {
      return <- create NFT(_name: name, _favouriteFood: favouriteFood, _luckyNumber: luckyNumber)
    }

    pub fun createMinter(): @Minter {
      return <- create Minter()
    }

  }

  init() {
    self.totalSupply = 0
    emit ContractInitialized()
    self.account.save(<- create Minter(), to: /storage/Minter)
  }
}



Transactions:

1. set up account 

import CryptoPoops from 0x01

transaction {

  prepare(acct: AuthAccount) {
    if acct.borrow<&CryptoPoops.Collection>(from: /storage/CryptoPoopsCollection) == nil {
      acct.save(<- CryptoPoops.createEmptyCollection() , to: /storage/CryptoPoopsCollection)
      acct.link<&CryptoPoops.Collection{CryptoPoops.CollectionPublic}>(/public/CryptoPoopsCollection, target: /storage/CryptoPoopsCollection)
    }
   
  }

  execute {
  }
}





2. mint NFT

import CryptoPoops from 0x01

transaction(addr: Address, name: String, favouriteFood: String, luckyNumber: Int) {

  prepare(acct: AuthAccount) {
    /* set up the account Collection if you havent do it */
    if acct.borrow<&CryptoPoops.Collection>(from: /storage/CryptoPoopsCollection) == nil {
      acct.save(<- CryptoPoops.createEmptyCollection() , to: /storage/CryptoPoopsCollection)
      acct.link<&CryptoPoops.Collection{CryptoPoops.CollectionPublic}>(/public/CryptoPoopsCollection, target: /storage/CryptoPoopsCollection)
    }

    /* get receiver collection reference */ 
    let collectionRef = getAccount(addr).getCapability<&CryptoPoops.Collection{CryptoPoops.CollectionPublic}>(/public/CryptoPoopsCollection)
                        .borrow() ?? panic("Cannot borrow collection reference ")

    /* minting NFT with Minter */ 
    let minterRef = acct.borrow<&CryptoPoops.Minter>(from: /storage/Minter) ?? panic("Cannot borrow minter reference")
    let nft <- minterRef.createNFT(name: name, favouriteFood: favouriteFood, luckyNumber: luckyNumber)
    
    /* deposit the nft thru the collectionRef */
    collectionRef.deposit(token: <- nft)
   
  }

  execute {
  }
}


Scripts 

1. Read all NFTs under a collection

import CryptoPoops from 0x01

pub fun main(addr: Address): [UInt64] {

/* get receiver collection reference */ 
    let collectionRef = getAccount(addr).getCapability<&CryptoPoops.Collection{CryptoPoops.CollectionPublic}>(/public/CryptoPoopsCollection)
                        .borrow() ?? panic("Cannot borrow collection reference ")
    return collectionRef.getIDs()
}



2. Read the metadata under the NFT

import CryptoPoops from 0x01

pub fun main(addr: Address, id: UInt64): {String : AnyStruct} {

/* define a dictionary to get the returned metadata */ 
    var metadata : {String : AnyStruct} = {}

/* get receiver collection reference */ 
    let collectionRef = getAccount(addr).getCapability<&CryptoPoops.Collection{CryptoPoops.CollectionPublic}>(/public/CryptoPoopsCollection)
                        .borrow() ?? panic("Cannot borrow collection reference ")
    
    let poopRef = collectionRef.borrowPoop(id: id)
    metadata["name"] = poopRef.name
    metadata["favouriteFood"] = poopRef.favouriteFood
    metadata["luckyNumber"] = poopRef.luckyNumber

    return metadata

}
