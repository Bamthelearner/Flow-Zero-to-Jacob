Describe what an event is, and why it might be useful to a client.
Answer: event is a record onchain to inform others what happens inside / around the contract apart from the transaction itself.
People can listen to the events and know what "events" happened with this contract. Graffle is one of the service provider.

Deploy a contract with an event in it, and emit the event somewhere else in the contract indicating that it happened.
Answer:

pub contract EventDemo{
    pub event contractInitialzied(contract: String)
    pub event numberUpdated(oldNumber: UInt64, newNumber: UInt64)

    pub var number: UInt64

    pub fun updateNumber(newNumber: UInt64){
        let numberBefore = self.number
        self.number = newNumber
        emit numberUpdated(oldNumber: numberBefore, newNumber: self.number)

    }

    init(){
        self.number = 0
        emit contractInitialzied(contract: "EventDemo") //This might be the laziest answer :O 
    }

}

Using the contract in step 2), add some pre conditions and post conditions to your contract to get used to writing them out.
Answer:

pub contract EventDemo{
    pub event contractInitialzied(contract: String)
    pub event numberUpdated(oldNumber: UInt64, newNumber: UInt64)

    pub var number: UInt64

    pub fun updateNumber(newNumber: UInt64){
        pre {
            number > 0 :"Number cannot be zero. Because I dont like it."
        }

        post {
            self.number != before(self.number) : "If you didn't change the number at all, why do this trxn LOL"
        }
        let numberBefore = self.number
        self.number = newNumber
        emit numberUpdated(oldNumber: numberBefore, newNumber: self.number)

    }

    init(){
        self.number = 0
        emit contractInitialzied(contract: "EventDemo") //This might be the laziest answer :O 
    }

}


For each of the functions below (numberOne, numberTwo, numberThree), follow the instructions.

pub contract Test {

  // TODO
  // Tell me whether or not this function will log the name.
  // name: 'Jacob'
  pub fun numberOne(name: String) {
    pre {
      name.length == 5: "This name is not cool enough."
    }
    log(name)
  }

  // TODO
  // Tell me whether or not this function will return a value.
  // name: 'Jacob'
  pub fun numberTwo(name: String): String {
    pre {
      name.length >= 0: "You must input a valid name."
    }
    post {
      result == "Jacob Tucker"
    }
    return name.concat(" Tucker")
  }

  pub resource TestResource {
    pub var number: Int

    // TODO
    // Tell me whether or not this function will log the updated number.
    // Also, tell me the value of `self.number` after it's run.
    pub fun numberThree(): Int {
      post {
        before(self.number) == result + 1
      }
      self.number = self.number + 1
      return self.number
    }

    init() {
      self.number = 0
    }

  }

}


Answer :

numberOne : Will log Jacob
numberTwo : Will return "Jacob Tucker"
numberThree : This will only panic. Coz in the post condition, it only allows the number before adding to be equal to the one after adding plus one.
The value of self.number will be 0 as the function can never get thru.