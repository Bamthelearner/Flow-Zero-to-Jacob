As always, feel free to answer in the language of your choice.

1. In words, list 3 reasons why structs are different from resources.

Resoueces cannot be copied.
Resources cannot be created outside of the contract.
Resources must be handled (must be returned / stored or destroyed)

2. Describe a situation where a resource might be better to use than a struct.

When you are handling a trxn worth a trillion dollars. 
It is better use a resource (which cannot be copied, will not be destroyed by accident) 
to handle the transaction vault.

3. What is the keyword to make a new resource?

create

4. Can a resource be created in a script or transaction 
(assuming there isn't a public function to create one)?

No

5. What is the type of the resource below?

pub resource Jacob {

}

@Jacob 

6. Let's play the "I Spy" game from when we were kids. 
I Spy 4 things wrong with this code. Please fix them.

pub contract Test {

    // Hint: There's nothing wrong here ;)
    pub resource Jacob {
        pub let rocks: Bool
        init() {
            self.rocks = true
        }
    }

    pub fun createJacob(): @Jacob { // there is 1 here
        let myJacob <- create Jacob() // there are 2 here
        return <- myJacob // there is 1 here
    }
}