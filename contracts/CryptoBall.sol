pragma solidity ^0.4.19;

import "./interfaces/LotteryInterface.sol";
import "./interfaces/State.sol";


/** @title CryptoBall Main Contract */
contract CryptoBall is LotteryInterface {

  enum LotteryState {
    Open,       // TODO
    Drawn,      // TODO
    Concluded   // TODO
  }

  enum TicketState {
    Open,       // TODO
    Verified,   // TODO
    Paid        // TODO
  }

  struct Lottery {
    LotteryState  state;        // TODO

    uint256       timeToDraw;   // TODO
  }


  State         state;

  function CryptoBall(address stateContract) public {
    state = State(stateContract);
  }

  /// TODO
  function buyTicket() public {

  }

  /// TODO
  function verifyTicket() public {

  }

  /// TODO
  function withdrawReward() public {

  }

  /// TODO
  function drawLottery() public {

  }

  /// TODO
  function concludeLottery() public {

  }
}
