pragma solidity ^0.4.19;

import "../interfaces/State.sol";


/** @title State Interface */
contract StateMock is State {

  // Mocked current time
  uint256 currentTime;

  // Mocked current block number
  uint256 currentBlockNumber;

  function setNow(uint256 _currentTime) {
    currentTime = _currentTime;
  }

  function getNow() view returns (uint256) {
    return currentTime;
  }

  function setCurrentBlockNumber(uint256 _currentBlockNumber) {
    currentBlockNumber = _currentBlockNumber;
  }

  function getBlockNumber() view returns (uint256) {
    return currentBlockNumber;
  }

  function getBlockhash(uint256 blockNumber) view returns (bytes32) {
    return keccak256(blockNumber);
  }

  function getRegularPoolPerTicket() pure returns (uint256) {
    return 0.0035 ether;
  }

  function getMiniJackpotPoolPerTicket() pure returns (uint256) {
    return 0.0020 ether;
  }

  function getJackpotPoolPerTicket() pure returns (uint256) {
    return 0.0020 ether;
  }

  function getTXFeePoolPerTicket() pure returns (uint256) {
    return 0.0025 ether;
  }

  function getTimeCutoffPurchase() pure returns (uint256) {
    return 2.0 hours;
  }

  function getTimeBetweenLotteries() pure returns (uint256) {
    return 3.5 days;
  }

  function getVerifyTimePeriod() pure returns (uint256) {
    return 2.0 days;
  }

  function getMaxWhiteball() pure returns (uint8) {
    return 29;
  }

  function getMaxPowerball() pure returns (uint8) {
    return 20;
  }

  function getRandSkipBlocks() pure returns (uint8) {
    return 100;
  }

  function getBitPerBall() pure returns (uint8) {
    return 5;
  }

  function getTierCount() pure returns (uint8) {
    return 7;
  }

  function getRewardAllocation(uint8 tier) pure returns (uint256) {
    if (tier == 1) return    0;
    if (tier == 2) return  514;
    if (tier == 3) return  578;
    if (tier == 4) return 1098;
    if (tier == 5) return  997;
    if (tier == 6) return 1462;
    if (tier == 7) return 5384;
    throw;
  }

  function getRewardTier(uint8 whiteBallMatches,
                         bool powerBallMatch) pure returns (uint8) {
    if (whiteBallMatches == 5 &&  powerBallMatch) return 1;
    if (whiteBallMatches == 5 && !powerBallMatch) return 2;
    if (whiteBallMatches == 4 &&  powerBallMatch) return 3;
    if (whiteBallMatches == 4 && !powerBallMatch) return 4;
    if (whiteBallMatches == 3 &&  powerBallMatch) return 5;
    if (whiteBallMatches == 2 &&  powerBallMatch) return 6;
    if (whiteBallMatches == 3 && !powerBallMatch ||
        whiteBallMatches == 1 &&  powerBallMatch ||
        whiteBallMatches == 0 &&  powerBallMatch) return 7;
    throw;
  }
}
