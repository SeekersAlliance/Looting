import { contract, web3 } from "./utils/contract";

const unlockNft = async () => {
  console.log('run unlockNFt');
  const nftManager = localStorage.getItem('CHALLENGER-ACCOUNT');

  const encodeABI = await contract.methods.unlockAndTransfer(nftManager, '0xb491C545983244B0146a9Ab55433897135be01Cb', 4, 1, 1, []).encodeABI();
  const tx = {
    from: nftManager,
    to: contract._address,
    gasPrice: web3.utils.toWei('20', 'gwei'),
    gasLimit: 200000,
    data: encodeABI,
  };

  const signedTx = await web3.eth.accounts.signTransaction(tx, 'dd86d28357f97aa127ecfea9b675c247ea02f877da7b26d99821e332edb4c5d4');
  web3.eth.sendSignedTransaction(signedTx.rawTransaction).on('receipt', console.log);
}

unlockNft();