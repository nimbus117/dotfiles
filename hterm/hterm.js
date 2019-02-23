// https://gist.github.com/j-bennet/84932a9da4f9a8e09fbba6bf10547fdb
// Run in the JavaScript console of the hterm browser window

// Clear all existing settings
term_.prefs_.storage.clear()

var colorPaletteOverides = [
  "#073642",  /*  0: black    */
  "#dc322f",  /*  1: red      */
  "#859900",  /*  2: green    */
  "#b58900",  /*  3: yellow   */
  "#268bd2",  /*  4: blue     */
  "#d33682",  /*  5: magenta  */
  "#2aa198",  /*  6: cyan     */
  "#eee8d5",  /*  7: white    */
  "#002b36",  /*  8: brblack  */
  "#cb4b16",  /*  9: brred    */
  "#586e75",  /* 10: brgreen  */
  "#657b83",  /* 11: bryellow */
  "#839496",  /* 12: brblue   */
  "#6c71c4",  /* 13: brmagenta*/
  "#93a1a1",  /* 14: brcyan   */
  "#fdf6e3",  /* 15: brwhite  */
];

var htermProfiles = [
  // Solarized Dark {base03:base0}
  {
    'name': 'solarized-dark',
    'prefs': {
      'background-color': colorPaletteOverides[8],
      'foreground-color': colorPaletteOverides[12],
      //'cursor-color': colorPaletteOverides[11],
      'cursor-color': 'rgba(131, 148, 150, 0.5)',
    },
  },
  // Solarized Light {base3:base00}
  {
    'name': 'solarized-light',
    'prefs': {
      'background-color': colorPaletteOverides[15],
      'foreground-color': colorPaletteOverides[11],
      //'cursor-color': colorPaletteOverides[8],
      'cursor-color': 'rgba(101, 123, 131, 0.5)',
    },
  },
];

function setPrefFonts() {
  term_.prefs_.set('font-size', 16);
  term_.prefs_.set('font-smoothing', 'subpixel-antialiased');

  //term_.prefs_.set('font-family', '"Source Code Pro", monospace');
  //term_.prefs_.set('font-family', '"DejaVu Sans Mono"');

  //term_.prefs_.set('user-css', 'http://fonts.googleapis.com/css?family=Source+Code+Pro');
  //term_.prefs_.set('font-family', '"Source Code Pro", monospace');

  term_.prefs_.set('user-css', 'http://fonts.googleapis.com/css?family=Droid+Sans+Mono');
  term_.prefs_.set('font-family', '"DejaVu Sans Mono", "Droid Sans Mono", monospace');

  //term_.prefs_.set('user-css', 'http://fonts.googleapis.com/css?family=Roboto+Mono');
  //term_.prefs_.set('font-family', '"Roboto Mono", monospace');
}

function setProfilePrefs(profile_name, prefs) {
  term_.setProfile(profile_name);
  for (var name in prefs) {
    term_.prefs_.set(name, prefs[name]);
  }
  //term_.prefs_.set('environment', {"TERM": "xterm-color"});
  // Use ANSI 16 colour terminal
  term_.prefs_.set('environment', {"TERM": "xterm-16color"});

  term_.prefs_.set('color-palette-overrides', colorPaletteOverides);

  term_.prefs_.set('enable-bold', true);
  term_.prefs_.set('enable-bold-as-bright', false);

  setPrefFonts();
}

htermProfiles.forEach(function(profile) {
  setProfilePrefs(profile.name, profile.prefs);
  if (profile.name == 'solarized-dark') {
    setProfilePrefs('default', profile.prefs);
  }
});

term_.setProfile('solarized-dark');
// term_.setProfile('solarized-light');

// disable the audible bell 
term_.prefs_.set('audible-bell-sound', '')
