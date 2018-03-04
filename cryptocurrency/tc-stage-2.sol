pragma solidity 0.4.8;
contract TCoin {
	mapping (address => uint256) public balanceOf; // show the balance, which is stored as uint256

	function TCoin(uint256 initialSupply) {
		balanceOf[msg.sender] = initialSupply;
	}

	function transfer(address _to, uint256 _value) {
		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
	}
}