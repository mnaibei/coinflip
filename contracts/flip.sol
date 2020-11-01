import "./provableAPI.sol";
//import "./ownable.sol";
pragma solidity 0.5.12;

contract Coinflip is usingProvable {

    uint public ContractBalance;

    bytes32 queryId;
    address onlyowner;

    struct Bet {
        address payable player;
        uint value;
        bool result;

    }


    event placeBet(address indexed player,bytes32 queryId, uint value);
    event bet(address indexed player, bytes32 Id, uint value, bool result);
    event funded(address onlyowner, uint funding);
    event LogNewProvableQuery(string description);
    event generatedRandomNumber(uint256 randomNumber);

    mapping (bytes32 => Bet)  betting;
    mapping (address => bool) waiting;

     /*constructor() public {
        provable_setProof(proofType_Ledger);

    }_*/


    modifier costs(uint cost){
        require(msg.value >= cost, "The minimum bet is 1 Ether");
        _;
    }

  function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public {
    require(msg.sender == address(onlyowner));

    if (provable_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0)
    {

    }
      else
      {

        uint256 randomNumber = uint256(keccak256(abi.encodePacked(_result))) % 2;

        if(randomNumber == 0){
            betting[_queryId].result = true;
        }
        else if(randomNumber == 1){
            betting[_queryId].result = false;
            betting[_queryId].player.transfer((betting[_queryId].value)*2);
        }

        waiting[betting[_queryId].player] = false;

        emit generatedRandomNumber(randomNumber);
        emit bet(betting[_queryId].player, _queryId, betting[_queryId].value, betting[_queryId].result);
       }
    }


    /*function flip() public payable costs(0.01 ether) returns(bool){
        require(address(this).balance >= msg.value, "The contract hasn't enought funds");
        bool success;
        if(now % 2 == 0){
            ContractBalance += msg.value;
            success = false;
        }
        else if(now % 2 == 1){
            ContractBalance -= msg.value;
            msg.sender.transfer(msg.value * 2);
            success = true;
        }
        //assert(ContractBalance == address(this).balance);
        emit placeBet(msg.sender, queryId, msg.value);
        return success;
    }*/


    function flip() public payable costs(1 ether){

        require(waiting[msg.sender] == false);

        waiting[msg.sender] = true;




        betting[queryId] = Bet({player: msg.sender, value: msg.value, result: false});


        emit placeBet(msg.sender, queryId, msg.value);


    }






    function withdrawAll() public  returns(uint){
        msg.sender.transfer(address(this).balance);
        assert(address(this).balance == 0);
        return address(this).balance;
    }
    function getBalance() public view returns (address, uint, uint) {
        return (address(this), address(this).balance, ContractBalance);
    }
    // Fund the Contract
    function fundContract() public payable  returns(uint){
        require(msg.value != 0);
        //ContractBalance += msg.value;
        emit funded(msg.sender, msg.value);
        //assert(ContractBalance == address(this).balance);
        return msg.value;
    }

}
