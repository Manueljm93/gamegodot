# Estructura del Proyecto - GameOne

> Godot 4 project layout.

## Arbol de Archivos

```
D:\GameOne\
├── project.godot           # Config principal Godot
├── icon.svg                # Icono del proyecto
├── CLAUDE.md               # Guidelines para Claude
├── .gitignore              # Exclusiones git (Godot)
│
├── scenes/                 # Escenas (.tscn)
│   └── main.tscn           # Escena principal - entry point
│
├── scripts/                # Scripts GDScript (.gd)
│   ├── main.gd             # Script de main scene
│   └── game_manager.gd     # Singleton autoload - estado global
│
├── assets/                 # Recursos del juego
│   ├── sprites/            # Imagenes, spritesheets
│   ├── audio/              # Musica, SFX
│   └── fonts/              # Tipografias
│
└── docs/                   # Documentacion del proyecto
    ├── filosofia-de-trabajo.md
    ├── investigacion-tecnologica.md
    ├── recursos-y-referencias.md
    └── estructura-proyecto.md (este archivo)
```

## Convenciones

### Nombres de archivos
- **Scenes**: `snake_case.tscn` en `scenes/`
- **Scripts**: `snake_case.gd` en `scripts/`
- **Assets**: `snake_case` con extension apropiada en subcarpeta de `assets/`

### Autoloads (Singletons)
- `GameManager` → `scripts/game_manager.gd` - Estado global del juego

### Escena principal
- `scenes/main.tscn` → Entry point configurado en project.godot

## Config Clave (project.godot)

| Setting | Valor | Razon |
|---------|-------|-------|
| Viewport | 1280x720 | 16:9 standard, escala bien |
| Stretch mode | canvas_items | Pixel art friendly |
| Stretch aspect | keep | Mantiene aspect ratio |
| Renderer | gl_compatibility | Maximo soporte de hardware |
| Texture filter | Nearest | Pixel art crisp (sin blur) |

## Principios de Estructura

1. **Flat > nested**: No subcarpetas hasta que sean necesarias.
2. **Separar scenes de scripts**: Facilita busqueda y diffs en git.
3. **Assets organizados por tipo**: sprites, audio, fonts.
4. **Docs fuera del engine**: `docs/` no afecta al juego, solo documentacion.

---
*Ultima actualizacion: 2026-10-24*
