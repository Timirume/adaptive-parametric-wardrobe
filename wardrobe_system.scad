// DESCRIPTION:
// Adaptive wardrobe system that automatically scales based on room width.
// Includes intelligent module distribution, remainder handling, and ergonomic hardware placement.
//
// All dimensions in millimetres.
// =========================================================================
// PROJECT: ADAPTIVE PARAMETRIC WARDROBE SYSTEM
// ARCHITECT: Timothy Okibe Ogese
// FEATURES: Auto-Scaling, Unified Top Panel, Ergonomic Hardware
// =========================================================================

// --- 1. USER INPUTS (The "Dashboard") ---
room_width            = 4000;   // Total available space
target_module_width   = 900;    // Desired width per wardrobe unit
handle_style          = "bar";  // "bar" or "knob"

// --- 2. SYSTEM CONSTANTS ---
total_height      = 2400;
depth             = 600;
thickness         = 18;         
plinth_h          = 100;        
drawer_zone_h     = 800;        
upper_zone_h      = 600;        
gap               = 2;          

// --- 3. HARDWARE MODULE (Refined Logic) ---
module handle_bar(len=150, thick=12, orientation="vertical") {
    color([0.7, 0.5, 0.2]) { // Metallic Gold
        if (orientation == "horizontal") {
            cube([len, thick, thick], center=true);
        } else { 
            cube([thick, thick, len], center=true);
        }
    }
}

// --- 4. SUB-ASSEMBLY MODULES ---
module carcass(w) {
    color([0.8, 0.7, 0.6]) {
        difference() {
            cube([w, depth, total_height - plinth_h]);
            translate([thickness, -1, thickness])
                cube([w - thickness*2, depth - thickness + 5, total_height]);
        }
    }
}

module door_pair(w, h, z_offset, handle_pos="center") {
    color([0.95, 0.95, 0.95], 0.9) {
        door_w = (w/2) - (gap*1.5);
        // UX Logic: Upper units get low handles for reachability
        h_z = (handle_pos == "low") ? 100 : h/2;

        translate([gap, -thickness, z_offset + gap]) {
            cube([door_w, thickness, h - gap*2]);
            translate([door_w - 25, -15, h_z]) handle_bar(150, 12, "vertical");
        }
        translate([door_w + gap*2, -thickness, z_offset + gap]) {
            cube([door_w, thickness, h - gap*2]);
            translate([25, -15, h_z]) handle_bar(150, 12, "vertical");
        }
    }
}

module smart_unit(w, type="wardrobe") {
    carcass(w);
    if (type == "wardrobe") {
        for(d = [0:2]) { // Drawer Logic
            d_h = drawer_zone_h / 3;
            translate([gap, -thickness, (d * d_h) + gap])
                color("white") cube([w - gap*2, thickness, d_h - gap*2]);
            // Horizontal Drawer Handles
            translate([w/2, -thickness - 15, (d * d_h) + d_h * 0.75]) 
                handle_bar(150, 12, "horizontal");
        }
        mid_door_h = total_height - plinth_h - drawer_zone_h - upper_zone_h;
        door_pair(w, mid_door_h, drawer_zone_h, "center");
        door_pair(w, upper_zone_h, total_height - plinth_h - upper_zone_h, "low"); 
    } else { // Shelf Logic
        for(s = [1:5]) {
            translate([thickness, 10, s * ((total_height-plinth_h)/6)]) 
                color("white") cube([w-thickness*2, depth-20, thickness]);
        }
    }
}

// --- 5. THE ENGINE & FINAL ASSEMBLY ---
num_main_units = max(1, floor(room_width / target_module_width));
leftover       = room_width % target_module_width;
has_shelf      = (leftover >= 300) ? 1 : 0;
actual_w       = has_shelf ? target_module_width : (room_width / num_main_units);

translate([0, 0, plinth_h]) {
    // Plinth & Top Panel
    color([0.2, 0.2, 0.2]) translate([0, 50, -plinth_h]) cube([room_width, depth-50, plinth_h]);
    color([0.8, 0.7, 0.6]) translate([0, 0, total_height - plinth_h]) cube([room_width, depth, thickness]);

    for (i = [0 : num_main_units - 1]) {
        translate([i * actual_w, 0, 0]) smart_unit(actual_w, "wardrobe");
    }
    if (has_shelf) {
        translate([num_main_units * actual_w, 0, 0]) smart_unit(leftover, "shelves");
    }
}
