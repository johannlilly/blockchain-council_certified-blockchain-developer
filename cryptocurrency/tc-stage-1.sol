pragma solidity 0.4.8;
contract TCoin {
	mapping (address => uint256) public balanceOf; // show the balance, which is stored as uint256
	// whenever you want to access the balance of an address
	// balanceOf[address] = __

	// create constructor
	function TCoin(uint256 initialSupply) {
		// the contract begins by creating/adding the initial supply to the sender's account
		balanceOf[msg.sender] = initialSupply;
	}

	// takes 2 args: the adress that you want to send to, and the amount you want to transfer
	function transfer(address _to, uint256 _value) {
		// deduct value to send from the balance of the sender
		balanceOf[msg.sender] -= _value;
		// add the value being sent to the receiver's account
		balanceOf[_to] += _value;
		// NOTE: we have not used any checks before transferring.
		// this is the minimum-viable contract
	}
}