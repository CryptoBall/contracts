from datetime import datetime, timedelta


class StateManager(object):
    '''A utility class to manage the blockchain state for testing purpose'''

    def __init__(self, contract):
        '''Initializes the state manager based on a StateMock contract'''
        self.contract = contract
        self.set_time(datetime.utcnow())

    def get_address(self):
        '''Gets the underlying contract's address'''
        return self.contract.address

    def get_time(self, **delta_kwargs):
        '''Gets the current time in this testing world, optionally with delta'''
        return self.current_time + timedelta(**delta_kwargs)

    def set_time(self, current_time):
        '''Sets the current time in this testing world.'''
        self.current_time = current_time
        self.contract.transact().setNow(int(current_time.timestamp()))

    def forward_time(self, **delta_kwargs):
        '''Forwards the current time in this testing world by some delta.'''
        self.set_time(self.get_time(**delta_kwargs))

    def set_block_number(self, block_number):
        '''Sets the block number magic value, resulting in different hash seed
           in our in-house smart randomization algorithm'''
        self.contract.transact().setCurrentBlockNumber(block_number)
