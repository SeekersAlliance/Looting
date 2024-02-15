import { injectHandler } from './utils/helper';

const connectWallet = () => {
  console.log('connect wallet!');
};

injectHandler('index-connect-button', connectWallet)
