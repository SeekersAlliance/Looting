import { contract, web3 } from "./utils/contract";
import config from './utils/config';

const unlockNft = async () => {
	const challengerAddress = localStorage.getItem('CHALLENGER-ACCOUNT');
	const encodeABI = await contract.methods.unlockAndTransfer(config.nftManagerAddress, challengerAddress, 4, 1, 1, []).encodeABI();
	const tx = {
		from: config.nftManagerAddress,
		to: contract._address,
		gasPrice: web3.utils.toWei('20', 'gwei'),
		gasLimit: 200000,
		data: encodeABI,
	};

	const signedTx = await web3.eth.accounts.signTransaction(tx, config.nftManagerKey);
	web3.eth.sendSignedTransaction(signedTx.rawTransaction).on('receipt', console.log);
}

unlockNft();
