# Registro de Decisiones - GameOne

> Cada decision importante se documenta con contexto y razonamiento.

## DEC-001: Motor de juego → Godot 4.7

- **Fecha**: 2026-10-24
- **Decision**: Usar Godot 4.7 como motor
- **Alternativas**: Unity, Unreal, Phaser.js, GameMaker
- **Razon**: Archivos texto plano (ideal para Claude), MIT license, buen soporte 2D y 3D, comunidad indie grande.
- **Estado**: Confirmada

## DEC-002: Pivot de 2D a 3D Low-Poly

- **Fecha**: 2026-10-24
- **Decision**: Cambiar de proyecto 2D a 3D low-poly con camara isometrica
- **Razon**: La vision del juego (For The King + Octopath Traveler) requiere estilo polygon 3D, no sprites 2D. Godot 4 soporta ambos.
- **Impacto**: Scene principal cambia de Node2D a Node3D, renderer Forward Plus, assets 3D en vez de sprites.
- **Estado**: Confirmada

## DEC-003: Assets iniciales → Quaternius (CC0)

- **Fecha**: 2026-10-24
- **Decision**: Usar packs de Quaternius (RPG Characters + Animated Monsters) como assets base.
- **Razon**: CC0 (sin restricciones), low-poly style compatible con vision, FBX importa directo en Godot.
- **Alternativas consideradas**: KayKit (tambien CC0, descargar manual), Kenney (mas 2D/pixel art).
- **Estado**: Implementada

## DEC-004: Arquitectura → Godot Scene Tree (no ECS)

- **Fecha**: 2026-10-24
- **Decision**: Usar Scene Tree nativo de Godot, no implementar ECS custom.
- **Razon**: Para inicio incremental, Scene Tree es suficiente. ECS solo si necesitamos manejar miles de entidades. No abstraccion prematura.
- **Estado**: Vigente

## DEC-005: Combate turn-based → In-place overlay (no escena separada)

- **Fecha**: 2026-10-25
- **Decision**: Combate ocurre en el mismo mapa (hex grid) con UI overlay, no en escena separada.
- **Razon**: Mas simple para M5 incremental. Enemigos visibles en el overworld como Barbarian.glb. Al pisar su hex, se activa combate con HP bars y turnos. Victoria remueve enemigo, derrota reinicia escena.
- **Alternativa**: Escena de combate separada (estilo Octopath). Evaluar para M7+ cuando haya party y habilidades multiples.
- **Estado**: Implementada

## DEC-006: Ability routing → Signal desde UI, main.gd decide destino

- **Fecha**: 2026-10-25
- **Decision**: ability_ui emite signal `ability_used`, main.gd rutea a combate o animacion libre segun estado.
- **Razon**: Desacopla UI de logica de combate. Permite reusar mismos botones en exploracion y combate.
- **Estado**: Implementada

## DEC-007: Pivot de gameplay → Heroes of Might and Magic III style

- **Fecha**: 2026-10-25
- **Decision**: Cambiar de "party RPG" (Octopath/For The King) a "hero + army strategy" (HoMM III).
- **Razon**: El usuario quiere base building, army management, hero que comanda tropas. Mas estrategia, menos RPG individual.
- **Impacto**: Party system reemplazado por army stacks. Se agrega town/base, recursos, recruitment. Combate pasa de 1v1 a stacks vs stacks. Hero no pelea directo, sus stats boostean al ejercito.
- **Que se mantiene**: Hex grid overworld, combate turn-based en hex arena, low-poly 3D, click-to-move, encounter system.
- **Estado**: En progreso

---
*Ultima actualizacion: 2026-10-25*
