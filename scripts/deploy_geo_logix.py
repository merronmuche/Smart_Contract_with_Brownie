
from brownie import  GeoLogixSmartContract, accounts


def main():
    deployer = accounts[0]

    # Deploy the GeoLogixSmartContract
    geo_logix = GeoLogixSmartContract.deploy({'from': deployer})

    # Print the contract address after deployment
    print(f"GeoLogixSmartContract deployed at: {geo_logix.address}")
