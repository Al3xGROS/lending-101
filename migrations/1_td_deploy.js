const Str = require('@supercharge/strings')
// const BigNumber = require('bignumber.js');

var TDErc20 = artifacts.require("ERC20TD.sol");
var evaluator = artifacts.require("Evaluator.sol");
var exerciceSolution = artifacts.require("ExerciceSolution.sol");


module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await setStaticContracts(deployer, network, accounts);
        await deployRecap(deployer, network, accounts); 
		await deployExercice(deployer, network, accounts);
    });
};

async function setStaticContracts(deployer, network, accounts) {
	TDToken = await TDErc20.at("0x27Dc7374e1C5BF954Daf6Be846598Af76A33F2a2")
	Evaluator = await evaluator.at("0xaeaD98593a19074375cCf3ec22E111ce48C02c7E")
}

async function deployRecap(deployer, network, accounts) {
	console.log("TDToken " + TDToken.address)
	console.log("Evaluator " + Evaluator.address)
}

async function deployExercice(deployer, network, accounts) {
	mySolution = await exerciceSolution.new("0x7b5C526B7F8dfdff278b4a3e045083FBA4028790")
	console.log("ContractAddress " + mySolution.address)
    console.log("MyAccount " + accounts[0])
	await Evaluator.submitExercice(mySolution.address)
	console.log("Exercice submitted!")
	myBalance = await TDToken.balanceOf(accounts[0])
	console.log("BalanceTokens " + myBalance/1000000000000000000)
}

