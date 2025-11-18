// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IGsmWithHyFiPool} from "../../src/bindings/IGsmWithHyFiPool.sol";

interface IGsmWithHyFiPoolV2 is IGsmWithHyFiPool {
  struct SwapParams {
    address swapRouter;
    bytes swapData;
    address sellToken;
    address buyToken;
    uint256 maxAmountIn;
    uint256 minAmountOut;
  }

  function HARVESTER_ROLE() external view returns (bytes32);

  function harvestLiquidity(
    SwapParams[] calldata swapParams
  ) external;
}