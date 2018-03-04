pragma solidity ^0.4.19;

import "./interfaces/State.sol";


/** @title CryptoBall Stake Contract */
contract Stake {

  State         state;

  function Stake(address stateContract) public {
    state = State(stateContract);
  }

  /// TODO
  function tokenFallback(address from, uint value, bytes data) public {
  }

  /// TODO
  function withdrawToken(address to, uint value) public {
  }

  /// TODO
  function verifyTicket() public {
  }
}
