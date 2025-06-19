module.exports = ({ env }) => ({
  app: {
    keys: env.array('APP_KEYS', ['yourKey1', 'yourKey2']),
  },
});
