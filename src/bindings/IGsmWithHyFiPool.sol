// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAccessControl} from "../../src/bindings/IAccessControl.sol";

interface IGsmWithHyFiPool is IAccessControl {
    function getHarvestableUnderlyingBalance() external view returns (uint256);
}