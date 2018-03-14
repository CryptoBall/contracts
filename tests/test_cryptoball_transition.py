import ethereum
import pytest

from eth_utils import to_wei


# def test_cryptoball_transition(web3, accounts, state, cryptoball):
#     print(web3.eth.getBalance(accounts[0]))
#     cryptoball.transact({
#         'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)
#     cryptoball.transact({
#         'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)
#     cryptoball.transact({
#         'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)
#     print(web3.eth.getBalance(accounts[0]))
#     # 4 days until the next draw
#     with pytest.raises(ethereum.tester.TransactionFailed):
#         cryptoball.transact().drawLottery()

#     cryptoball.transact({
#         'value': to_wei(0.01, 'ether')}).buyTicket([0, 1, 2, 3, 4], 5)
