//versiona pragma
// maximum version number for which this code can be compiled
// you may also see this => ^0.4.8 ; which indicates that version and above cannot compile
pragma solidity 0.4.8; 

//import section
// import an external file or external smart contract from another location. It should have a .sol extension
import "filename";

//begin the contract
/// @title This is the layout of the solidity code
// everything needs to be within the contract block
contract ContractName {
    /*
    * @title A Simple Layout Example
    * @author Toshendra Sharma
    * @notice Example for the Solidity Course
    * @dev This line is for developers only
    * 
    */

     // This is a single-line comment.

    /*
    This is a
    multi-line comment.
    */

    // State Variables
    // variables can be anywhere in the contract, even below the function modifiers
    // address, uint, string = data type
    // public, private = access type
    // stateVariable1, stateVariable2 = variable name
    address public stateVariable1;
    uint public stateVariable2;
    uint private stateVariable3;
    string public constant HOST_ID = 0x1234;

    // Events
    // events are optional
    // events are ways to log the particular values in the interface
    // this is also how you perform debugging
    event LogEvent1(address param1, uint param2);
    event LogEvent2(address param1);
    event LogEvent3();

    // Function Modifiers
    // modifiers are the way to set restrictions on certain functions
    modifier onlyIfOwnerModifier() { 
        if (msg.sender != owner) throw;
        _;
    }

    modifier onlyIfMortalModifier() { 
        if (msg.sender != mortal) throw;
        _;
    }

    // Struct, arrays or Enum if any here
    // here, you are simply defining data types
    enum enum1 { val1, val2, val3 }
    struct struct1 { 
        uint weight;
        uint height;
        address location;
    }
    mapping (address => uint) balances;


    // Define consutruct here
    // the constructor of the smart contract
    // MUST have the same name as the contract name
    function ContractName(uint initialCoins) {
       // Initialize state variables here
    }

    /// @dev Comment for developers
    /// @param parameters details
    /// @return return variable details
    function function1(address param1, uint param2) {
       //body of function here
       //
       //
    }

    /// @dev Comment for developers
    /// @param parameters details
    /// @return return variable details
    function function2(address param1, uint param2) {
       //body of function here
       //
       //
    }

    //default function
    // define a default function to execute if there is no particular function for defined for the function that you are calling
    function(){
        throw;
    }

}
