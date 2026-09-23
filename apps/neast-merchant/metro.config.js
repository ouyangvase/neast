// Metro config for the neast-merchant Expo app inside the pnpm monorepo.
// - watchFolders / nodeModulesPaths make the workspace root resolvable so the
//   source-consumed `@neast/*` packages and hoisted node_modules work.
// - react-native-svg-transformer turns `*.svg` imports into components
//   (the Flutter apps' tab/menu icons are SVG).
const path = require('path');
const { getDefaultConfig } = require('expo/metro-config');

const projectRoot = __dirname;
const workspaceRoot = path.resolve(projectRoot, '../..');

const config = getDefaultConfig(projectRoot);

config.watchFolders = [workspaceRoot];
config.resolver.nodeModulesPaths = [
  path.resolve(projectRoot, 'node_modules'),
  path.resolve(workspaceRoot, 'node_modules'),
];

config.transformer = {
  ...config.transformer,
  babelTransformerPath: require.resolve('react-native-svg-transformer'),
};
config.resolver.assetExts = config.resolver.assetExts.filter((ext) => ext !== 'svg');
config.resolver.sourceExts = [...config.resolver.sourceExts, 'svg'];

module.exports = config;
