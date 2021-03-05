import pytest


@pytest.fixture(scope="function", autouse=True)
def shared_setup(fn_isolation):
    pass

@pytest.fixture()
def yieldtoken(TestERC, accounts):
    return TestERC.deploy({'from':accounts[0]})

@pytest.fixture()
def testyield(TestYield, yieldtoken, accounts):
    return TestYield.deploy(yieldtoken, "TestYield", "YLD", {'from':accounts[0]})
