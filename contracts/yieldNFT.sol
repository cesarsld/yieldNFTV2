pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../interfaces/Mintable.sol";

contract yieldNFT is ERC721 {
	uint256 constant public RATE = 10 ether; 
	uint256 constant public INITIAL_ISSUANCE = 3650 ether;

	mapping(address => uint256) public rewards;
	mapping(address => uint256) public lastUpdate;

	Mintable public yieldToken;

	event RewardPaid(address indexed user, uint256 reward);

	constructor(address _yield, string memory _name, string memory _symbol) public ERC721(_name, _symbol) {
		yieldToken = Mintable(_yield);
	}

	// called on transfers
	modifier updateReward(address _from, address _to) {
		if (lastUpdate[_from] > 0)
			rewards[_from] += balanceOf(_from).mul(RATE.mul((block.timestamp.sub(lastUpdate[_from])))).div(86400);
		lastUpdate[_from] = block.timestamp;
		if (_to != address(0)) {
			if (lastUpdate[_to] > 0)
				rewards[_to] += balanceOf(_to).mul(RATE.mul((block.timestamp.sub(lastUpdate[_to])))).div(86400);
			lastUpdate[_to] = block.timestamp;
		}
		_;
	}

	// called when minting many NFTs
	modifier updateRewardOnMint(address _user, uint256 _amount) {
		if (lastUpdate[_user] > 0)
			rewards[_user] += balanceOf(_user).mul(RATE.mul((block.timestamp.sub(lastUpdate[_user])))).div(86400)
				.add(_amount.mul(INITIAL_ISSUANCE));
		else 
			rewards[_user] += _amount.mul(INITIAL_ISSUANCE);
		lastUpdate[_user] = block.timestamp;
		_;
	}

	function getReward() external updateReward(msg.sender, address(0)) {
		uint256 reward = rewards[msg.sender];
		if (reward > 0) {
			rewards[msg.sender] = 0;
			yieldToken.mint(msg.sender, reward);
			emit RewardPaid(msg.sender, reward);
		}
	}

    function transferFrom(address from, address to, uint256 tokenId) public override updateReward(from, to){
		super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override updateReward(from, to) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override updateReward(from, to) {
		super.safeTransferFrom(from, to, tokenId, _data);
    }
}