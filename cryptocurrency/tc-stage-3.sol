pragma solidity 0.4.8;

contract admined {
	address public admin;

	function admined() {
		admin = msg.sender;
	}

	modifier = onlyAdmin(){
		if(msg.sender != admin) throw;
		_; // whenever this modifier is applied, the function will execute as it is
	}

	//transfer administratorship
	function transferAdminship(address newAdmin){
		admin = newAdmin;
	}

}

contract TCoin {

	mapping (address => uint256) public balanceOf;
	mapping (address => mapping (address => uint256)) public allowance;
	string public standard = "TCoin v1.0";
	string public name;
	string public symbol;
	uint8 public decimal;
	uint256 public totalSupply;
	event Transfer(address indexed from, address indexed to, uint256 value);

	function TCoin(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) {
		balanceOf[msg.sender] = initialSupply;
		totalSupply = initialSupply;
		decimal = decimalUnits;
		symbol = tokenSymbol;
		name = tokenName;
	}

	function transfer(address _to, uint256 _value) {
		if(balanceOf[msg.sender] < _value) throw;
		if(balanceOf[_to] + _value < balanceOf[_to]) throw;
		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
 		Transfer(msg.sender, _to, _value);
	}

	function approve(address _spender, uint256 _value) returns (bool success) {
		allowance[msg.sender][_spender] = _value;
		return true;
	}

	function transferFrom(address _from, address _to, uint _value) returns (bool success) {
		if (balanceOf[_from] < _value) throw;
		if(balanceOf[_to] + _value < balanceOf[_to]) throw;
		if (_value > allowance[_from][msg.sender]) throw;
		balanceOf[_from] -= _value;
		balanceOf[_to] += _value;
		allowance[_from][msg.sender] -= _value;
		Transfer(_from, _to, _value);
		return true;
	}
}

contract TCoinAdvanced is admined, TCoin{
	// pass variables in the constructor in particular order
	function TCoinAdvanced(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralAdmin) TCoin (0, tokenName, tokenSymbol, decimalUnits){
		totalSupply = initialSupply;
		if(centralAdmin != 0)
			admin = centralAdmin;
		else
			admin = msg.sender;
		balanceOf[admin] = initialSupply;
		totalSupply = initialSupply;
	}
}


