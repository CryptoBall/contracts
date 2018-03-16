import pytest
from tests.utils.state import StateManager


@pytest.fixture()
def balance(accounts, web3):
    web3.eth.defaultAccount = accounts[9]
    def get_balance_impl(account_id=9):
        return web3.eth.getBalance(accounts[account_id])
    return get_balance_impl


@pytest.fixture()
def state(provider):
    state_contract = provider.get_or_deploy_contract('StateMock')[0]
    return StateManager(state_contract)


@pytest.fixture()
def balls(provider, state):
    return provider.get_or_deploy_contract('BallsMock',
        deploy_args=(state.get_address(),))[0]


@pytest.fixture()
def reward(provider, state):
    return provider.get_or_deploy_contract('RewardMock',
        deploy_args=(state.get_address(),))[0]


@pytest.fixture()
def cbt_token(provider):
    return provider.get_or_deploy_contract('CryptoBallToken')[0]


@pytest.fixture()
def cryptoball(provider, state):
    # Assumes that the first lottery's draw time is 4 days from now
    return provider.get_or_deploy_contract('CryptoBall',
        deploy_args=(state.get_address(),
                     int(state.get_time(days=4).timestamp())))[0]
