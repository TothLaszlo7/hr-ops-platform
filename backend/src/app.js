const express = require('express');

const app = express();

app.use(express.json());

const employees = [
  { id: 1, name: "Toth Laszlo" },
  { id: 2, name: "Fodor Klaudia" }
];



app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK' });
});

app.get('/employees', (req, res) => {
  res.status(200).json(employees);
});

app.post('/employees', (req, res) => {
  const newEmployee = {
    id: employees.length + 1,
    name: req.body.name
  };

  employees.push(newEmployee);

  res.status(201).json(newEmployee);
});

app.post('/db-init', async (req, res) => {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS employees (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL
      );
    `);

    res.json({ message: 'Employees table created' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Database initialization failed' });
  }
});

module.exports = app;