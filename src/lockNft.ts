import { contract, web3 } from "./utils/contract";
import { injectHandler } from "./utils/helper";
import config from './utils/config';

const lockNft = async (nftId: number) => {
  const blockTimestamp = await web3.eth.getBlock("latest");
  const expired = blockTimestamp.timestamp + BigInt(600);

  const encodeABI = await contract.methods.lock(config.nftManagerAddress, nftId, 1, expired).encodeABI();
  const tx = {
    from: config.nftManagerAddress,
    to: contract._address,
    gasPrice: web3.utils.toWei('20', 'gwei'),
    gasLimit: 200000,
    data: encodeABI,
  };

  const signedTx = await web3.eth.accounts.signTransaction(tx, config.nftManagerKey);
  web3.eth.sendSignedTransaction(signedTx.rawTransaction).on('receipt', () => {
    localStorage.setItem('selectedNftId', String(nftId));
    location.href = './game/index.html';
  });
}

injectHandler('char1', () => lockNft(1));
injectHandler('char2', () => lockNft(2));
injectHandler('char3', () => lockNft(3));
injectHandler('char4', () => lockNft(4));
injectHandler('char5', () => lockNft(5));
