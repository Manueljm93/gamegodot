# Estructura del Proyecto - GameOne

> Godot 4.7 - 3D Low-Poly RPG project layout.

## Arbol de Archivos

```
D:\GameOne\
├── project.godot           # Config principal Godot
├── icon.svg                # Icono del proyecto
├── CLAUDE.md               # Guidelines para Claude
├── .gitignore              # Exclusiones git (Godot)
│
├── scenes/                 # Escenas (.tscn)
│   └── main.tscn           # Escena principal 3D - entry point
│
├── scripts/                # Scripts GDScript (.gd)
│   ├── main.gd             # Controlador principal - scene setup, input, estados
│   ├── game_manager.gd     # Singleton autoload - estado global
│   ├── hex_grid.gd         # Generador de hex grid, pathfinding BFS
│   ├── character.gd        # Controller de personaje, animaciones
│   ├── animation_loader.gd # Carga animaciones de GLB externos
│   ├── ability_ui.gd       # HUD de habilidades (botones)
│   ├── combat_manager.gd   # Logica de combate turn-based
│   ├── combat_ui.gd        # HUD de combate (HP bars, turnos)
│   └── validate.gd         # Script headless para validacion GDScript
│
├── assets/
│   ├── models/
│   │   ├── characters/     # Modelos 3D FBX (personajes + monstruos)
│   │   ├── items/          # Armas, objetos
│   │   └── environment/    # Terreno, props
│   ├── audio/              # Musica, SFX
│   └── fonts/              # Tipografias
│
└── docs/                   # Documentacion del proyecto
    ├── filosofia-de-trabajo.md
    ├── investigacion-tecnologica.md
    ├── recursos-y-referencias.md
    ├── estructura-proyecto.md (este archivo)
    ├── vision-del-juego.md
    └── decisiones.md
```

## Modelos 3D Disponibles

### Personajes (Quaternius - CC0)
| Archivo | Descripcion |
|---------|-------------|
| Warrior.fbx | Guerrero con espada |
| Wizard.fbx | Mago con baston |
| Ranger.fbx | Arquero |
| Rogue.fbx | Ladron con daga |
| Monk.fbx | Monje |
| Cleric.fbx | Clerigo con baston |

### Monstruos (Quaternius - CC0)
| Archivo | Descripcion |
|---------|-------------|
| Bat.fbx | Murcielago volador |
| Dragon.fbx | Dragon |
| Skeleton.fbx | Esqueleto |
| Slime.fbx | Slime |

## Convenciones

### Nombres de archivos
- **Scenes**: `snake_case.tscn` en `scenes/`
- **Scripts**: `snake_case.gd` en `scripts/`
- **Models**: `PascalCase.fbx` en subcarpeta de `assets/models/`

### Autoloads (Singletons)
- `GameManager` → `scripts/game_manager.gd` - Estado global del juego

### Escena principal
- `scenes/main.tscn` → Entry point configurado en project.godot (Node3D)

## Config Clave (project.godot)

| Setting | Valor | Razon |
|---------|-------|-------|
| Viewport | 1280x720 | 16:9 standard |
| Renderer | Forward Plus | Necesario para 3D con luces/sombras |
| MSAA 3D | 2x | Anti-aliasing suave para low-poly |
| Camera | Orthogonal | Isometrica (simil For The King) |

## Principios de Estructura

1. **Flat > nested**: No subcarpetas hasta que sean necesarias.
2. **Separar scenes de scripts**: Facilita busqueda y diffs en git.
3. **Models por rol**: characters, items, environment.
4. **Docs fuera del engine**: `docs/` no afecta al juego, solo documentacion.
5. **Licencias junto a assets**: LICENSE_*.txt en carpeta de models.

---
*Ultima actualizacion: 2026-10-25*
