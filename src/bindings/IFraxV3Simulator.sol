// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

interface IFraxV3Simulator {
    /// @notice Result of a liquidation simulation
    struct LiquidationSimulationResult {
        uint256 collateralToLiquidate;      // Amount of collateral that would be liquidated (after protocol fee)
        uint256 debtToRepay;                // Amount of debt that would be repaid (including flash loan fee)
        uint256 healthFactor;               // User's current health factor (custom for Fraxlend)
        bool isLiquidatable;                // Whether the user can be liquidated
        string reason;                      // Reason if not liquidatable
    }

    /// @notice Parameters for simulating a liquidation
    struct SimulateLiquidationParams {
        address fraxlendPair;
        address user;
        uint256 sharesToLiquidate; // 0 for max
    }

    /**
     * @notice Simulates a liquidation call for a Fraxlend V3 pair
     * @param params The simulation parameters
     * @return result The liquidation simulation result
     */
    function simulateLiquidation(
        SimulateLiquidationParams calldata params
    ) external view returns (LiquidationSimulationResult memory result);

    /**
     * @notice Simulates liquidation for multiple users at once
     * @param params Array of simulation parameters
     * @return results Array of liquidation simulation results
     */
    function simulateLiquidationBatch(
        SimulateLiquidationParams[] calldata params
    ) external view returns (LiquidationSimulationResult[] memory results);
} 