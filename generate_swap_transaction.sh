#!/bin/bash

# Generate Real Swap Transaction
echo "🎯 REAL SWAP TRANSACTION GENERATOR"
echo "=================================="

CONTRACT_ADDRESS="ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608"
CONTRACT_NAME="simple-stx-swap"
SENDER_ADDRESS="ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608"  # Your wallet address
SWAP_AMOUNT="1000"  # 0.001 STX in microSTX

echo "📋 Transaction Details:"
echo "From: $SENDER_ADDRESS"
echo "To Contract: $CONTRACT_ADDRESS.$CONTRACT_NAME"
echo "Function: swap-stx-for-sbtc"
echo "Amount: $SWAP_AMOUNT microSTX (0.001 STX)"
echo ""

# Check sender balance first
echo "💰 Checking your wallet balance..."
BALANCE_CHECK=$(curl -s "https://api.testnet.hiro.so/v2/accounts/$SENDER_ADDRESS")

if [[ "$BALANCE_CHECK" == *"balance"* ]]; then
    echo "✅ Wallet found on testnet!"
    echo "Balance info: $BALANCE_CHECK" | grep -o '"balance":"[^"]*"' | head -1
else
    echo "❌ Wallet not found or no balance"
    echo "Get testnet STX: https://explorer.stacks.co/sandbox/faucet?chain=testnet"
    exit 1
fi

echo ""
echo "🔧 To make the real swap, you need to:"
echo ""
echo "1. Use Hiro Wallet browser extension"
echo "2. Or use Stacks CLI with your private key"
echo "3. Or use the browser interface (safest)"
echo ""

# Generate the CLI command (but don't execute with private key)
echo "📜 Stacks CLI Command (YOU need to add your private key):"
echo ""
echo "stx call_contract_func \\"
echo "  --testnet \\"
echo "  --contract-address $CONTRACT_ADDRESS \\"
echo "  --contract-name $CONTRACT_NAME \\"
echo "  --function-name swap-stx-for-sbtc \\"
echo "  --function-args 'u$SWAP_AMOUNT' \\"
echo "  --private-key YOUR_PRIVATE_KEY"
echo ""

echo "🌐 EASIEST METHOD - Browser:"
echo "Visit: https://explorer.stacks.co/address/$CONTRACT_ADDRESS?chain=testnet"
echo "Click 'simple-stx-swap' → 'Call Function' → 'swap-stx-for-sbtc'"
echo "Enter: $SWAP_AMOUNT"
echo ""

echo "✅ Your contract is ready for real transactions!"
