// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ILiquidator {
    /// @notice Performs a liquidation
    /// @param pair address of the pool to be liquidated
    /// @param user address of the user to be liquidated
    /// @param collateralAsset address of the collateral asset to be liquidated
    /// @param debtAsset address of the debt asset to be repaid
    /// @param swapPath encoded path of pools to swap collateral through, see: https://docs.uniswap.org/contracts/v3/guides/swaps/multihop-swaps
    /// @param liqPath either "flashSwap", "usdxlFlashMinter", "gluex", or "usdt0StabilityModule"
    function liquidate(
        address pair,
        address user,
        address collateralAsset,
        address debtAsset,
        bytes[] calldata swapPath,
        string calldata liqPath
    ) external returns (address, int256);

    /// @notice Performs a liquidation
    /// @param pair address of the pool to be liquidated
    /// @param user address of the user to be liquidated
    /// @param collateralAsset address of the collateral asset to be liquidated
    /// @param debtAsset address of the debt asset to be repaid
    /// @param maxDebtToCover the maximum debt to cover in token amount
    /// @param swapPath encoded path of pools to swap collateral through, see: https://docs.uniswap.org/contracts/v3/guides/swaps/multihop-swaps
    /// @param liqPath either "flashSwap", "usdxlFlashMinter", "gluex", or "usdt0StabilityModule"
    function liquidate(
        address pair,
        address user,
        address collateralAsset,
        address debtAsset,
        uint256 maxDebtToCover,
        bytes[] calldata swapPath,
        string calldata liqPath
    ) external returns (address, int256);
}