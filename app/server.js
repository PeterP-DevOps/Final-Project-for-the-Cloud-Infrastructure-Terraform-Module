const express = require('express');
const mysql = require('mysql2/promise');

const app = express();
const port = process.env.PORT || 3000;

async function queryDb() {
  const conn = await mysql.createConnection({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT || 3306,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  });

  const [rows] = await conn.query('SELECT NOW() AS now_time');
  await conn.end();
  return rows[0].now_time;
}

app.get('/', async (req, res) => {
  try {
    const dbTime = await queryDb();
    res.send(`OK. DB time: ${dbTime}`);
  } catch (err) {
    res.status(500).send(`DB error: ${err.message}`);
  }
});

app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});