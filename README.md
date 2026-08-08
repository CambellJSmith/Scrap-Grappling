# scrap_grappling

A Godot 4.6 incremental construction prototype about scraplings building an enormous machine.

## current prototype

The prototype includes:

- physical-looking scrapling swarm rendering with tiny procedural pixel art
- iron, nickel, cobalt, wood, knowledge, and electronics production chains
- houses that increase population capacity and automatically attract new scraplings
- training infrastructure that converts general scraplings into specialized jobs
- a university and research progression leading into advanced metallurgy and electronics
- machine construction stages that consume manufactured components and visualize them being thrown at the machine
- modular simulation systems separated from world rendering and UI
- data-driven buildings, recipes, training, research, and machine stages
- no Godot signals; UI buttons use `BaseButton._pressed()` and direct method calls

## godot version

Targeted at Godot 4.6.x. The project uses a 640x360 viewport, integer viewport scaling, nearest filtering, and pixel-snapped 2D transforms for crisp pixel art.

## architecture

- `scripts/data/` contains IDs and reusable definition structures.
- `scripts/simulation/` contains deterministic game state and progression systems.
- `scripts/world/` contains procedural pixel-art visualization only.
- `scripts/ui/` contains Control-based interface panels and reusable action buttons.
- `scripts/util/` contains stateless helpers.

The simulation intentionally does not depend on world nodes or UI nodes. This keeps systems independently reusable and makes later save/load, offline progression, and performance-oriented rendering easier to add.
