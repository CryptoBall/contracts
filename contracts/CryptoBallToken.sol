pragma solidity ^0.4.19;

import "./ERC223/ERC223_Token.sol";


/** @title CryptoBall Token Contract */
contract CryptoBallToken is ERC223Token {
  string public name = "CryptoBallToken";
  string public symbol = "CBT";
  uint8 public decimals = 18;
}
