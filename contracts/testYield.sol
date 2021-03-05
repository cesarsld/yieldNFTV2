pragma solidity ^0.6.12;

import "./yieldNFT.sol";

contract TestYield is yieldNFT{
	constructor(address _yield, string memory _name, string memory _symbol) yieldNFT(_yield, _name, _symbol) public 
	{}

	function mintNFTs(uint256 _amount) external updateRewardOnMint(msg.sender, _amount){
        for (uint i = 0; i < _amount; i++) {
            uint mintIndex = totalSupply();
            _safeMint(msg.sender, mintIndex);
        }
	}
}