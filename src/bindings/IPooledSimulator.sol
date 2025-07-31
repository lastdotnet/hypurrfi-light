// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPooledSimulator {
    struct SimulateLiquidationParams {
        address collateralAsset;
        address debtAsset;
        address user;
        uint256 debtToCover;
    }

    struct LiquidationSimulationResult {
        uint256 collateralToLiquidate;      // Amount of collateral that would be liquidated (after protocol fee)
        uint256 debtToRepay;                // Amount of debt that would be repaid (including flash loan fee)
        uint256 debtTokensLeft;             // Amount of debt tokens left after repaying debt + flash loan fee (at oracle price)
        uint256 healthFactor;               // User's current health factor
        bool isLiquidatable;                // Whether the user can be liquidated
        string reason;                      // Reason if not liquidatable
    }

    function ADDRESSES_PROVIDER() external view returns (address);
    function POOL() external view returns (address);
    function getLiquidationBonus(address collateralAsset) external view returns (uint256);
    function getLiquidationProtocolFee(address collateralAsset) external view returns (uint256);
    function simulateLiquidation(SimulateLiquidationParams calldata params) external view returns (LiquidationSimulationResult memory result);
    function simulateLiquidationBatch(SimulateLiquidationParams[] calldata params) external view returns (LiquidationSimulationResult[] memory results);
} 