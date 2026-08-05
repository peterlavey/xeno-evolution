# Desglose de Sprites: Prototype Alien (Cutout Rigging)

Este documento detalla la separación de capas necesaria para el rig esquelético en Godot 4, asegurando rotaciones fluidas y sin artefactos.

## Especificaciones Generales
- **Resolución Base**: 256x256 px por pieza (aprox).
- **Formato**: PNG-32 (Transparencia total).
- **Padding**: 5-10px de margen circular en articulaciones para Mesh Deformation.

## Listado de Piezas (Layers)

| Pieza | Nombre Archivo | Z-Index | Punto de Pivote (Origen) | Notas |
| :--- | :--- | :---: | :--- | :--- |
| **Cabeza** | `alien_head.png` | 10 | Base del cuello | Incluye antenas fijas. |
| **Ojo (L/R)** | `alien_eye.png` | 11 | Centro del ojo | Para animar parpadeo/escala. |
| **Torso** | `alien_torso.png` | 0 | Centro de la cadera | Pieza central del rig. |
| **Brazo Sup. D** | `alien_arm_r_up.png` | 5 | Hombro | Conexión circular con torso. |
| **Brazo Inf. D** | `alien_arm_r_low.png` | 4 | Codo | Traslape con Brazo Sup. |
| **Mano D** | `alien_hand_r.png` | 6 | Muñeca | |
| **Brazo Sup. I** | `alien_arm_l_up.png` | -5 | Hombro | Detrás del torso. |
| **Brazo Inf. I** | `alien_arm_l_low.png` | -6 | Codo | |
| **Mano I** | `alien_hand_l.png` | -4 | Muñeca | |
| **Pierna Sup. D** | `alien_leg_r_up.png` | 2 | Cadera | |
| **Pierna Inf. D** | `alien_leg_r_low.png` | 1 | Rodilla | |
| **Pie D** | `alien_foot_r.png` | 3 | Tobillo | |
| **Pierna Sup. I** | `alien_leg_l_up.png` | -2 | Cadera | |
| **Pierna Inf. I** | `alien_leg_l_low.png` | -3 | Rodilla | |
| **Pie I** | `alien_foot_l.png` | -1 | Tobillo | |

## Guía de Traslape (Overlapping)
- **Articulaciones**: Los extremos de las piezas (codos, rodillas, hombros) deben terminar en una forma **semicircular**.
- **Máscara de Recorte**: No usar bordes duros en las uniones; el color debe extenderse un poco más allá del punto de rotación para que al girar no se vea el "hueco" del hueso.

## Jerarquía de Nodos Sugerida (Godot)
1. `Skeleton2D`
   - `Hip` (Bone2D) -> `Torso`
     - `Chest` (Bone2D) -> `Head`
     - `Shoulder_R` -> `Arm_R_Up` -> `Arm_R_Low` -> `Hand_R`
     - `Shoulder_L` -> `Arm_L_Up` -> `Arm_L_Low` -> `Hand_L`
     - `Thigh_R` -> `Leg_R_Up` -> `Leg_R_Low` -> `Foot_R`
     - `Thigh_L` -> `Leg_L_Up` -> `Leg_L_Low` -> `Foot_L`
