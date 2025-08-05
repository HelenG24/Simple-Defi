# 🌾 TokenFarm - Proportional Staking Rewards in Solidity

Una granja de staking descentralizada que distribuye recompensas de forma proporcional al total stakeado, utilizando dos contratos ERC20: `LPToken` y `DappToken`.

---

## 📌 Descripción

Los usuarios pueden depositar tokens LP (Liquidity Provider Token) y ganar recompensas automáticas en `DappToken`, distribuidas proporcionalmente al número de bloques transcurridos y la cantidad de tokens en staking.

---

## 🔧 Contratos

- `DappToken.sol`: Token ERC20 que se acuña como recompensa.
- `LPToken.sol`: Token ERC20 que se utiliza para hacer staking.
- `TokenFarm.sol`: Contrato principal que gestiona depósitos, recompensas y retiros.

---

## 🚀 Funcionalidades principales

- 🥩 `deposit(uint256 _amount)`: Deposita tokens LP para hacer staking.
- 🌿 `withdraw()`: Retira los tokens LP.
- 🎁 `claimRewards()`: Reclama los DappTokens acumulados como recompensa.
- ⚖️ `distributeRewardsAll()`: Reparte recompensas a todos los usuarios stakeando.
- 📊 Recompensas proporcionales según:  
  `recompensa = REWARD_PER_BLOCK * bloques * participación_proporcional`

---

## 📜 Parámetros importantes

- `REWARD_PER_BLOCK`: `1e18` (1 DAPP por bloque).
- `totalStakingBalance`: Suma total de todos los tokens LP stakeados.
- `checkpoints`: Último bloque en el que se calcularon recompensas por usuario.

---

## Licencia

MIT