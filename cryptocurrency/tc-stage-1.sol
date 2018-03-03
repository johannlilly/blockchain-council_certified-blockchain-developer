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
}