'use strict';

const { getPackagesSync } = require('@manypkg/get-packages');
const browserslist = require('browserslist');
const { resolveToEsbuildTarget } = require('esbuild-plugin-browserslist');
const ESLintPlugin = require('eslint-webpack-plugin');
const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');
const fs = require('fs');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const path = require('path');
const { DefinePlugin, EnvironmentPlugin } = require('webpack');
const WebpackAssetsManifest = require('webpack-assets-manifest');
const { merge } = require('webpack-merge');
const WebpackBar = require('webpackbar');
const common = require('./webpack.common.js');
const getEnvConfig = require('./env-util.js');

const esbuildTargets = resolveToEsbuildTarget(browserslist(), { printUnknownTargets: false });
const esbuildOptions = {
  target: esbuildTargets,
  format: undefined,
  jsx: 'automatic',
};

function getDecoupledPlugins() {
  const { packages } = getPackagesSync(process.cwd());
  return packages.filter((pkg) => pkg.dir.includes('plugins/datasource')).map((pkg) => `${pkg.dir}/**`);
}

function scenesModule() {
  const scenesPath = path.resolve('./node_modules/@grafana/scenes');
  try {
    const status = fs.lstatSync(scenesPath);
    if (status.isSymbolicLink()) {
      console.log(`scenes is linked to local scenes repo`);
      return path.resolve(scenesPath + '/src');
    }
  } catch (error) {
    console.error(`Error checking scenes path: ${error.message}`);
  }
  return scenesPath;
}

const envConfig = getEnvConfig();

module.exports = (env = {}) => {
  return merge(common, {
    mode: 'development',
    devtool: 'source-map',

    entry: {
      app: './public/app/index.ts',
      dark: './public/sass/grafana.dark.scss',
      light: './public/sass/grafana.light.scss',
    },

    watchOptions: {
      ignored: ['/node_modules/', ...getDecoupledPlugins()],
    },

    resolve: {
      alias: {
        react: path.resolve('./node_modules/react'),
        'react-router-dom': path.resolve('./node_modules/react-router-dom'),
        '@grafana/scenes': scenesModule(),
      },
    },

    module: {
      rules: [
        {
          test: /\.tsx?$/,
          use: {
            loader: 'esbuild-loader',
            options: esbuildOptions,
          },
        },
        require('./sass.rule.js')({
          sourceMap: false,
          preserveUrl: true,
        }),
      ],
    },

    output: {
      pathinfo: false,
      publicPath: '/',
      filename: '[name].bundle.js',
      path: path.resolve(__dirname, '../../public/build'),
    },

    optimization: {
      moduleIds: 'named',
      runtimeChunk: true,
      removeAvailableModules: false,
      removeEmptyChunks: false,
      splitChunks: false,
    },

    cache: {
      type: 'filesystem',
      name: 'grafana-default-development',
      buildDependencies: {
        config: [__filename],
      },
    },

    devServer: {
      port: 3000,
      hot: true,
      open: true,
      historyApiFallback: true,
      static: {
        directory: path.resolve(__dirname, '../../public'),
        publicPath: '/',
      },
      compress: true,
    },

    plugins: [
      new ForkTsCheckerWebpackPlugin({
        async: true,
        typescript: {
          mode: 'write-references',
          memoryLimit: 5096,
          diagnosticOptions: {
            semantic: true,
            syntactic: true,
          },
        },
      }),
      new ESLintPlugin({
        cache: true,
        lintDirtyModulesOnly: true,
        extensions: ['.ts', '.tsx'],
        configType: 'flat',
      }),
      new MiniCssExtractPlugin({
        filename: 'grafana.[name].[contenthash].css',
      }),
      new DefinePlugin({
        'process.env': {
          NODE_ENV: JSON.stringify('development'),
        },
      }),
      new WebpackAssetsManifest({
        entrypoints: true,
        integrity: true,
        integrityHashes: ['sha384', 'sha512'],
        publicPath: true,
      }),
      new WebpackBar({
        color: '#eb7b18',
        name: 'Grafana',
      }),
      new EnvironmentPlugin(envConfig),
    ],

    stats: 'minimal',
  });
};
