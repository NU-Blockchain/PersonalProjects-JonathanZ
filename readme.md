# Creating your personal project

Before you start, a few things to note:

First, open the truffle-config.js file, where you'll specify what network to connect to. In our case, the Ganache app simulates a local network. Within the 'networks' field, un-comment the 'development' field:
```
development: {
    host: "127.0.0.1",     // Localhost (default: none)
    port: 7545,            // Standard Ethereum port (default: none)
    network_id: "*",       // Any network (default: none)
},
```
and make sure that the hostname and port fields matches w/ the 'RPC Server' field of your Ganache App.

Also, scroll down and take note of the value in this field 
```
compilers: {
    solc: {
      version: "0.8.17"
```

If your version number < 0.8.0, your should probably update your solidity compiler by running 'npm update -g truffle'.

Make sure that these are set up and they work.


### Setting up truffle's framework

Note: I've completed these for you in the starter code, but if you'd like to start from scratch, you'd have to do this too.

'truffle init' only gives us the bare minimum of a framework, so we have to populate it some more before start coding our first smart contract.


In the ./contracts folder, create a file named 'Migrations.sol' and populate it with this:
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Migrations {
  address public owner = msg.sender;
  uint public last_completed_migration;

  modifier restricted() {
    require(
      msg.sender == owner, "This function is restricted to the contract's owner"
    );
    _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}
```
Now, in the ./migrations folder, create a file named '1_initial_migration.js' and populate it with this:
```
const Migrations = artifacts.require("Migrations");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
```

Once you are done with this, run 'truffle migrate' to deploy your contracts and your should end up with a successful deployment. 

### The three folders

./contracts stores all of your .sol solidity contracts. 
./migrations stores .js files that help deploy your contracts
./test stores .js files that you use to test your contracts' functions with

### Depedencies

You will (definitely) need to install more dependencies on to your computer from nodeJs and other sources. Your tutorial should give a good idea of that. If not, message one of Tony, Marco and Peter and we'll help you with that. 