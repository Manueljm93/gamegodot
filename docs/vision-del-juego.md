# Vision del Juego - GameOne

> Documento vivo. Se actualiza a medida que la vision se consolida.

## Concepto Core

Fusion de **Heroes of Might and Magic III** (hero + army, base building, strategy) con **For The King** (hex grid overworld, low-poly 3D, tabletop feel) y toques de **Octopath Traveler** (combate turn-based satisfactorio).

### Que tomamos de cada referencia

**De Heroes of Might and Magic III:**
- Hero comanda un ejercito (army stacks, no party RPG)
- Base/Town edificable con upgrades y reclutamiento
- Recursos (gold, wood, ore) para construir y reclutar
- Combate en hex grid tactico (stacks vs stacks)
- Hero stats boostean al ejercito, no pelea directo
- Sistema de dias/turnos con movimiento limitado

**De For The King:**
- Overworld con hex grid explorable
- Estilo visual low-poly 3D (polygon simil tabletop)
- Encuentros en el mapa

**De Octopath Traveler:**
- Combate turn-based con profundidad tactica
- Progresion de habilidades

### Que NO incluimos (por ahora)
- Narrativa / historia (se agrega despues si se decide)
- Multiplayer
- Procedural generation (evaluar mas adelante)
- Multiples facciones/towns (una sola por ahora)

## Estilo Visual

- **3D Low-Poly** estilo tabletop/storybook
- Camara isometrica semi-top-down
- Colores calidos, iluminacion suave
- Modelos simples, expresivos por silueta

## Pilares de Gameplay (sin orden de prioridad)

1. **Strategy + Base Building** — Construir town, reclutar ejercito, gestionar recursos
2. **Combate turn-based en hex grid** — Army stacks tacticos, hero spells
3. **Exploracion en hex grid** — Descubrir mapa, capturar minas, encontrar enemigos
4. **Progresion de Hero** — Stats, skills, level up por XP de combates

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
5. ~~**Milestone 5**: Combate turn-based con arena y encounter choice~~ ✓
6. **Milestone 6**: Base/Town + recursos (gold) + menu de construccion
7. **Milestone 7**: Army stacks (hero comanda tropas, no pelea solo)
8. **Milestone 8**: Recruitment (dwellings en town → reclutar tropas)
9. **Milestone 9**: Hero stats (Attack/Defense boost army)
10. **Milestone 10**: Turn system (dias, movimiento limitado)
11. **Milestone 11**: Spells en combate
12. *...se define a medida que avanzamos*

---
*Ultima actualizacion: 2026-10-25*
