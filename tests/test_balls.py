import ethereum
import pytest


def test_shows_empty_balls_correctly(chain):
    balls, _ = chain.provider.get_or_deploy_contract('BallsMock')

    white_balls, power_ball = balls.call().show(0)
    assert white_balls == [0, 0, 0, 0, 0]
    assert power_ball == 0


def test_sets_balls_correctly(chain):
    balls, _ = chain.provider.get_or_deploy_contract('BallsMock')

    balls.transact().set(0, [27, 28, 1, 0, 3], 15)
    white_balls, power_ball = balls.call().show(0)
    assert white_balls == [27, 28, 1, 0, 3]
    assert power_ball == 15

    balls.transact().set(0, [14, 11, 1, 2, 3], 2)
    white_balls, power_ball = balls.call().show(0)
    assert white_balls == [14, 11, 1, 2, 3]
    assert power_ball == 2


def test_does_not_allow_invalid_values(chain):
    balls, _ = chain.provider.get_or_deploy_contract('BallsMock')

    # white ball out of range
    with pytest.raises(ethereum.tester.TransactionFailed):
        balls.transact().set(0, [29, 28, 1, 0, 3], 15);

    # power ball out of range
    with pytest.raises(ethereum.tester.TransactionFailed):
        balls.transact().set(0, [18, 28, 1, 0, 3], 20);

    # duplicated white balls
    with pytest.raises(ethereum.tester.TransactionFailed):
        balls.transact().set(0, [10, 10, 2, 3, 4], 12);


def test_returns_score_correctly(chain):
    balls, _ = chain.provider.get_or_deploy_contract('BallsMock')

    balls.transact().set(0, [1, 2, 3, 4, 5], 15)
    balls.transact().set(1, [28, 27, 26, 25, 24], 15)
    white_matches, power_match = balls.call().score(0, 1)
    assert white_matches == 0
    assert power_match

    balls.transact().set(0, [9, 8, 1, 4, 2], 18)
    balls.transact().set(1, [28, 1, 26, 4, 9], 0)
    white_matches, power_match = balls.call().score(0, 1)
    assert white_matches == 3
    assert not power_match

    balls.transact().set(0, [9, 4, 1, 3, 28], 0)
    balls.transact().set(1, [4, 28, 1, 3, 9], 0)
    white_matches, power_match = balls.call().score(0, 1)
    assert white_matches == 5
    assert power_match


def test_refuses_to_compute_score_of_invalid_balls(chain):
    balls, _ = chain.provider.get_or_deploy_contract('BallsMock')

    with pytest.raises(ethereum.tester.TransactionFailed):
        balls.call().score(0, 2)
