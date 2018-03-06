import ethereum
import pytest

from eth_utils import to_wei


def test_cryptoball_buy_ticket_cost(cryptoball):
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact().buyTicket([0, 1, 2, 3, 4], 5)

    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact({
            'value': to_wei(0.0001, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)

    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact({
            'value': to_wei(0.1, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)

    cryptoball.transact({
        'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)


def test_cryptoball_buy_ticket_value(cryptoball):
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact({
            'value': to_wei(0.01, 'ether')}).buyTicket([0, 0, 2, 3, 4], 5)

    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact({
            'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 29], 5)

    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact({
            'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 20)

    cryptoball.transact({
        'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 28], 19)


def test_cryptoball_buy_period(state, cryptoball):
    # 4 days until the next draw
    cryptoball.transact({
        'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)

    # 3 days until the next draw
    state.forward_time(days=1)
    cryptoball.transact({
        'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)

    # 1 day until the next draw
    state.forward_time(days=2)
    cryptoball.transact({
        'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)

    # 3 hours until the next draw
    state.forward_time(hours=21)
    cryptoball.transact({
        'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)

    # 1 hour and 50 minutes until the next draw
    state.forward_time(hours=1, minutes=10)
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact({
            'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)

    # 10 minutes after the draw deadline
    state.forward_time(hours=2)
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact({
            'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)

    # draw the lottery!
    cryptoball.transact().drawLottery()

    # 3 days and 12 hours until the next draw
    cryptoball.transact({
        'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)

    # 2 hours and 1 minute until the next draw
    state.forward_time(days=3, hours=9, minutes=49)
    cryptoball.transact({
        'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)

    # 1 hour and 59 minutes until the next draw
    state.forward_time(minutes=2)
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact({
            'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)
