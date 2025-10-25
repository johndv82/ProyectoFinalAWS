# Usa una imagen base de Node.js
FROM node:18-alpine

# Crea un directorio para tu app
WORKDIR /app

# Copia los archivos del proyecto
COPY package*.json ./

# Instala dependencias
RUN npm install --production

# Copia el resto del código fuente
COPY . .

# Expone el puerto en el que corre tu app (3000)
EXPOSE 3000

# Comando para iniciar la app
CMD ["npm", "start"]
