1. Explain why standards can be benefitial to the Flow ecosystem.
Ans : With this standard, contracts abide by the same standard can interact with each other without diving deep into the code.
All you have to do is to specify if the contract abides by the standard.

Also, it can set requirements for contracts on flow to have specific functions implemented.

2. What is YOUR favourite food?

Ans :Pizza?

3. Please fix this code (Hint: There are two things wrong):
Ans : I think there are more than 2 things wrong??


The contract interface:

pub contract interface ITest {
  pub var number: Int
  
  pub fun updateNumber(newNumber: Int) {
    pre {
      newNumber >= 0: "We don't like negative numbers for some reason. We're mean."
    }
    post {
      self.number == newNumber: "Didn't update the number to be the new number."
    }
  }

  pub resource interface IStuff {
    pub var favouriteActivity: String
  }

  pub resource Stuff : IStuff {
    pub var favouriteActivity: String
  }
}

}
The implementing contract:

pub contract Test : ITest {
  pub var number: Int
  
  pub fun updateNumber(newNumber: Int) {
    self.number = newNumber
  }

  pub resource Stuff: ITest.IStuff {
    pub var favouriteActivity: String

    init() {
      self.favouriteActivity = "Playing League of Legends."
    }
  }

  init() {
    self.number = 0
  }
}

