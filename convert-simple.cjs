// Convert seed phrase to private key using Stacks libraries
const { generateWallet } = require('@stacks/wallet-sdk');

async function convertSeedToPrivateKey() {
  const mnemonic = "april imitate artefact green various connect plunge sick naive bundle novel garlic burst peace leopard embark novel visit school stairs creek current park mind";
  
  try {
    // Generate wallet from mnemonic
    const wallet = await generateWallet({
      secretKey: mnemonic,
      password: ''
    });
    
    // Get the first account (index 0)
    const account = wallet.accounts[0];
    
    console.log('✅ Conversion successful!');
    console.log('Address:', account.stxAddress);
    console.log('Private Key:', account.stxPrivateKey);
    console.log('\n📋 Update your .env file with:');
    console.log(`DEPLOYER_SECRET_KEY=${account.stxPrivateKey}`);
    
  } catch (error) {
    console.error('❌ Error converting seed phrase:', error.message);
  }
}

convertSeedToPrivateKey();
