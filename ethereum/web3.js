import Web3 from 'web3';

let web3;

if (typeof window !== 'undefined' && typeof window.web3 !== 'undefined') { 
    // we are in the browser and metamask is running
    //web3 = new Web3(window.web3.currentProvider);
    window.ethereum.request({ method: "eth_requestAccounts" });
    web3 = new Web3(window.ethereum);
} else { 
    // we are on the server *or* user is not running metamask
    const provider = new Web3.providers.HttpProvider(
        'https://rinkeby.infura.io/v3/d93bb8242d994d608440f4636e3757ac'
    );
    web3 = new Web3(provider);
}

export default web3;

