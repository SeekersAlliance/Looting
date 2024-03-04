# Looting
---
## Smart Contracts
### ERC-2266: Lockable ERC-1155 Extension
#### Introduction
This smart contract introduces a new type of ERC-1155 token: the lockable ERC-1155 token. The main features are:
- Token owners can call `approveLock` to approve other addresses to lock their ERC-2266 tokens. Only addresses with approved lock can call lock-related functions.
- The struct `lockStatus` stores the locker address, lock number, and expired time for each token ID. Other lockers cannot lock the token until the expiration time has been reached or the tokens have been unlocked.
- Locked tokens cannot be transferred until expired or unlocked.

#### Functions
`function setApprovalForLock(address locker, bool approved) external;`: Approves the locker to lock the token.
`function lock(address account, uint256 id, uint256 locknum, uint256 expired) external;`: Locks the token id of an account.
`function unlock(address account, uint256 id, uint256 unlocknum) external;`: Unlocks the token id of an account.
`function unlockAndTransfer(address from, address to, uint256 id, uint256 unlockNum, uint256 transferNum, bytes memory data) external;`: Unlocks the token id of `from` address and transfers the tokens to `to` address.

#### Conclusion
This EIP is a powerful tool that can be used to add functionality to ERC-1155 tokens. It is flexible and can be used in a variety of use cases.

### Looting: Implementation of ERC-2266
#### Overview
This smart contract implements a looting game using ERC-2266: Looting. The key features are: 
- Manager role: this role can `lock` to lock all players' tokens without `approveLock`. This implementation increases the playability since players do not have to prepare gas token to approve the project before playing the game.
- When a battle starts, the manager locks the challenged player's tokens to prevent them from transferring tokens before the battle ends, which can prevent cheating.
- When a player wins a battle, the manager call `unlockAndTransfer` to unlock and transfer the defeated player's tokens to the winner.
#### Flow Chart
![alt text](./FlowChart.jpg?raw=true "Looting Flow Chart") 

---
## Frontend
### Javascript build 
Javascript under src folder written in Typescript, which should be transpiled to legacy javascript for execution in Browser.
Therefore, following step is needed to transpile the src:

- Make sure [Bun](https://bun.sh/) is installed via `curl -fsSL https://bun.sh/install | bash`.
- Run `bun install` to install dependencies (just like npm install)
- Configuration e.g NFT Manager account, private key, contract address would be find/editable under `src/utils/config.ts`
- Run `bun build.js` to build executable javascript output (under `/js` folder)

### Development:
- Run `bun build.js watch` (or `yarn dev`) to watch/rebuild `js` on changes in `src`
- Run `bun x lr-http-server` to serve project in http

### Configuration:
As described above, configuration located under src/utils/config.ts, in there you'll found:

- `contractAddress`: put deployed Smart Contract address (from `contracts/src/Looting.sol`)
- `nftManagerKey`: private-key (in string formnat) of the NFT Manager account (as we simulate Game Server right inside the front-end for now, which could be relocate/move into dedicate server/api)
- `nftManagerAddress`: wallet address of the NFT Manager account
- `challengedAddress`: wallet address of the Challenged account (for now, will be temporarily the `nftManagerAddress`)
