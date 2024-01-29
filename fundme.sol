// SPDX-License-Identifier: MIT


pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18; //5 dollars

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund () public payable {
        require(msg.value.getConversionRate() > MINIMUM_USD, "didn't send enough eth");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner{
        for (/* starting index */uint256 funderIndex = 0;
            /*ending index*/ funderIndex < funders.length;
            /*step amount*/ funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0; //remove money from dictionary because it's being drained
          }
    funders = new address[](0);
  
    (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
    require(callSuccess, "Call Failed For Some Reason...");
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _; // runs anything else after this.
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

}
 