// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {IPoolAddressesProvider} from "src/core/interfaces/IPoolAddressesProvider.sol";
import {IPool} from "src/core/interfaces/IPool.sol";

/**
 * @title IPooledLiquidationSimulator
 * @notice Interface for PooledLiquidationSimulator contract
 * @dev This interface provides view functions to calculate liquidation amounts without executing them
 */
interface IPooledLiquidationSimulator {
  /**
   * @notice Structure for liquidation opportunity results
   */
  struct LiquidationOpportunity {
    address collateralAsset;
    address debtAsset;
    uint256 collateralToLiquidate;
    uint256 debtToRepay;
    uint256 collateraToLiquidateInUsd;
    uint256 debtToRepayInUsd;
    int256 profitInUsd;  // Can be negative (loss) or positive (profit)
    uint256 healthFactor;
    bool isLiquidatable;
    string reason;
  }

  /**
   * @notice Structure for liquidation simulation parameters
   */
  struct SimulateLiquidationParams {
    address collateralAsset;
    address debtAsset;
    address user;
    uint256 debtToCover;
  }

  /**
   * @notice Structure for liquidation simulation results
   */
  struct LiquidationSimulationResult {
    uint256 collateralToLiquidate;
    uint256 debtToRepay;
    uint256 collateralToLiquidateInUsd;
    uint256 debtToRepayInUsd;
    uint256 healthFactor;
    bool isLiquidatable;
    string reason;
  }

  /**
   * @notice Gets the most profitable liquidation opportunity for a user
   * @param user The user address
   * @return opportunity The best liquidation opportunity
   */
  function getBestLiqOp(address user) external view returns (LiquidationOpportunity memory opportunity);

  /**
   * @notice Gets the most profitable liquidation opportunity for a user with a debt ceiling
   * @param user The user address
   * @param maxDebtToRepayInUsd Maximum debt to repay in USD (8 decimals). If debtToRepayInUsd exceeds this, 
   *        the debt amount is capped and collateral is recalculated accordingly. Use type(uint256).max for no limit.
   * @return opportunity The best liquidation opportunity respecting the debt ceiling
   */
  function getBestLiqOp(address user, uint256 maxDebtToRepayInUsd) external view returns (LiquidationOpportunity memory opportunity);

  /**
   * @notice Gets all liquidation opportunities for a user, sorted by profitability
   * @param user The user address
   * @return opportunities Array of liquidation opportunities sorted by profit (highest first)
   */
  function getAllLiqOps(address user) external view returns (LiquidationOpportunity[] memory opportunities);

  /**
   * @notice Gets all liquidation opportunities for a user with a debt ceiling, sorted by profitability
   * @param user The user address
   * @param maxDebtToRepayInUsd Maximum debt to repay in USD (8 decimals). If debtToRepayInUsd exceeds this,
   *        the debt amount is capped and collateral is recalculated accordingly. Use type(uint256).max for no limit.
   * @return opportunities Array of liquidation opportunities sorted by profit (highest first)
   */
  function getAllLiqOps(address user, uint256 maxDebtToRepayInUsd) external view returns (LiquidationOpportunity[] memory opportunities);

  /**
   * @notice Gets the liquidation bonus for a collateral asset
   * @param collateralAsset The collateral asset address
   * @return The liquidation bonus percentage
   */
  function getLiquidationBonus(address collateralAsset) external view returns (uint256);

  /**
   * @notice Gets the liquidation protocol fee for a collateral asset
   * @param collateralAsset The collateral asset address
   * @return The liquidation protocol fee percentage
   */
  function getLiquidationProtocolFee(address collateralAsset) external view returns (uint256);

  /**
   * @notice Simulates a liquidation call to determine the amount of collateral that would be liquidated
   * @param params The simulation parameters
   * @return result The liquidation simulation result
   */
  function simulateLiquidation(
    SimulateLiquidationParams memory params
  ) external view returns (LiquidationSimulationResult memory result);

  /**
   * @notice Simulates multiple liquidation calls in batch
   * @param params Array of simulation parameters
   * @return results Array of liquidation simulation results
   */
  function simulateLiquidationBatch(
    SimulateLiquidationParams[] memory params
  ) external view returns (LiquidationSimulationResult[] memory results);

  /**
   * @notice Gets the addresses provider
   * @return The addresses provider contract
   */
  function ADDRESSES_PROVIDER() external view returns (IPoolAddressesProvider);

  /**
   * @notice Gets the pool contract
   * @return The pool contract
   */
  function POOL() external view returns (IPool);
}
