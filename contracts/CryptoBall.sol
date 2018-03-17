pragma solidity ^0.4.19;

import "./interfaces/LotteryInterface.sol";
import "./interfaces/State.sol";
import "./Balls.sol";
import "./Reward.sol";


/** @title CryptoBall Main Contract */
contract CryptoBall is LotteryInterface {
  using Balls for Balls.Data;
  using Reward for Reward.Data;

  enum LotteryState {
    Open,       // Lottery is currently open for anyone to buy
    Drawn,      // Lottery is drawn, waiting for tickets to get verified
    Concluded   // Lottery is concluded, time to withdraw the rewards!
  }

  enum TicketState {
    Open,       // Ticket is bought and paid, and nothing has been done since
    Verified,   // Ticket is verified for reward
    Paid        // Ticket reward has been paid to the buyer
  }

  struct Ticket {
    TicketState   state;            // The state of this ticket
    address       owner;            // Who bought this lottery ticket?

    Balls.Data    balls;            // The 5+1 balls associated with Ticket
    uint8         whiteBallMatches; // Cached value
    bool          powerBallMatch;   // Cached value
  }

  struct Lottery {
    LotteryState  state;            // The state of this lottery
    uint256       timeToDraw;       // When to draw this lottery?
    // uint256       verifyRewardFund; // TODO

    Ticket[]      tickets;          // TODO
    Balls.Data    balls;            // TODO
    Reward.Data   reward;           // TODO
  }


  State       state;              // The constants state library

  Lottery[]   lotteries;          // The list of all lotteries ever exist
  uint256     nextJackpotAmount;  // The amount of jackpot contributing to the
                                  // next lottery


  function CryptoBall(address stateContract, uint256 firstDraw) public {
    state = State(stateContract);
    addNextLottery(firstDraw);
  }

  /// TODO
  function buyTicket(uint8[5] whiteBalls, uint8 powerBall) public payable {
    require(msg.value ==
      state.getRegularPoolPerTicket() +
      state.getMiniJackpotPoolPerTicket() +
      state.getJackpotPoolPerTicket() +
      state.getTXFeePoolPerTicket());

    Lottery storage lottery = getCurrentLottery();
    require(lottery.state == LotteryState.Open);
    require(state.getNow() <
            lottery.timeToDraw - state.getTimeCutoffPurchase());

    uint256 nextTicketId = lottery.tickets.length++;
    Ticket storage ticket = lottery.tickets[nextTicketId];

    ticket.state = TicketState.Open;
    ticket.owner = msg.sender;
    ticket.balls.set(whiteBalls, powerBall, state);

    // lottery.verifyRewardFund += state.getTXFeePoolPerTicket();
    lottery.reward.addRegularFund(state.getRegularPoolPerTicket());
    lottery.reward.addMiniJackpotFund(state.getMiniJackpotPoolPerTicket());
    nextJackpotAmount += state.getJackpotPoolPerTicket();
  }

  /// TODO
  function verifyTicket(uint256 ticketId, address verifier) public {
    Lottery storage lottery = getPreviousLottery();
    Ticket storage ticket = lottery.tickets[ticketId];

    require(lottery.state == LotteryState.Drawn);
    require(ticket.state == TicketState.Open);
    ticket.state = TicketState.Verified;

    (ticket.whiteBallMatches, ticket.powerBallMatch) =
        lottery.balls.score(ticket.balls, state);

    lottery.reward.addWinner(ticket.whiteBallMatches,
                             ticket.powerBallMatch,
                             state);

    // TODO: Verify Reward
  }

  /// TODO
  function withdrawReward(uint256 lotteryId, uint256 ticketId) public {
    Lottery storage lottery = lotteries[lotteryId];
    Ticket storage ticket = lottery.tickets[ticketId];

    require(ticket.state == TicketState.Verified);
    ticket.state = TicketState.Paid;

    uint256 rewardAmount = lottery.reward.getPayout(ticket.whiteBallMatches,
                                                    ticket.powerBallMatch,
                                                    state);

    ticket.owner.transfer(rewardAmount);
  }

  /// TODO
  function drawLottery() public {
    if (lotteries.length > 1 &&
        lotteries[lotteries.length - 2].state != LotteryState.Concluded) {
      concludeLottery();
    }

    Lottery storage lottery = getCurrentLottery();

    require(lottery.state == LotteryState.Open);
    require(state.getNow() >= lottery.timeToDraw);

    lottery.state = LotteryState.Drawn;
    lottery.balls.rand(state);

    addNextLottery(lottery.timeToDraw + state.getTimeBetweenLotteries());
  }

  /// TODO
  function concludeLottery() public {
    Lottery storage lottery = getPreviousLottery();

    require(lottery.state == LotteryState.Drawn);
    require(state.getNow() >=
            lottery.timeToDraw + state.getVerifyTimePeriod());

    lottery.state = LotteryState.Concluded;
    lottery.reward.computePayouts(state);

    Lottery storage currentLottery = getCurrentLottery();
    currentLottery.reward.addJackpotFund(lottery.reward.getUnusedJackpot());
  }

  /// TODO
  function getPreviousLottery() internal returns (Lottery storage) {
    return lotteries[lotteries.length - 2];
  }

  function getCurrentLottery() internal returns (Lottery storage) {
    return lotteries[lotteries.length - 1];
  }

  function addNextLottery(uint256 timeToDraw) internal {
    uint256 nextLotteryId = lotteries.length ++;

    Lottery storage lottery = lotteries[nextLotteryId];
    lottery.state = LotteryState.Open;
    lottery.timeToDraw = timeToDraw;
    lottery.reward.addJackpotFund(nextJackpotAmount);
    nextJackpotAmount = 0;
  }
}
