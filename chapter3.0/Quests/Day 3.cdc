1. Define your own contract that stores a dictionary of resources. 
Add a function to get a reference to one of the resources in the dictionary.

pub contract Jacob {
    access(contract) var ownedJacobArray : @[JacobResource]
    access(contract) var ownedJacobMap : @{String : JacobResource}

    init(){
        self.ownedJacobArray <- [
            <- create JacobResource(_string : "Tucker") ,
            <- create JacobResource(_string : "Is The Best!")
        ]
        self.ownedJacobMap <- {
            "Tucker" : <- create JacobResource(_string : "Tucker"),
            "Is The Best!" : <- create JacobResource(_string : "Is The Best!")
        }
    }

    pub resource JacobResource{
        pub let string : String 

        init(_string: String){
            self.string = _string
        }
    }

    pub fun getArrayRef(resIndex: UInt64) : &JacobResource {
        pre{
            self.ownedJacobArray[resIndex] != nil : "Cannot find this resource in array"
        }
        return &self.ownedJacobArray[resIndex] as &JacobResource
    }

    pub fun getMapRef(resKey: String) : &JacobResource {
        pre{
            self.ownedJacobMap[resKey] != nil : "Cannot find this resource in the map"
        }
        return &self.ownedJacobMap[resKey] as &JacobResource
    }


}

2. Create a script that reads information from that resource using the reference from the function you defined in part 1.

import Jacob from 0xJacob

pub fun main(resIndex: UInt64, resKey: String) : [String] {
    let arrayRef = Jacob.getArrayRef(resIndex: resIndex)
    let mapRef = Jacob.getMapRef(resKey:resKey)

    return [arrayRef.string, mapRef.string]
}

3. Explain, in your own words, why references can be useful in Cadence.

We dont have to move around the resource to get the information / call the function in it.
It would be dangerous for others that wants to call the function of a resources to get the resource itself.