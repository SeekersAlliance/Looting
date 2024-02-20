import { contract, web3 } from "./utils/contract";
import config from './utils/config';

const unlockNft = async () => {
  const challengerAddress = localStorage.getItem('CHALLENGER-ACCOUNT');
  const nftId = parseInt(localStorage.getItem('selectedNftId') as string);
  const encodeABI = await contract.methods.unlockAndTransfer(config.nftManagerAddress, challengerAddress, nftId, 1, 1, []).encodeABI();
  const transaction = {
    from: config.nftManagerAddress,
    to: contract._address,
    gasPrice: web3.utils.toWei('20', 'gwei'),
    gasLimit: 200000,
    data: encodeABI,
  };

  const signedTx = await web3.eth.accounts.signTransaction(transaction, config.nftManagerKey);
  web3.eth.sendSignedTransaction(signedTx.rawTransaction).on('receipt', console.log);
}

unlockNft();
