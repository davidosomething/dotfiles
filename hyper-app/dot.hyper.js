module.exports = {
  config: {
    // default font size in pixels for all tabs
    fontSize: 12,

    // font family with optional fallbacks
    fontFamily: '"Fira Mono for Powerline", "FuraMonoForPowerline Nerd Font", Menlo, "DejaVu Sans Mono", "Lucida Console", monospace',

    cursorBlink: true,

    // terminal cursor background color (hex)
    cursorColor: '#F81CE5',

    // color of the text
    foregroundColor: '#fff',

    // terminal background color
    backgroundColor: '#222',

    // border color (window, tabs)
    borderColor: '#000',

    // custom css to embed in the main window
    css: '',

    // custom padding (css format, i.e.: `top right bottom left`)
    termCSS: '',

    // custom padding
    padding: '12px 14px',

    // some color overrides. see http://bit.ly/29k1iU2 for
    // the full list
    colors: [
      '#000000',
      '#ff0000',
      '#33ff00',
      '#ffff00',
      '#0066ff',
      '#cc00ff',
      '#00ffff',
      '#d0d0d0',
      '#808080',
      '#ff0000',
      '#33ff00',
      '#ffff00',
      '#0066ff',
      '#cc00ff',
      '#00ffff',
      '#ffffff'
    ],
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hypersolar`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [
    //// Alt buffer scrolling broken in Hyper 2.0
    //'hyperterm-alternatescroll',

    //// blinking cursor
    //'hyperterm-blink',

    'hyperterm-base16-tomorrow-night',

    //'hyperterm-resboned',

    //// fancy tabs
    //'hyperterm-mactabs',

    //// draggable tabs
    //'hyperterm-tabs',

    // bold active tab
    'hyperterm-bold-tab',

    //// tab icons
    //'hyperterm-tab-icons',

    //// add focus-gained/lost events
    'hyperterm-focus-reporting',

    //// respect xterm titles
    'hyperterm-title',

    //// status bar
    //'hyperline',
    'hyper-statusline',

    // clickable links in same window... buggy
    'hyperlinks',

    // Pane shortcuts
    // Doesn't seem to work
    //'hyper-pane',
    //'hyper-keymap',

    // quit on close last pane
    'hyper-quit',
  ],

  // in development, you can create a directory under
  // `~/.hyperterm_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: []
};
