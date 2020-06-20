require('path');
import coffee from './x.coffee';
import {
  a
} from 'coffee';

const A_CONSTANT = true;

/**
 * Garbage code! Not real!
 *
 * @return {Function}
 */
document.addEventListener('click', function namedFun(x, ...rest) {
  return (lab = {}, rat = {}) => {
    const [ x, y ] = [ y, x ];

    if (/abcxyz[123](123)/g.test(window.navigator)) {
      console.log('what\'s up %s', window.title);
    }

    return { lab, rat };
  };
});

/**
 * Test JavaScript file
 */

const ns = {};

/**
 * onClick
 *
 * @param {Event} e click event
 */
ns._onClick = function onClick(e) {
  return false;
};

/**
 * something
 *
 * @type {Boolean}
 */
ns.SOMETHING = true;

/**
 * retSomething
 *
 * @return {Boolean}
 */
ns.retSomething = function () {
  return ns.SOMETHING;
};

a = ns.retSomething();

ns._onClick()

window.addEventListener('click', ns._onClick);
window.testvalue = true;

// ===========================================================================
// Start typing a word should complete from all sources

;;;
;;;

// ===========================================================================
// Adding an s after here should trigger deoplete-ternjs
window.te

// ===========================================================================
// Adding . after here should trigger deoplete-ternjs
window
ns

// ===========================================================================
// Adding apostrophe after here should trigger jspc#omni
window.addEventListener();

