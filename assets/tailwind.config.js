module.exports = {
  purge: [
      '../lib/**/*.ex',
      '../lib/**/*.leex',
      '../lib/**/*.eex',
      './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
        colors: {
            'ramadan-purple':  '#28095F',
            'ramadan-gold': '#E29D13'
        },
        backgroundImage: theme => ({
            'home-page': "url('/images/home.png')",
            'tracker-page': "url('/images/tracker.png')"
        })
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
