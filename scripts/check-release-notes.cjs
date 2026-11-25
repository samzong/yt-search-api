const fs = require('node:fs');

const version = process.env.RELEASE_TAG.slice(1);
const changelog = fs.readFileSync('CHANGELOG.md', 'utf8');
const entries = changelog.split(/^## /m).slice(1);
const matches = entries.filter((entry) => entry.startsWith(`[${version}] (`));
if (matches.length !== 1) {
  throw new Error(`CHANGELOG.md must contain exactly one entry for ${version}`);
}
const body = matches[0].split('\n').slice(1).join('\n').trim();
const generated = fs.readFileSync('release-notes.md', 'utf8').trim();
const generatedBody = generated.split('\n').slice(1).join('\n').trim();
if (!/^\* \S/m.test(body) || body !== generatedBody) {
  throw new Error(`CHANGELOG.md does not match git-cliff notes for ${version}`);
}
