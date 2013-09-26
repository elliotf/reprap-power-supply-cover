psu_length = 215;
psu_width = 114;
psu_height = 50;
psu_terminal_inset = 17;
psu_terminal_width = 110;
psu_terminal_height = 25;

psu_mount_hole_spacing_width = 50;
psu_mount_hole_spacing_length = 150;
psu_mount_hole_spacing_from_end = 32.5;
psu_mount_hole_spacing_from_side = 32;

psu_hole_from_end = 33;
psu_hole_spacing = 25;
psu_hole_from_top = 13;

hole_diam = 3.5;

clearance = .5; // reduce clearance from .5; it's too much

wall_thickness = 2;

total_width = psu_width + clearance * 2 + wall_thickness * 2;
inner_width = total_width - wall_thickness * 2;

total_height = psu_height + clearance * 2 + wall_thickness * 2;
inner_height = total_height - wall_thickness * 2;

depth = 22;
total_depth = depth + wall_thickness + psu_hole_from_end + hole_diam/2 + wall_thickness * 2;

switch_diam = 20.75;
wire_hole_width  = 12;
wire_hole_height = 6;

plug_width = 28;
plug_height = 31.5;

cover();
module cover() {
  % translate([wall_thickness+clearance,wall_thickness+clearance,depth+wall_thickness]) psu();
  difference() {
    cube([total_width,total_height,total_depth]);

    // mounting holes
    translate([0,0,depth + psu_hole_from_end + 2]) {
      translate([0,wall_thickness + clearance + psu_hole_from_top,0]) rotate([0,90,0]) cylinder(r=2, h=psu_width * 4, center=true, $fn=6);
      translate([0,wall_thickness + clearance + psu_hole_from_top + psu_hole_spacing,0]) rotate([0,90,0]) cylinder(r=2, h=psu_width * 4, center=true, $fn=6);
    }

    // plug hole
    translate([total_width - wall_thickness * 3 - plug_height, wall_thickness*3, -1]) cube([plug_height,plug_width,psu_length]);

    // switch hole
    translate([switch_diam/2+wall_thickness*6,switch_diam/2+wall_thickness*4,-1]) cylinder(r=switch_diam/2,$fn=32,h=psu_length);
    translate([switch_diam/2+wall_thickness*6,wall_thickness*4,-1]) cube([2.25,2,psu_length],center=true);

    // wire hole
    translate([wall_thickness,total_height-wire_hole_width-wall_thickness*5,-1]) cube([wire_hole_height,wire_hole_width,psu_length]);

    // main cavity
    translate([wall_thickness,wall_thickness,wall_thickness]) cube([inner_width,inner_height,psu_length]);

    // shorter bottom
    translate([wall_thickness + 6,wall_thickness*4,wall_thickness*7.5+depth]) cube([inner_width - 12,inner_height,psu_length]);

    // shorter top
    translate([wall_thickness + 6,wall_thickness*-4,wall_thickness*4+depth+psu_terminal_inset]) cube([inner_width - 12,inner_height,psu_length]);

    // ventilation/material saving holes on the side
    // big holes
    //translate([0,total_height / 2, depth + psu_terminal_inset + 1]) rotate([90,0,0]) rotate([0,90,0]) cylinder(r=14, h=psu_width * 4, center=true, $fn=6);
    for(from_end=[0:6]) {
      for(from_top=[.8,.45,.1]) {
        translate([-1,inner_height*from_top-wall_thickness,wall_thickness*2+7.5*from_end]) {
          cube([psu_width*2,13,3.5]);
        }
      }
    }

    // top/bottom holes
    for(from_end=[0:4]) {
      for(from_side=[0:5]) {
        translate([wall_thickness*4+from_side*18,-1,wall_thickness*3.5+7.5*from_end]) {
          cube([13,psu_height*2,3.5]);
        }
      }
    }

    // smaller holes on the sides
    /*
    for (i=[1:3]) {
      translate([0,6 + 11 * i, 20]) rotate([90,0,0]) rotate([0,90,0]) cylinder(r=3, h=psu_width * 4, center=true, $fn=6);
    }
    for (i=[1:4]) {
      translate([0,11 * i, 9]) rotate([90,0,0]) rotate([0,90,0]) cylinder(r=3, h=psu_width * 4, center=true, $fn=6);
    }

    // smaller holes on the top/bottom
    for(h=[1:2]) {
      for (i=[1:9]) {
        translate([5 + 11 * i, 0, 16]) rotate([90,0,90]) rotate([0,90,0]) cylinder(r=3, h=psu_width * 4, center=true, $fn=6);
        translate([5 + 11 * i, 0, 36]) rotate([90,0,90]) rotate([0,90,0]) cylinder(r=3, h=psu_width * 4, center=true, $fn=6);
      }
      for (i=[1:10]) {
        translate([-1 + 11 * i, 0, 26]) rotate([90,0,90]) rotate([0,90,0]) cylinder(r=3, h=psu_width * 4, center=true, $fn=6);
        translate([-1 + 11 * i, 0, 6]) rotate([90,0,90]) rotate([0,90,0]) cylinder(r=3, h=psu_width * 4, center=true, $fn=6);
      }
    }
    */

    // smaller holes on the end
    for(h=[0:1]) {
      for(n=[0:5]) {
        translate([switch_diam+wall_thickness*8+7*n,wall_thickness*3+h*(total_height/2-wall_thickness),-1]) cube([4,total_height/2-wall_thickness*4,psu_length]);
      }
    }
  }
}

module plug_hole() {
}

module switch_hole() {
}

//psu();
module psu() {
  difference() {
    cube([psu_width,psu_height,psu_length]);
    translate([(psu_width - psu_terminal_width) / 2, -1, -1]) cube([psu_terminal_width,psu_terminal_height + 1,psu_terminal_inset + 1]);

    // cover mounting holes
    translate([0,psu_hole_from_top,psu_hole_from_end]) rotate([0,90,0]) cylinder(h=psu_width * 2,r=hole_diam/2, center=true);
    translate([0,psu_hole_from_top + psu_hole_spacing,psu_hole_from_end]) rotate([0,90,0]) cylinder(h=psu_width * 2,r=hole_diam/2, center=true);

    // psu mounting holes (terminal side)
    translate([psu_mount_hole_spacing_from_side,0,psu_mount_hole_spacing_from_end]) rotate([90,0,0]) cylinder(h=psu_width * 2,r=hole_diam/2, center=true);
    translate([psu_mount_hole_spacing_from_side + psu_mount_hole_spacing_width,0,psu_mount_hole_spacing_from_end]) rotate([90,0,0]) cylinder(h=psu_width * 2,r=hole_diam/2, center=true);

    // psu mounting holes (blank side)
    translate([psu_mount_hole_spacing_from_side,0,psu_mount_hole_spacing_from_end + psu_mount_hole_spacing_length]) rotate([90,0,0]) cylinder(h=psu_width * 2,r=hole_diam/2, center=true);
    translate([psu_mount_hole_spacing_from_side + psu_mount_hole_spacing_width,0,psu_mount_hole_spacing_from_end + psu_mount_hole_spacing_length]) rotate([90,0,0]) cylinder(h=psu_width * 2,r=hole_diam/2, center=true);
  }
}
