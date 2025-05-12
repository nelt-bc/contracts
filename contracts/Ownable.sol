// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

abstract contract Ownable {
    address private _owner;

    modifier onlyOwner() {
        require(msg.sender == owner(), "ONLY OWNER");
        _;
    }

    constructor(address user) {
        _owner = user;
    }

    function owner() public view returns (address) {
        return _owner;
    }
}
