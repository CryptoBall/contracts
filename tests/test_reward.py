import ethereum
import pytest

from eth_utils import to_wei


def assert_approx(expected, value):
    # Similar to assert equality, but allow the value to be within range
    # [0.75 * expected, 1.25 * expected]. Only for checking order of magnitude.
    assert value >= 0.5 * expected
    assert value <= 1.5 * expected


def test_invalid_reward_tier(reward):
    with pytest.raises(ethereum.tester.TransactionFailed):
        reward.transact().addMultipleWinners(0, False, 1)

    with pytest.raises(ethereum.tester.TransactionFailed):
        reward.transact().addMultipleWinners(1, False, 10);

    with pytest.raises(ethereum.tester.TransactionFailed):
        reward.transact().addMultipleWinners(2, False, 100);


def test_basic_reward(reward, state):
    # 2000000 Participants
    # 7000 ETH Regular Pool. 4000 ETH Mini Jackpot Pool. 4000 ETH Jackpot Pool.
    state.contract.transact().setRegularPoolPerTicket(to_wei(7000, 'ether'))
    state.contract.transact().setMiniJackpotPoolPerTicket(to_wei(4000, 'ether'))
    reward.transact().addNonJackpotFund()
    reward.transact().addJackpotFund(to_wei(4000, 'ether'))

    reward.transact().addMultipleWinners(0, True, 35000)
    reward.transact().addMultipleWinners(1, True, 44000)
    reward.transact().addMultipleWinners(2, True, 17000)
    reward.transact().addMultipleWinners(3, False, 44000)
    reward.transact().addMultipleWinners(3, True, 2300)
    reward.transact().addMultipleWinners(4, False, 1900)
    reward.transact().addMultipleWinners(4, True, 100)
    reward.transact().addMultipleWinners(5, False, 16)
    reward.transact().addMultipleWinners(5, True, 1)
    reward.transact().computePayouts()

    assert reward.call().getUnusedJackpot() == to_wei(2000, 'ether')
    assert_approx(reward.call().getPayout(0, True), to_wei(0.03, 'ether'))
    assert_approx(reward.call().getPayout(1, True), to_wei(0.03, 'ether'))
    assert_approx(reward.call().getPayout(2, True), to_wei(0.06, 'ether'))
    assert_approx(reward.call().getPayout(3, False), to_wei(0.03, 'ether'))
    assert_approx(reward.call().getPayout(3, True), to_wei(0.3, 'ether'))
    assert_approx(reward.call().getPayout(4, False), to_wei(0.4, 'ether'))
    assert_approx(reward.call().getPayout(4, True), to_wei(4, 'ether'))
    assert_approx(reward.call().getPayout(5, False), to_wei(22.5, 'ether'))
    assert_approx(reward.call().getPayout(5, True), to_wei(6000, 'ether'))


def test_without_big_jackpot(reward, state):
    # 100000 Participants
    # 350 ETH Regular Pool. 200 ETH Mini Jackpot Pool. 200 ETH Jackpot Pool.
    state.contract.transact().setRegularPoolPerTicket(to_wei(350, 'ether'))
    state.contract.transact().setMiniJackpotPoolPerTicket(to_wei(200, 'ether'))
    reward.transact().addNonJackpotFund()
    reward.transact().addJackpotFund(to_wei(200, 'ether'))

    reward.transact().addMultipleWinners(0, True, 1700)
    reward.transact().addMultipleWinners(1, True, 2200)
    reward.transact().addMultipleWinners(2, True, 800)
    reward.transact().addMultipleWinners(3, False, 2000)
    reward.transact().addMultipleWinners(3, True, 100)
    reward.transact().addMultipleWinners(4, False, 80)
    reward.transact().addMultipleWinners(4, True, 5)
    reward.transact().addMultipleWinners(5, False, 1)
    reward.transact().addMultipleWinners(5, True, 0)
    reward.transact().computePayouts()

    reward.call().getUnusedJackpot() == to_wei(200, 'ether')
    assert_approx(reward.call().getPayout(0, True), to_wei(0.03, 'ether'))
    assert_approx(reward.call().getPayout(1, True), to_wei(0.03, 'ether'))
    assert_approx(reward.call().getPayout(2, True), to_wei(0.06, 'ether'))
    assert_approx(reward.call().getPayout(3, False), to_wei(0.03, 'ether'))
    assert_approx(reward.call().getPayout(3, True), to_wei(0.3, 'ether'))
    assert_approx(reward.call().getPayout(4, False), to_wei(0.4, 'ether'))
    assert_approx(reward.call().getPayout(4, True), to_wei(4, 'ether'))
    assert_approx(reward.call().getPayout(5, False), to_wei(200, 'ether'))
    assert_approx(reward.call().getPayout(5, True), to_wei(0, 'ether'))


def test_even_with_lower_players(reward, state):
    # 10000 Participants
    # 35 ETH Regular Pool. 20 ETH Mini Jackpot Pool. 20 ETH Jackpot Pool.
    state.contract.transact().setRegularPoolPerTicket(to_wei(35, 'ether'))
    state.contract.transact().setMiniJackpotPoolPerTicket(to_wei(20, 'ether'))
    reward.transact().addNonJackpotFund()
    reward.transact().addJackpotFund(to_wei(20, 'ether'))

    reward.transact().addMultipleWinners(0, True, 170)
    reward.transact().addMultipleWinners(1, True, 220)
    reward.transact().addMultipleWinners(2, True, 80)
    reward.transact().addMultipleWinners(3, False, 200)
    reward.transact().addMultipleWinners(3, True, 10)
    reward.transact().addMultipleWinners(4, False, 8)
    reward.transact().addMultipleWinners(4, True, 1)
    reward.transact().addMultipleWinners(5, False, 0)
    reward.transact().addMultipleWinners(5, True, 0)
    reward.transact().computePayouts()

    assert reward.call().getUnusedJackpot() == to_wei(20, 'ether')
    assert_approx(reward.call().getPayout(0,  True), to_wei(0.03, 'ether'))
    assert_approx(reward.call().getPayout(1,  True), to_wei(0.03, 'ether'))
    assert_approx(reward.call().getPayout(2,  True), to_wei(0.06, 'ether'))
    assert_approx(reward.call().getPayout(3, False), to_wei(0.03, 'ether'))
    assert_approx(reward.call().getPayout(3,  True), to_wei(0.3, 'ether'))
    assert_approx(reward.call().getPayout(4, False), to_wei(0.4, 'ether'))
    assert_approx(reward.call().getPayout(4,  True), to_wei(20, 'ether'))
    assert_approx(reward.call().getPayout(5, False), to_wei(0, 'ether'))
    assert_approx(reward.call().getPayout(5,  True), to_wei(0, 'ether'))
