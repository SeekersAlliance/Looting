import ABI from './abi.json';

const web3 = new Web3(window.ethereum);

export const contractAddress = '0xd9145CCE52D386f254917e481eB44e9943F39138';
export const contract = new web3.eth.Contract(ABI, contractAddress);
