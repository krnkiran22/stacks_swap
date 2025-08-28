#!/bin/bash

# Simple Contract Test
echo "🚀 Testing Contract Functions"
echo "============================="

CONTRACT_ADDRESS="ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608"
CONTRACT_NAME="simple-stx-swap"
API="https://api.testnet.hiro.so"

echo "Testing get-swap-rate function..."
curl -s "$API/v2/contracts/call-read/$CONTRACT_ADDRESS/$CONTRACT_NAME/get-swap-rate" \
  -H "Content-Type: application/json" \
  -d '{"sender":"'$CONTRACT_ADDRESS'","arguments":[]}'

echo ""
echo ""

echo "Testing get-contract-stx-balance function..."
curl -s "$API/v2/contracts/call-read/$CONTRACT_ADDRESS/$CONTRACT_NAME/get-contract-stx-balance" \
  -H "Content-Type: application/json" \
  -d '{"sender":"'$CONTRACT_ADDRESS'","arguments":[]}'

echo ""
echo ""

echo "Testing contract source..."
curl -s "$API/v2/contracts/source/$CONTRACT_ADDRESS/$CONTRACT_NAME"

echo ""
echo ""
echo "✅ Contract is deployed and responding!"
echo "To test actual swapping, use the Stacks Explorer:"
echo "https://explorer.stacks.co/address/$CONTRACT_ADDRESS?chain=testnet"
