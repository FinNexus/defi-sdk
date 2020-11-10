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

import { ERC20 } from "../../ERC20.sol";
import { TokenMetadata, Component } from "../../Structs.sol";
import { TokenAdapter } from "../TokenAdapter.sol";


/**
 * @dev OptionsManagerV2 contract interface.
 * Only the functions required for FinNexusTokenAdapter contract are added.
 */
interface OptionsManagerV2 {
    function getTokenNetworth() external view returns (uint256);
}


/**
 * @dev FNXOracle contract interface.
 * Only the functions required for FinNexusTokenAdapter contract are added.
 */
interface FNXOracle {
    function getPrice(address asset) external view returns (uint256);
}


/**
 * @title Token adapter for FinNexus.
 * @dev Implementation of TokenAdapter interface.
 * @author jeffqg123 <forestjqg@163.com>
 */
contract FinNexusTokenAdapter is TokenAdapter {

    address public constant OPT_MANAGER_FNX = 0xfDf252995da6D6c54C03FC993e7AA6B593A57B8d;
    address public constant OPT_MANAGER_USDC = 0x120f18F5B8EdCaA3c083F9464c57C11D81a9E549;
    
    address public constant ORACLE = 0x43BD92bF3Bb25EBB3BdC2524CBd6156E3Fdd41F3;


    address public constant FNX = 0xeF9Cd7882c067686691B6fF49e650b43AFBBCC6B;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    address public constant FPT_FNX = 0x7E605Fb638983A448096D82fFD2958ba012F30Cd;
    address public constant FPT_USDC = 0x16305b9EC0bdBE32cF8a0b5C142cEb3682dB9d2d;
    /**
     * @return TokenMetadata struct with ERC20-style token info.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getMetadata(address token) external view override returns (TokenMetadata memory) {
        return TokenMetadata({
            token: token,
            name: ERC20(token).name(),
            symbol: ERC20(token).symbol(),
            decimals: ERC20(token).decimals()
        });
    }

    /**
     * @return Array of Component structs with underlying tokens rates for the given token.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getComponents(address) external view override returns (Component[] memory) {
        
        Component[] memory underlyingTokens = new Component[](2);

        uint256 fptWorth = OptionsManagerV2(OPT_MANAGER_USDC).getTokenNetworth();
        uint256 tokenPrice = FNXOracle(ORACLE).getPrice(USDC);
        tokenPrice = tokenPrice * 1e6 ;
        underlyingTokens[0] = Component({
                token:FPT_USDC,
                tokenType: "ERC20",
                rate: tokenPrice / fptWorth
                });
                
        fptWorth = OptionsManagerV2(OPT_MANAGER_FNX).getTokenNetworth();
        tokenPrice = FNXOracle(ORACLE).getPrice(FNX);    
        tokenPrice =  tokenPrice * 1e18;
        underlyingTokens[1] = Component({
                token:FPT_FNX,
                tokenType: "ERC20",
                rate: tokenPrice / fptWorth
                });
                
        return underlyingTokens;
    }
}
