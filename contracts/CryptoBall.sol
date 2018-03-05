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
    Open,       // TODO
    Drawn,      // TODO
    Concluded   // TODO
  }

  enum TicketState {
    Open,       // TODO
    Verified,   // TODO
    Paid        // TODO
  }

  struct Ticket {
    TicketState   state;            // TODO
    address       owner;            // TODO

    Balls.Data    balls;            // TODO
    uint8         whiteBallMatches; // TODO
    bool          powerBallMatch;   // TODO
  }

  struct Lottery {
    LotteryState  state;          // TODO
    uint256       timeToDraw;     // TODO

    Ticket[]      tickets;        // TODO
    Balls.Data    balls;          // TODO
    Reward.Data   reward;         // TODO
  }


  State       state;

  Lottery[]   lotteries;
  Ticket[]    tickets;
  uint256     nextJackpotAmount;

  uint256 constant REGULAR_PER_TICKET      = 0.0035 ether;
  uint256 constant MINI_JACKPOT_PER_TICKET = 0.0020 ether;
  uint256 constant JACKPOT_PER_TICKET      = 0.0020 ether;
  uint256 constant TX_FEE_PER_TICKET       = 0.0025 ether;
  uint256 constant TICKET_COST             = 0.0100 ether;

  uint256 constant TIME_CUTOFF_PURCHASE    = 2.0 hours;
  uint256 constant TIME_BETWEEN_DRAW       = 3.5 days;
  uint256 constant TIME_FOR_VERIFY         = 1.0 days;


  function CryptoBall(address stateContract,
                      uint256 firstDraw) public {
    assert(
      REGULAR_PER_TICKET + MINI_JACKPOT_PER_TICKET +
      JACKPOT_PER_TICKET + TX_FEE_PER_TICKET == TICKET_COST
    );

    state = State(stateContract);

    require(firstDraw >= state.getNow() + TIME_BETWEEN_DRAW);
    addNextLottery(firstDraw);
  }

  /// TODO
  function buyTicket(uint8[5] whiteBalls, uint8 powerBall) public payable {
    require(msg.value == TICKET_COST);

    Lottery storage lottery = getCurrentLottery();
    require(lottery.state == LotteryState.Open);
    require(state.getNow() < lottery.timeToDraw - TIME_CUTOFF_PURCHASE);

    uint256 nextTicketId = tickets.length++;
    Ticket storage ticket = tickets[nextTicketId];

    ticket.state = TicketState.Open;
    ticket.owner = msg.sender;
    ticket.balls.set(whiteBalls, powerBall);

    lottery.reward.addRegularFund(REGULAR_PER_TICKET);
    lottery.reward.addMiniJackpotFund(MINI_JACKPOT_PER_TICKET);
    nextJackpotAmount += JACKPOT_PER_TICKET;
  }

  /// TODO
  function verifyTicket(uint256 ticketId) public {
    Lottery storage lottery = getPreviousLottery();
    Ticket storage ticket = lottery.tickets[ticketId];

    require(lottery.state == LotteryState.Drawn);
    require(ticket.state == TicketState.Open);
    ticket.state = TicketState.Verified;

    (ticket.whiteBallMatches, ticket.powerBallMatch) =
        lottery.balls.score(ticket.balls);

    lottery.reward.addWinner(ticket.whiteBallMatches,
                             ticket.powerBallMatch);
  }

  /// TODO
  function withdrawReward(uint256 lotteryId, uint256 ticketId) public {
    Lottery storage lottery = lotteries[lotteryId];
    Ticket storage ticket = lottery.tickets[ticketId];

    require(ticket.state == TicketState.Verified);
    ticket.state = TicketState.Paid;

    uint256 rewardAmount = lottery.reward.getPayout(ticket.whiteBallMatches,
                                                    ticket.powerBallMatch);
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

    addNextLottery(lottery.timeToDraw + TIME_BETWEEN_DRAW);
  }

  /// TODO
  function concludeLottery() public {
    Lottery storage lottery = getPreviousLottery();

    require(lottery.state == LotteryState.Drawn);
    require(state.getNow() >= lottery.timeToDraw + TIME_FOR_VERIFY);

    lottery.state = LotteryState.Concluded;
    lottery.reward.computePayouts();

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
