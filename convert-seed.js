import { generateWallet, getStxAddress } from '@stacks/wallet-sdk';
import pkg from '@stacks/network';
const { StacksTestnet } = pkg;

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
    
    // Get testnet address
    const network = new StacksTestnet();
    const address = getStxAddress({ account, network });
    
    console.log('Address:', address);
    console.log('Private Key:', account.stxPrivateKey);
    
  } catch (error) {
    console.error('Error converting seed phrase:', error);
  }
}

convertSeedToPrivateKey();
