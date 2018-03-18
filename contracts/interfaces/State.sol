pragma solidity ^0.4.19;


/** @title State Interface */
contract State {

  /// Block chain states
  function getNow() public view returns (uint256);
  function getBlockNumber() public view returns (uint256);
  function getBlockhash(uint256 blockNumber) public view returns (bytes32);

  /// Cryptoball core constants
  function getRegularPoolPerTicket() public view returns (uint256);
  function getMiniJackpotPoolPerTicket() public view returns (uint256);
  function getJackpotPoolPerTicket() public view returns (uint256);
  function getTXFeePoolPerTicket() public view returns (uint256);

  function getTimeCutoffPurchase() public view returns (uint256);
  function getTimeBetweenLotteries() public view returns (uint256);
  function getVerifyTimePeriod() public view returns (uint256);

  /// Balls library constants
  /// White balls must be between [0, MAX_WHITEBALL)
  function getMaxWhiteball() public view returns (uint8);
  /// Power balls must be between [0, MAX_POWERBALL)
  function getMaxPowerball() public view returns (uint8);
  /// Number of blocks to skip for generating random balls
  function getRandSkipBlocks() public view returns (uint8);
  /// Number of bits required to generate random balls
  function getBitPerBall() public view returns (uint8);

  /// Rewards library constants
  function getTierCount() public view returns (uint8);
  function getRewardAllocation(uint8 tier) public view returns (uint256);
  function getRewardTier(uint8 whiteBallMatches,
                         bool powerBallMatch) public view returns (uint8);
}
