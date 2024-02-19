# Looting

### Javascript build 
Javascript under src folder written in Typescript, which should be transpiled to legacy javascript for execution in Browser.
Therefore, following step is needed to transpile the src:

- Make sure [Bun](https://bun.sh/) is installed via `curl -fsSL https://bun.sh/install | bash`.
- Run `bun install` to install dependencies (just like npm install)
- Configuration e.g NFT Manager account, private key, contract address would be find/editable under `src/utils/config.ts`
- Run `bun build.js` to build executable javascript output (under `/js` folder)

### Development:
- Run `build build.js watch` to watch/rebuild `js` on changes in `src`
- Run `bun x lr-http-server` to serve project in http

### Configuration:
As described above, configuration located under src/utils/config.ts, in there you'll found:

- `contractAddress`: put deployed Smart Contract address (from `contracts/src/Looting.sol`)
- `nftManagerKey`: private-key (in string formnat) of the NFT Manager account (as we simulate Game Server right inside the front-end for now, which could be relocate/move into dedicate server/api)
- `nftManagerAddress`: wallet address of the NFT Manager account
- `challengedAddress`: wallet address of the Challenged account (for now, will be temporarily the `nftManagerAddress`)
