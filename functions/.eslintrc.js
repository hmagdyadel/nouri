module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "google",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["tsconfig.json"],
    sourceType: "module",
  },
  plugins: ["@typescript-eslint"],
  rules: {
    "quotes": ["error", "single"],
    "indent": ["error", 2],
    "object-curly-spacing": ["error", "always"],
    "max-len": ["off"],
  },
  ignorePatterns: [
    "/lib/**/*",
  ],
};
