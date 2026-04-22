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
- Los objetos no poolables (partículas, efectos one-shot) también pasan por `ObjectFactory` via `SignalHub.create_object` — `LevelBase` los despacha directo a `create_and_add` si no tienen Pool registrado.

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
- Animación de muerte geométrica diferida a Fase 5 (Boss) — fragmentos reales tienen más sentido en un enemigo importante.

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

---

## FASE 2.2 — Juice de Movimiento

### Camera Lead
- Blend de aim + movimiento con prioridad en aim — muestra el área tácticamente relevante.
- El Player calcula la dirección y empuja los datos a la cámara via `camera.update_lead(aim_direction, move_direction)` — la cámara no accede al Player.
- `aim_direction` se calcula como `(controller.aim_target - global_position).normalized()`.
- Parámetros exportados: `aim_lead_strength`, `move_lead_strength`, `lerp_speed` — tuneables desde inspector.

### HurtBox — extensión de señal
- La señal `hitted` se extendió a `hitted(damage: int, source_position: Vector2)`.
- `source_position` se toma de `area.global_position` directamente en `_on_area_entered` — HitBox no necesita cambios.
- Decisión: toda la info del golpe viaja junta en la señal, preparado para SFX direccional y partículas de impacto en Fase 2.3.

### Knockback — solo Player
- `KnockbackComponent` como nodo hijo del Player — no se implementó en enemigos por ahora.
- Decay via `_physics_process` con `move_toward` — lineal pero tuneable, más simple que Tween y suficiente.
- Compite con el movimiento normal — el mover sigue activo, el impulso decae naturalmente sobre la velocity.
- El dash cancela el knockback — le da agencia al jugador para escapar del hitstun.
- Parámetros exportados: `impulse_strength`, `decay`.

### Dash Visuals — separación de polígonos
- Al dashear, todos los polígonos de `Visuals` se desplazan uniformemente en la dirección del dash y vuelven con overshoot (`TRANS_BACK + EASE_OUT`).
- La dirección del dash se convierte a espacio local de `Visuals` via `to_local(global_position + dash_direction).normalized()` — necesario porque `Visuals` rota hacia el aim.
- Factor de separación uniforme para todas las piezas — la separación escalonada por pieza resultó en demasiado ruido visual.
- `DashComponent.try_dash()` retorna `bool` para que el Player sepa si el dash fue exitoso y active los visuales.

---

## FASE 2.3 — Juice de Impacto

### Audio — SFX
- SFX generados con sfxr.me (jsfxr) — estética retro sintetizada, sin assets externos.
- Un `AudioStreamPlayer2D` por evento, como hijo directo del nodo que produce el sonido.
- Audio posicional sobre centralizado (AudioManager descartado) — con cámara que sigue al player el panning agrega información espacial válida.
- `EnemyBase` tiene los SFX base (hurt). Cada subclase puede sobreescribir con sus propios nodos.
- SFX de muerte del player usan `process_mode = PROCESS_MODE_ALWAYS` — necesitan sonar con el árbol pausado.
- Música como `AudioStreamPlayer` (no 2D) — loop frenético electrónico/sintetizado.

### Screen Shake — Trauma System
- Trauma acumulable (0.0 a 1.0), el shake se calcula como `trauma²` — curva de decay más natural que lineal.
- Decay lineal por delta — el trauma baja solo con el tiempo.
- El offset de shake se suma al offset de lead **después** del lerp — si se mezclan antes, el lerp amortigua el shake y se vuelve imperceptible.
- Eventos y valores: disparo → 0.08, daño recibido → 0.40, muerte del player → 0.8.
- Solo en eventos del player — impacto en enemigo y muerte de enemigo no generan shake (decisión de diseño: el shake comunica consecuencias para el jugador, no daño infligido).

### Partículas — Arquitectura
- Todas las partículas pasan por `SignalHub.create_object` → `LevelBase` → `ObjectFactory.create_and_add`.
- Las partículas nacen como hijos del Level, no del nodo que las crea — resuelve el problema de lifetime cuando el nodo padre hace `queue_free()`.
- Contrato de `activate(pos, dir)` — igual que los objetos poolables pero sin `deactivate()`. Se auto-destruyen con `queue_free()` al terminar (`finished` signal).
- `ObjectType` nuevo por cada efecto de partícula — sin Pool registrado, van directo a `create_and_add`.

### Partículas — Decisiones por efecto
- **Impacto genérico de bala:** dirección opuesta al impacto (`(-dir).angle()`). Color PLAYER_ACCENT. Se emite en `Bullet._on_hit_box_hitted` antes de `deactivate()`.
- **Impacto en enemigo:** dos tipos según HP — `ENEMY_HIT_ARMOR` (HP > 1) y `ENEMY_HIT_CORE` (HP == 1). Lógica en `ChaserDamageVisuals` — no en `EnemyBase` porque cada enemigo tiene su propio umbral de HP.
- **Muerte de enemigo:** omnidireccional, mezcla armadura + core en una sola escena con dos `GPUParticles2D`. Se emite en `EnemyBase._on_died` antes de `queue_free()`.
- **Dash:** dirección opuesta al movimiento. `Transform Align: Rotation` en el material para que la textura (línea) se alinee a la dirección de cada partícula.

### Animación de muerte — Player
- Flujo: HP = 0 → `_is_dead = true` (bloquea physics/input) → shake → vibración + glow exponencial del core → explosión de fragmentos → `queue_free()` → `get_tree().paused = true`.
- Vibración implementada con Tween (offsets aleatorios en runtime) — AnimationPlayer no puede expresar direcciones calculadas dinámicamente.
- Glow del core sube exponencialmente durante la vibración via Tween paralelo (`TRANS_EXPO + EASE_IN`).
- Explosión: cada fragmento vuela en dirección radial calculada en runtime + fade a 0.
- `get_tree().paused` se ejecuta después de que termina la animación — el callable se pasa como parámetro a `play_death()`.
- Game Over UI diferida — por ahora solo pausa. El cartel se implementa cuando se diseñe el flujo de meta.

### Freeze Frame y animación de muerte geométrica
- Freeze frame diferido a Fase 5 — no hay enemigos importantes para aplicarlo aún.
- Fragmentos geométricos reales (polígonos volando) diferidos a Fase 5 (Boss) — overkill para el Chaser básico con el feedback que ya tiene.
