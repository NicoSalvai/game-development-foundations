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

---

## FASE 2.1 — Identidad Visual

### Paleta de colores
- Player: rampa de bronce real (#0d0a07 → #3d2b1a → #7a4f2e → #c8843a → #f3ebd4).
- Enemigos caparazón: azul acero frío (#0a0f14 → #1e405b → #2d6e8a → #409f42 como acento).
- Enemigos núcleo: verde necrón (#8fd345 exterior, #bdff8c interior — ambos con glow HDR).
- Separación cálido/frío entre player y enemigos — nunca se confunden en pantalla.
- Colores de glow (#bdff8c, #f3ebd4) superan el umbral HDR del WorldEnvironment para activar bloom.

### WorldEnvironment
- Background via ColorRect full rect — el Background Mode del Environment no funciona bien en 2D.
- Tonemap: Linear — ACES aplasta los highlights y debilita el glow, Filmic apaga los saturados.
- Glow: Additive, Threshold 0.8, Intensity 0.7, Bloom 0.15. Levels: 0.5 / 0.8 / 0.4 / 0.1.
- Guardado como recurso .tres reutilizable.

### Identidad visual — Player
- Forma hexagonal irregular con flecha interna apuntando a +X (frente = derecha, convención Godot).
- 13 Polygon2D todos con 3 vértices — consistencia preparada para morph futuro de variantes de arma.
- El morph pistola↔cañón queda para Fase 4 cuando se implementen variantes de arma.
- Animación de disparo via AnimationPlayer: kickback de Visuals + flash HDR en Core. ShooterComponent.shoot() retorna bool para triggerear la animación.

### Identidad visual — Chaser
- Forma de punta de lanza — masa visual atrás, punta agresiva adelante apuntando a +X.
- Caparazón azul acero frío + núcleo verde necrón en capas (Core / Int).
- El núcleo ya tiene valor HDR > 1.0 en el canal verde — brilla sin configuración extra.

### Balas
- Un solo Polygon2D, forma de punta de flecha (4 vértices), color #f3ebd4 — brilla por el WorldEnvironment.
- Tamaño deliberadamente menor que los personajes para jerarquía visual clara.

### Animaciones
- Idle descartado — no va con la estética frenética del juego.
- Animación de muerte movida a Fase 2.3 junto a partículas — requiere explosión de fragmentos con glow.

### Feedback visual de daño — Chaser
- Sistema de 3 estados vinculado al HP (max_hp subido a 3).
- HP 3 → caparazón cerrado. HP 2 → caparazón resquebrajado. HP 1 → núcleo expuesto.
- Implementado en `ChaserDamageVisuals.gd` — script dedicado hijo de Visuals, no genérico.
- Hit flash via modulate en Visuals (Color 3,3,3 — supera HDR, el flash activa glow).
- Transiciones via Tween con TRANS_BACK + EASE_OUT — overshoot sutil que se siente como impacto.
- Los estados acumulan — rotación y posición no se resetean entre estados, el daño es permanente visualmente.

### Feedback visual de daño — Player
- Sistema de 5 estados (uno por cada HP perdido, max_hp = 5).
- Grietas (Crack) como Polygon2D hijos de cada pieza de armadura, ocultos hasta recibir daño.
- En HP crítico (1): además de grietas, aparecen Leaks — polígonos del color del núcleo (#f3ebd4) dentro de las grietas, como si el núcleo se estuviera exponiendo.
- Implementado en `PlayerDamageVisuals.gd` — script dedicado hijo de Visuals.
- Reveal via Tween de modulate.a (0→1 en 0.08s) — sin hit flash, la grieta es el feedback.
- Hit flash, camera shake y SFX pendientes → Fase 2.3.
