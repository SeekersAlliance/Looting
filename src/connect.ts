import { injectHandler } from './utils/helper';

const connectWallet = async () => {
	const [account] = await window.ethereum.request({ method: 'eth_requestAccounts' });

	if (!account) {
		console.log('unable to get account');
		return;
	}

	localStorage.setItem('CHALLENGER-ACCOUNT', account);
	location.href = './view-wallet.html';
};

injectHandler('index-connect-button', connectWallet)
