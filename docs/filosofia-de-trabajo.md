# Filosofia de Trabajo - GameOne

> Documento vivo. Se actualiza a medida que el proyecto evoluciona.

## Principios Fundamentales

### 1. Todo Puede Cambiar
- Nada esta definido en su totalidad. El juego se descubre mientras se construye.
- Cada decision de diseno es provisional hasta que se valide jugando.
- La arquitectura debe soportar cambios sin reescrituras masivas.

### 2. Progreso Incremental
- Features pequenas, funcionales, visibles.
- Cada iteracion debe producir algo jugable o demostrable.
- Priorizar "algo que funciona" sobre "algo perfecto".
- Ciclo: construir → probar → evaluar → iterar.

### 3. Rastreo y Trazabilidad
- Cada decision importante se documenta con su contexto y razon.
- Si algo cambia, se documenta por que cambio.
- Los docs/ son la memoria del proyecto entre sesiones.

### 4. Abstraccion Correcta (No Prematura)
- No abstraer hasta que haya al menos 2-3 casos concretos.
- Preferir composicion sobre herencia.
- Sistemas desacoplados: cambiar una parte no rompe otras.
- Si una abstraccion no se justifica hoy, no se hace hoy.

### 5. Simplicidad Primero
- Minimo codigo que resuelve el problema.
- No features especulativas.
- No "flexibilidad" que nadie pidio.
- Si 200 lineas pueden ser 50, reescribir.

## Metodologia con Claude

### Sesiones de Trabajo
- Cada sesion tiene un objetivo claro y acotado.
- Se documenta que se hizo y que quedo pendiente.
- Los docs/ sirven como contexto entre sesiones.

### Documentacion
- `docs/` = filosofia, investigacion, decisiones, roadmap.
- Archivos .md separados por tema, no un mega-documento.
- Cada doc tiene fecha de ultima actualizacion relevante.

### Codigo
- Cambios quirurgicos: solo tocar lo necesario.
- Tests antes de refactors.
- Match con estilo existente.

## Flujo de Decision

```
¿Necesito esto ahora? 
  → NO: documentar como idea futura, seguir adelante.
  → SI: ¿Es la forma mas simple de hacerlo?
    → NO: simplificar.
    → SI: implementar, testear, documentar decision.
```

## Estado del Proyecto

- **Fase actual**: Investigacion y setup inicial
- **Motor elegido**: Godot 4 (confirmado 2026-10-24)
- **Genero/Mecanicas**: Por definir
- **Plataforma target**: Por definir

---
*Ultima actualizacion: 2026-10-24*
