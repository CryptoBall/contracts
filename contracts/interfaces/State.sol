pragma solidity ^0.4.19;


/** @title State Interface */
contract State {

  /// Returns 'now'
  function getNow() view returns (uint256);

  /// Returns 'block.number'
  function getBlockNumber() view returns (uint256);

  /// Returns 'block.blockhash(blockNumber)'
  function getBlockhash(uint256 blockNumber) view returns (bytes32);
}
