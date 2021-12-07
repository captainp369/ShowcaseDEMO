const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

const buildPath = path.resolve(__dirname,'build1');
fs.removeSync(buildPath);

const campaignPath = path.resolve(__dirname,'contracts','Campaign.sol')
const campaignFactoryPath = path.resolve(__dirname,'contracts','CampaignFactory.sol')

const source = fs.readFileSync(campaignPath,'utf8');
const source2 = fs.readFileSync(campaignFactoryPath,'utf8');
//const output = solc.compile(source,1).contracts;

let complierInput = {
    language: 'Solidity',
    sources:
    {
        'Campaign.sol': 
        {
            content: source
        },
        'CampaignFactory.sol': 
        {
            content: source2
        }
    },
    settings:
    {
        optimizer:
        {
            enabled: true
        },
        outputSelection:
        {
            '*':{
                '*':['*']
            }
        }
    }
};
console.log('compiling contract');
// let output = JSON.parse(solc.compile(JSON.stringify(complierInput)));

fs.ensureDirSync(buildPath);

// console.log(output.contracts.Campaign);
// console.log('----------')
// console.log(output.contracts.CampaignFactory);

// for (let contract in output) {
//     fs.outputJSONSync(
//         path.resolve(buildPath,contract+'.json'),
//         output[contract]
//     );
// }

module.exports = JSON.parse(solc.compile(JSON.stringify(complierInput))).contracts[
    'Campaign.sol'
  ].Campaign;
module.exports = JSON.parse(solc.compile(JSON.stringify(complierInput))).contracts[
    'CampaignFactory.sol'
  ].CampaignFactory;