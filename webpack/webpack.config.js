const fs = require('fs')
const path = require('path')
const webpack = require('webpack')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const AssetsPlugin = require('assets-webpack-plugin')

const NODE_ENV = process.env.NODE_ENV

const globalConfig = {
  CSS_SOURCE_MAP: false,
  rootPath: path.join(__dirname, '../'),

  isDev: NODE_ENV === 'development',
  isProd: NODE_ENV === 'production'
}

const CSS_SOURCE_MAP = globalConfig.CSS_SOURCE_MAP

const rootPath = globalConfig.rootPath
const xGemsPath = `${rootPath}/X_GEMS`

const appJSPath = `${rootPath}/app/assets/javascripts`
const appCSSPath = `${rootPath}/app/assets/stylesheets`

let WebPackConfig = {
  watch: watch(globalConfig),

  entry: {
    open_cook_application: `${rootPath}/app/assets/javascripts/_open_cook/application`,
    open_cook_application_styles: `${rootPath}/app/assets/stylesheets/_open_cook/application`,

    'user_room_layout': `@user_room-scripts/user_room/layout/application`,
    'user_room_layout_styles': `@user_room-styles/user_room/layout/application`,

    'rails_shop': `@rails_shop-scripts/rails_shop/application`,
    'rails_shop_styles': `@rails_shop-styles/rails_shop/application`
  },

  output: {
    publicPath: '/bundles/',
    path: `${rootPath}/public/bundles`,
    filename: "[name].[chunkhash].js",
    chunkFilename: "[chunkhash].js"
  },

  resolve : {
    extensions: [".css", ".js", ".js.coffee", ".json", ".sass", ".scss", ".css.sass", ".css.scss"],

    alias: {
      '@components':  `${rootPath}/assets/components/`,
      '@vendors':     `${rootPath}/assets/vendors`,
      '@jquery':      "@vendors/JQuery",

      '@appJS': appJSPath,
      '@appCSS': appCSSPath,

      '@opencook-vendorScripts': `${appJSPath}/_open_cook/vendors`
    }
  },

  module: {
    rules: [
      {
        test: /.js$/,
        loader: 'babel-loader'
      },

      {
        test: /.js.coffee$/,
        loader: 'coffee-loader'
      },

      {
        test: /.css$/,
        use: [
          {
            loader: 'style-loader',
            options: { sourceMap: CSS_SOURCE_MAP }
          },

          {
            loader: 'css-loader',
            options: {
              modules: true,
              importLoaders: 1,
              sourceMap: CSS_SOURCE_MAP,
              localIdentName: '[hash:base64:5]'
            }
          },

          {
            loader: 'postcss-loader',
            options: { sourceMap: CSS_SOURCE_MAP }
          }
        ]
      },

      {
        test: new RegExp('(.sass)|(.scss)|(.css.sass)|(.css.scss)$'),
        use: [{
          loader: "style-loader"
        }, {
          loader: "css-loader"
        }, {
          loader: "sass-loader"
        }]
      }
    ]
  },

  plugins: [
    null,
    new AssetsPlugin(),
    new webpack.HashedModuleIdsPlugin(),

    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery'
    }),

    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: nodeEnv(globalConfig)
      }
    }),

    new webpack.optimize.CommonsChunkPlugin({
      name: "manifest",
      minChunks: Infinity
    }),

    // https://github.com/webpack/webpack/issues/4638
    new webpack.optimize.CommonsChunkPlugin({
      async: 'jquery',
      children: true,
      minChunks: (m) => /node_modules\/(?:jquery)/.test(m.context)
    }),

    addUglifyPlugin(globalConfig),
    addBundleAnalyzerPlugin(globalConfig)
  ].filter(Boolean)
}

WebPackConfig.resolve.alias = addGemWebPackBridge(WebPackConfig)

// HELPERS

function watch (gOptions) {
  return gOptions.isDev ? true : false
}

function addUglifyPlugin (gOptions) {
  if (gOptions.isDev) return null
  return new UglifyJsPlugin()
}

function addBundleAnalyzerPlugin (gOptions) {
  if (!gOptions.isDev) return null

  const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin
  return new BundleAnalyzerPlugin({openAnalyzer: false})
}

function nodeEnv (gOptions) {
  if (gOptions.isDev) return JSON.stringify('development')
  return JSON.stringify('production')
}

function addGemWebPackBridge (WebPackConfig) {
  let alias = WebPackConfig.resolve.alias
  const bridgeFile = `${rootPath}/gems-assets-webpack-bridge.json`
  var bridgeAlias = JSON.parse(fs.readFileSync(bridgeFile, 'utf8'))
  return Object.assign(alias, bridgeAlias)
}

module.exports = WebPackConfig
