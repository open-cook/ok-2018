const fs = require('fs')
const path = require('path')
const webpack = require('webpack')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const AssetsPlugin = require('assets-webpack-plugin')

const NODE_ENV = process.env.NODE_ENV

const globalConfig = {
  CSS_SOURCE_MAP: false,
  rootPath: path.join(__dirname, '../../'),

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
    'rails_shop_styles': `@rails_shop-styles/rails_shop/application`,

    'bootstrap_default_styles': '@app-styles/bootstrap_default/application',
    'bootstrap_default_scripts': '@app-scripts/bootstrap_default/application'
  },

  output: {
    publicPath: '/bundles/',
    path: `${rootPath}/public/bundles`,
    filename: "[name].[chunkhash].js",
    chunkFilename: "[chunkhash].js"
  },

  resolve : {
    extensions: [".js", ".js.coffee", ".json", ".css", ".less", ".sass", ".scss", ".css.sass", ".css.scss"],

    alias: {
      '@app-components':  `${rootPath}/app/assets/components/`,
      '@app-vendors':     `${rootPath}/app/assets/vendors`,

      '@app-scripts': appJSPath,
      '@app-styles': appCSSPath,

      '@jquery': "@app-vendors/jquery",
      '@bootstrap': "@app-vendors/bootstrap",
      '@jquery-ujs': "@app-vendors/jquery-ujs",
      '@font-awesome': "@app-vendors/font-awesome",
      '@toastr': "@app-vendors/toastr",

      '@open_cook-vendor_scripts': `${appJSPath}/_open_cook/vendors`
    }
  },

  module: {
    rules: [
      {
        test: new RegExp('.js$'),
        use: babelLoader()
      },

      {
        test: new RegExp('.js.coffee$'),
        use: coffeeLoader()
      },

      {
        test: new RegExp('.less$'),
        use: lessLoader()
      },

      {
        test: new RegExp('.css$'),
        use: cssLoader()
      },

      {
        test: new RegExp('(.sass)|(.scss)|(.css.sass)|(.css.scss)$'),
        use: sassLoader()
      },

      {
        test: new RegExp('.(woff|woff2|ttf|eot)$'),
        use: [fileLoader()]
      },

      {
        test: new RegExp('.(png|gif|jpg|jpe?g)$'),
        use: imageLoader()
      },

      {
        test: new RegExp('.svg$'),
        use: svgLoader()
      }
    ]
  },

  externals: {
    $: "window.JQuery",
    "jQuery": "window.JQuery",
    "jquery": "window.JQuery",
    "jquery.ui.widget": "window.JQuery.widget"
  },

  plugins: [
    null,
    new AssetsPlugin(),
    new webpack.HashedModuleIdsPlugin(),

    new webpack.ProvidePlugin({
      $: "@jquery",
      jQuery: "@jquery",
      "window.jQuery": "@jquery"
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
    // new webpack.optimize.CommonsChunkPlugin({
    //   async: 'jquery',
    //   children: true,
    //   minChunks: (m) => /node_modules\/(?:jquery)/.test(m.context)
    // }),

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

// LOADERS

function styleLoader () {
  return {
    loader: 'style-loader',
    options: { sourceMap: CSS_SOURCE_MAP }
  }
}

function postCCSLoader () {
  return {
    loader: 'postcss-loader',
    options: { sourceMap: CSS_SOURCE_MAP }
  }
}

function defaultCSSLoader () {
  return {
    loader: 'css-loader',
    options: {
      importLoaders: 1,
      sourceMap: CSS_SOURCE_MAP
    }
  }
}

function vendorCSSLoader () {
  return {
    loader: "css-loader",
    options: {
      importLoaders: 1,
      sourceMap: CSS_SOURCE_MAP
    }
  }
}

function moduleCSSLoader () {
  return {
    loader: "css-loader",
    options: {
      importLoaders: 1,
      sourceMap: CSS_SOURCE_MAP,

      modules: true,
      localIdentName: '[hash:base64:5]'
    }
  }
}

function cssLoader () {
  return [
    styleLoader(),
    defaultCSSLoader(),
    postCCSLoader()
  ]
}

function lessLoader () {
  return [
    styleLoader(),
    vendorCSSLoader(),
    postCCSLoader()
  ]
}

function sassLoader () {
  return [
    styleLoader(),
    defaultCSSLoader(),
    { loader: "sass-loader" }
  ]
}

function coffeeLoader () {
  return [
    { loader: 'imports-loader?this=>window' },
    { loader: 'coffee-loader' }
  ]
}

function babelLoader () {
  { loader: 'babel-loader' }
}

function fileLoader () {
  return {
    loader: 'file-loader',
    options: { name: 'assets/[name]_[hash:6].[ext]' }
  }
}

function imageLoader () {
  return [
    fileLoader(),

    {
      loader: 'image-webpack-loader',
      options: {
        mozjpeg: {
          progressive: true,
          quality: 65
        },
        optipng: {
          enabled: true,
        },
        pngquant: {
          quality: '65-90',
          speed: 4
        },
        gifsicle: {
          interlaced: false,
        }
      }
    }
  ]
}

function svgLoader () {
  return [
    fileLoader(),

    {
      loader: 'svgo-loader',

      options: {
        plugins: [
          { removeTitle: true },
          { convertColors: {shorthex: true} },
          { convertPathData: true }
        ]
      }
    }
  ]
}

module.exports = WebPackConfig
