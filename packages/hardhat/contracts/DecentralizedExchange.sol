// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract DecentralizedExchange is Context {
    mapping(address => mapping(address => uint256)) public balances;
    
    event TokensDeposited(address indexed token, address indexed user, uint256 amount);
    event TokensWithdrawn(address indexed token, address indexed user, uint256 amount);
    event TokensSwapped(address indexed tokenGive, uint256 amountGive, address indexed tokenGet, uint256 amountGet);

    function depositTokens(address token, uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        
        IERC20(token).transferFrom(_msgSender(), address(this), amount);
        balances[_msgSender()][token] += amount;

        emit TokensDeposited(token, _msgSender(), amount);
    }

    function withdrawTokens(address token, uint256 amount) external {
        require(balances[_msgSender()][token] >= amount, "Insufficient balance");

        IERC20(token).transfer(_msgSender(), amount);
        balances[_msgSender()][token] -= amount;

        emit TokensWithdrawn(token, _msgSender(), amount);
    }

    function swapTokens(address tokenGive, uint256 amountGive, address tokenGet) external {
        require(balances[_msgSender()][tokenGive] >= amountGive, "Insufficient balance");

        uint256 amountGet = amountGive; // Simulate 1:1 token swap
        balances[_msgSender()][tokenGive] -= amountGive;
        balances[_msgSender()][tokenGet] += amountGet;

        emit TokensSwapped(tokenGive, amountGive, tokenGet, amountGet);
    }
}