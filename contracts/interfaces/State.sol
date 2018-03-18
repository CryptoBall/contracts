pragma solidity ^0.4.19;


/** @title State Interface */
contract State {

  /// Block chain states
  function getNow() view returns (uint256);
  function getBlockNumber() view returns (uint256);
  function getBlockhash(uint256 blockNumber) view returns (bytes32);

  /// Cryptoball core constants
  function getRegularPoolPerTicket() view returns (uint256);
  function getMiniJackpotPoolPerTicket() view returns (uint256);
  function getJackpotPoolPerTicket() view returns (uint256);
  function getTXFeePoolPerTicket() view returns (uint256);

  function getTimeCutoffPurchase() view returns (uint256);
  function getTimeBetweenLotteries() view returns (uint256);
  function getVerifyTimePeriod() view returns (uint256);

  /// Balls library constants
  /// White balls must be between [0, MAX_WHITEBALL)
  function getMaxWhiteball() view returns (uint8);
  /// Power balls must be between [0, MAX_POWERBALL)
  function getMaxPowerball() view returns (uint8);
  /// Number of blocks to skip for generating random balls
  function getRandSkipBlocks() view returns (uint8);
  /// Number of bits required to generate random balls
  function getBitPerBall() view returns (uint8);

  /// Rewards library constants
  function getTierCount() view returns (uint8);
  function getRewardAllocation(uint8 tier) view returns (uint256);
  function getRewardTier(uint8 whiteBallMatches,
                         bool powerBallMatch) view returns (uint8);
}
