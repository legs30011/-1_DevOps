# Kubernetes

Kubernetes (o “K8s”) es un sistema de orquestación de contenedores de código abierto, originalmente desarrollado por Google y ahora mantenido por la Cloud Native Computing Foundation (CNCF). Facilita el despliegue, escalado y operación de aplicaciones en contenedores de forma declarativa y automatizada.

---

## 📐 Arquitectura

### 1. Plano de Control (Control Plane)
- **kube‑apiserver**  
  Punto de entrada de todas las peticiones REST. Valida y persiste el estado deseado en etcd.
- **etcd**  
  Almacén clave‑valor distribuido que guarda la configuración y el estado del clúster.
- **kube‑scheduler**  
  Asigna Pods a nodos libres según recursos, afinidades y restricciones.
- **kube‑controller‑manager**  
  Ejecuta bucles de control (replicación, nodos, endpoints, cuentas de servicio…) para mantener el estado deseado.

### 2. Plano de Datos (Data Plane)
- **kubelet**  
  Agente que corre en cada nodo; recibe manifest YAML (PodSpecs) y gestiona los contenedores.
- **kube‑proxy**  
  Gestiona el networking en cada nodo: mantiene reglas de red (iptables/ipvs) para Services.
- **Container Runtime**  
  Motor que ejecuta contenedores (Docker, containerd, CRI‑O…).

---

## 📦 Objetos Básicos de Kubernetes

| Objeto        | Descripción                                                                 |
|---------------|------------------------------------------------------------------------------|
| **Pod**       | Unidad más pequeña: uno o varios contenedores que comparten red y almacenamiento. |
| **ReplicaSet**| Asegura que haya un número dado de réplicas de un Pod en ejecución.          |
| **Deployment**| Gestión declarativa de ReplicaSets; soporta rolling updates y rollbacks.     |
| **StatefulSet**| Despliega Pods con identidad estable (nombre, almacenamiento persistente).   |
| **DaemonSet** | Despliega un Pod en todos (o algunos) nodos del clúster.                     |
| **Job**       | Ejecuta tareas de corta duración que terminan cuando completan su trabajo.   |
| **CronJob**   | Programa Jobs de manera periódica (como cron).                               |
| **Service**   | Abstracción de red estable (ClusterIP, NodePort, LoadBalancer) para Pods.    |
| **Ingress**   | Reglas de enrutamiento HTTP/S externas hacia Services.                       |
| **ConfigMap** | Inyecta configuración en Pods sin reempaquetar la imagen.                    |
| **Secret**    | Similar a ConfigMap, pero para datos sensibles (contraseñas, tokens).        |
| **Namespace** | Aislamiento lógico de recursos dentro de un clúster.                        |
| **Volume**    | Almacenamiento persistente montado en Pods (hostPath, PVC, NFS, CSI…).      |

---

## 🔄 Modelo Declarativo

1. Escribes archivos **YAML** o **JSON** que describen el estado deseado (`kubectl apply -f mi-manifest.yaml`).  
2. El **kube‑apiserver** lo registra en **etcd**.  
3. El **control plane** (scheduler, controllers) actúa para que el estado real coincida con el deseado: crea, actualiza o borra Pods, Services, etc.

---

## 🛠️ Comandos Clave (`kubectl`)

```bash
kubectl get pods                    # Listar Pods
kubectl describe svc my-service     # Información detallada de un Service
kubectl apply -f deployment.yaml    # Crear/actualizar recursos
kubectl delete -f job.yaml          # Eliminar recursos
kubectl logs my-pod                 # Ver logs de un Pod
kubectl exec -it my-pod -- bash     # Abrir shell dentro de un contenedor
kubectl port-forward svc/my-service 8080:80  # Reenviar puertos al host
kubectl top nodes/pods              # Métricas de CPU y memoria (requiere Metrics Server)
🔍 Salud y Recursos
Liveness Probe: detecta si el contenedor está bloqueado → reinicio.

Readiness Probe: detecta si el contenedor está listo → Service lo incluye/excluye.

Requests & Limits: garantiza calidad de servicio y evita “noisy neighbors.”

🌐 Ecosistema y Extensiones
Helm: gestor de paquetes (charts) para distribuir aplicaciones.

Operators: controladores especializados para gestionar aplicaciones complejas.

CNI (Container Network Interface): plugins de red (Calico, Flannel, Weave…).

CSI (Container Storage Interface): plugins de almacenamiento (Portworx, Rook…).

📈 Buenas Prácticas
Usa Namespaces y RBAC para segmentar y proteger entornos.

Mantén las imágenes actualizadas y firmadas (SBOM, Image Scanning).

Configura Healthchecks y límites de recursos.

Emplea Rolling Updates y PodDisruptionBudgets para alta disponibilidad.

Centraliza logs (ELK, Fluentd) y métricas (Prometheus, Grafana).

🚀 Casos de Uso
Microservicios escalables y resilientes.

Plataformas de CI/CD (Jenkins X, Tekton).

Big Data y ML pipelines (Kubeflow).

Edge computing y entornos híbridos.

