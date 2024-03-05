# Looting
---
## Smart Contracts
### LockableERC-1155 (extends ERC-1155)
#### Introduction
This smart contract introduces a new type of ERC-1155 token: the LockableERC-1155 token. Its main features are:
- Token owners can call `approveLock` to approve other addresses to lock their ERC-1155 tokens. Only addresses with approved lock can call lock-related functions.
- The struct `lockStatus` stores the locker address, lock number, and expiration time for each token ID. Other lockers cannot lock the token until the expiration time is reached or the token has been unlocked.
- Locked tokens cannot be transferred until after expiration or explicitly unlocked.

#### Functions
`setApprovalForLock(address locker, bool approved) external;`: Approves the `locker` address with the permission to lock tokens.  
`lock(address account, uint256 id, uint256 locknum, uint256 expired) external;`: Locks the token `id` in a specified wallet `address` until the `expired` time.  
`unlock(address account, uint256 id, uint256 unlocknum) external;`: Unlocks the token `id` in a specified wallet `address`.  
`unlockAndTransfer(address from, address to, uint256 id, uint256 unlockNum, uint256 transferNum, bytes memory data) external;`: Unlocks amount `unlocknum` of the token `id` in the `from` address and transfers amount `transferNum` to the `to` address.

#### Conclusion
This extension is a powerful tool that can be used to add functionality to ERC-1155 tokens. It is flexible and can be used in a variety of use cases.

### Looting: Implementation of LockableERC1155
#### Overview
This smart contract implements a "looting" game using LockableERC1155. Its key features are: 
- Manager role: This role can `lock` all players' tokens minted by this contract without the permission of the `isApprovalForLock`. This implementation increases the general user experience since players do not have to constantly expend gas to approve for locking before playing each game.
- When a battle starts, the manager locks the challenged player's targeted token(s) to prevent them from transferring or selling the token(s) before the battle ends, preventing players from cheating.
- When a player wins a battle, the manager calls `unlockAndTransfer` to unlock and transfer the defeated player's token(s) to the winner.
#### User Flow
![Flow Chart](./flowchart.jpg?raw=true) 

---
## Frontend
### Javascript build 
Javascript under src folder is written in Typescript, which should be transpiled to legacy javascript for execution in Browser.
Follow the steps below to transpile the src:

- Make sure [Bun](https://bun.sh/) is installed via `curl -fsSL https://bun.sh/install | bash`.
- Run `bun install` to install dependencies (just like npm install)
- Configurations (e.g NFT Manager account, private key, contract address) can be set in `src/utils/config.ts`
- Run `bun build.js` to build the executable javascript output (under `/js` folder)

### Development:
- Run `bun build.js watch` (or `yarn dev`) to watch/rebuild `js` on changes in `src`
- Run `bun x lr-http-server` to serve project in http

### Configuration:
As described above, configurations are located in src/utils/config.ts, where you will find:

- `contractAddress`: deployed looting smart contract address (from `contracts/src/Looting.sol`)
- `nftManagerKey`: private-key (in string format) of the NFT Manager's account (We simulate the Game Server inside the frontend for now, it should be relocate/move into dedicate server/api in a production setup)
- `nftManagerAddress`: wallet address of the NFT Manager account
- `challengedAddress`: wallet address of the Challenged account (we have set it to `nftManagerAddress` for the convenience of this demo)
