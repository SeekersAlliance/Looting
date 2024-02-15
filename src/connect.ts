import { injectHandler } from './utils/helper';
import { contract } from './utils/contract';

const connectWallet = () => {
  console.log('connect wallet!', contract);
};

injectHandler('index-connect-button', connectWallet)
