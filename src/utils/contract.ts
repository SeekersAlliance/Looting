import ABI from './abi.json';

const web3 = new Web3(window.ethereum);

export const contractAddress = '0x340513CFa8183599be3b8dEb8DB02a30E4013E6E';
export const contract = new web3.eth.Contract(ABI, contractAddress);
