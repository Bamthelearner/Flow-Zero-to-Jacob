1. What does .link() do?
    .link() creates a capability of a resource in storage and save the path to /public/ or /private/

2. In your own words (no code), explain how we can use resource interfaces to only expose certain things to the /public/ path.
    We put the functions / variables / constants that we want to expose to the public in the resource interface, 
    then create a capability to that resources which adopts the resource interface and store it to the public path.


3. Deploy a contract that contains a resource that implements a resource interface. Then, do the following:

    pub contract Jacob{
        pub resource interface IJacobResource{
            pub let canRead : String
        }

        pub resource JacobResource: IJacobResource {
            pub let canRead : String
            pub var cannotRead : String

            init(){
                self.canRead = "You Can See Me"
                self.cannotRead = "You Cannot See Me"
            }
        }

        pub fun createJacob(): @JacobResource{
            return <- create JacobResource()
        }
    }

    1. In a transaction, save the resource to storage and link it to the public with the restrictive interface.
        import Jacob from 0xJacob

        transaction(){
            prepare(acct: AuthAccount){
                let jacob <- createJacob()
                acct.save(<- jacob, to: /storage/Jacob)
                acct.link<&Jacob.JacobResource{Jacob.IJacobResource}>(/public/Jacob, target: /storage/Jacob)
            }
        }

    2. Run a script that tries to access a non-exposed field in the resource interface, and see the error pop up.
        import Jacob from 0xJacob

        pub fun main(acct: Address) {
            let jacobCap = getAccount(acct)
                .getCapability<&Jacob.JacobResource{Jacob.IJacobResource}>(/public/Jacob)

            let jacobRef = jacobCap.borrow() ?? panic("Cannot get Jacob's Reference")

            log(jacobRef.cannotRead)
        }

    3. Run the script and access something you CAN read from. Return it from the script.

            import Jacob from 0xJacob

        pub fun main(acct: Address) : String {
            let jacobCap = getAccount(acct)
                .getCapability<&Jacob.JacobResource{Jacob.IJacobResource}>(/public/Jacob)

            let jacobRef = jacobCap.borrow() ?? panic("Cannot get Jacob's Reference")

            return jacobRef.canRead
        }