import { contract, web3 } from "./utils/contract";
import { injectHandler } from "./utils/helper";

const lockNft = async () => {
  const nftManager = localStorage.getItem('CHALLENGER-ACCOUNT');
  const blockTimestamp = await web3.eth.getBlock("latest");
  const expired = blockTimestamp.timestamp + BigInt(600);

  const encodeABI = await contract.methods.lock(nftManager, 4, 1, expired).encodeABI();
  const tx = {
    from: nftManager,
    to: contract._address,
    gasPrice: web3.utils.toWei('20', 'gwei'),
    gasLimit: 200000,
    data: encodeABI,
  };

  const signedTx = await web3.eth.accounts.signTransaction(tx, 'dd86d28357f97aa127ecfea9b675c247ea02f877da7b26d99821e332edb4c5d4');
  web3.eth.sendSignedTransaction(signedTx.rawTransaction).on('receipt', () => {
    const domain = window.location.origin;
    window.location.href = `${domain}/game/index.html`;
  });
}

injectHandler('char4', lockNft);