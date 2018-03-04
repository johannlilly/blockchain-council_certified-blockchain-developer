pragma solidity 0.4.8;
contract TCoin {
	mapping (address => uint256) public balanceOf;
	// define a standard
	string public standard = "TCoin v1.0";

	// because this is a constructor, these parameters will be initialized when the contract is created
	function TCoin(uint256 initialSupply) {
		balanceOf[msg.sender] = initialSupply;
	}

	function transfer(address _to, uint256 _value) {
		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
	}
}