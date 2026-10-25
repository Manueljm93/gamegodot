# Vision del Juego - GameOne

> Documento vivo. Se actualiza a medida que la vision se consolida.

## Concepto Core

Fusion de **Octopath Traveler** (combate turn-based, party, clases) con **For The King** (hex grid overworld, estilo visual low-poly, exploracion tactica).

### Que tomamos de cada referencia

**De For The King:**
- Overworld con hex grid
- Estilo visual low-poly 3D (polygon 2D simil 3D)
- Exploracion con party en mapa
- Elementos tacticos/estrategicos

**De Octopath Traveler:**
- Sistema de combate turn-based profundo
- Clases y habilidades de personajes
- Progresion RPG

### Que NO incluimos (por ahora)
- Narrativa / historia (se agrega despues si se decide)
- Multiplayer
- Procedural generation (evaluar mas adelante)

## Estilo Visual

- **3D Low-Poly** estilo tabletop/storybook
- Camara isometrica semi-top-down
- Colores calidos, iluminacion suave
- Modelos simples, expresivos por silueta

## Pilares de Gameplay (sin orden de prioridad)

1. **Combate turn-based** — Satisfactorio, con profundidad tactica
2. **Exploracion en hex grid** — Descubrir el mapa, encontrar eventos
3. **Gestion de party** — Clases, equipamiento, progresion
4. **Riesgo/recompensa** — Decisiones con peso

## Assets Actuales

### KayKit Adventurers (CC0)
- Knight, Barbarian, Mage, Ranger, Rogue, Rogue_Hooded (GLB)
- Animaciones: General (Idle, Hit, Death, Throw, Interact, Use_Item, Spawn, PickUp) + Movement (Walking, Running, Jump)
- Items: 31 armas/objetos (swords, axes, bows, shields, staves)

### Personajes (Quaternius - CC0)
- Warrior, Wizard, Ranger, Rogue, Monk, Cleric (FBX)

### Monstruos (Quaternius - CC0)
- Bat, Dragon, Skeleton, Slime (FBX)

### Pendiente
- [ ] Props de entorno (arboles, rocas, edificios)
- [ ] UI/HUD polish
- [ ] Audio placeholder

## Roadmap Tentativo (Features Incrementales)

1. ~~**Milestone 1**: Knight visible en 3D isometrica~~ ✓
2. ~~**Milestone 2**: Sistema de habilidades con animaciones~~ ✓
3. ~~**Milestone 3**: Hex grid overworld con terrenos~~ ✓
4. ~~**Milestone 4**: Click-to-move con BFS pathfinding~~ ✓
5. **Milestone 5**: Combate turn-based basico (HP, turnos, victoria/derrota)
6. **Milestone 6**: Party de multiples personajes
7. **Milestone 7**: Clases y habilidades diferenciadas
8. **Milestone 8**: Enemigos con AI basica
9. *...se define a medida que avanzamos*

---
*Ultima actualizacion: 2026-10-25*
