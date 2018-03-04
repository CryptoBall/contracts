pragma solidity ^0.4.19;

import "./interfaces/State.sol";


/** @title Balls Library */
library Balls {
  // White balls must be between [0, MAX_WHITEBALL)
  uint8 constant public MAX_WHITEBALL = 29;
  // Power balls must be between [0, MAX_POWERBALL)
  uint8 constant public MAX_POWERBALL = 19;
  // Number of blocks to skip for generating random balls
  uint8 constant internal RAND_SKIP_BLOCKS = 200;
  // Number of bits required to generate random balls
  uint8 constant internal BIT_PER_BALL = 5;

  struct Data {
    // The 5 white balls. All zeroes for uninitialized balls.
    uint8[5]  whiteBalls;
    // The powerball. Zero for uninitialized balls.
    uint8     powerBall;
  }

  /** @dev Returns the balls representation as a non-struct for getters.
    * @param self The balls to show
    */
  function show(Data storage self) public view returns (uint8[5], uint8) {
    return (self.whiteBalls, self.powerBall);
  }

  /** @dev Sets the given balls to the given values
    * @param self The balls to mutate
    * @param whiteBalls An array of 5 integers representing white balls
    * @param powerBall An integer representing power ball value
    */
  function set(Data storage self, uint8[5] whiteBalls, uint8 powerBall) public {
    // Sets white balls and power ball
    self.whiteBalls[0] = whiteBalls[0];
    self.whiteBalls[1] = whiteBalls[1];
    self.whiteBalls[2] = whiteBalls[2];
    self.whiteBalls[3] = whiteBalls[3];
    self.whiteBalls[4] = whiteBalls[4];
    self.powerBall = powerBall;
    // Checks that the new structure is valid
    validate(self);
  }

  /** @dev Sets the given balls to "random" values based on block hashes.
    *      See the official CryptoBall spec for details.
    * @param self The balls to mutate
    */
  function rand(Data storage self, State state) public {
    // Gets the current block
    uint256 currentBlock = state.getBlockNumber();
    // Requires at least RAND_SKIP_BLOCKS+6*BIT_PER_BALL blocks prior to
    // the current block to generate random balls.
    require(currentBlock > RAND_SKIP_BLOCKS + 6*BIT_PER_BALL);
    currentBlock -= RAND_SKIP_BLOCKS;

    // 0 <= _i < 5 for white balls. _i = 5 for power ball.
    for (uint8 _i = 0; _i < 6; ++_i) {
      // Moves back BIT_PER_BALL blocks for a new number
      currentBlock -= BIT_PER_BALL;

      uint256 digit = 0;
      // Let's try all possible 256 digits
      for (; digit < 256; ++digit) {
        uint8 randNumber = randImpl(currentBlock, digit, state);
        if (_i == 5) {
          if (randNumber < MAX_POWERBALL) {
            // Only accepts power ball in range [0, MAX_POWERBALL)
            self.powerBall = randNumber;
            break;
          }
        } else {
          bool ok = true;
          for (uint8 _j = 0; _j < _i; ++_j) {
            // Changes `ok` to false if we already have this number previously
            if (randNumber == self.whiteBalls[_j]) {
              ok = false;
            }
          }

          if (ok && randNumber < MAX_WHITEBALL) {
            // Only accepts non-dup white ball in range [0, MAX_WHITEBALL)
            self.whiteBalls[_i] = randNumber;
            break;
          }
        }
      }
      // We never practically expects `digit` to go beyond 255.
      assert(digit < 256);
    }

    // Checks that the new structure is valid
    validate(self);
  }

  /** @dev Computes the number of white ball matches and whether power ball
           matches for the two given balls
      @param self The first ball
      @param other The second ball
      @return Number of white matches and whether power ball matches
    */
  function score(Data storage self,
                 Data storage other) public view returns (uint8, bool) {
    // Confirms that both structures are valid
    validate(self);
    validate(other);
    // Counts number of white ball matches
    uint8 whiteBallMatches = 0;
    for (uint8 _sIdx = 0; _sIdx < 5; ++_sIdx) {
      // Loops through other's white balls and increments the variable upon
      // finding the same number. `break` is not really needed but added for
      // efficiency.
      for (uint8 _oIdx = 0; _oIdx < 5; ++_oIdx) {
        if (self.whiteBalls[_sIdx] == other.whiteBalls[_oIdx]) {
          ++whiteBallMatches;
          break;
        }
      }
    }
    // Checks if the power ball matches
    bool powerBallMatch = self.powerBall == other.powerBall;
    return (whiteBallMatches, powerBallMatch);
  }

  /** @dev Validates the balls struct
    * @param self The balls to validate
    */
  function validate(Data storage self) internal view {
    for (uint8 _i = 0; _i < 5; ++_i) {
      // White balls must be less than MAX_WHITEBALL and not contain duplicate
      require(self.whiteBalls[_i] < MAX_WHITEBALL);
      for (uint8 _j = 0; _j < _i; ++_j) {
        require(self.whiteBalls[_i] != self.whiteBalls[_j]);
      }
    }
    // Power ball must be less than MAX_POWERBALL
    require(self.powerBall < MAX_POWERBALL);
  }

  /** @dev Gets 2^power. Fails if the return result is more than 8 bits.
    * @param power The power
    * @return 2^power
    */
  function small2Pow(uint256 power) internal pure returns (uint8) {
    assert(power < 8);
    return uint8(1) << power;
  }

  /** @dev Gets a "random" number using the digit^th digits from block
    *  baseBlockNumber, baseBlockNumber+1, ..., baseBlockNumber+BIT_PER_BALL-1
    * @param baseBlockNumber The first block number to generate
    * @param digit The digit number used to generate
    * @return The "random number"
    */
  function randImpl(uint256 baseBlockNumber,
                    uint256 digit,
                    State state) internal view returns (uint8) {
    uint8 result = 0;
    for (uint8 _i = 0; _i < BIT_PER_BALL; ++_i) {
      // Gets the hash of the _i^th block
      bytes32 hash = state.getBlockhash(baseBlockNumber+_i);
      // Though possible, `hash` should never practically be zero
      assert(hash != 0);
      // Gets the [digit/8]^th byte of the block
      uint8 hashValue = uint8(hash[digit/8]);
      // `testValue`'s byte only contains 1 at position digit%8
      uint8 testValue = small2Pow(digit%8);
      // The test below is true iff the hash's digit^th digit is 1
      if ((hashValue & testValue) != 0) {
        result += small2Pow(_i);
      }
    }

    return result;
  }
}
