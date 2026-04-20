# Design Log

## FASE 1 — Core jugable

### Arquitectura del Player
- Separación en componentes: Controller (input), Mover (física), Skills (dash, etc). El Player orquesta, no implementa.
- Los inputs son configurables via `PlayerControls` (Resource) — base para soporte Coop sin cambios de código.
- `move_and_slide()` vive en el Player, no en el Mover. El Mover solo calcula velocity.

### Dash
- Dirección bloqueada al inicio — el jugador se compromete. Evaluamos dash hacia `aim_target` si estás quieto pero no se sentía bien.
- Cooldown arranca cuando el dash *termina*, no cuando empieza — más justo para el jugador.

### Aim — Gamepad / Mouse
- Switching automático por último dispositivo usado, sin configuración manual.
- Al soltar el stick, el aim mantiene la última dirección — no salta al mouse.
- TODO: Revisar si la detección de dispositivo es costosa o rebuscada.

### Sistema de Armas
- Descartamos WeaponSlot + Pistol. El cuerpo del personaje ES el arma visualmente.
- Cambiar de arma en el futuro = animar los polígonos del cuerpo.
- `ShooterComponent` genérico y reutilizable, posicionado en `Visuals` para heredar su rotación.
- Múltiples `ShooterComponent` son posibles (ej. FrontShooter, BackShooter).

### Instanciación — ObjectFactory + Pool
- El Pool conoce a la Factory, no al revés. Pool gestiona ciclo de vida; Factory solo instancia.
- Un Pool por tipo de objeto. `LevelBase` despacha por `ObjectType` — agregar un nuevo Pool es trivial.
- Los objetos poolables implementan `activate` / `deactivate`. La Factory los trata igual.

### HitBox / HurtBox
- `HitBox` inflige daño, `HurtBox` lo recibe.
- La HurtBox extrae el daño y lo emite como número — el padre no necesita saber de dónde vino.
- Ninguno sabe del otro excepto que `HurtBox` chequea `if area is HitBox`.

### Enemigos
- `EnemyBase` como escena heredable — cada enemigo define sus propios visuales, la base no impone forma.
- `HPComponent` emite señal `died` propia — reutilizable para el Player también, no acopla a `SignalHub`.
- `enemy_died` en SignalHub sin parámetro — no necesitamos saber qué enemigo murió por ahora.
- Los Movers de enemigos solo calculan velocity. `move_and_slide()` vive en el Enemy.

### Pendientes
- Muerte del player (actualmente solo loguea).
- Knockback al recibir daño → Fase 2.
- Detección gamepad/mouse → revisar en Fase 2.
