import { injectHandler } from './utils/helper';

const connectWallet = async () => {
  const chainConfig = {
    chainId: '0x15EB',
    chainName: 'opBNB Testnet',
    nativeCurrency: {
      symbol: 'tBNB',
      decimals: 18,
    },
    rpcUrls: ['https://opbnb-testnet-rpc.bnbchain.org'],
    blockExplorerUrls: ['https://opbnb-testnet.bscscan.com'],
  }

  try {
    console.log('start');
    const accounts = await window.ethereum
      ?.request({
        method: 'wallet_requestPermissions',
        params: [
          {
            eth_accounts: {},
          }
        ]
      });
    const account = accounts?.[0]?.caveats?.[0].value[0];
    localStorage.setItem('CHALLENGER-ACCOUNT', account);

    await window.ethereum?.request({
          method: 'wallet_addEthereumChain',
          params: [chainConfig],
        });

    await window.ethereum?.request({
          method: 'wallet_switchEthereumChain',
          params: [
            {
              chainId: chainConfig.chainId,
            },
          ],
        }).then(() => {
          window.location.href = './view-wallet.html';
        });
  } catch (err) {
    console.log('Unable to retrieve account', err);
  }
};

injectHandler('index-connect-button', connectWallet)
