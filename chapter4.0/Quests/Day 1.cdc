1. Explain what lives inside of an account.

An account storage consists of 
    1. Contract Code where all the contracts you deployed live
    2. Account Storage which stores resources , also with paths to expose links to the public / certain group of people

2. What is the difference between the /storage/, /public/, and /private/ paths?
    /storage/ is the storage path only the account holder can access, stores resources.
    /public/ is the public path where public links are stored, everyone can access this.
    /private/ is the private path where private links are stored, only people granted access by the account holder can access.

3. What does .save() do? What does .load() do? What does .borrow() do?
    .save() save the resources to the account's /storage/
    .load() returns (take out) the resources from the account's /storage/
    .borrow() returns a reference to the resources under the account's /storage/

4. Explain why we couldn't save something to our account storage inside of a script.
    It is because we have to access the auth account to mess around with the account storage.
    In a script, we can only run getAccount which returns a public account.
    We can only access the storage of an account in the prepare phrase of a transaction.

5. Explain why I couldn't save something to your account.
    Auth Account is needed to store something into it.
    Without the signing of a transaction from my side, no one can access the storage of my account.

6. Define a contract that returns a resource that has at least 1 field in it. Then, write 2 transactions:
    pub contract Jacob{
        pub resource JacobResource{
            pub let name : String

            init(){
                self.name = "Tucker"
            }
        }

        pub fun createJacob(): @JacobResource{
            return <- create JacobResource()
        }
    }

A transaction that first saves the resource to account storage, then loads it out of account storage, 
logs a field inside the resource, and destroys it.

    import Jacob from 0xJacob

    transaction(){

        prepare(acct: AuthAccount){
            let jacob <- Jacob.createJacob()
            acct.save(<- jacob, to:/storage/Jacob)
            let jacobagain <- acct.load<@Jacob.JacobResource>(from: /storage/Jacob)

            destroy jacobagain
        }

        execute{}
    }


A transaction that first saves the resource to account storage, 
then borrows a reference to it, and logs a field inside the resource.

    import Jacob from 0xJacob

    transaction(){

        prepare(acct: AuthAccount){
            let jacob <- Jacob.createJacob()
            acct.save(<- jacob, to:/storage/Jacob)
            let jacobagain = acct.borrow<&Jacob.JacobResource>(from: /storage/Jacob)
                ?? panic ("Jacob is not yours")
            log(jacobagain.name)

        }

        execute{}
    }