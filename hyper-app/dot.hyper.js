module.exports = {
  config: {
    updateChannel: 'canary',

    // default font size in pixels for all tabs
    fontSize: 12,

    // font family with optional fallbacks
    fontFamily: '"Fira Mono for Powerline", "FuraMonoForPowerline Nerd Font", Menlo, "DejaVu Sans Mono", "Lucida Console", monospace',

    lineHeight: 1.4,

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

    // custom padding
    padding: '12px 14px',

    // ansi color overrides. see http://bit.ly/29k1iU2 for
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

    scrollback: 9999,

    showWindowControls: false,

    /**
     * hyper-pane
     */
    paneNavigation: {
      debug: false,
      hotkeys: {
        navigation: {
          up: 'meta+alt+up',
          down: 'meta+alt+down',
          left: 'meta+alt+left',
          right: 'meta+alt+right'
        },
        maximize: 'meta+shift+enter'
      },
      showIndicators: false, // Show pane number
      indicatorStyle: { // Added to indicator <div>
        position: 'absolute',
        top: 0,
        left: 0,
        fontSize: '10px'
      },
      focusOnMouseHover: false,
      inactivePaneOpacity: 1
    }
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hypersolar`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [
    'hyperterm-base16-tomorrow-night',

    //// add focus-gained/lost events
    'hyperterm-focus-reporting',

    'hyper-search',

    // status bar
    'hyper-statusline',

    // Pane shortcuts
    // Doesn't seem to work
    'hyper-pane',
    //'hyper-keymap',

  ],

};
