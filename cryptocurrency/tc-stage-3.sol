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

	uint256 minimumBalanceForAccounts = 5 finney; // minimum. this can change.
	uint256 public sellPrice; //default value is 0
	uint256 public buyPrice;
	// keep track of frozen accounts with a mapping
	// use address as a key, then map a boolean to each address
	mapping (address => bool) public frozenAccount;

	// inform others about the address that has been frozen or unfrozen
	event FrozenFund(address target, bool frozen);

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

	// onlyAdmin is allowed to execute this function
	function mintToken(address target, uint256 mintedAmount) onlyAdmin {
		balanceOf[target] += mintedAmount;
		totalSupply += mintedAmount;
		// execute the event
		// 0 = represents the source account
		// this = represents smart contract address number
		// mintedAmount = destination 
		Transfer(0, this, mintedAmount);
		// then, from the contract, notify the amount has been trasnferred to the target
		Transfer(this, target, mintedAmount);
	}

	// create function for freezing
	function freezeAccount(address target, bool freeze) onlyAdmin{
		frozenAccount[target] = freeze;
		FrozenFund(target, freeze); // freeze is like the status, a bool
	}

	// extend transfer()
	function transfer(address _to, uint256 _value) {
		if (msg.sender.balance < minimumBalanceForAccounts) // in wei format
		sell((minimumBalanceForAccounts - msg.sender.balance)/sellPrice); // convert back to some ETH so there is always a min balance
		
		if(frozenAccount[msg.sender]) throw; // if true (if is frozen), throw error
		if(balanceOf[msg.sender] < _value) throw;
		if(balanceOf[_to] + _value < balanceOf[_to]) throw;
		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
 		Transfer(msg.sender, _to, _value);
	}

	// extend transferFrom()
	function transferFrom(address _from, address _to, uint _value) returns (bool success) {
		if(frozenAccount[_from]) throw; // if true (if is frozen), throw error
		if (balanceOf[_from] < _value) throw;
		if(balanceOf[_to] + _value < balanceOf[_to]) throw;
		if (_value > allowance[_from][msg.sender]) throw;
		balanceOf[_from] -= _value;
		balanceOf[_to] += _value;
		allowance[_from][msg.sender] -= _value;
		Transfer(_from, _to, _value);
		return true;
	}

	// function to set prices
	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyAdmin {
		sellPrice = newSellPrice;
		buyPrice = newBuyPrice;
	}

	// we want users to set how much they want to buy using the ETH they have
	// remember, users can send ETH using buy()
	// the smart contract must contain some TCoins for the exchange of ETH to take place to the buyer's account
	function buy() payable { // we want people to send ETH using the payable method 
		// convert
		uint256 amount = (msg.value/(1 ether)) / buyPrice; // convert units properly. The smallest unit of ETH is called Wei, and is 1x10^-18 ETH, i.e.
		// does the smart contract hold a balance above what is being requested?
		if(balanceOf[this] < amount) throw;
		balanceOf[msg.sender] += amount;
		balanceOf[this] -= amount;
		// announce
		Transfer(this, msg.sender, amount);
	}

	function sell(uint256 amount){
		// does seller have enough ETH?
		if(balanceOf[msg.sender] < amount) throw;
		balanceOf[msg.sender] -= amount;
		// make sure sender receives ETH
		// access address of sender, then add ETH
		if(!msg.sender.send(amount * sellPrice * 1 ether)){ // The smallest unit of ETH is called Wei, and is 1x10^-18 ETH, i.e.
			// throw reverts changes
			throw;
		} else {
			// sender + has sent TCoins + for ETH
			Transfer(msg.sender, this, amount);
		}
	}
}


