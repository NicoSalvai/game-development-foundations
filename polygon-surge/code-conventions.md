# Code Conventions

## Nomenclatura

### Variables privadas
Usar prefijo `_` para variables de instancia privadas (no pensadas para acceso externo).
No usar `_` en variables `@onready` — son internas por naturaleza.

```gdscript
# Privada
var _dash_direction: Vector2

# Pública
var is_dashing: bool

# @onready — sin prefijo
@onready var dash_timer: Timer = $DashTimer
```
