require("dotenv").config();
const express = require("express");
const app = express();

const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get("/", (req, res) => {
  res.send("¡Servidor Express desplegado correctamente en AWS ECS Fargate!");
});

app.get("/saludo/:nombre", (req, res) => {
  const nombre = req.params.nombre;
  res.json({ mensaje: `Hola ${nombre}, mi app funciona perfectamente.` });
});

app.listen(PORT, () => {
  console.log(`Servidor ejecutándose en el puerto ${PORT}`);
});
