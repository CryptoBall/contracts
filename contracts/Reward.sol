pragma solidity ^0.4.19;

import "./interfaces/State.sol";


/** @title Reward Library */
library Reward {

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
                     bool powerBallMatch,
                     State state) public {
    addMultipleWinners(self, whiteBallMatches, powerBallMatch, 1, state);
  }

  function addMultipleWinners(Data storage self,
                              uint8 whiteBallMatches,
                              bool powerBallMatch,
                              uint256 winnerCounts,
                              State state) public {
    require(!self.isLocked);
    uint8 tier = state.getRewardTier(whiteBallMatches, powerBallMatch);
    self.winnerCounts[tier] += winnerCounts;
  }

  /// TODO
  function computePayouts(Data storage self, State state) public {
    require(!self.isLocked);
    self.isLocked = true;

    uint256 totalAllocation = 0;
    uint8 tierCount = state.getTierCount();
    uint8 idx;
    for (idx = 1; idx <= tierCount; ++idx) {
      if (self.winnerCounts[idx] > 0) {
        totalAllocation += state.getRewardAllocation(idx);
      }
    }

    for (idx = 1; idx <= tierCount; ++idx) {
      if (self.winnerCounts[idx] > 0) {
        uint256 payout = self.totalRegularFund * state.getRewardAllocation(idx);
        payout /= totalAllocation;
        self.payouts[idx] += payout;
      }
    }

    for (idx = 1; idx <= tierCount; ++idx) {
      if (self.winnerCounts[idx] > 0) {
        self.payouts[idx] += self.totalMiniJackpotFund;
        break;
      }
    }

    self.hasJackpot = self.winnerCounts[1] > 0;
    if (self.hasJackpot) {
      self.payouts[1] += self.totalJackpotFund / 2;
    }

    for (idx = 1; idx <= tierCount; ++idx) {
      if (self.winnerCounts[idx] > 0) {
        self.payouts[idx] /= self.winnerCounts[idx];
      }
    }
  }

  /// TODO
  function getPayout(Data storage self,
                     uint8 whiteBallMatches,
                     bool powerBallMatch,
                     State state) public view returns (uint256) {
    require(self.isLocked);
    return self.payouts[state.getRewardTier(whiteBallMatches, powerBallMatch)];
  }

  function getUnusedJackpot(Data storage self) public view returns (uint256) {
    require(self.isLocked);
    return self.hasJackpot ? self.totalJackpotFund / 2 : self.totalJackpotFund;
  }
}
