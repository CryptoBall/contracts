pragma solidity ^0.4.19;


/** @title State Interface */
contract State {

  /// Block chain states
  function getNow() view returns (uint256);
  function getBlockNumber() view returns (uint256);
  function getBlockhash(uint256 blockNumber) view returns (bytes32);

  /// Cryptoball core constants
  function getRegularPoolPerTicket() pure returns (uint256);
  function getMiniJackpotPoolPerTicket() pure returns (uint256);
  function getJackpotPoolPerTicket() pure returns (uint256);
  function getTXFeePoolPerTicket() pure returns (uint256);

  function getTimeCutoffPurchase() pure returns (uint256);
  function getTimeBetweenLotteries() pure returns (uint256);
  function getVerifyTimePeriod() pure returns (uint256);

  /// Balls library constants
  /// White balls must be between [0, MAX_WHITEBALL)
  function getMaxWhiteball() pure returns (uint8);
  /// Power balls must be between [0, MAX_POWERBALL)
  function getMaxPowerball() pure returns (uint8);
  /// Number of blocks to skip for generating random balls
  function getRandSkipBlocks() pure returns (uint8);
  /// Number of bits required to generate random balls
  function getBitPerBall() pure returns (uint8);

  /// Rewards library constants
  function getTierCount() pure returns (uint8);
  function getRewardAllocation(uint8 tier) pure returns (uint256);
  function getRewardTier(uint8 whiteBallMatches,
                         bool powerBallMatch) pure returns (uint8);
}
