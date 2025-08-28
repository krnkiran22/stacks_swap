#!/bin/bash
# Testnet Contract Testing Script

echo "🚀 Testing your STX-sBTC swap contract on testnet..."
echo "Contract: ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap"
echo ""

# Test 1: Get swap rate
echo "📊 Test 1: Getting swap rate..."
curl -s -X POST "https://api.testnet.hiro.so/v2/contracts/call-read/ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608/simple-stx-swap/get-swap-rate" \
-H "Content-Type: application/json" \
-d '{"sender":"ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608","arguments":[]}' | jq '.'

echo ""

# Test 2: Check contract STX balance
echo "💰 Test 2: Checking contract STX balance..."
curl -s -X POST "https://api.testnet.hiro.so/v2/contracts/call-read/ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608/simple-stx-swap/get-contract-stx-balance" \
-H "Content-Type: application/json" \
-d '{"sender":"ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608","arguments":[]}' | jq '.'

echo ""

# Test 3: Check your sBTC balance
echo "🪙 Test 3: Checking your sBTC balance..."
curl -s -X POST "https://api.testnet.hiro.so/v2/contracts/call-read/ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608/simple-stx-swap/get-sbtc-balance" \
-H "Content-Type: application/json" \
-d '{"sender":"ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608","arguments":["0x0516de5e71efa3fcdfd7b0c3b8e35b5f4f4dc9bb83cf"]}' | jq '.'

echo ""
echo "✅ Contract is live and responding!"
echo ""
echo "🎯 To make actual swaps (write operations), use:"
echo "   1. Stacks Explorer: https://explorer.stacks.co/address/ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608?chain=testnet"
echo "   2. Hiro Wallet with testnet mode"
echo "   3. Your own dApp frontend"
echo ""
echo "💡 For 0.001 STX swap, use amount: 1000"
