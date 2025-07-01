# Raft Consensus Group

Una **Raft Consensus Group** (o clúster Raft) es un conjunto de servidores que usan el algoritmo **Raft** para mantenerse de acuerdo sobre una secuencia de operaciones (un “log” replicado) incluso ante fallos de nodos o de red. Raft está diseñado para ser simple de entender y aplicar, en contraste con Paxos.

---

## 📋 Conceptos clave

- **Servidor**: uno de los nodos del clúster. Mantiene:
  - Un **log** de entradas (comandos) indexadas.
  - Un **estado de máquina** que aplica esas entradas.
  - Variables de Raft: `currentTerm`, `votedFor`, `log[]`.

- **Roles** (cada servidor cambia de rol en diferentes momentos):
  1. **Leader**  
     - Único nodo que recibe nuevas entradas de clientes.  
     - Replica entradas en los followers.  
     - Envía latidos (heartbeats) periódicos via `AppendEntries` para evitar elecciones.
  2. **Follower**  
     - Nodo pasivo.  
     - Responde a solicitudes de candidato o líder.  
     - Reinicia su temporizador de elección al recibir heartbeats.
  3. **Candidate**  
     - Se autopromueve cuando no recibe heartbeats dentro de un “election timeout”.  
     - Pide votos con `RequestVote` a otros servidores.  
     - Si obtiene mayoría, se convierte en líder; si recibe `AppendEntries` de un líder con término igual o mayor, vuelve a follower.

- **Términos** (`term`): números monotonamente crecientes que identifican “rondas” de elecciones. Cada petición RPC lleva un `term`. Un servidor actualiza su `currentTerm` al recibir uno mayor y pasa a follower.

---

## ⚙️ Fases del algoritmo

1. **Elección de líder**  
   - Un follower se convierte en candidate al expirar su election timeout.  
   - Envía `RequestVote(term, candidateId, lastLogIndex, lastLogTerm)` a todos.  
   - Los servidores votan si no han votado en ese término y el log del candidato está al día.  
   - Con votos > N/2 → líder; si ve un término mayor → vuelve a follower; si empate → nueva elección.

2. **Replicación de log**  
   - El líder acepta comandos de clientes, los añade a su log local.  
   - Envía `AppendEntries(term, leaderId, prevLogIndex, prevLogTerm, entries[], leaderCommit)` a cada follower.  
   - Si el follower acepta, responde `success=true` y actualiza su log; si no (inconsistencia), responde `false` y el líder retrocede `nextIndex` para reintentar.

3. **Compromiso y aplicación**  
   - El líder marca una entrada como *committed* cuando está replicada en la mayoría de servidores.  
   - Envía `leaderCommit` en los heartbeats para que followers actualicen su `commitIndex`.  
   - Cada servidor aplica entradas hasta `commitIndex` a su máquina de estado.

4. **Cambio de miembros**  
   - Raft soporta cambios seguros de configuración (p.ej. agregar/quitar servidores) en dos fases (“joint consensus”).  
   - Nueva configuración se replica como una entrada de log, primero operando con la configuración antigua y nueva, luego solo con la nueva.

---

## ✅ Propiedades de seguridad

1. **Seguridad del líder**: un nuevo líder ha replicado al menos el log de su predecesor.  
2. **Seguridad del registro**: una vez que una entrada es commit­teada en un término, nunca se pierde.  
3. **Disponibilidad**: mientras la mayoría de nodos estén vivos y comunicándose, el clúster sigue aceptando comandos.

---

## 🔨 Ejemplo básico de comandos (usando etcd/HashiCorp Raft)

> _Este ejemplo asume un binario que usa Raft internamente y expone flags para inicializar/únirse al clúster._

```bash
# Arrancar el primer nodo (bootstrap)
myapp --id node1 \
      --raft-dir ./data1 \
      --raft-bootstrap

# Arrancar un follower y unirse al cluster node1
myapp --id node2 \
      --raft-dir ./data2 \
      --raft-join http://node1:2380

# Comprobar estado del Raft cluster
myapp raft status