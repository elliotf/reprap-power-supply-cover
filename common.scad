// adjust these numbers as necessary
psu_length = 215;
psu_width = 114;
psu_height = 50;

// screw terminals
screw_terminal_inset = 17;
screw_terminal_width = 110;
screw_terminal_height = 25;

// large mount holes on the bottom of the PSU
bottom_mount_hole_spacing_width = 50;
bottom_mount_hole_spacing_length = 150;
bottom_mount_hole_spacing_from_end = 32.5;
bottom_mount_hole_spacing_from_side = 32;

side_mount_hole_from_end = 33;
side_mount_hole_spacing = 25;
side_mount_hole_from_top = 13;

mount_hole_diam = 3.5;

// Don't make this too thin; plug insertion/removal puts a fair amount of strain on the part
wall_thickness = 2;
end_thickness = wall_thickness*2;

total_width = psu_width + wall_thickness * 2;
total_height = psu_height + wall_thickness * 2;

// How far the end of the cover should be from the end of the PSU.
// This is to leave room for the plug and cables.
cavity_depth = 10;

function get_total_depth(cavity) = cavity + end_thickness + side_mount_hole_from_end + mount_hole_diam/2 + wall_thickness * 2;

wire_hole_width  = 12;
wire_hole_height = 6;

da6 = 1 / cos(180 / 6) / 2;

module vent_holes() {
  // ventilation/material saving holes on the side
  for(from_end=[0:6]) {
    for(from_top=[.8,.45,.1]) {
      translate([-1,psu_height*from_top-wall_thickness,wall_thickness*3.25+8*from_end]) {
        cube([psu_width*2,13,4]);
      }
    }
  }

  // top/bottom holes
  for(from_end=[0:5]) {
    for(from_side=[0:5]) {
      translate([wall_thickness*4+from_side*17.7,-1,wall_thickness*2.5+8*from_end]) {
        cube([13.5,psu_height*2,4]);
      }
    }
  }

  // smaller holes on the end
  for(h=[0]) {
    for(n=[0:5]) {
      translate([wall_thickness*6+8.5*n,wall_thickness*3+h*(total_height/2-wall_thickness),-1])
        cube([4,total_height-wall_thickness*6,psu_length]);
    }
  }
}

module psu() {
  translate([-psu_width/2,-psu_height/2,0])
  difference() {
    cube([psu_width,psu_height,psu_length]);
    translate([(psu_width - screw_terminal_width) / 2, -1, -1]) cube([screw_terminal_width,screw_terminal_height + 1,screw_terminal_inset + 1]);

    // cover mounting holes
    translate([0,side_mount_hole_from_top,side_mount_hole_from_end]) rotate([0,90,0]) cylinder(h=psu_width * 2,r=mount_hole_diam/2, center=true);
    translate([0,side_mount_hole_from_top + side_mount_hole_spacing,side_mount_hole_from_end]) rotate([0,90,0]) cylinder(h=psu_width * 2,r=mount_hole_diam/2, center=true);

    // psu mounting holes (terminal side)
    translate([bottom_mount_hole_spacing_from_side,0,bottom_mount_hole_spacing_from_end]) rotate([90,0,0]) cylinder(h=psu_width * 2,r=mount_hole_diam/2, center=true);
    translate([bottom_mount_hole_spacing_from_side + bottom_mount_hole_spacing_width,0,bottom_mount_hole_spacing_from_end]) rotate([90,0,0]) cylinder(h=psu_width * 2,r=mount_hole_diam/2, center=true);

    // psu mounting holes (blank side)
    translate([bottom_mount_hole_spacing_from_side,0,bottom_mount_hole_spacing_from_end + bottom_mount_hole_spacing_length]) rotate([90,0,0]) cylinder(h=psu_width * 2,r=mount_hole_diam/2, center=true);
    translate([bottom_mount_hole_spacing_from_side + bottom_mount_hole_spacing_width,0,bottom_mount_hole_spacing_from_end + bottom_mount_hole_spacing_length]) rotate([90,0,0]) cylinder(h=psu_width * 2,r=mount_hole_diam/2, center=true);
  }
}
