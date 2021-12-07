import web3 from "./web3";
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
    JSON.parse(CampaignFactory.interface),//abi
    '0x14F0bBb88a6DF36313933FF01cFE757C7763Fc8d'//address
);

export default instance;

