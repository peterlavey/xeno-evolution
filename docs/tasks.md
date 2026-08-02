# Task List

## Phase 1: Setup & Core Data
- [x] **Task 1.1: Define Unit Resource**
    - Description: Create a Godot `Resource` class for Alien Units.
    - Plan Link: Unit Data Structure
    - Requirement Link: Req 1
- [x] **Task 1.2: Define Hero Resource**
    - Description: Create a Godot `Resource` class for Heroes.
    - Plan Link: Hero & Power Data
    - Requirement Link: Req 4
- [x] **Task 1.3: Define Power Resource**
    - Description: Create a Godot `Resource` class for Powers/Abilities.
    - Plan Link: Hero & Power Data
    - Requirement Link: Req 5
- [x] **Task 1.4: Implement Collection Manager**
    - Description: Create an Autoload to manage the player's collection of units.
    - Plan Link: Basic Persistence
    - Requirement Link: Req 1
- [x] **Task 1.5: Create Base Visual Assets**
    - Description: Establish sprite size standards and create placeholder PNGs for units and environment.
    - Plan Link: Sprite Standard
    - Requirement Link: Req 2

## Phase 2: Combat & AI
- [x] **Task 2.1: Setup Isometric Battle Scene**
    - Description: Create a base scene with an isometric TileMap or NavigationRegion.
    - Plan Link: Isometric Grid & Navigation
    - Requirement Link: Req 2
- [x] **Task 2.2: Implement Base Unit AI**
    - Description: Create a state machine for automatic movement and target seeking.
    - Plan Link: Unit AI (Melee/Ranged)
    - Requirement Link: Req 2
- [x] **Task 2.3: Implement Melee/Ranged Attack Logic**
    - Description: Specific behaviors for different unit types.
    - Plan Link: Unit AI (Melee/Ranged)
    - Requirement Link: Req 2
- [x] **Task 2.4: Combat Health & Damage System**
    - Description: Logic for units taking damage and dying.
    - Plan Link: Combat Logic
    - Requirement Link: Req 2

## Phase 3: World & Progression
- [ ] **Task 3.1: Country Data & Map UI**
    - Description: Create Resources for countries and a simple map interface.
    - Plan Link: World Map UI
    - Requirement Link: Req 3
- [ ] **Task 3.2: Invasion Flow Logic**
    - Description: Controller for transitioning between Map, Squad Select, and Battle.
    - Plan Link: Invasion Flow
    - Requirement Link: Req 3

## Phase 4: Evolution Mechanics
- [ ] **Task 4.1: Hero Abduction UI**
    - Description: Screen shown after victory to select a hero for abduction.
    - Plan Link: Abduction Sequence
    - Requirement Link: Req 4
- [ ] **Task 4.2: Power Extraction Logic**
    - Description: RNG-based system for succeeding in stealing a power.
    - Plan Link: Evolution System
    - Requirement Link: Req 5
- [ ] **Task 4.3: Unit Evolution UI**
    - Description: Interface to apply a stolen power to a specific unit.
    - Plan Link: Evolution System
    - Requirement Link: Req 5
