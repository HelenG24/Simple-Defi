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

## Dirección Contratos Verificados
- `DappToken.sol` : 0x837e06427596d85765179F014DefE20f4F2A7f9D
- `LPToken.sol` : 0xCb0016DB25F4e6B4B68A3bDD5C1531B0c5162419
- `TokenFarm.sol` : 0xe713d73850261d22713F995C1cf021274A224b82

---

## Licencia

MIT
