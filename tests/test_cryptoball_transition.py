import ethereum
import pytest

from eth_utils import to_wei
from tests.utils.asserts import assert_approx_eq


def test_cryptoball_transition(state, cryptoball):
    # 4 days until the next draw
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact().drawLottery()

    state.forward_time(days=3, hours=23, minutes=59)

    # 1 minute until the next draw
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact().drawLottery()

    state.forward_time(minutes=2)

    # 1 minute after the next draw
    cryptoball.transact().drawLottery()

    # No repeat draw
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact().drawLottery()

    # 1 day 23 hours 59 min until the conclude
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact().concludeLottery()

    state.forward_time(days=1, hours=23, minutes=58)

    # 1 minute until the next draw
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact().concludeLottery()

    state.forward_time(minutes=2)

    # 1 minute after the next draw
    cryptoball.transact().concludeLottery()

    # No repeat conclude
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact().concludeLottery()

    # 1 day 11 hours 59 min until the next draw
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact().drawLottery()

    state.forward_time(days=1, hours=11, minutes=58)

    # 1 minute until the next draw
    with pytest.raises(ethereum.tester.TransactionFailed):
        cryptoball.transact().drawLottery()

    state.forward_time(minutes=2)

    # 1 minute after the next draw
    cryptoball.transact().drawLottery()
