const { execSync } = require('child_process');

module.exports = () => {
  const pkgs = JSON.parse(execSync(
    [ 'brew' ].concat([ 'info', '--installed', '--json=v1' ]).join(' ')
  ).toString());

  process.stdout.write('# brew packages\n\n');
  process.stdout.write(`Generated on ${(new Date().toISOString())}\n\n`);
  process.stdout.write('| Package | Description |\n');
  process.stdout.write('| ------- | ----------- |\n');
  pkgs.forEach(({ name, desc, homepage }) => {
    process.stdout.write(`| [${name}](${homepage}) | \`${desc}\` |\n`);
  });

};
