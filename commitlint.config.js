module.exports = {
  extends: ['@commitlint/config-conventional'],
  ignores: [
    // Don't lint deploy messages
    (message) => /^Bumped to version \d+ \[skip ci\]$/.test(message),
  ],
};
