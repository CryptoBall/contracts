import ethereum


def test_cbt_basic_functionality(cbt_token):
    assert cbt_token.call().name() == 'CryptoBallToken'
    assert cbt_token.call().symbol() == 'CBT'
    assert cbt_token.call().decimals() == 18
    assert cbt_token.call().totalSupply() == 0
