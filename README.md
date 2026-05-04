# Adaptive Parametric Wardrobe System (OpenSCAD)

## Overview
This project is a parametric wardrobe system developed using OpenSCAD.  
It dynamically generates wardrobe layouts based on available room width, preferred module sizes, and fabrication constraints.

## Key Features
- Auto-scaling layout engine
- Dynamic module distribution
- Remainder-based shelf logic
- Parametric drawers, doors, and handles
- Fabrication-aware dimensions

## How It Works
The system calculates:
- Number of standard wardrobe units
- Remaining space
- Whether to introduce a shelf unit or redistribute dimensions

All geometry is generated from adjustable parameters.

## Usage

1. Open the `.scad` file in OpenSCAD
2. Modify the parameters at the top:

```
room_width = 4000;
target_module_width = 900;
handle_style = "bar";
```

3. Press F5 (Preview) or F6 (Render)

## Example Scenarios

| Room Width | Behaviour |
|-----------|----------|
| 3600      | Perfect modular fit |
| 4000      | Includes shelf remainder |
| 2500      | Scales modules proportionally |

## Author
Timothy Okibe Ogese  
Computational Design Engineer | BIM & Parametric Systems Specialist
