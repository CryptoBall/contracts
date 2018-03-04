pragma solidity ^0.4.19;


/** @title Reward Library */
library Reward {

  uint8 constant public TIER_COUNT = 7;

  struct Data {
    // The number of winners for each of the tiers
    uint256[8]  winnerCounts;
    // TODO
    uint256     totalRegularFund;
    // TODO
    uint256     totalMiniJackpotFund;
    // TODO
    uint256     totalJackpotFund;
    // TODO
    bool        isLocked;
    // TODO
    bool        hasJackpot;
    // TODO
    uint256[8]  payouts;
  }

  /// TODO
  function addRegularFund(Data storage self, uint256 amount) public {
    require(!self.isLocked);
    self.totalRegularFund += amount;
  }

  /// TODO
  function addMiniJackpotFund(Data storage self, uint256 amount) public {
    require(!self.isLocked);
    self.totalMiniJackpotFund += amount;
  }

  /// TODO
  function addJackpotFund(Data storage self, uint256 amount) public {
    require(!self.isLocked);
    self.totalJackpotFund += amount;
  }

  /// TODO
  function addWinner(Data storage self,
                     uint8 whiteBallMatches,
                     bool powerBallMatch) public {
    addMultipleWinners(self, whiteBallMatches, powerBallMatch, 1);
  }

  function addMultipleWinners(Data storage self,
                              uint8 whiteBallMatches,
                              bool powerBallMatch,
                              uint256 winnerCounts) public {
    require(!self.isLocked);
    uint8 tier = getRewardTier(whiteBallMatches, powerBallMatch);
    self.winnerCounts[tier] += winnerCounts;
  }

  /// TODO
  function computePayouts(Data storage self) public {
    require(!self.isLocked);
    self.isLocked = true;

    uint256 totalAllocation = 0;
    uint8 idx;
    for (idx = 1; idx <= TIER_COUNT; ++idx) {
      if (self.winnerCounts[idx] > 0) {
        totalAllocation += getRewardAllocation(idx);
      }
    }

    for (idx = 1; idx <= TIER_COUNT; ++idx) {
      if (self.winnerCounts[idx] > 0) {
        uint256 payout = self.totalRegularFund * getRewardAllocation(idx);
        payout /= totalAllocation;
        self.payouts[idx] += payout;
      }
    }

    for (idx = 1; idx <= TIER_COUNT; ++idx) {
      if (self.winnerCounts[idx] > 0) {
        self.payouts[idx] += self.totalMiniJackpotFund;
        break;
      }
    }

    self.hasJackpot = self.winnerCounts[1] > 0;
    if (self.hasJackpot) {
      self.payouts[1] += self.totalJackpotFund / 2;
    }

    for (idx = 1; idx <= TIER_COUNT; ++idx) {
      if (self.winnerCounts[idx] > 0) {
        self.payouts[idx] /= self.winnerCounts[idx];
      }
    }
  }

  /// TODO
  function getPayout(Data storage self,
                     uint8 whiteBallMatches,
                     bool powerBallMatch) public view returns (uint256) {
    require(self.isLocked);
    return self.payouts[getRewardTier(whiteBallMatches, powerBallMatch)];
  }

  function getUnusedJackpot(Data storage self) public view returns (uint256) {
    require(self.isLocked);
    return self.hasJackpot ? self.totalJackpotFund / 2 : self.totalJackpotFund;
  }

  /// TODO
  function getRewardAllocation(uint8 tier) private pure returns (uint256) {
    if (tier == 1) return    0;
    if (tier == 2) return  514;
    if (tier == 3) return  578;
    if (tier == 4) return 1098;
    if (tier == 5) return  997;
    if (tier == 6) return 1462;
    if (tier == 7) return 5384;
    throw;
  }

  /// TODO
  function getRewardTier(uint8 whiteBallMatches,
                         bool powerBallMatch) private pure returns (uint8) {
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
