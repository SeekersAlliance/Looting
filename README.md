# Looting
---
## Smart Contracts
### Extension: LockableERC1155 
#### Introduction
This smart contract introduces a new type of ERC-1155 token: the lockable ERC-1155 token. The main features are:
- Token owners can call `approveLock` to approve other addresses to lock their ERC-1155 tokens. Only addresses with approved lock can call lock-related functions.
- The struct `lockStatus` stores the locker address, lock number, and expired time for each token ID. Other lockers cannot lock the token until the expiration time has been reached or the tokens have been unlocked.
- Locked tokens cannot be transferred until expired or unlocked.

#### Functions
`setApprovalForLock(address locker, bool approved) external;`: Approves the `locker` address with the permission to lock tokens.  
`lock(address account, uint256 id, uint256 locknum, uint256 expired) external;`: Locks the token `id` in a specified wallet `address` until the `expired` time.  
`unlock(address account, uint256 id, uint256 unlocknum) external;`: Unlocks the token `id` in a specified wallet `address`.  
`unlockAndTransfer(address from, address to, uint256 id, uint256 unlockNum, uint256 transferNum, bytes memory data) external;`: Unlocks amount `unlocknum` of the token `id` in the `from` address and transfers amount `transferNum` to the `to` address.

#### Conclusion
This extension is a powerful tool that can be used to add functionality to ERC-1155 tokens. It is flexible and can be used in a variety of use cases.

### Looting: Implementation of LockableERC1155
#### Overview
This smart contract implements a looting game using LockableERC1155. The key features are: 
- Manager role: This role can `lock` all players' tokens without the permission of the `isApprovalForLock`. This implementation increases the playability since players do not have to prepare gas token to approve the project before playing the game.
- When a battle starts, the manager locks the challenged player's tokens to prevent them from transferring or selling the tokens before the battle ends, which can prevent cheating.
- When a player wins a battle, the manager call `unlockAndTransfer` to unlock and transfer the defeated player's tokens to the winner.
#### Flow Chart
![Flow Chart](./flowchart.jpg?raw=true) 

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
