# Requirements Document

## Introduction
"Xeno Evolution" is a 2D isometric auto-battler where players command a force of collectible alien units to invade Earth. The core gameplay loop involves selecting a squad, attacking countries, defeating human military forces and super-powered heroes, abducting those heroes to extract their powers, and permanently evolving alien units with these new abilities to conquer increasingly difficult regions.

## 1. Unit & Card System
1. **User Story:** As a player, I want to collect and manage diverse alien units so that I can build a specialized squad for different planetary invasions.
   - **Acceptance Criteria:** WHEN viewing the collection THEN the system SHALL display each unit's name, rarity (Common to Mythic), stats (HP, Attack, Defense, Speed, Element, Attack Range, Visual Scale), and special abilities.
   - **Acceptance Criteria:** WHEN a unit is acquired THEN it SHALL be stored in a persistent collection.
   - **Acceptance Criteria:** WHEN a power is applied THEN it SHALL permanently modify the unit's attributes or behavior.
   - **Acceptance Criteria:** WHEN units are displayed in combat THEN the system SHALL respect their individual visual scaling (e.g., humans smaller than heroes).

## 2. Combat System (Auto-Battler)
2. **User Story:** As a player, I want to deploy my squad in isometric battles so that I can see my strategic preparations play out automatically.
   - **Acceptance Criteria:** WHEN a battle starts THEN units SHALL move and attack automatically based on their individual AI behaviors.
   - **Acceptance Criteria:** WHEN a melee unit is deployed THEN it SHALL seek the nearest enemy and engage in close combat.
   - **Acceptance Criteria:** WHEN a ranged unit is deployed THEN it SHALL maintain optimal distance and attack from afar.
   - **Acceptance Criteria:** WHEN all defenders (military and heroes) are defeated THEN the battle SHALL result in victory.

## 3. World Map & Countries
3. **User Story:** As a player, I want to choose which country to invade so that I can manage my progression and target specific rewards.
   - **Acceptance Criteria:** WHEN viewing the world map THEN the system SHALL show countries with specific difficulty levels, enemy types, and potential hero rewards.
   - **Acceptance Criteria:** WHEN a country is selected THEN the system SHALL display its resistance level (Army size and Hero presence) and unique powers available for extraction.

## 4. Super-Heroes & Abduction
4. **User Story:** As a player, I want to defeat and abduct super-heroes so that I can gain access to their unique powers.
   - **Acceptance Criteria:** WHEN a hero is defeated in battle THEN the system SHALL initiate an abduction sequence.
   - **Acceptance Criteria:** WHEN abducting a hero THEN the system SHALL offer a set of powers to extract based on the hero's type and rarity.

## 5. Power Extraction & Evolution
5. **User Story:** As a player, I want to extract powers from abducted heroes so that I can evolve my alien units permanently.
   - **Acceptance Criteria:** WHEN attempting extraction THEN the system SHALL calculate success based on power rarity, hero level, and alien technology upgrades.
   - **Acceptance Criteria:** WHEN an extraction is successful THEN the player SHALL be able to assign the power to a compatible alien unit permanently.
   - **Acceptance Criteria:** WHEN a power is assigned THEN the unit's metadata SHALL be updated to reflect the new ability (e.g., adding "Flight" or "Fire Resistance").
