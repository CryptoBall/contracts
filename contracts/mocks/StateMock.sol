pragma solidity ^0.4.19;

import "../interfaces/State.sol";


/** @title State Interface */
contract StateMock is State {

  // Mocked current time
  uint256 currentTime;

  // Mocked current block number
  uint256 currentBlockNumber;

  function setNow(uint256 _currentTime) public {
    currentTime = _currentTime;
  }

  function getNow() public view returns (uint256) {
    return currentTime;
  }

  function setCurrentBlockNumber(uint256 _currentBlockNumber) public {
    currentBlockNumber = _currentBlockNumber;
  }

  function getBlockNumber() public view returns (uint256) {
    return currentBlockNumber;
  }

  function getBlockhash(uint256 blockNumber) public view returns (bytes32) {
    return keccak256(blockNumber);
  }
}
