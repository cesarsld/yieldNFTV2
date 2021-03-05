pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestERC is ERC20("Test", "T") {
	function mint(address _to, uint256 _amount) external {
		_mint(_to, _amount);
	}
}
