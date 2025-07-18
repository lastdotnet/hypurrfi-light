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
        uint256 collateralToLiquidate;
        uint256 debtToRepay;
        uint256 healthFactor;
        bool isLiquidatable;
        string reason;
    }

    function ADDRESSES_PROVIDER() external view returns (address);
    function POOL() external view returns (address);
    function getLiquidationBonus(address collateralAsset) external view returns (uint256);
    function getLiquidationProtocolFee(address collateralAsset) external view returns (uint256);
    function simulateLiquidation(SimulateLiquidationParams calldata params) external view returns (LiquidationSimulationResult memory result);
    function simulateLiquidationBatch(SimulateLiquidationParams[] calldata params) external view returns (LiquidationSimulationResult[] memory results);
} 