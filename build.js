const fs = require('fs');
const path = require('path');

const ROOT = __dirname;
const DIST = path.join(ROOT, 'dist');

function copyRecursive(src, dest) {
  if (!fs.existsSync(src)) return;
  const stat = fs.statSync(src);
  if (stat.isDirectory()) {
    fs.mkdirSync(dest, { recursive: true });
    for (const entry of fs.readdirSync(src)) {
      copyRecursive(path.join(src, entry), path.join(dest, entry));
    }
  } else {
    fs.mkdirSync(path.dirname(dest), { recursive: true });
    fs.copyFileSync(src, dest);
  }
}

console.log('[INFO] Building LENSA static bundle into dist/...');
fs.mkdirSync(DIST, { recursive: true });

const itemsToCopy = [
  'index.html',
  'app.html',
  'manifest.json',
  'sw.js',
  'assets',
  'redesign'
];

for (const item of itemsToCopy) {
  copyRecursive(path.join(ROOT, item), path.join(DIST, item));
}

console.log('[INFO] LENSA build completed successfully!');

