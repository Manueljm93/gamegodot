# Recursos y Referencias - GameOne

> Links, repos, y fuentes utiles encontrados durante investigacion.
> Fecha: 2026-10-24

## Repositorios GitHub Relevantes

### Claude + Game Dev
- **[Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)** - Template completo: 48+ agentes AI, 37+ skills, hooks. Convierte Claude Code en estudio de desarrollo. Muy ambicioso, util como referencia de estructura .claude/.
- **[stahura/claude-gamedev-kit](https://github.com/stahura/claude-gamedev-kit)** - Template para builds automaticos de juegos Godot con Claude Code.
- **[Glitch-Gaming-Platform/AI-Prompts-For-Game-Development](https://github.com/Glitch-Gaming-Platform/AI-Prompts-For-Game-Development)** - Coleccion de prompts ordenados para crear juegos con AI.
- **[sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills)** - Skills de game dev para Claude Code.

### MCP y Herramientas
- **[CoplayDev/unity-mcp](https://github.com/CoplayDev/unity-mcp)** - MCP server para Unity (referencia si se necesita integracion con editor).

## Articulos y Guias

### Claude + Godot
- [The Godot AI Workflow in 2026](https://www.summerengine.com/blog/godot-agentic-coding) - Ciclo intent→edit→run→feedback. Key insight: diferencia entre herramientas es cuanto acceso tienen al proyecto, no calidad de codigo.
- [How to Use AI in Godot: Step-by-Step 2026](https://www.summerengine.com/blog/how-to-use-ai-in-godot) - Verificacion > prompting. LLMs confunden Godot 3/4.
- [Mastering Claude AI + Godot](https://www.buildzn.com/blog/mastering-claude-ai-godot-game-development-your-practical-guide) - Guia practica general.

### Claude + Game Dev General
- [Claude Code for Game Development (Medium)](https://chierhu.medium.com/claude-code-for-game-development-7a88fcd19992) - Claude funciona mejor con engines text-based (Godot, Phaser). Mal con binarios (Unity, Unreal).
- [How I Use Claude Like a Junior Dev](https://mrphilgames.substack.com/p/how-i-use-claude-like-a-junior-dev) - Instancias paralelas en branches separados. Cuidado con merges.
- [Breakout with Claude (Les Orchard)](https://blog.lmorchard.com/2025/07/10/breakout-with-claude/index.md) - Ejemplo completo: Breakout en Phaser 3. Prompts y transcripts commiteados al repo.
- [Using Claude AI in Game Development (Kevuru)](https://kevurugames.com/blog/using-claude-ai-in-game-development/) - Overview general.

### Comparativas de Motores
- [Top 5 Game Engines 2026](https://blog.hitem3d.ai/blog/Top-5-Game-Engines-Compared-Unity-vs-Unreal-vs-Godot-and-More-in-2026)
- [Best 2D Game Engines 2026 (Cubix)](https://www.cubix.co/blog/best-2d-game-engines-complete-comparison-guide/)
- [Best 2D Game Engines 2026 (Pixune)](https://pixune.com/blog/best-2d-game-engines/)
- [Godot vs Phaser (ToolRadar)](https://toolradar.com/compare/godot-vs-phaser)
- [Unity vs Godot vs Unreal 2026](https://oceanviewgames.co.uk/blog/posts/unity-vs-godot-vs-unreal-2026)

### Arquitectura de Juegos
- [ECS Game Design Pattern (GameDev.net)](https://gamedev.net/tutorials/programming/general-and-gameplay-programming/the-entity-component-system-c-game-design-pattern-part-1-r4803) - ECS en C++, conceptos aplicables.
- [What is ECS (Educative)](https://www.educative.io/answers/what-is-the-ecs-design-pattern) - Introduccion al patron.

## Key Takeaways para Nuestro Proyecto

1. **Godot + Claude = buena combinacion** por archivos texto plano.
2. **Documentar cada sesion** - contexto entre sesiones es critico.
3. **Verificar siempre** - codigo que compila puede no funcionar.
4. **Pinear version Godot** en prompts para evitar confusion 3 vs 4.
5. **No sobrecomplicar** - Claude Code Game Studios es referencia, no template a copiar entero.
6. **Git desde dia 1** - diffs limpios con Godot, historial de todo.

---
*Ultima actualizacion: 2026-10-24*
