# Looting

### Javascript build 
Javascript under src folder written in Typescript, which should be transpiled to legacy javascript for execution in Browser.
Therefore, following step is needed to transpile the src:

- Make sure [Bun](https://bun.sh/) is installed via `curl -fsSL https://bun.sh/install | bash`.
- Run `bun install` to install dependencies (just like npm install)
- Run `bun build.js` to build executable javascript output (under `/js` folder)

### Development:
- Run `build build.js watch` to watch/rebuild `js` on changes in `src`
- Run `bun x lr-http-server` to serve project in http
