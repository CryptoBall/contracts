import argparse

from populus import Project
from populus.utils.wait import wait_for_transaction_receipt


def check_succesful_tx(web3, txid, timeout=180):
    receipt = wait_for_transaction_receipt(web3, txid, timeout=timeout)
    txinfo = web3.eth.getTransaction(txid)

    assert txinfo['gas'] != receipt['gasUsed']
    return receipt


def deploy(chain, name, args=()):
    contract = chain.provider.get_contract_factory(name)
    txhash = contract.deploy(args=args)
    print('Deploying {}, tx hash is {}'.format(name, txhash))
    receipt = check_succesful_tx(chain.web3, txhash)
    addr = receipt['contractAddress']
    print('Deployed {}, addr is {}'.format(name, addr))
    chain.registrar.set_contract_address(name, addr)
    return addr


def main():
    project = Project()

    chain_name = 'kovan'
    with project.get_chain(chain_name) as chain:
        state_addr = deploy(chain, 'StateImpl')
        deploy(chain, 'Balls')
        deploy(chain, 'Reward')
        deploy(chain, 'CryptoBall', (state_addr, 100))


if __name__ == '__main__':
    main()
