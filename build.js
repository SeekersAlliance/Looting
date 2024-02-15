const { readdirSync } = require('fs');

const files = readdirSync('./src');
const entries = files
  .filter(i => i.endsWith('.ts'))
  .map(i => `./src/${i}`);

await Bun.build({
  entrypoints: entries,
  outdir: './js',
});

console.log('Javascript bundled successful under js folder.')

