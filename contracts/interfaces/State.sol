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
  function getMaxWhiteball() pure returns (uint8);
  function getMaxPowerball() pure returns (uint8);
  function getRandSkipBlocks() pure returns (uint8);
  function getBitPerBall() pure returns (uint8);


  /// Rewards library constants
  function getTierCount() pure returns (uint8);
  function getRewardAllocation(uint8 tier) pure returns (uint256);
  function getRewardTier(uint8 whiteBallMatches,
                         bool powerBallMatch) pure returns (uint8);
}
