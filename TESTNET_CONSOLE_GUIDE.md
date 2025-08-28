# 🌐 TESTNET CONSOLE TESTING GUIDE

## ✅ Your Contract is LIVE on Testnet!

**Contract Address:** `ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap`
**Testnet Explorer:** https://explorer.stacks.co/address/ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608?chain=testnet

---

## 🚀 Method 1: Testnet Console Commands

**Step 1: Navigate to project in WSL**

```bash
wsl
cd my-swap-project
```

**Step 2: Start testnet console**

```bash
clarinet console --testnet
```

**Step 3: Test your deployed contract**

```clarity
;; Test contract exists and get swap rate
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap get-swap-rate)

;; Swap 0.001 STX (u1000) for sBTC
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap swap-stx-for-sbtc u1000)

;; Check your sBTC balance
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap get-sbtc-balance 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608)

;; Check contract STX balance
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap get-contract-stx-balance)
```

---

## 🌐 Method 2: Stacks Explorer (Browser Testing)

**Step 1: Open Contract in Browser**
https://explorer.stacks.co/address/ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608?chain=testnet

**Step 2: Click on "simple-stx-swap" contract**

**Step 3: Click "Call Function"**

**Step 4: Test Functions:**

- Function: `swap-stx-for-sbtc`
- Amount: `1000` (for 0.001 STX)
- Connect your wallet to execute

---

## 💰 Get Testnet STX First

**Before testing, get testnet STX:**

1. Visit: https://explorer.stacks.co/sandbox/faucet?chain=testnet
2. Enter your address: `ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608`
3. Request testnet STX

---

## 🔧 Wallet Setup for Real Testing

**Option A: Hiro Wallet**

1. Install: https://wallet.hiro.so/
2. Switch to "Testnet" in settings
3. Import with mnemonic: `april imitate artefact green various connect plunge sick naive bundle novel garlic burst peace leopard embark novel visit school stairs creek current park mind`
4. Your address should be: `ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608`

**Option B: Leather Wallet**

1. Install: https://leather.io/
2. Switch to testnet
3. Import same mnemonic
4. Test contract interaction

---

## 🎯 Expected Results

**When testing 0.001 STX swap:**

1. **get-swap-rate:** `(ok u100000000)` ✅
2. **swap-stx-for-sbtc u1000:** `(ok u100000000)` ✅
3. **get-sbtc-balance:** `(ok u100000000)` ✅
4. **get-contract-stx-balance:** `(ok u1000)` ✅

**Your wallet STX balance should decrease by 0.001 STX + gas fees!**

---

## 🛠 Troubleshooting

**If console shows "unresolved contract":**

- Make sure you're using `--testnet` flag
- Contract must be fully deployed (wait 1-2 minutes after deployment)
- Check contract exists: https://explorer.stacks.co/address/ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608?chain=testnet

**If "insufficient funds":**

- Get testnet STX from faucet first
- Make sure you have at least 0.001 STX + 0.001 STX for gas

**If wallet not connecting:**

- Switch wallet to testnet mode
- Import correct mnemonic
- Refresh browser page

---

## 🚀 Quick Commands to Copy

**In WSL terminal (in my-swap-project directory):**

```bash
# Start testnet console
clarinet console --testnet

# Then paste these one by one:
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap get-swap-rate)
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap swap-stx-for-sbtc u1000)
(contract-call? 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608.simple-stx-swap get-sbtc-balance 'ST2ZGZXG4030P1RNEAYP2NTP6JYETW4V634A2G608)
```

**Your contract is LIVE and ready for testing!** 🎉
