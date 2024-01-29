// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract FallBackExample {
    uint256 public myFavouriteNumber;

    receive() external payable {
        myFavouriteNumber = 1;
    }

    fallback() external payable {
        myFavouriteNumber = 2;
    }
}