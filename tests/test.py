import brownie
from brownie import accounts
from contracts import GeoLogixSmartContract
from contracts.GeoLogixSmartContract import GeoLogixSmartContract




def test_deploy_and_mint():
    # Deploy the smart contract
    token = accounts[0].deploy(GeoLogixSmartContract)

    # Check the owner's balance after deployment
    assert token.balanceOf(accounts[0]) == 0.5 * 10**18  # Assuming 0.5 ether in Wei

def test_transfer():
    # Deploy the smart contract
    token = accounts[0].deploy(GeoLogixSmartContract)

    # Transfer 100 tokens from owner to another account
    with brownie.reverts("ERC20: transfer amount exceeds balance"):
        token.transfer(accounts[1], 100, {'from': accounts[0]})

    # Check the balances after the failed transfer
    assert token.balanceOf(accounts[0]) == 0.5 * 10**18  # Initial balance remains the same
    assert token.balanceOf(accounts[1]) == 0  # Recipient balance remains 0
