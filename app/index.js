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
  res.json({ mensaje: `Hola ${nombre}, mi app funciona bien.` });
});

app.get("/status", (req, res) => {
  res.json({
    status: "ok",
    entorno: "desarrollo",
    uptime: `${process.uptime().toFixed(2)} segundos`,
    fecha: new Date().toISOString(),
  });
});

// --- Endpoint de información del sistema ---
app.get("/info", (req, res) => {
  res.json({
    plataforma: os.platform(),
    arquitectura: os.arch(),
    hostname: os.hostname(),
    memoria_libre: `${(os.freemem() / 1024 / 1024).toFixed(2)} MB`,
    memoria_total: `${(os.totalmem() / 1024 / 1024).toFixed(2)} MB`,
    cpus: os.cpus().length,
    hora_local: new Date().toLocaleString(),
  });
});

app.listen(PORT, () => {
  console.log(`Servidor ejecutándose en el puerto ${PORT}`);
});
