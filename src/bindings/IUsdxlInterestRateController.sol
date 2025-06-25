// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {IUsdxlToken} from '../../../usdxl/interfaces/IUsdxlToken.sol';
import {IWrappedHypeGateway} from '@hypurrfi/periphery/contracts/misc/interfaces/IWrappedHypeGateway.sol';

/**
 * @title IUsdxlInterestRateController
 * @author Last Labs
 * @notice Interface for USDXL interest rate controller based on price deviation from peg
 * @dev Controller runs 3 times per day, maintains perpetual loan to ensure rate updates, 
 *      adjusts rates based on USDXL price relative to $1 peg
 */
interface IUsdxlInterestRateController {
    // Events
    event RateUpdated(uint256 oldRate, uint256 newRate, uint256 usdxlPrice, uint256 timestamp);
    event PerpetualLoanCreated(uint256 amount, uint256 timestamp);
    event PerpetualLoanRefreshed(uint256 amount, uint256 timestamp);
    event ExecutionSkipped(uint256 reason, uint256 timestamp);
    event PriceDataEmitted(uint256 offchainPrice, uint256 onchainPrice, uint256 timestamp);
    event PerpetualLoanAmountUpdated(uint256 oldAmount, uint256 newAmount, uint256 timestamp);
    event ExecutionIntervalUpdated(uint256 oldInterval, uint256 newInterval, uint256 timestamp);
    event UsdxlOracleUpdated(address oldOracle, address newOracle, uint256 timestamp);
    event MaxRateUpdated(uint256 oldMaxRate, uint256 newMaxRate, uint256 timestamp);
    event ParametersUpdated(
        uint256 oldMinRate, 
        uint256 newMinRate,
        uint256 oldMaxRate,
        uint256 newMaxRate,
        uint256 oldRateAdjustment, 
        uint256 newRateAdjustment,
        uint256 oldPriceThreshold, 
        uint256 newPriceThreshold,
        uint256 oldTargetPrice, 
        uint256 newTargetPrice,
        uint256 timestamp
    );
    event HYPEReceived(address sender, uint256 amount);
    event HYPEWithdrawn(address recipient, uint256 amount);
    event HYPESupplied(uint256 amount, uint256 timestamp);
    event HYPEWithdrawnFromPool(uint256 amount, address recipient, uint256 timestamp);
    event LoanClosed(uint256 timestamp);

    // Errors
    error ExecutionTooEarly();
    error InvalidOraclePrice();
    error PerpetualLoanFailed();
    error RateUpdateFailed();
    error InvalidParameter();

    // Configurable parameters (view functions)
    function minRate() external view returns (uint256);
    function maxRate() external view returns (uint256);
    function rateAdjustment() external view returns (uint256);
    function priceThreshold() external view returns (uint256);
    function targetPrice() external view returns (uint256);
    function perpetualLoanAmount() external view returns (uint256);
    function executionInterval() external view returns (uint256);
    function usdxlOracle() external view returns (address);

    // State variables (view functions)
    function USDXL_TOKEN() external view returns (IUsdxlToken);
    function USDXL_RESERVE() external view returns (address);
    function WRAPPED_HYPE_GATEWAY() external view returns (IWrappedHypeGateway);
    function lastExecutionTime() external view returns (uint256);
    function currentRate() external view returns (uint256);
    function perpetualLoanActive() external view returns (bool);
    function perpetualLoanDebt() external view returns (uint256);

    // Parameter update functions
    function updateMaxRate(uint256 newMaxRate) external;
    function updateParameters(
        uint256 newMinRate,
        uint256 newMaxRate,
        uint256 newRateAdjustment,
        uint256 newPriceThreshold,
        uint256 newTargetPrice
    ) external;
    function updateMinRate(uint256 newMinRate) external;
    function updateRateAdjustment(uint256 newRateAdjustment) external;
    function updatePriceThreshold(uint256 newPriceThreshold) external;
    function updateTargetPrice(uint256 newTargetPrice) external;
    function updatePerpetualLoanAmount(uint256 newAmount) external;
    function updateExecutionInterval(uint256 newInterval) external;
    function updateUsdxlOracle(address newOracle) external;

    // Core execution function
    function execute(int256 offchainPrice) external;

    // Emergency functions
    function emergencyUpdateRate(uint256 newRate) external;
    function emergencyRepayAll() external;

    // Withdrawal functions
    function withdrawUsdxl(uint256 amount, address to) external;
    function withdrawSuppliedHYPE(uint256 amount, address payable to) external;
    function withdrawHYPE(uint256 amount, address payable to) external;

    // Utility functions
    function closeLoanAndWithdrawAll(address payable to) external;

    // View functions
    function getUsdxlPrice() external view returns (uint256);
    function getNextExecutionTime() external view returns (uint256);
    function isExecutionDue() external view returns (bool);
    function getParameters() external view returns (
        uint256 minRate_,
        uint256 maxRate_,
        uint256 rateAdjustment_,
        uint256 priceThreshold_,
        uint256 targetPrice_
    );
    function getPerpetualLoanStatus() external view returns (bool active, uint256 debt);
    function getCurrentInterestRate() external view returns (uint256);
    function getSuppliedHYPEBalance() external view returns (uint256);

    // Receive function
    receive() external payable;
} 