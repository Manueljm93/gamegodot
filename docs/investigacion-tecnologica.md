# Investigacion Tecnologica - GameOne

> Resumen de investigacion sobre motores y herramientas para juego 2D.
> Fecha de investigacion: 2026-10-24

## Resumen Ejecutivo

Para un juego 2D con desarrollo incremental asistido por Claude, **Godot 4** emerge como mejor candidato por:
- Gratis, MIT license, sin royalties.
- Proyecto basado en texto (scenes como .tscn, scripts como .gd) → ideal para AI/Claude.
- Renderer 2D dedicado y maduro.
- GDScript simple de aprender, similar a Python.
- Comunidad indie grande y creciente.

**Phaser.js** es alternativa fuerte si se quiere juego web-first.

## Comparativa de Motores

### Godot 4 ⭐ (Recomendado)
| Aspecto | Detalle |
|---------|---------|
| Licencia | MIT, gratis, sin royalties |
| Lenguaje | GDScript (principal), C#, C++ via GDExtension |
| 2D | Renderer dedicado, pixel-perfect |
| AI-friendly | Archivos texto plano (.tscn, .gd), estructura legible por Claude |
| Comunidad | Grande, creciente rapido post-Unity controversia |
| Plataformas | Desktop, mobile, web (web limitado con C#) |
| Debilidades | Asset marketplace chico, console export requiere third-party |

### Phaser.js (Alternativa web)
| Aspecto | Detalle |
|---------|---------|
| Licencia | MIT, gratis |
| Lenguaje | JavaScript / TypeScript |
| 2D | Framework dedicado 2D, browser-native |
| AI-friendly | Todo es codigo, muy legible por Claude |
| Comunidad | Mayor comunidad HTML5 games |
| Plataformas | Web (browser), empaquetable con Electron |
| Debilidades | Solo 2D, requiere tooling externo para builds nativos |

### Unity (Descartado para este proyecto)
| Aspecto | Detalle |
|---------|---------|
| Licencia | Gratis hasta $200K revenue, luego pago |
| Por que no | Archivos binarios, editor visual pesado, dificil para Claude operar. 2D es ciudadano de segunda clase. |

### GameMaker (Alternativa posible)
| Aspecto | Detalle |
|---------|---------|
| Licencia | Gratis no-comercial, $99.99 comercial |
| Por que considerar | Enfocado 100% en 2D, muy beginner-friendly |
| Por que no | GML menos estandar, menor interoperabilidad con Claude que GDScript |

## Por Que Godot + Claude Funciona Bien

1. **Archivos texto plano**: Scenes (.tscn) y scripts (.gd) son texto → Claude puede leer, editar, crear.
2. **GDScript legible**: Sintaxis similar a Python, Claude lo maneja bien.
3. **Estructura de proyecto clara**: Carpetas con recursos organizados, no binarios opacos.
4. **Documentacion abundante**: Godot docs son exhaustivos, Claude tiene buen conocimiento.
5. **Sin vendor lock**: MIT license, control total del proyecto.

## Patron Arquitectonico: ECS vs Scene Tree

### Godot Scene Tree (Built-in)
- Godot usa arbol de nodos como patron principal.
- Cada nodo es un componente (Sprite, CollisionShape, AudioPlayer).
- Composicion natural: armar entidades combinando nodos.
- Para juego 2D incremental, Scene Tree es suficiente al inicio.

### Entity Component System (ECS)
- Separa datos (Components) de logica (Systems).
- Mejor performance con muchas entidades (~miles).
- Mas complejo de implementar, overkill para inicio.
- **Decision**: no usar ECS ahora. Si el juego crece a necesitarlo, migrar.

## Advertencias Importantes

- **LLMs y Godot 3 vs 4**: Claude puede confundir API de Godot 3 con 4. Siempre especificar version.
- **Verificacion**: Codigo generado debe compilar Y funcionar. Compilar no es suficiente.
- **Assets binarios**: Sprites, audio, etc. Claude no puede generar. Se manejan manualmente o con herramientas externas.

## Herramientas Complementarias

| Herramienta | Uso |
|-------------|-----|
| Aseprite / LibreSprite | Pixel art y sprites |
| Tiled | Level design (exporta a Godot) |
| BFXR / sfxr | Sound effects placeholder |
| Git | Version control (texto plano = diffs limpios) |

## Decision Pendiente

> **Motor elegido: Godot 4** ✅ Confirmado 2026-10-24
> 
> Repo: https://github.com/Manueljm93/gamegodot.git

---
*Fuentes de investigacion en docs/recursos-y-referencias.md*
*Ultima actualizacion: 2026-10-24*
