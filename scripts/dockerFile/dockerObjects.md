# Docker Objects

Docker organiza todo en “objetos” que representan las piezas fundamentales con las que construyes y ejecutas aplicaciones en contenedores. A continuación, un repaso de los principales objetos y qué hace cada uno:

---

## 1. Images

- **¿Qué son?** Plantillas inmutables que contienen tu aplicación, sus dependencias y metadatos (instrucciones de arranque, variables de entorno, puertos expuestos…).  
- **Creación:** A partir de un `Dockerfile` con `docker build -t usuario/mi-imagen:tag .`.  
- **Gestión:**  
  - Listar: `docker image ls`  
  - Ver detalles: `docker image inspect usuario/mi-imagen:tag`  
  - Eliminar: `docker image rm ID_o_nombre`  

---

## 2. Containers

- **¿Qué son?** Instancias en ejecución de una image. Un contenedor es un grupo de procesos aislados (namespaces) con límites (cgroups).  
- **Creación & ejecución:** `docker run [opciones] usuario/mi-imagen:tag`  
- **Gestión:**  
  - Listar activos: `docker container ls`  
  - Listar todos (incluidos parados): `docker container ls -a`  
  - Inspeccionar: `docker container inspect nombre_o_ID`  
  - Entrar un shell: `docker exec -it nombre_o_ID sh`  
  - Detener: `docker container stop nombre_o_ID`  
  - Eliminar: `docker container rm nombre_o_ID`  

---

## 3. Volumes

- **¿Qué son?** Almacenamiento persistente gestionado por Docker, independiente del ciclo de vida de los contenedores.  
- **Tipos:**  
  - **Named volumes** (`docker volume create datos_db`)  
  - **Bind mounts** (montar carpetas locales con `-v /host/ruta:/contenedor/ruta`)  
- **Gestión:**  
  - Listar: `docker volume ls`  
  - Inspeccionar: `docker volume inspect nombre`  
  - Eliminar: `docker volume rm nombre`  

---

## 4. Networks

- **¿Qué son?** Redes virtuales que permiten la comunicación entre contenedores. Docker crea por defecto:  
  - `bridge` (la red por defecto)  
  - `host` (sin aislamiento)  
  - `none` (sin interfaz de red)  
- **Creación:** `docker network create mi_red --driver bridge`  
- **Gestión:**  
  - Listar: `docker network ls`  
  - Inspeccionar: `docker network inspect mi_red`  
  - Conectar un contenedor: `docker network connect mi_red nombre_contenedor`  
  - Desconectar: `docker network disconnect mi_red nombre_contenedor`  
  - Eliminar: `docker network rm mi_red`  

---

## 5. Secrets & Configs (Swarm)

- **¿Qué son?** Objetos para manejar datos sensibles o de configuración en clústeres Docker Swarm.  
- **Crear secret:** `docker secret create my_secret secret.txt`  
- **Ver:** `docker secret ls`  
- **Usar en servicio:**  
  ```yaml
  services:
    web:
      image: nginx
      secrets:
        - my_secret

Config: similar a secrets, pero para archivos de configuración no sensibles.

## 6. Plugins
¿Qué son? Extensiones externas para storage, networking, logging, etc.

Gestión:

Listar: docker plugin ls

Instalar: docker plugin install plugin/name

Habilitar/deshabilitar: docker plugin enable|disable plugin/name

Eliminar: docker plugin rm plugin/name

## 7. Builder (BuildKit)
¿Qué es? El motor interno que procesa tu Dockerfile y gestiona caché, etapas múltiples, paralelismo.

Uso: habilitado por defecto en versiones recientes. Controlas con:

bash
Copiar
Editar
DOCKER_BUILDKIT=1 docker build .
Flujo típico de trabajo
Define tu aplicación en un Dockerfile → docker build.

Inicia tu contenedor con docker run, vinculando puertos y volúmenes.

Conecta contenedores en una network para que hablen entre sí.

Persiste datos en volumes.

(En Swarm) Distribuye configuración/sensibles con secrets/configs.

Extiende Docker con plugins según necesites.