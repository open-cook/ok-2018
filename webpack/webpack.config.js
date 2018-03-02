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

module.exports = {
  watch: watch(globalConfig),

  entry: {
    open_cook_application: `${rootPath}/app/assets/javascripts/_open_cook/application.js`,
    open_cook_application_styles: `${rootPath}/app/assets/stylesheets/_open_cook/application.js`
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

      '@opencook-vendorScripts': `${appJSPath}/_open_cook/vendors`,

      '@logJS-scripts': `${xGemsPath}/log_js/app/assets/javascripts`,

      '@notifications-scripts': `${xGemsPath}/notifications/app/assets/javascripts`,
      '@notifications-styles': `${xGemsPath}/notifications/app/assets/stylesheets`,

      '@the_comments-scripts': `${xGemsPath}/the_comments/app/assets/javascripts`,
      '@the_comments-styles': `${xGemsPath}/the_comments/app/assets/stylesheets`,

      '@protozaur-styles': `${xGemsPath}/protozaur/app/assets/stylesheets/ptz`,
      '@protozaur_theme-styles': `${xGemsPath}/protozaur_theme/app/assets/stylesheets/protozaur_theme`,

      '@user_room-styles': `${xGemsPath}/user_room/app/assets/stylesheets/user_room`,
      '@table_holy_grail-styles': `${xGemsPath}/table_holy_grail_layout/app/assets/stylesheets`
    }
  },

  module: {
    rules: [
      {
        test: /\.js\.coffee$/,
        loader: 'coffee-loader'
      },

      {
        test: /\.css$/,
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
