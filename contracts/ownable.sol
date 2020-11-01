pragma solidity 0.5.12;

contract Ownable {

  address onlyowner;

  modifier owner()
  {
    if (onlyowner != msg.sender)
    {
      revert();
    } else
      {
        _;
      }
    }
}
