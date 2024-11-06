#!/usr/bin/python3
from web3 import Web3
from web3.middleware import SignAndSendRawMiddlewareBuilder
import time

rust_token_hex = open('.build/erc20/rust-token.bin').read().rstrip()

w3 = Web3(Web3.HTTPProvider('http://localhost:8545'))
sender = w3.eth.account.create()
pk = w3.to_hex(sender.key)
print(sender.address)

tx_hash = w3.eth.send_transaction({'from': w3.eth.accounts[0],'to':sender.address,'value':1000000000000000000})
print('transfer eth tx hash:', tx_hash)
w3.eth.wait_for_transaction_receipt(tx_hash)

w3.middleware_onion.inject(SignAndSendRawMiddlewareBuilder.build(sender), layer=0)

deploy_token_tx = {
  'from': sender.address,
  'data': rust_token_hex,
  'to': '',
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

tx_hash = w3.eth.send_transaction(deploy_token_tx)
print('deploy tx hash:', tx_hash)
receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print('deploy receipt:', receipt)
token_address = receipt['contractAddress']

mint_token_data = '40c10f19000000000000000000000000' + sender.address[2:] + '00000000000000000000000000000000000000000000000000000000000003e8'

mint_token_tx = {
  'from': sender.address,
  'data': mint_token_data,
  'to': token_address,
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

tx_hash = w3.eth.send_transaction(mint_token_tx)
print('mint tx hash:', tx_hash)
receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print('mint receipt:', receipt)

balanceOf_token_data = '70a08231000000000000000000000000' + sender.address[2:]

balanceOf_token_tx = {
  'from': sender.address,
  'data': balanceOf_token_data,
  'to': token_address,
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

balance = w3.eth.call(balanceOf_token_tx)
print('balance:', balance)

transfer_token_data = 'a9059cbb000000000000000000000000111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000000000000003e8'

transfer_token_tx = {
  'from': sender.address,
  'data': transfer_token_data,
  'to': token_address,
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

tx_hash = w3.eth.send_transaction(transfer_token_tx)
print('tx hash:', tx_hash)
receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print('receipt:', receipt)

balance = w3.eth.call(balanceOf_token_tx)
print('balance:', balance)

balanceOf_token_data2 = '70a082310000000000000000000000001111111111111111111111111111111111111111'
balanceOf_token_tx['data'] = balanceOf_token_data2

balance = w3.eth.call(balanceOf_token_tx)
print('balance:', balance)

decimals_token_tx = {
  'from': sender.address,
  'data': balanceOf_token_data,
  'to': token_address,
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

decimals_token_data2 = '313ce567'
decimals_token_tx['data'] = decimals_token_data2

decimals = w3.eth.call(decimals_token_tx)
print('decimals:', decimals)

endpoint_not_found_data = 'deadbeef'

endpoint_not_found_tx = {
  'from': sender.address,
  'data': endpoint_not_found_data,
  'to': token_address,
  'value': 0,
  'gas': 11000000,
  'maxFeePerGas': 2000000000,
  'maxPriorityFeePerGas': 1000000000,
}

tx_hash = w3.eth.send_transaction(endpoint_not_found_tx)
print('endpoint not found hash:', tx_hash)
receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print('mint receipt:', receipt)
