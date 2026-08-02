# Task List

## Phase 1: Setup & Core Data
- [x] **Task 1.1: Define Unit Resource**
    - Description: Create a Godot `Resource` class for Alien Units. Includes `attack_range` and `visual_scale` stats.
    - Plan Link: Unit Data Structure
    - Requirement Link: Req 1
- [x] **Task 1.2: Define Hero & Human Resources**
    - Description: Create Godot `Resource` classes for Heroes and Human Soldiers. Includes `visual_scale` for army size simulation.
    - Plan Link: Hero & Power Data
    - Requirement Link: Req 4
- [x] **Task 1.3: Define Power Resource**
    - Description: Create a Godot `Resource` class for Powers/Abilities.
    - Plan Link: Hero & Power Data
    - Requirement Link: Req 5
- [x] **Task 1.4: Implement Collection Manager**
    - Description: Create an Autoload to manage the player's collection of units and fix persistence issues using `CollectionData`.
    - Plan Link: Basic Persistence
    - Requirement Link: Req 1
- [x] **Task 1.5: Create Base Visual Assets**
    - Description: Establish sprite size standard (64x64) and create placeholder PNGs for units and environment.
    - Plan Link: Sprite Standard
    - Requirement Link: Req 2

## Phase 2: Combat & AI
- [x] **Task 2.1: Setup Isometric Battle Scene**
    - Description: Create a base scene with an isometric TileMap or NavigationRegion. Supports large battles (60+ units).
    - Plan Link: Isometric Grid & Navigation
    - Requirement Link: Req 2
- [x] **Task 2.2: Implement Base Unit AI**
    - Description: Create a state machine for automatic movement and target seeking. Includes Kiting, fixed sprite paths, and fixed unused parameter warnings.
    - Plan Link: Unit AI (Melee/Ranged)
    - Requirement Link: Req 2
- [x] **Task 2.3: Implement Melee/Ranged Attack Logic**
    - Description: Specific behaviors for different unit types, including projectile system.
    - Plan Link: Unit AI (Melee/Ranged)
    - Requirement Link: Req 2
- [x] **Task 2.4: Combat Health & Damage System**
    - Description: Implemented modular `HealthComponent` with signals, knockback, and Shader-based white flash effect.
    - Plan Link: Combat Logic
    - Requirement Link: Req 2

## Phase 3: World & Progression
- [x] **Task 3.1: Country Data & Map UI**
    - Description: Create Resources for countries and a simple map interface. Always-visible Evolution button and direct invasion start.
    - Plan Link: World Map UI
    - Requirement Link: Req 3
- [x] **Task 3.2: Invasion Flow Logic**
    - Description: Controller for transitioning between Map, Squad Select, and Battle. Removed intermediate confirmation button.
    - Plan Link: Invasion Flow
    - Requirement Link: Req 3

## Phase 4: Evolution Mechanics
- [x] **Task 4.1: Hero Abduction UI**
    - Description: Screen shown after victory to select a hero for abduction.
    - Plan Link: Abduction Sequence
    - Requirement Link: Req 4
- [x] **Task 4.2: Power Extraction Logic**
    - Description: RNG-based system for succeeding in stealing a power.
    - Plan Link: Evolution System
    - Requirement Link: Req 5
- [x] **Task 4.3: Unit Evolution UI**
    - Description: Interface to apply a stolen power to a specific unit.
    - Plan Link: Evolution System
    - Requirement Link: Req 5

## Phase 5: Mobile Optimization
- [x] **Task 5.1: Configure Portrait Orientation**
    - Description: Set window resolution to 720x1280 and set orientation to portrait in project.godot.
    - Plan Link: Portrait Mode Support
    - Requirement Link: Req 2
- [x] **Task 5.2: Adjust Battle Scene for Vertical Layout**
    - Description: Reposition units and camera for top-down vertical combat flow. Player units (Aliens) spawn at bottom, enemies (Humans) at top.
    - Plan Link: Portrait Mode Support
    - Requirement Link: Req 2
