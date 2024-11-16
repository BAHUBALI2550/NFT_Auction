// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "lib\framework\packages\0xcert-ethereum-utils-contracts\src\contracts\permission\ownable.sol";

/**
 * @dev Truffle migrations manager.
 */
contract Migrations is Ownable {
    uint256 public lastCompletedMigration;

    /**
     * @dev Contract constructor.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Sets migration state.
     * @param _completed Last completed migration number.
     */
    function setCompleted(uint256 _completed) public onlyOwner() {
        lastCompletedMigration = _completed;
    }

    /**
     * @dev Permorms migration.
     * @param _addr New migration address.
     */
    function upgrade(address _addr) public onlyOwner() {
        Migrations upgraded = Migrations(_addr);
        upgraded.setCompleted(lastCompletedMigration);
    }
}