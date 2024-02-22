import { injectHandler } from './utils/helper';

const targetChainConfig = {
  chainId: '0x15EB',
  chainName: 'opBNB Testnet',
  nativeCurrency: {
    symbol: 'tBNB',
    decimals: 18,
  },
  rpcUrls: ['https://opbnb-testnet-rpc.bnbchain.org'],
  blockExplorerUrls: ['https://opbnb-testnet.bscscan.com'],
}

const redirectConnectedPlayer = async () => {
  const [account] = await window.ethereum.request({ method: 'eth_accounts' });

  await window.ethereum?.request({
    method: 'wallet_addEthereumChain',
    params: [targetChainConfig],
  });

  await window.ethereum?.request({
    method: 'wallet_switchEthereumChain',
    params: [
      {
        chainId: targetChainConfig.chainId,
      }
    ]
  }).then(() => {
    if (account) {
      localStorage.setItem('CHALLENGER-ACCOUNT', account);
      window.location.href = './view-wallet.html';
    }
  });
};

const connectWallet = async () => {
  try {
    const [account] = await window.ethereum?.request({ method: 'eth_requestAccounts' });
    localStorage.setItem('CHALLENGER-ACCOUNT', account);

    await window.ethereum?.request({
      method: 'wallet_addEthereumChain',
      params: [targetChainConfig],
    });

    await window.ethereum?.request({
      method: 'wallet_switchEthereumChain',
      params: [
        {
          chainId: targetChainConfig.chainId,
        },
      ],
    }).then(() => {
      if (account) {
        window.location.href = './view-wallet.html';
      }
    });
  } catch (err) {
    console.log('Unable to retrieve account', err);
  }
};

injectHandler('index-connect-button', connectWallet);
redirectConnectedPlayer();
