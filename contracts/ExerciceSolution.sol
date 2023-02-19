pragma solidity ^0.6.0;
import "./IExerciceSolution.sol";
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IFlashLoanSimpleReceiver} from "@aave/core-v3/contracts/flashloan/interfaces/IFlashLoanSimpleReceiver.sol";


contract ExerciceSolution is IExerciceSolution
{
    IPool private aavePool;
    
    constructor(address poolAddress) public {
        aavePool = IPool(poolAddress);
    }

	function depositSomeTokens() override external {
        uint256 amount = 100000000000000000000;
        address daiAdress = 0xBa8DCeD3512925e52FE67b1b5329187589072A55;

        IERC20 token = IERC20(daiAdress);

        // Approve Dai for AAVE
        token.approve(address(aavePool), amount);

        // Deposit the asset into the Aave protocol
        aavePool.supply(daiAdress, amount, address(this), 0);
    }

	function withdrawSomeTokens() override external {
        uint256 amount = 10000000000000000000;
        address USDCAddress = 0xBa8DCeD3512925e52FE67b1b5329187589072A55;

        // Borrow the asset
        aavePool.withdraw(USDCAddress, amount, address(this));
    }

	function borrowSomeTokens() override external {
        uint256 amount = 1000000;
        address USDCAddress = 0x65aFADD39029741B3b8f0756952C74678c9cEC93;

        // Borrow the asset
        aavePool.borrow(USDCAddress, amount, 2, 0, address(this));
    }

	function repaySomeTokens() override external {
        uint256 amount = 10000;
        address USDCAddress = 0x65aFADD39029741B3b8f0756952C74678c9cEC93;

        IERC20 token = IERC20(USDCAddress);

        // Approve USDC for AAVE
        token.approve(address(aavePool), amount);

        // Borrow the asset
        aavePool.repay(USDCAddress, amount, 2, address(this));
    }

	function doAFlashLoan() override external {
        address USDCAddress = 0x65aFADD39029741B3b8f0756952C74678c9cEC93;
        uint256 amount = 1000000 * 1000000;

        aavePool.flashLoanSimple(address(this), USDCAddress, amount, "", 0); 
    }

	function repayFlashLoan() override external {

    }

    function getFundsBack(uint256 amount)external{
        address USDCAddress = 0x65aFADD39029741B3b8f0756952C74678c9cEC93;
        IERC20 token = IERC20(USDCAddress);

        token.transfer(0x2B1a884Dc7a8f0cc17939928895D9D7cb9146074, amount);
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external returns (bool) {

        //we have borrowed some funds
        uint256 amountOwed = amount + premium;
        address USDCAddress = 0x65aFADD39029741B3b8f0756952C74678c9cEC93;
        IERC20 token = IERC20(USDCAddress);
        token.approve(address(aavePool), amountOwed);

        return true;
    }
}