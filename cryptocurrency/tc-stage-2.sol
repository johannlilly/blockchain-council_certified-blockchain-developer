pragma solidity 0.4.8;
contract TCoin {

	// STATE VARIABLES
	// public = the value of the variable is accessible by anyone with the address of the smart contract
	mapping (address => uint256) public balanceOf;
	// mapping within mapping
	// the first address = sender's address
	// the second address = address of person being authorized
	// uint256 = number of TCoin the other person is allowed to execute or transfer
	// allowance = a variable, a mapping, a key-value pair, an indexed array
	// index 1 = person allowing
	// index 2 = person allowed
	mapping (address => (address => uint256)) public allowance;
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
	event Transfer(address indexed from, address indexed to, uint256 value); // used "indexed" to store in log memory, not contract data
	// keep record - for whom and how much

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
		// call the event Transfer() function
		// (who it is from, who it is to, how much)
		// this can also be used for debugging to check intermediate values of the smart contract paramter or state variables
		Transfer(msg.sender, _to, _value);
	}

	// define function for approving the spender.
	// configured to return a bool
	function approve(address _spender, uint256 _value) returns (bool success) {
		allowance[msg.sender][_spender] = _value;
		return true;
	}

	// define function for transfer from (from account, to account, amount)
	functaion transferFrom(address _from, address _to, uint _value) returns (bool success) {
		// check if sender has sufficient balance
		if (balanceOf[_from] < _value) throw;
		// check overflow
		if(balanceOf[_to] + _value < balanceOf[_to]) throw;
		// if person is not authorized to send this much value
		if (_value > allowance[_from][msg.sender]) throw;
		// compiler is ready for execution
		balanceOf[_from] -= _value;
		balanceOf[_to] += _value;
		// reduced remaining spending limit
		allowance[_from][msg.sender] -= _value;
		// send event that transfer has occured
		Transfer(_from, _to, _value);
		return true;
	}
}