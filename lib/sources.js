'use strict';

// Recursive array flatten
const flatten = (arr) => arr.reduce(
  (a, b) => a.concat(Array.isArray(b) ? flatten(b) : b), []
);

// parse DKO_SOURCE into array like [ 'a', '{', 'b', '}', 'c' ]
const sources = flatten(
  process.env['DKO_SOURCE']
    .split('->')
    .slice(1)
    .map((s) => s.split(' '))
).filter((n) => n.length);

const LEVELS = {
  '{': 1,
  '}': -1,
};

module.exports = () => {
  // output and store bracket balance
  // exits non-zero if brackets not balanced
  process.exit(sources.reduce((indent, node) => {
    if (LEVELS[node]) {
      indent += LEVELS[node];
    }
    else {
      process.stdout.write(`  ${'  '.repeat(indent)}- ${node}\n`);
    }
    return indent;
  }, 0));
};
