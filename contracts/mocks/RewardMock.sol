pragma solidity ^0.4.19;

import "../Reward.sol";


/** @title RewardMock Contract for Testing Reward Library */
contract RewardMock {
  using Reward for Reward.Data;

  Reward.Data   reward;
  State         state;

  function RewardMock(address stateContract) public {
    state = State(stateContract);
  }

  function addNonJackpotFund() public {
    reward.addNonJackpotFund(state);
  }

  function addJackpotFund(uint256 amount) public {
    reward.addJackpotFund(amount);
  }

  function addMultipleWinners(uint8 whiteBallMatches,
                              bool powerBallMatch,
                              uint256 winnerCount) public {
    reward.addMultipleWinners(whiteBallMatches, powerBallMatch,
                              winnerCount, state);
  }

  function computePayouts() public {
    reward.computePayouts(state);
  }

  function getUnusedJackpot() public view returns (uint256) {
    return reward.getUnusedJackpot();
  }

  function getPayout(uint8 whiteBallMatches,
                     bool powerBallMatch) public view returns (uint256) {
    return reward.getPayout(whiteBallMatches, powerBallMatch, state);
  }
}
