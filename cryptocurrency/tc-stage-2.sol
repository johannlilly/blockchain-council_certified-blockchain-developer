pragma solidity 0.4.8;
contract TCoin {
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

	// because this is a constructor, these parameters will be initialized when the contract is created
	function TCoin(uint256 initialSupply) {
		balanceOf[msg.sender] = initialSupply;
	}

	function transfer(address _to, uint256 _value) {
		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
	}
}