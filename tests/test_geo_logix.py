import brownie
from brownie import GeoLogixSmartContract, accounts

def test_evaluation_excellent_performance():
    # Deploy the GeoLogixSmartContract
    geo_logix = GeoLogixSmartContract.deploy({'from': accounts[0]})

    # Evaluate driver with excellent performance
    tx = geo_logix.evaluateDriver(95, 95, {'from': accounts[0]})

    # Check the driver's balance
    assert geo_logix.balanceOf(accounts[0]) == 0.2  # 0.15 salary + 0.05 reward
    assert "SalaryReleased" in tx.events

def test_evaluation_average_performance():
    # Deploy the GeoLogixSmartContract
    geo_logix = GeoLogixSmartContract.deploy({'from': accounts[0]})

    # Evaluate driver with average performance
    tx = geo_logix.evaluateDriver(85, 85, {'from': accounts[0]})

    # Check the driver's balance
    assert geo_logix.balanceOf(accounts[0]) == 0.15  # Only salary, no reward
    assert "SalaryReleased" in tx.events

def test_evaluation_below_average_performance():
    # Deploy the GeoLogixSmartContract
    geo_logix = GeoLogixSmartContract.deploy({'from': accounts[0]})

    # Evaluate driver with below-average performance
    tx = geo_logix.evaluateDriver(70, 70, {'from': accounts[0]})

    # Check the driver's balance
    assert geo_logix.balanceOf(accounts[0]) == 0.1  # Reduced salary due to penalty
    assert "PenaltyApplied" in tx.events
