// V4 calibration jig for Modix V4 printers, modelled by the FAST research group.
// Dimensions follow Modix's V4 calibration jig.
// SPDX-License-Identifier: MIT
//
// Bent-strap L bracket: a vertical strap with three holes, a horizontal top
// leg with a long slot, a pair of clip tabs on the side and on the back, and a
// boss around the middle hole. Origin and axes match the reference part:
// X across the strap, Y through its thickness (front face at Y = 0, top leg
// toward +Y), Z up the strap.

/* [Strap] */
// Width of the strap (X)
strap_width = 20;
// Thickness of the strap and top leg
strap_thickness = 4;
// Overall height of the strap including the top leg (Z)
strap_height = 84;
// Corner radius at the free ends of the strap and the top leg
end_corner_radius = 3;
// Outside radius of the bend between strap and top leg
bend_outer_radius = 3;
// Inside fillet radius of the bend between strap and top leg
bend_inner_radius = 3;

/* [Top leg] */
// Reach of the top leg from the strap front face (Y)
leg_length = 50;
// Slot width
slot_width = 5.4;
// Y position of the slot end nearest the strap (centre of end radius)
slot_start_y = 10;
// Y position of the far slot end (centre of end radius)
slot_end_y = 45;
// Slot centreline offset in X from the strap centreline
slot_offset_x = 0.4123;

/* [Strap holes] */
// Diameter of the bottom hole
hole_bottom_d = 5.3;
// Height of the bottom hole centre
hole_bottom_z = 10;
// Diameter of the middle hole (through the boss)
hole_middle_d = 3.6;
// Height of the middle hole centre
hole_middle_z = 24;
// Diameter of the top hole
hole_top_d = 3.4;
// Height of the top hole centre (also the symmetry plane of the tab pairs)
hole_top_z = 59.9;

/* [Boss] */
// Bottom of the boss behind the middle hole
boss_z0 = 20;
// Height of the boss (Z)
boss_height = 8;
// How far the boss stands off the strap back face (Y)
boss_depth = 4;
// Radius of the boss outer vertical edges
boss_edge_radius = 0.5;
// Fillet radius where the middle hole meets the boss face
boss_hole_fillet = 1.5;

/* [Clip tabs] */
// Clear gap between the inner faces of the upper and lower tab
tab_gap = 18.2;
// Side tab reach from the strap edge (X)
side_tab_length = 10.8;
// Side tab thickness next to the strap
side_tab_thickness = 2.2;
// Length of the thinner tip of the side tab
side_tab_tip_length = 4;
// Thickness of the side tab tip (flush with the tab outer face)
side_tab_tip_thickness = 1.2;
// Fillet radius between side tab and strap edge
side_tab_fillet = 3;
// Back tab reach from the strap back face (Y)
back_tab_depth = 7;
// Back tab thickness
back_tab_thickness = 1.2;
// Fillet radius between back tab and strap back face
back_tab_fillet = 1.5;
// Radius of the back tab outer vertical edges
back_tab_edge_radius = 0.5;

/* [Quality] */
// Minimum facet angle
$fa = 2;
// Minimum facet size
$fs = 0.2;

/* [Hidden] */
eps = 0.01;
x0 = side_tab_length;          // strap left edge
x1 = side_tab_length + strap_width; // strap right edge
xc = (x0 + x1) / 2;            // strap centreline
t = strap_thickness;
leg_z0 = strap_height - t;     // underside of the top leg

// Rectangle with the two corners on its +V side rounded (in the 2D plane).
module rounded_end_rect(size, r) {
    hull() {
        square([size[0], eps]);
        translate([r, size[1] - r]) circle(r);
        translate([size[0] - r, size[1] - r]) circle(r);
    }
}

// Concave fillet filling the corner at the 2D origin, in the +U/+V quadrant.
module fillet2d(r) {
    difference() {
        square(r);
        translate([r, r]) circle(r);
    }
}

