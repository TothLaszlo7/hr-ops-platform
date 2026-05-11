const express = require("express");
const pool = require("./db");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get("/health", (req, res) => {
  res.json({ status: "OK" });
});

app.get("/db-test", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");

    res.json({
      message: "Database connection works!",
      time: result.rows[0],
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: "Database connection failed",
    });
  }
});

app.post("/db-init", async (req, res) => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS employees (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL
      );
    `);

    await pool.query(`
      INSERT INTO employees (name)
      SELECT 'Toth Laszlo'
      WHERE NOT EXISTS (
        SELECT 1 FROM employees WHERE name = 'Toth Laszlo'
      );
    `);

    await pool.query(`
      INSERT INTO employees (name)
      SELECT 'Fodor Klaudia'
      WHERE NOT EXISTS (
        SELECT 1 FROM employees WHERE name = 'Fodor Klaudia'
      );
    `);

    res.json({ message: "Employees table initialized" });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: "Database initialization failed",
    });
  }
});

app.get("/employees", async (req, res) => {
  try {
    const result = await pool.query("SELECT id, name FROM employees ORDER BY id");

    res.json(result.rows);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: "Failed to fetch employees",
    });
  }
});

app.post("/employees", async (req, res) => {
  try {
    const { name } = req.body;

    if (!name) {
      return res.status(400).json({
        error: "Name is required",
      });
    }

    const result = await pool.query(
      "INSERT INTO employees (name) VALUES ($1) RETURNING id, name",
      [name]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: "Failed to create employee",
    });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});