const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const dotenv = require('dotenv')
const GoogleFontsPlugin = require('google-fonts-plugin')
const { VueLoaderPlugin } = require('vue-loader')
const typescript = require('./loaders/typescript')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.loaders.prepend('typescript', typescript)

const dotenvFiles = [
  `.env.${process.env.NODE_ENV}.local`,
  '.env.local',
  `.env.${process.env.NODE_ENV}`,
  '.env',
]

dotenvFiles.forEach((dotenvFile) => {
  dotenv.config({ path: dotenvFile, silent: true })
})

// https://webpack.js.org/plugins/environment-plugin/#usage-with-default-values
environment.plugins.prepend('Environment',
  new webpack.EnvironmentPlugin({
    HOST: process.env.HOST,
    JP_KEYCODE: 13,
    S3_IDENTITY_POOL_ID: process.env.G3Y_S3_IDENTITY_POOL_ID,
    AWS_REGION: process.env.G3Y_AWS_REGION,
    AWS_BUCKET: process.env.G3Y_AWS_BUCKET,
  })
)

environment.plugins.prepend(
  'Provide',
  new GoogleFontsPlugin({
    fonts: [
      {
        family: 'Noto Sans JP',
        variants: [
          '400',
          '700',
        ],
        "subsets": [
          "japanese"
        ]
      },
      {
        family: 'Lato',
        variants: [
          '400',
          '700',
        ],
      },
    ],
    filename: 'fonts.scss',
    path: 'src/fonts',
  })
)

module.exports = environment