// Run a 2D shape drawn in the (X, Z) plane, through Y from y0 to y0 + h.
module extrude_xz(y0, h) {
    translate([0, y0 + h, 0]) rotate([90, 0, 0]) linear_extrude(h) children();
}

// Run a 2D shape drawn in the (Y, Z) plane, through X from x_a to x_a + h.
module extrude_yz(x_a, h) {
    translate([x_a, 0, 0]) rotate([90, 0, 90]) linear_extrude(h) children();
}

module strap() {
    // Vertical strap, rounded at the bottom, square at the top.
    extrude_xz(0, t)
        translate([x0, strap_height]) mirror([0, 1])
            rounded_end_rect([strap_width, strap_height], end_corner_radius);
}

module top_leg() {
    translate([0, 0, leg_z0]) linear_extrude(t) difference() {
        translate([x0, 0]) rounded_end_rect([strap_width, leg_length], end_corner_radius);
        hull() for (y = [slot_start_y, slot_end_y])
            translate([xc + slot_offset_x, y]) circle(d = slot_width);
    }
}

module bend_inner_fillet() {
    extrude_yz(x0, strap_width)
        translate([t, leg_z0]) mirror([0, 1]) fillet2d(bend_inner_radius);
}

module bend_outer_round() {
    // Material to remove from the outside of the bend.
    extrude_yz(x0 - eps, strap_width + 2 * eps)
        translate([0, strap_height]) mirror([0, 1]) fillet2d(bend_outer_radius);
}

module boss() {
    translate([0, t, boss_z0]) linear_extrude(boss_height)
        translate([x0, 0]) rounded_end_rect([strap_width, boss_depth], boss_edge_radius);
}

module boss_hole_fillet() {
    // Rounded entry of the middle hole on the boss face.
    r0 = hole_middle_d / 2;
    f = boss_hole_fillet;
    translate([xc, t + boss_depth, hole_middle_z]) rotate([-90, 0, 0])
        rotate_extrude() translate([r0, 0]) mirror([0, 1]) fillet2d(f);
}

// One side tab and one back tab with their fillets, outer face at z = 0,
// growing toward +Z (toward the other tab of the pair).
module tab_set() {
    // side tab
    extrude_xz(0, t) {
        translate([side_tab_tip_length, 0])
            square([x0 - side_tab_tip_length + eps, side_tab_thickness]);
        square([side_tab_tip_length + eps, side_tab_tip_thickness]);
        translate([x0, 0]) mirror([1, 0]) mirror([0, 1]) fillet2d(side_tab_fillet);
    }
    // back tab, flush with the side tab inner face
    bz = side_tab_thickness - back_tab_thickness;
    translate([0, 0, bz]) {
        linear_extrude(back_tab_thickness)
            translate([x0, t - eps])
                rounded_end_rect([strap_width, back_tab_depth + eps], back_tab_edge_radius);
        extrude_yz(x0, strap_width)
            translate([t, 0]) mirror([0, 1]) fillet2d(back_tab_fillet);
    }
}

module tabs() {
    outer = tab_gap / 2 + side_tab_thickness;
    translate([0, 0, hole_top_z - outer]) tab_set();
    translate([0, 0, hole_top_z + outer]) mirror([0, 0, 1]) tab_set();
}

module hole_y(d, z) {
    translate([xc, -1, z]) rotate([-90, 0, 0]) cylinder(d = d, h = t + boss_depth + 2);
}

module v4_calibration_jig() {
    difference() {
        union() {
            strap();
            top_leg();
            bend_inner_fillet();
            boss();
            tabs();
        }
        bend_outer_round();
        hole_y(hole_bottom_d, hole_bottom_z);
        hole_y(hole_middle_d, hole_middle_z);
        hole_y(hole_top_d, hole_top_z);
        boss_hole_fillet();
    }
}

v4_calibration_jig();
