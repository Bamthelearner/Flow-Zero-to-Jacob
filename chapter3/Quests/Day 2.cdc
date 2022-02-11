For today's quest, you'll have 1 large quest instead of a few little ones.

1. Write your own smart contract that contains two state variables: 
an array of resources, and a dictionary of resources. 
Add functions to remove and add to each of them. 
They must be different from the examples above.


pub contract Jacob {
    access(contract) var ownedJacobArray : @[JacobResource]
    access(contract) var ownedJacobMap : @{String : JacobResource}

    init(){
        self.ownedJacobArray <- []
        self.ownedJacobMap <- {}
    }

    pub resource JacobResource{
        pub let string : String 

        init(){
            self.string = "is the best!"
        }
    }

    pub fun addtoArray(res: @JacobResource){
        self.ownedJacobArray.append(<- res)
    }

    pub fun removefromArray(resIndex: UInt64): @JacobResource{
        pre{
            self.ownedJacobArray[resIndex] != nil : "Cannot find this resource"
        }
        return <- self.ownedJacobArray.remove(at: resIndex)
    }

    pub fun addtoMap(res: @JacobResource){
        self.ownedJacobMap[res.string] <-! res
    }

    pub fun removefromMap(resKey: String) : @JacobResource{
        pre{
            self.ownedJacobMap[resKey] != nil : "Cannot find this resource"
        }
        return <- self.ownedJacobMap.remove(key:resKey)!
    }

}