import brownie
import pytest
from brownie import Wei

def test_mint(testyield, yieldtoken, accounts, chain):
	testyield.mintNFTs(10, {'from':accounts[0]})
	assert testyield.rewards(accounts[0]) == 10 * Wei('3650 ether')
	testyield.getReward({'from':accounts[0]})
	assert yieldtoken.balanceOf(accounts[0]) >= 10 * Wei('3650 ether')

def test_reward(testyield, yieldtoken, accounts, chain):
	testyield.mintNFTs(10, {'from':accounts[0]})
	testyield.getReward({'from':accounts[0]})
	pre = yieldtoken.balanceOf(accounts[0])
	chain.sleep(86400)
	testyield.getReward({'from':accounts[0]})
	assert yieldtoken.balanceOf(accounts[0]) - pre >= 10 * Wei("10 ether")

def test_transfer(testyield, yieldtoken, accounts, chain):
	testyield.mintNFTs(10, {'from':accounts[0]})
	testyield.getReward({'from':accounts[0]})
	chain.sleep(86400)
	for i in range(5):
		testyield.safeTransferFrom(accounts[0], accounts[1], i)
	chain.sleep(86401)
	pre = yieldtoken.balanceOf(accounts[0])
	testyield.getReward({'from':accounts[0]})
	testyield.getReward({'from':accounts[1]})
	assert yieldtoken.balanceOf(accounts[0]) - pre >= 15 * Wei("10 ether")
	assert yieldtoken.balanceOf(accounts[1]) >= 5 * Wei("10 ether")

def test_transfer_2(testyield, yieldtoken, accounts, chain):
	testyield.mintNFTs(10, {'from':accounts[0]})
	testyield.getReward({'from':accounts[0]})
	chain.sleep(86400)
	for i in range(10):
		testyield.safeTransferFrom(accounts[0], accounts[1], i)
	testyield.getReward({'from':accounts[0]})
	chain.sleep(86401)
	pre = yieldtoken.balanceOf(accounts[0])
	testyield.getReward({'from':accounts[0]})
	testyield.getReward({'from':accounts[1]})
	assert yieldtoken.balanceOf(accounts[0]) - pre == 0
	assert yieldtoken.balanceOf(accounts[1]) >= 10 * Wei("10 ether")