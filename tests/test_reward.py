import ethereum
import pytest


def test_basic_reward(reward):
    # 2000000 Participants
    # 7000 ETH Regular Pool. 4000 ETH Mini Jackpot. 4000 ETH Jackpot.
    reward.transact().addFunds(int(7000e18), int(4000e18), int(4000e18))
    reward.transact().addMultipleWinners(0,  True, 35000)
    reward.transact().addMultipleWinners(1,  True, 44000)
    reward.transact().addMultipleWinners(2,  True, 17000)
    reward.transact().addMultipleWinners(3, False, 44000)
    reward.transact().addMultipleWinners(3,  True,  2300)
    reward.transact().addMultipleWinners(4, False,  1900)
    reward.transact().addMultipleWinners(4,  True,   100)
    reward.transact().addMultipleWinners(5, False,    16)
    reward.transact().addMultipleWinners(5,  True,     1)
    reward.transact().computePayouts()

    assert reward.call().getUnusedJackpot() == 0
    assert reward.call().getPayout(0,  True) ==      30539868839334261 #      3x
    assert reward.call().getPayout(1,  True) ==      30539868839334261 #      3x
    assert reward.call().getPayout(2,  True) ==      60001993421708362 #      6x
    assert reward.call().getPayout(3, False) ==      30539868839334261 #      3x
    assert reward.call().getPayout(3,  True) ==     302436741362200390 #     30x
    assert reward.call().getPayout(4, False) ==     403195769749300990 #     40x
    assert reward.call().getPayout(4,  True) ==    4032692116017143426 #    400x
    assert reward.call().getPayout(5, False) ==   22413535333399780723 #   2250x
    assert reward.call().getPayout(5,  True) == 8000000000000000000000 # Jackpot


def test_without_big_jackpot(reward):
    # 100000 Participants
    # 350 ETH Regular Pool. 200 ETH Mini Jackpot. 200 ETH Jackpot.
    reward.transact().addFunds(int(350e18), int(200e18), int(200e18))
    reward.transact().addMultipleWinners(0,  True, 1700)
    reward.transact().addMultipleWinners(1,  True, 2200)
    reward.transact().addMultipleWinners(2,  True,  800)
    reward.transact().addMultipleWinners(3, False, 2000)
    reward.transact().addMultipleWinners(3,  True,  100)
    reward.transact().addMultipleWinners(4, False,   80)
    reward.transact().addMultipleWinners(4,  True,    5)
    reward.transact().addMultipleWinners(5, False,    1)
    reward.transact().addMultipleWinners(5,  True,    0)
    reward.transact().computePayouts()

    assert reward.call().getUnusedJackpot() == 200e18
    assert reward.call().getPayout(0,  True) ==     31833931078289103 #      3x
    assert reward.call().getPayout(1,  True) ==     31833931078289103 #      3x
    assert reward.call().getPayout(2,  True) ==     63752118010565135 #      6x
    assert reward.call().getPayout(3, False) ==     31833931078289103 #      3x
    assert reward.call().getPayout(3,  True) ==    347802252566530449 #     30x
    assert reward.call().getPayout(4, False) ==    478794976577294926 #     40x
    assert reward.call().getPayout(4,  True) ==   4032692116017143426 #    400x
    assert reward.call().getPayout(5, False) == 217930828266719824578 # MiniJpt
    assert reward.call().getPayout(5,  True) ==                     0


def test_even_with_lower_players(reward):
    # 10000 Participants
    # 35 ETH Regular Pool. 20 ETH Mini Jackpot. 20 ETH Jackpot.
    reward.transact().addFunds(int(35e18), int(20e18), int(20e18))
    reward.transact().addMultipleWinners(0,  True, 170)
    reward.transact().addMultipleWinners(1,  True, 220)
    reward.transact().addMultipleWinners(2,  True,  80)
    reward.transact().addMultipleWinners(3, False, 200)
    reward.transact().addMultipleWinners(3,  True,  10)
    reward.transact().addMultipleWinners(4, False,   8)
    reward.transact().addMultipleWinners(4,  True,   0)
    reward.transact().addMultipleWinners(5, False,   0)
    reward.transact().addMultipleWinners(5,  True,   0)
    reward.transact().computePayouts()

    assert reward.call().getUnusedJackpot() == 20e18
    assert reward.call().getPayout(0,  True) ==   35721936081923115 #    3.5x
    assert reward.call().getPayout(1,  True) ==   35721936081923115 #    3.5x
    assert reward.call().getPayout(2,  True) ==   71538418521418185 #    7.0x
    assert reward.call().getPayout(3, False) ==   35721936081923115 #    3.5x
    assert reward.call().getPayout(3,  True) ==  390280729224918912 #     40x
    assert reward.call().getPayout(4, False) == 3037272117212839727 # MiniJpt
    assert reward.call().getPayout(4,  True) ==                   0
    assert reward.call().getPayout(5, False) ==                   0
    assert reward.call().getPayout(5,  True) ==                   0
