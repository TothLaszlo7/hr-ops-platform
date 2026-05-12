const { Pool } = require("pg");
const { getDatabaseSecret } = require("./secrets");

let pool;

async function initDbPool() {
  if (pool) {
    return pool;
  }

  const secret = await getDatabaseSecret();

  pool = new Pool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    user: secret.username,
    password: secret.password,
    ssl: {
      rejectUnauthorized: false,
    },
  });

  return pool;
}

async function query(text, params) {
  const dbPool = await initDbPool();
  return dbPool.query(text, params);
}

module.exports = {
  query,
};