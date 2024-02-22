import { injectHandler } from './utils/helper';

const opBNBChainTarget = {
  chainId: '0x15EB',
  chainName: 'opBNB Testnet',
  nativeCurrency: {
    symbol: 'tBNB',
    decimals: 18,
  },
  rpcUrls: ['https://opbnb-testnet-rpc.bnbchain.org'],
  blockExplorerUrls: ['https://opbnb-testnet.bscscan.com'],
}

const ensureNetworkTarget = async (targetConfig: any) => {
  await window.ethereum?.request({
    method: 'wallet_addEthereumChain',
    params: [targetConfig],
  });

  await window.ethereum?.request({
    method: 'wallet_switchEthereumChain',
    params: [
      {
        chainId: targetConfig.chainId,
      }
    ]
  });
};

const hydrateAccount = (account: string) => {
  localStorage.setItem('CHALLENGER-ACCOUNT', account);
};

const navigateNext = () => {
  window.location.href = './view-wallet.html';
};

const redirectConnectedPlayer = async () => {
  try {
    console.log('Seekers version 0.0.13')
    const [account] = await window.ethereum.request({ method: 'eth_accounts' });
    if (account) { /* <- if already connected before */
      await ensureNetworkTarget(opBNBChainTarget);
      hydrateAccount(account);
      navigateNext();
    }
  } catch (err) {
    console.log('Unable to retrieve account', err);
  }
};

const connectWallet = async () => {
  try {
    const [account] = await window.ethereum?.request({ method: 'eth_requestAccounts' });
    await ensureNetworkTarget(opBNBChainTarget);
    if (account) {
      hydrateAccount(account);
      navigateNext();
    }
  } catch (err) {
    console.log('Unable to connect', err);
  }
};

injectHandler('index-connect-button', connectWallet);
redirectConnectedPlayer();
