pragma solidity 0.4.8;
contract TCoin {

	// STATE VARIABLES
	// public = the value of the variable is accessible by anyone with the address of the smart contract
	mapping (address => uint256) public balanceOf;
	// define a standard, or version... hardcoded
	string public standard = "TCoin v1.0";
	// define a variable for the name of the coin
	string public name;
	// define a variable for the symbol of the coin
	string public symbol;
	// define a variable for the max number of decimal points of the coin
	// unsigned 8-bit integer (0 -> 255)
	uint8 public decimal; // for Ethereum, it is 18
	// define a variable for the total supply of coins that can be in existence
	uint256 public totalSupply;
	// define a variable so we can later notify participants in a transaction
	event Transfer(address indexed from, address indexed to, uint256 value); // store in log memory, not contract data

	// because this is a constructor, these parameters will be initialized when the contract is created
	// add in the variables we created above to have them initialized, as well
	function TCoin(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) {
		balanceOf[msg.sender] = initialSupply;
		totalSupply = initialSupply;
		decimal = decimalUnits;
		symbol = tokenSymbol;
		name = tokenName;
	}

	// add some checks before initiating a transfer
	function transfer(address _to, uint256 _value) {
		// check if the sender balance is greater than the value
		if(balanceOf[msg.sender] < _value) throw; // throw exception and stop execution
		// overflow is by adding the token amount, the value does not overflow the datatype
		if(balanceOf[_to] + _value < balanceOf[_to]) throw;
		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
	}
}