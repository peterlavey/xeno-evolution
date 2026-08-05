# Character Layering & Export Specification (v1.0)

## Overview
To support `Skeleton2D` rigging and `Polygon2D` mesh deformation, sprites must be separated into discrete layers.

## Layer Structure
1. **Head**: Includes face, eyes, and any headgear.
2. **Torso**: The main body segment.
3. **Arm_L_Upper / Arm_L_Lower**: Left arm segments.
4. **Arm_R_Upper / Arm_R_Lower**: Right arm segments.
5. **Leg_L_Upper / Leg_L_Lower**: Left leg segments.
6. **Leg_R_Upper / Leg_R_Lower**: Right leg segments.
7. **Special_FX**: Glows, particles, or trailing elements.

## Export Format
- **Format**: Transparent PNG-32.
- **Naming**: `[unit_name]_[layer_name].png` (e.g., `alien_warrior_head.png`).
- **Alignment**: Assets should be exported in their "rest pose" (T-pose or A-pose).
- **Padding**: Provide 5-10 pixels of overlap at joints to prevent gaps during mesh deformation.
