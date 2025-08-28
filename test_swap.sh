#!/bin/bash

# Test STX to sBTC Swap Contract on Testnet
echo "🚀 Testing STX-sBTC Swap Contract on Testnet"
echo "=============================================="

CONTRACT_ADDRESS="ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608"
CONTRACT_NAME="simple-stx-swap"
TESTNET_API="https://api.testnet.hiro.so"

echo "Contract: $CONTRACT_ADDRESS.$CONTRACT_NAME"
echo ""

# Test 1: Get Swap Rate
echo "📊 Test 1: Getting swap rate..."
curl -s "$TESTNET_API/v2/contracts/call-read/$CONTRACT_ADDRESS/$CONTRACT_NAME/get-swap-rate" \
  -H "Content-Type: application/json" \
  -d '{"sender":"'$CONTRACT_ADDRESS'","arguments":[]}' | \
  python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if 'result' in data:
        result = data['result']
        if result.startswith('0x01'):
            # Extract the number from hex
            hex_val = result[2:]
            # Convert to decimal
            decimal_val = int(hex_val, 16)
            print(f'✅ Swap Rate: {decimal_val:,} (1 STX = {decimal_val/1000000} sBTC)')
        else:
            print(f'❌ Error: {result}')
    else:
        print('❌ No result found')
        print(json.dumps(data, indent=2))
except Exception as e:
    print(f'❌ Parse error: {e}')
    print(sys.stdin.read())
"

echo ""

# Test 2: Get Contract STX Balance
echo "💰 Test 2: Getting contract STX balance..."
curl -s "$TESTNET_API/v2/contracts/call-read/$CONTRACT_ADDRESS/$CONTRACT_NAME/get-contract-stx-balance" \
  -H "Content-Type: application/json" \
  -d '{"sender":"'$CONTRACT_ADDRESS'","arguments":[]}' | \
  python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if 'result' in data:
        result = data['result']
        if result.startswith('0x01'):
            hex_val = result[2:]
            decimal_val = int(hex_val, 16)
            stx_amount = decimal_val / 1000000
            print(f'✅ Contract STX Balance: {decimal_val:,} microSTX ({stx_amount:.6f} STX)')
        else:
            print(f'❌ Error: {result}')
    else:
        print('❌ No result found')
except Exception as e:
    print(f'❌ Parse error: {e}')
"

echo ""

# Test 3: Get sBTC Balance for Contract Address
echo "🪙 Test 3: Getting sBTC balance for contract address..."
curl -s "$TESTNET_API/v2/contracts/call-read/$CONTRACT_ADDRESS/$CONTRACT_NAME/get-sbtc-balance" \
  -H "Content-Type: application/json" \
  -d '{"sender":"'$CONTRACT_ADDRESS'","arguments":["'$CONTRACT_ADDRESS'"]}' | \
  python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if 'result' in data:
        result = data['result']
        if result.startswith('0x01'):
            hex_val = result[2:]
            decimal_val = int(hex_val, 16)
            sbtc_amount = decimal_val / 100000000
            print(f'✅ Contract sBTC Balance: {decimal_val:,} sBTC units ({sbtc_amount:.8f} sBTC)')
        else:
            print(f'❌ Error: {result}')
    else:
        print('❌ No result found')
except Exception as e:
    print(f'❌ Parse error: {e}')
"

echo ""

# Test 4: Check if contract exists and get info
echo "🔍 Test 4: Contract information..."
curl -s "$TESTNET_API/v2/contracts/source/$CONTRACT_ADDRESS/$CONTRACT_NAME" | \
  python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if 'source' in data:
        print('✅ Contract exists and is deployed')
        print(f'✅ Contract ID: {data.get(\"contract_id\", \"N/A\")}')
        print(f'✅ Block Height: {data.get(\"block_height\", \"N/A\")}')
        print(f'✅ Clarity Version: {data.get(\"clarity_version\", \"N/A\")}')
    else:
        print('❌ Contract not found or error occurred')
        print(json.dumps(data, indent=2))
except Exception as e:
    print(f'❌ Parse error: {e}')
"

echo ""
echo "=============================================="
echo "🎯 To test actual swapping with your wallet:"
echo "1. Visit: https://explorer.stacks.co/address/$CONTRACT_ADDRESS?chain=testnet"
echo "2. Click on 'simple-stx-swap' contract"
echo "3. Use 'Call Function' to test swap-stx-for-sbtc"
echo "4. Amount for 0.001 STX: 1000"
echo "=============================================="
