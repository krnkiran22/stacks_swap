# 🚀 Complete Testnet Deployment Guide

## 📍 Your Wallet Information

**Your Stacks Testnet Address:** `ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608`

This address was generated from your mnemonic in `settings/Testnet.toml`

---

## 🎯 Step-by-Step Testnet Deployment

### Step 1: Check Contract Compilation

```bash
wsl clarinet check
```

### Step 2: Generate Deployment Plan

```bash
wsl clarinet deployments generate --testnet --manual-cost
```

### Step 3: Deploy to Testnet

```bash
wsl clarinet deployments apply --testnet
```

### Step 4: Get Testnet STX (If Needed)

- Visit: https://explorer.stacks.co/sandbox/faucet?chain=testnet
- Enter your address: `ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608`
- Request testnet STX tokens

---

## 💰 Testing Your Contract on Testnet

### Method 1: Using Clarinet Console (Recommended)

After deployment, start console:

```bash
# IMPORTANT: Navigate to project directory first!
cd "C:\Users\HP\OneDrive\Desktop\stacksbc\my-swap-project"
wsl
cd my-swap-project
clarinet console
```

**⚠️ CRITICAL:** You MUST be in the project directory or you'll get "unresolved contract" errors!

**Test Commands:**

```clarity
;; Swap 0.001 STX (u1000) for sBTC
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap swap-stx-for-sbtc u1000)

;; Check your sBTC balance
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap get-sbtc-balance 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608)

;; Check contract STX balance
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap get-contract-stx-balance)

;; Swap sBTC back to STX
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap swap-sbtc-for-stx u100000000)
```

### Method 2: Using Stacks Explorer

1. Go to: https://explorer.stacks.co/?chain=testnet
2. Search for: `ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap`
3. Click on your contract
4. Use the "Call Function" interface

---

## 🔍 Amount Reference for 0.001 STX

| Action                | Function                   | Input Value  | Expected Result   |
| --------------------- | -------------------------- | ------------ | ----------------- |
| Swap 0.001 STX → sBTC | `swap-stx-for-sbtc`        | `u1000`      | `(ok u100000000)` |
| Check sBTC balance    | `get-sbtc-balance`         | Your address | `(ok u100000000)` |
| Check contract STX    | `get-contract-stx-balance` | None         | `(ok u1000)`      |
| Swap back sBTC → STX  | `swap-sbtc-for-stx`        | `u100000000` | `(ok u1000)`      |

---

## 📱 Wallet Integration

### For Hiro Wallet Users:

1. **Add Testnet Network:**

   - Open Hiro Wallet
   - Go to Settings → Network
   - Select "Testnet"

2. **Import Your Account:**

   - Use the same mnemonic from `settings/Testnet.toml`
   - Your address should be: `ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608`

3. **Get Testnet STX:**

   - Use the faucet: https://explorer.stacks.co/sandbox/faucet?chain=testnet

4. **Test Contract Calls:**
   - Use the Stacks Explorer or wallet dApp browser
   - Navigate to your contract on testnet

---

## 🛠 Troubleshooting

### Common Issues:

1. **"Contract not found" or "unresolved contract" error:**

   - ❌ **Wrong:** Running console from wrong directory
   - ✅ **Correct:** Navigate to project directory first:
     ```bash
     cd "C:\Users\HP\OneDrive\Desktop\stacksbc\my-swap-project"
     wsl
     cd my-swap-project
     clarinet console
     ```
   - The console should show your contract in the table, not "default settings"

2. **"Insufficient funds" error:**

   - Make sure you deployed with: `wsl clarinet deployments apply --testnet`
   - Wait 1-2 minutes after deployment
   - Check deployment status in Stacks Explorer

3. **"Insufficient funds" error:**

   - Get testnet STX from faucet
   - Make sure you have at least 0.001 STX + gas fees

4. **"Invalid mnemonic" error:**

   - Verify your mnemonic in `settings/Testnet.toml` has 12-24 words
   - No extra spaces or line breaks

5. **Wrong wallet address:**
   - Your address MUST be: `ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608`
   - This comes from your specific mnemonic

---

## 🎯 Quick Test Sequence

**Copy and paste these commands one by one in clarinet console:**

```clarity
;; 1. First, check if contract exists
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap get-swap-rate)

;; 2. Swap 0.001 STX for sBTC
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap swap-stx-for-sbtc u1000)

;; 3. Check your sBTC balance
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap get-sbtc-balance 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608)

;; 4. Check contract received your STX
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap get-contract-stx-balance)
```

**Expected Results:**

1. Rate check: `(ok u100000000)` - Confirms contract works
2. Swap result: `(ok u100000000)` - You got sBTC!
3. Your balance: `(ok u100000000)` - Your sBTC balance
4. Contract balance: `(ok u1000)` - Contract holds your STX

---

## 🌐 Important Links

- **Testnet Faucet:** https://explorer.stacks.co/sandbox/faucet?chain=testnet
- **Testnet Explorer:** https://explorer.stacks.co/?chain=testnet
- **Your Contract:** `ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap`
- **Your Wallet:** `ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608`

---

## ✅ Success Indicators

When everything works correctly:

1. **Contract deployment:** ✅ Shows in Stacks Explorer
2. **Swap function:** ✅ Returns `(ok u100000000)`
3. **Balance check:** ✅ Shows your sBTC balance
4. **STX transfer:** ✅ Your wallet STX decreases
5. **Contract balance:** ✅ Contract holds your STX

**Your contract is ready for real testnet usage!** 🚀
