import ABI from './abi.json';
import config from './config';

export const web3 = new Web3(window.ethereum);
export const contract = new web3.eth.Contract(ABI, config.contractAddress);
