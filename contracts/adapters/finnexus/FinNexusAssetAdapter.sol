// Copyright (C) 2020 Zerion Inc. <https://zerion.io>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

pragma solidity 0.6.5;
pragma experimental ABIEncoderV2;

import { ProtocolAdapter } from "../ProtocolAdapter.sol";

interface FPTCoin {
    function balanceOf(address account) external view returns (uint256);
    function lockedBalanceOf(address account) external view returns (uint256);
}
/**
 * @title Asset adapter for FinNexus option protocol.
 * @dev Implementation of ProtocolAdapter interface.
 * @author jeffqg123 <forestjqg@163.com>
 */
contract FinNexusAssetAdapter is ProtocolAdapter {

    string public constant override adapterType = "Asset";
    string public constant override tokenType = "FPT token";

    address public constant FPT_FNX = 0x7E605Fb638983A448096D82fFD2958ba012F30Cd;
    address public constant FPT_USDC = 0x16305b9EC0bdBE32cF8a0b5C142cEb3682dB9d2d;
    
    /**
     * @return Amount of FPT token on FNX the Option protocol by the given account.
     * @dev Implementation of ProtocolAdapter interface function.
     */
    function getBalance(address, address account) external view override returns (uint256) {
        uint256 fptFnx = FPTCoin(FPT_FNX).balanceOf(account) +  FPTCoin(FPT_FNX).lockedBalanceOf(account);
        uint256 fptUsdc= FPTCoin(FPT_USDC).balanceOf(account) +  FPTCoin(FPT_USDC).lockedBalanceOf(account);
        return fptFnx + fptUsdc;
    }
}
