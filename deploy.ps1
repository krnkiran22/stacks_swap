# Simple Swap Deployment Script
# Run this after installing Clarinet

param(
    [string]$Network = "testnet",
    [switch]$CheckOnly = $false,
    [switch]$TestOnly = $false
)

Write-Host "=== Simple Swap Project Deployment ===" -ForegroundColor Green

# Check if Clarinet is installed
try {
    $clarinetVersion = clarinet --version
    Write-Host "✅ Clarinet found: $clarinetVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Clarinet not found. Please install Clarinet first." -ForegroundColor Red
    Write-Host "Run: winget install hirosystems.clarinet" -ForegroundColor Yellow
    exit 1
}

# Navigate to project directory
$projectPath = "C:\Users\HP\OneDrive\Desktop\stacksbc\my-swap-project"
if (Test-Path $projectPath) {
    Set-Location $projectPath
    Write-Host "✅ Project directory found" -ForegroundColor Green
} else {
    Write-Host "❌ Project directory not found: $projectPath" -ForegroundColor Red
    exit 1
}

# Check contract syntax
Write-Host "`n🔍 Checking contract syntax..." -ForegroundColor Yellow
try {
    clarinet check
    Write-Host "✅ All contracts compile successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Contract compilation failed" -ForegroundColor Red
    exit 1
}

if ($CheckOnly) {
    Write-Host "`n✅ Check complete. Contracts are valid." -ForegroundColor Green
    exit 0
}

# Run tests
Write-Host "`n🧪 Running tests..." -ForegroundColor Yellow
try {
    clarinet test
    Write-Host "✅ All tests passed" -ForegroundColor Green
} catch {
    Write-Host "❌ Tests failed" -ForegroundColor Red
    exit 1
}

if ($TestOnly) {
    Write-Host "`n✅ Tests complete." -ForegroundColor Green
    exit 0
}

# Deploy contracts
if ($Network -eq "testnet") {
    Write-Host "`n🚀 Deploying to testnet..." -ForegroundColor Yellow
    Write-Host "Make sure you have configured your .env file with:" -ForegroundColor Cyan
    Write-Host "  - DEPLOYER_SECRET_KEY" -ForegroundColor Cyan
    Write-Host "  - DEPLOYER_STX_ADDRESS" -ForegroundColor Cyan
    
    $confirm = Read-Host "`nProceed with deployment? (y/N)"
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        try {
            clarinet deploy --testnet
            Write-Host "✅ Deployment to testnet completed" -ForegroundColor Green
        } catch {
            Write-Host "❌ Deployment failed" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Deployment cancelled" -ForegroundColor Yellow
    }
} elseif ($Network -eq "mainnet") {
    Write-Host "`n⚠️  MAINNET DEPLOYMENT" -ForegroundColor Red
    Write-Host "This will deploy to mainnet with real STX!" -ForegroundColor Red
    $confirm = Read-Host "Are you absolutely sure? Type 'DEPLOY' to confirm"
    if ($confirm -eq "DEPLOY") {
        try {
            clarinet deploy --mainnet
            Write-Host "✅ Deployment to mainnet completed" -ForegroundColor Green
        } catch {
            Write-Host "❌ Deployment failed" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Mainnet deployment cancelled" -ForegroundColor Yellow
    }
}

Write-Host "`n🎉 All operations completed successfully!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. Note your deployed contract addresses" -ForegroundColor White
Write-Host "2. Update the frontend configuration" -ForegroundColor White
Write-Host "3. Test the contracts in production" -ForegroundColor White
