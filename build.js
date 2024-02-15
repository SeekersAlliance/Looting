const { readdirSync } = require('fs');
const chokidar = require('chokidar');

const args = process.argv;
const mode = args[2] || 'none';
const files = readdirSync('./src');
const entries = files
  .filter(i => i.endsWith('.ts'))
  .map(i => `./src/${i}`);

await Bun.build({ entrypoints: entries, outdir: './js' });

if (mode === 'watch') {
  chokidar.watch('./src').on('change', async (uri) => {
    if (uri.split('/').length <= 2) {
      await Bun.build({ entrypoints: [uri], outdir: './js' });
    }
  });
}

