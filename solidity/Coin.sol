// define most recent compatability for the compiler
pragma solidity 0.4.8;

// the owner of this contract can add Coin to anyone's account

// contract is the first line.
// think of it like a class, where Coin here is the coin name.
contract Coin {
    // define metadata
    /*
    * @title A Simple Subcurrency Example
    * @author Toshendra Sharma
    * @notice Example for the Solidity Course
    * @dev This is only for demo the simple Coin example
    *
    */
    // define variables
    address public minter;
    uint public totalCoins;

    // define events
    event LogCoinsMinted(address deliveredTo, uint amount);
    event LogCoinsSent(address sentTo, uint amount);

    // define mapping (mapping applies a function to all elements of an array or some iterative object)
    // you pass the address and the value inside it
    // that value will become the number of coins available inside that address
    mapping (address => uint) balances;
    function Coin(uint initialCoins) {
        minter = msg.sender;
        totalCoins = initialCoins;
        balances[minter] = initialCoins;
    }

    // define a function mint()
    // think of "mint" like minting new coinage for use in circulation
    // here, the owner of the contract can add Coins to the owner
    /// @notice Mint the coins
    /// @dev This does not return any value
    /// @param owner address of the coin owner, amount amount of coins to be delivered to owner
    /// @return Nothing
    function mint(address owner, uint amount) {
        if (msg.sender != minter) return;
        balances[owner] += amount;
        totalCoins += amount;
        // log that the person has received coins, so that others node can listen 
        LogCoinsMinted(owner, amount);
    }

    // define function send()
    // send any amount of coins to the receiver
    function send(address receiver, uint amount) {
        // check that the sender has enough to send
        if (balances[msg.sender] < amount) return;
        // deduct amount from the sender
        balances[msg.sender] -= amount;
        // add the amount to the receiver
        balances[receiver] += amount;
        // log that the person has received coins, so that others node can listen 
        LogCoinsSent(receiver, amount);
    }

    // the value returned will be the balance, a constant
    function queryBalance(address addr) constant returns (uint balance) {
        return balances[addr];
    }
 
    // destroy the whole smart contract and make it unusable whenever you want
    // this can only be killed by the minter, who is the owner of the smart contract
    function killCoin() returns (bool status) {
        if (msg.sender != minter) throw;
        selfdestruct(minter);
    }
}