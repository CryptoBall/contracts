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
