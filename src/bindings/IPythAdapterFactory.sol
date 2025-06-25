// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

/// @title IPythAdapterFactory contains the events that PythAdapterFactory contract emits.
/// @dev This interface can be used for listening to the updates for off-chain.
interface IPythAdapterFactory {
    event AdapterDeployed(address indexed adapter, address indexed asset, bytes32 indexed priceId, string description);
}
