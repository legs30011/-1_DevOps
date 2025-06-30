# Live Debugging de Node.js con Docker y VS Code

Esta guía recopila todos los pasos y comandos que utilizamos para poner a punto la depuración en vivo de un servidor Node.js dentro de un contenedor Docker, y cómo conectarlo desde Visual Studio Code.

---

## 🔧 Prerrequisitos

- Docker Desktop (o Colima / Docker Machine) en ejecución  
- Visual Studio Code  
- Extensión **Node.js** para depuración  
- (Opcional) Extensión **Debugger for Chrome**  

---

## 📁 Estructura del proyecto

node-debug-demo/
├── app.js
├── index.html
├── package.json
├── Dockerfile
├── docker-compose.yml
└── .vscode/
└── launch.json

yaml
Copiar
Editar

---

## ✏️ Ajustes en archivos clave

### 1. Dockerfile

```diff
-FROM node:5.11.0-slim
+FROM node:18-slim

 WORKDIR /code

 RUN npm install -g nodemon

 COPY package.json /code/package.json
 RUN npm install && npm ls

 COPY . /code

 CMD ["npm", "start"]
• Actualizamos a Node 18 LTS.
• Eliminamos RUN mv /code/node_modules /node_modules.

2. docker-compose.yml
yaml
Copiar
Editar
services:
  web:
    build: .
-   command: nodemon --debug=5858
+   command: nodemon --inspect=0.0.0.0:5858 --legacy-watch
    volumes:
      - .:/code
    ports:
      - "8000:8000"
      - "5858:5858"
• Quitamos la línea obsoleta version:.
• Usamos --inspect en lugar de --debug.
• --legacy-watch para detectar cambios dentro del contenedor.

3. app.js
diff
Copiar
Editar
- server.listen(80, () => {
-   console.log('HTTP server listening on port 80');
- });
+ server.listen(8000, () => {
+   console.log('HTTP server listening on port 8000');
+ });
Nos aseguramos de que el servidor escuche en el puerto 8000, que mapeamos en Docker.

4. .vscode/launch.json
json
Copiar
Editar
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Attach to Docker",
      "type": "node",
      "request": "attach",
      "protocol": "inspector",
      "address": "localhost",
      "port": 5858,
      "restart": true,
      "sourceMaps": false,
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "/code"
    },
    {
      "name": "Launch Chrome",
      "type": "pwa-chrome",
      "request": "launch",
      "url": "http://localhost:8000",
      "webRoot": "${workspaceFolder}"
    }
  ]
}
• Attach to Docker: para depurar el back‑end Node.js.
• Launch Chrome: para depurar el front‑end servido por Node.

💻 Comandos utilizados
Navegar al proyecto

bash
Copiar
Editar
cd scripts/ci/CD/dockerClass/node-debug-demo
Detener el stack anterior

bash
Copiar
Editar
docker-compose down
(Re)construir la imagen

bash
Copiar
Editar
docker-compose build
Arrancar el contenedor

bash
Copiar
Editar
docker-compose up --build
Para ejecución en segundo plano:

bash
Copiar
Editar
docker-compose up --build -d
Verificar contenedores en ejecución

bash
Copiar
Editar
docker ps
Consultar logs del servicio

bash
Copiar
Editar
docker logs node-debug-demo-web-1
Probar conectividad desde el host

bash
Copiar
Editar
curl -I http://localhost:8000
🐞 Depuración en VS Code
Abre app.js y coloca un breakpoint junto a la línea deseada.

Ve al panel Run & Debug (Ctrl + Shift + D).

Selecciona Attach to Docker (o Launch Chrome) en el dropdown.

Haz clic en el ► verde.

Refresca el navegador o espera la recarga automática cada 2 s.

VS Code pausará la ejecución en tu breakpoint, permitiéndote inspeccionar variables y paso a paso.