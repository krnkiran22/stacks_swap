#!/bin/bash

# Check if swap was successful
echo "🔍 CHECKING SWAP RESULTS"
echo "======================="

CONTRACT_ADDRESS="ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608"
CONTRACT_NAME="simple-stx-swap"
USER_ADDRESS="ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608"
API="https://api.testnet.hiro.so"

echo "Checking contract STX balance..."
STX_BALANCE=$(curl -s "$API/v2/contracts/call-read/$CONTRACT_ADDRESS/$CONTRACT_NAME/get-contract-stx-balance" \
  -H "Content-Type: application/json" \
  -d '{"sender":"'$CONTRACT_ADDRESS'","arguments":[]}')

echo "Contract STX Balance: $STX_BALANCE"

echo ""
echo "Checking your sBTC balance..."
SBTC_BALANCE=$(curl -s "$API/v2/contracts/call-read/$CONTRACT_ADDRESS/$CONTRACT_NAME/get-sbtc-balance" \
  -H "Content-Type: application/json" \
  -d '{"sender":"'$CONTRACT_ADDRESS'","arguments":["'$USER_ADDRESS'"]}')

echo "Your sBTC Balance: $SBTC_BALANCE"

echo ""
if [[ "$STX_BALANCE" == *"0x0100000000000000000000000000000003e8"* ]]; then
    echo "🎉 SUCCESS! Contract received 1000 microSTX (0.001 STX)"
elif [[ "$STX_BALANCE" != *"0x010000000000000000000000000000000000"* ]]; then
    echo "✅ Contract has STX balance - swap may have occurred!"
else
    echo "❌ No STX in contract yet - swap not completed"
fi

if [[ "$SBTC_BALANCE" == *"0x0100000000000000000000001dcd6500"* ]]; then
    echo "🎉 SUCCESS! You received sBTC (100,000,000 units)"
elif [[ "$SBTC_BALANCE" != *"0x010000000000000000000000000000000000"* ]]; then
    echo "✅ You have sBTC balance - swap may have occurred!"
else
    echo "❌ No sBTC balance yet - swap not completed"
fi

echo ""
echo "To make a real swap, use the browser interface:"
echo "https://explorer.stacks.co/address/$CONTRACT_ADDRESS?chain=testnet"
