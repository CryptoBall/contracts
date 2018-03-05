import pytest


@pytest.fixture()
def state(provider):
    return provider.get_or_deploy_contract('StateMock')[0]


@pytest.fixture()
def balls(provider, state):
    return provider.get_or_deploy_contract('BallsMock',
        deploy_args=(state.address,))[0]


@pytest.fixture()
def reward(provider):
    return provider.get_or_deploy_contract('RewardMock')[0]


@pytest.fixture()
def cbt_token(provider):
    return provider.get_or_deploy_contract('CryptoBallToken')[0]
