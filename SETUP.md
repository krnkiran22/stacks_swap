# Clarinet Installation and Setup Guide

## Install Clarinet

### Option 1: Using Winget (Recommended for Windows)

```powershell
winget install hirosystems.clarinet
```

### Option 2: Using Scoop

```powershell
scoop bucket add clarinet https://github.com/hirosystems/scoop-clarinet.git
scoop install clarinet
```

### Option 3: Manual Installation

1. Download from: https://github.com/hirosystems/clarinet/releases
2. Extract to a folder (e.g., C:\tools\clarinet\)
3. Add to PATH environment variable

## Verify Installation

```powershell
clarinet --version
```

## Project Setup Commands

### 1. Initialize Project (Already Done)

```bash
clarinet new my-swap-project
cd my-swap-project
```

### 2. Check Contract Syntax

```bash
clarinet check
```

### 3. Run Tests

```bash
clarinet test
```

### 4. Start Development Console

```bash
clarinet console
```

### 5. Deploy to Testnet

```bash
clarinet deploy --testnet
```

## Quick Verification Script

After installing Clarinet, run these commands to verify everything works:

```powershell
# Navigate to project
cd C:\Users\HP\OneDrive\Desktop\stacksbc\my-swap-project

# Check if contracts compile
clarinet check

# Run tests
clarinet test

# Start console for manual testing
clarinet console
```

## Manual Testing in Console

Once in `clarinet console`, you can test the contracts:

```javascript
// Check deployer balance of test token A
(contract-call? .test-token-a get-balance tx-sender)

// Transfer tokens to another address for testing
(contract-call? .test-token-a transfer u1000000 tx-sender 'ST1J4G6RR643BCG8G8SR6M2D9Z9KXT2NJDRK3FBTK none)

// Create a trading pair
(contract-call? .simple-swap create-pair .test-token-a .test-token-b u100000000 u200000000)

// Get swap quote
(contract-call? .simple-swap get-swap-quote u10000000 .test-token-a .test-token-b)

// Perform a swap
(contract-call? .simple-swap swap-exact-tokens-for-tokens u5000000 u9000000 .test-token-a .test-token-b)
```

## Troubleshooting

### Contract Not Found Error

- Make sure all contracts are in the `contracts/` folder
- Check `Clarinet.toml` for correct contract paths
- Verify contract dependencies

### Permission Errors

- Run PowerShell as Administrator
- Check Windows execution policy: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

### Path Issues

- Restart terminal after Clarinet installation
- Manually add Clarinet to PATH if needed
- Use full path to clarinet.exe if necessary

## Next Steps After Installation

1. **Install Clarinet** using one of the methods above
2. **Verify installation** with `clarinet --version`
3. **Check contracts** with `clarinet check`
4. **Run tests** with `clarinet test`
5. **Deploy to testnet** when ready
