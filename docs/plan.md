# Implementation Plan

## Goal
Establish a robust foundation for "Xeno Evolution" by implementing a data-driven unit system, an isometric auto-battle engine, and a persistent progression system based on hero power extraction.

## Phase 1: Core Data & Unit Systems
Focus on the underlying architecture for units, heroes, and powers.
- **Unit Data Structure** (Linked to Req 1): Implement `Resource`-based units (Alien, Hero, Human) with stats, rarity, and ability slots. Established technological superiority (3x stats) for Aliens vs Humans. Support visual scaling for large-scale battles. (Priority: High)
- **Hero & Power Data** (Linked to Req 4, 5): Define data structures for heroes and the powers they yield. (Priority: High)
- **Basic Persistence** (Linked to Req 1): Save/Load system for unit collection and permanent upgrades. (Priority: Medium)
- **Sprite Standard** (Linked to Req 2): Establish a consistent sprite size (64x64) and create placeholder assets for development. (Priority: High)
- **Unit Card UI (TCG Style)** (Linked to Req 1): Visual representation of units with name, image, cost, stats, and abilities. (Priority: Medium) [DONE]

## Phase 2: Isometric Combat Engine
Develop the automatic battle system.
- **Isometric Grid & Navigation** (Linked to Req 2): Basic environment for units to move in. (Priority: High)
- **Unit AI (Melee/Ranged)** (Linked to Req 2): Implement the behavior trees or state machines for automatic combat. Added organic movement variations (speed, offsets, async updates) for natural behavior. (Priority: High)
- **Combat Logic** (Linked to Req 2): Damage calculation, health management, and victory conditions. Includes visual feedback (Shader-based flash) and modular `HealthComponent` with knockback mechanics. (Priority: High) [DONE]

## Phase 3: World Map & Invasion Loop
Connect battles to the progression system.
- **World Map UI** (Linked to Req 3): Country selection and difficulty display. Permanent access to Evolution Chamber. (Priority: Medium) [DONE]
- **Invasion Flow** (Linked to Req 3): Direct country selection -> Squad selection -> Battle -> Result. (Priority: Medium) [DONE]

## Phase 4: Abduction & Evolution
The core loop of stealing and applying powers.
- **Abduction Sequence** (Linked to Req 4): Post-battle hero capture mechanics. (Priority: Medium) [DONE]
- **Evolution System** (Linked to Req 5): Interface and logic for applying extracted powers to alien units. (Priority: High) [DONE]

## Phase 5: Mobile Optimization
Adapt the game for vertical mobile devices.
- **Portrait Mode Support** (Linked to Req 2): Configure project for 720x1280 resolution and adjust combat layouts for vertical flow. (Priority: Medium) [DONE]

## Dependencies & Risks
- **Dependency**: Unit AI depends on a functional isometric navigation system.
- **Risk**: Balancing the power extraction success rates to maintain long-term engagement.
- **Risk**: Performance in auto-battles with high unit counts.
