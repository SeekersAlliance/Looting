import ABI from './abi.json';

export const web3 = new Web3(window.ethereum);

export const contractAddress = '0x0288Ca4FE6E5645464aA1C95F4E4EaAAc0F005C8';
export const contract = new web3.eth.Contract(ABI, contractAddress);
