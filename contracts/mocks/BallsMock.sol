pragma solidity ^0.4.19;

import "../Balls.sol";


/** @title BallsMock Contract for Testing Balls Library */
contract BallsMock {
  using Balls for Balls.Data;

  Balls.Data[5] balls;
  State         state;

  function BallsMock(address stateContract) public {
    state = State(stateContract);
  }

  function show(uint idx) public view returns (uint8[5], uint8) {
    return balls[idx].show();
  }

  function score(uint idx1, uint idx2) public view returns (uint8, bool) {
    return balls[idx1].score(balls[idx2], state);
  }

  function set(uint idx, uint8[5] whiteBalls, uint8 powerBall) public {
    balls[idx].set(whiteBalls, powerBall, state);
  }

  function rand(uint idx) public {
    balls[idx].rand(state);
  }
}
