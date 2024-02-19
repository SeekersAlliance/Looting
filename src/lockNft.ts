import { contract } from "./utils/contract";
import { injectHandler } from "./utils/helper";

const lockNft = async () => {
  const challengerAcc = localStorage.getItem('CHALLENGER-ACCOUNT');

  const result = await contract.methods.lock(challengerAcc, 4, 1, 2000).call();
  console.log(result);
}

injectHandler('char4', lockNft);