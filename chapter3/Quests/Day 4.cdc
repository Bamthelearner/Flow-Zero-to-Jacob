1. Explain, in your own words, the 2 things resource interfaces can be used for 
(we went over both in todays content)
    1. To ensure a resource implement some certain functions or variables.
    2. To expose the specific variables / functions to certain group of people.

2. Define your own contract. Make your own resource interface and a resource that implements the interface. 
Create 2 functions. In the 1st function, show an example of not restricting the type of the resource and accessing its content. 
In the 2nd function, show an example of restricting the type of the resource and NOt being able to access its content.

pub contract Jacob{

    pub resource interface IJacobResource{
        pub var name : String
    }

    pub resource JacobResource : IJacobResource {
        pub var name : String

        init(){
            self.name = "Tucker"
        }

        pub fun updatename(newName: String) {
            self.name = newName
        }
    }

    pub fun noInterface() {
        let res : @JacobResource <- create JacobResource()
        res.updatename(newName: "The Lord")
        log(res.name)

        destroy res
    }

    pub fun yesInterface() {
        let res : @JacobResource{IJacobResource} <- create JacobResource()
        res.updatename(newName: "The Lord")
        log(res.name)

        destroy res
    }

}


3. How would we fix this code?

pub contract Stuff {

    pub struct interface ITest {
      pub var greeting: String
      pub var favouriteFruit: String
    }

    // ERROR:
    // `structure Stuff.Test does not conform 
    // to structure interface Stuff.ITest`
    pub struct Test: ITest {
      pub var greeting: String

      pub fun changeGreeting(newGreeting: String): String {
        self.greeting = newGreeting
        return self.greeting // returns the new greeting
      }

      init() {
        self.greeting = "Hello!"
      }
    }

    pub fun fixThis() {
      let test: Test{ITest} = Test()
      let newGreeting = test.changeGreeting(newGreeting: "Bonjour!") // ERROR HERE: `member of restricted type is not accessible: changeGreeting`
      log(newGreeting)
    }
}

My solution below:

pub contract Stuff {

    pub struct interface ITest {
      pub var greeting: String
      pub var favouriteFruit: String

      // Expose the function changeGreeting in ITest Interface
      pub fun changeGreeting(newGreeting: String): String
    }

    // ERROR:
    // `structure Stuff.Test does not conform 
    // to structure interface Stuff.ITest`
    pub struct Test: ITest {
      pub var greeting: String

        // Add a variable favouriteFruit which has a type : String here
      pub var favouriteFruit: String

      pub fun changeGreeting(newGreeting: String): String {
        self.greeting = newGreeting
        return self.greeting // returns the new greeting
      }

      init() {
        self.greeting = "Hello!"

        //initialize favouritefruit
        self.favouriteFruit = "Orange?"
      }
    }

    pub fun fixThis() {
      let test: Test{ITest} = Test()
      let newGreeting = test.changeGreeting(newGreeting: "Bonjour!") // ERROR HERE: `member of restricted type is not accessible: changeGreeting`
      log(newGreeting)
    }
}