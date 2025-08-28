// Simple seed phrase to private key converter
const crypto = require('crypto');
const { mnemonicToSeed } = require('bip39');
const { HDKey } = require('hdkey');

async function convertSeedToPrivateKey() {
  const mnemonic = "april imitate artefact green various connect plunge sick naive bundle novel garlic burst peace leopard embark novel visit school stairs creek current park mind";
  
  try {
    // Convert mnemonic to seed
    const seed = await mnemonicToSeed(mnemonic);
    
    // Derive HDKey from seed
    const hdkey = HDKey.fromMasterSeed(seed);
    
    // Stacks derivation path: m/44'/5757'/0'/0/0
    const derivedKey = hdkey.derive("m/44'/5757'/0'/0/0");
    
    // Get private key
    const privateKey = derivedKey.privateKey.toString('hex');
    
    console.log('Private Key:', privateKey);
    console.log('\nUpdate your .env file with:');
    console.log(`DEPLOYER_SECRET_KEY=${privateKey}`);
    
  } catch (error) {
    console.error('Error converting seed phrase:', error);
  }
}

convertSeedToPrivateKey();
