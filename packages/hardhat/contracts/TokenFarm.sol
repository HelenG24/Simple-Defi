// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./DappToken.sol";
import "./LPToken.sol";

/**
 * @title Proportional Token Farm
 * @notice Una granja de staking donde las recompensas se distribuyen proporcionalmente al total stakeado.
 */
contract TokenFarm {
    //
    // Variables de estado
    //
    string public name = "Proportional Token Farm";
    address public owner;
    DappToken public dappToken;
    LPToken public lpToken;

    uint256 public constant REWARD_PER_BLOCK = 1e18; // Recompensa por bloque
    uint256 public totalStakingBalance;

    address[] public stakers;
    mapping(address => uint256) public stakingBalance;
    mapping(address => uint256) public checkpoints;
    mapping(address => uint256) public pendingRewards;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    //
    // Eventos
    //
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);
    event RewardsDistributed();

    //
    // Constructor
    //
    constructor(DappToken _dappToken, LPToken _lpToken) {
        dappToken = _dappToken;
        lpToken = _lpToken;
        owner = msg.sender;
    }

    /**
     * @notice Deposita tokens LP para staking.
     * @param _amount Cantidad de tokens LP a depositar.
     */
    function deposit(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");

        // Transferir LP tokens al contrato
        lpToken.transferFrom(msg.sender, address(this), _amount);

        // Calcular y distribuir recompensas antes de actualizar balance
        distributeRewards(msg.sender);

        // Actualizar balances
        stakingBalance[msg.sender] += _amount;
        totalStakingBalance += _amount;

        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
            hasStaked[msg.sender] = true;
        }

        isStaking[msg.sender] = true;

        if (checkpoints[msg.sender] == 0) {
            checkpoints[msg.sender] = block.number;
        }

        emit Deposit(msg.sender, _amount);
    }

    /**
     * @notice Retira todos los tokens LP en staking.
     */
    function withdraw() external {
        require(isStaking[msg.sender], "User is not staking");

        uint256 balance = stakingBalance[msg.sender];
        require(balance > 0, "Staking balance is 0");

        // Calcular y distribuir recompensas antes de retirar
        distributeRewards(msg.sender);

        // Actualizar balances
        stakingBalance[msg.sender] = 0;
        totalStakingBalance -= balance;
        isStaking[msg.sender] = false;

        // Transferir tokens de vuelta
        lpToken.transfer(msg.sender, balance);

        emit Withdraw(msg.sender, balance);
    }

    /**
     * @notice Reclama recompensas pendientes.
     */
    function claimRewards() external {
        uint256 pendingAmount = pendingRewards[msg.sender];
        require(pendingAmount > 0, "No pending rewards");

        pendingRewards[msg.sender] = 0;

        dappToken.mint(msg.sender, pendingAmount);

        emit RewardsClaimed(msg.sender, pendingAmount);
    }

    /**
     * @notice Distribuye recompensas a todos los usuarios en staking.
     */
    function distributeRewardsAll() external {
        require(msg.sender == owner, "Only owner can distribute");

        for (uint256 i = 0; i < stakers.length; i++) {
            address user = stakers[i];
            if (isStaking[user]) {
                distributeRewards(user);
            }
        }

        emit RewardsDistributed();
    }

    /**
     * @notice Calcula y distribuye las recompensas proporcionalmente al staking total.
     */
    function distributeRewards(address beneficiary) private {
        uint256 lastCheckpoint = checkpoints[beneficiary];
        uint256 currentBlock = block.number;

        if (currentBlock <= lastCheckpoint || totalStakingBalance == 0) {
            return;
        }

        uint256 blocksPassed = currentBlock - lastCheckpoint;
        uint256 userBalance = stakingBalance[beneficiary];

        if (userBalance == 0) {
            checkpoints[beneficiary] = currentBlock;
            return;
        }

        // Calcular participación proporcional
        uint256 reward = (REWARD_PER_BLOCK * blocksPassed * userBalance) / totalStakingBalance;

        pendingRewards[beneficiary] += reward;
        checkpoints[beneficiary] = currentBlock;
    }
}
