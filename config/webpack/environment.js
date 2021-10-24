const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const path = require('path')

module.exports = environment

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  ApplicationController: ['application_controller', 'default']
}))

environment.config.merge({
  resolve: {
    alias: {
      helpers: path.resolve('app/javascript/helpers'),
      lib: path.resolve('app/javascript/lib'),
    }
  }
})
