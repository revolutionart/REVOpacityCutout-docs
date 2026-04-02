# Introduction

## REVO Opacity Cutout Blender Addon

REVO Opacity Cutout converts texture masks into clean cutout geometry directly in Blender, making it easier to create game-ready foliage and decals. Built for Unreal Engine 5 workflows with Nanite in mind, it can also be used with SpeedTree and includes a Megascans-style vertex color painter for advanced wind setup on trees and vegetation.

## Main Features

- 2D / Planar Cutout mode for fast contour-based cutouts on flat cards
- 3D / Grid Mask mode for curved meshes where preserving surface flow matters
- 3D / Precise mode for high-accuracy cutouts on non-planar geometry (for example canopies)
- Built-in quality presets for quick setup and consistent results
- Optional advanced controls for contour cleanup and triangulation behavior
- Integrated vertex painter tools for RGBA foliage channel workflows
- The original source mesh is never modified. All edits are performed on a duplicate, which is marked in the Outliner with a suffix such as `_Cutout or _PreciseCut`
- One-click dependency installer from inside the panel

## N-Panel

Use the N-Panel workflow:

- Open `3D View > N-Panel > REV OpacityCutout`
- Select mask image and channel
- Choose a quality preset
- Run one of the Generate actions

### Main operators you will use

| Action | Notes |
| --- | --- |
| Generate Cutout (2D / Planar) | Main contour pipeline |
| Generate 3D Cutout (Grid Mask) | Face-sampling mode on source mesh |
| Generate 3D Precise Cut | UV clip + reprojection workflow |


## Required Dependencies

These Python packages are required for the add-on to function correctly:

| Dependency | Why it is required |
| --- | --- |
| `opencv-python` | Image processing for mask analysis and cutout preparation |
| `pyclipper` | Polygon clipping/offset operations used during contour cleanup |

Use the **Install Dependencies** button in the add-on panel to install both packages automatically if they are missing.

## Required Blender version

- Minimum supported: Blender 4.0
- Recommended: Blender 4.2+
- Add-on version: 1.0.0
- License: MIT