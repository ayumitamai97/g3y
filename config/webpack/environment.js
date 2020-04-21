const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const dotenv = require('dotenv')
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
environment.plugins.prepend('Environment', new webpack.EnvironmentPlugin({
  HOST: process.env.HOST,
}))

module.exports = environment
