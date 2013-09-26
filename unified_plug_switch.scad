da6 = 1 / cos(180 / 6) / 2;

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

clearance = 0; // reduce clearance from .5; it's too much

wall_thickness = 2;
end_thickness = wall_thickness*2;

total_width = psu_width + clearance * 2 + wall_thickness * 2;
inner_width = total_width - wall_thickness * 2;

total_height = psu_height + clearance * 2 + wall_thickness * 2;
inner_height = total_height - wall_thickness * 2;

depth = 30;
total_depth = depth + wall_thickness + psu_hole_from_end + hole_diam/2 + wall_thickness * 2;

switch_diam = 20.75;
wire_hole_width  = 12;
wire_hole_height = 6;

cover();
module cover() {
  % translate([wall_thickness+clearance,wall_thickness+clearance,depth+wall_thickness]) psu();
  difference() {
    cube([total_width,total_height,total_depth]);

    // main cavity
    translate([wall_thickness,wall_thickness,end_thickness]) cube([inner_width,inner_height,psu_length]);

    // mounting holes
    translate([0,wall_thickness + psu_hole_from_top,depth + psu_hole_from_end + 2]) {
      translate([0,0,0])                rotate([90,0,0]) rotate([0,90,0]) cylinder(r=4*da6, h=psu_width * 4, center=true, $fn=6);
      translate([0,psu_hole_spacing,0]) rotate([90,0,0]) rotate([0,90,0]) cylinder(r=4*da6, h=psu_width * 4, center=true, $fn=6);
    }

    // plug hole
    translate([total_width - wall_thickness*2 - plug_height/2 - 3, psu_height/2 + 2, -1]) {
      scale([1,1,10]) rotate([0,0,180]) plug_hole();
    }

    vent_holes();

    // wire hole
    translate([wall_thickness,total_height-wire_hole_width-wall_thickness*5,-1]) cube([wire_hole_height,wire_hole_width,psu_length]);

    // shorter bottom
    translate([wall_thickness + 6,wall_thickness*4,wall_thickness*7.5+depth]) cube([inner_width - 12,inner_height,psu_length]);

    // shorter top
    translate([wall_thickness + 6,wall_thickness*-4,wall_thickness*4+depth+psu_terminal_inset]) cube([inner_width - 12,inner_height,psu_length]);

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
  }
}


plug_width = 27.5;
plug_height = 47.5;
plug_hole_from_switch_end = 22.5;
plug_hole_width = 40;

//plug_hole();
module plug_hole() {

    // mounting holes
    for (side=[1,-1]) {
      translate([-1*(plug_height/2-plug_hole_from_switch_end),plug_hole_width/2*side,0])
        cylinder(r=4/2,center=true,h=wall_thickness,$fn=6);
    }

  difference() {
    cube([plug_height,plug_width,wall_thickness],center=true);

    // angled corners on plug side
    for (side=[1,-1]) {
      translate([plug_height/2,plug_width/2*side,0]) rotate([0,0,45]) cube([8.5,8.5,wall_thickness*2],center=true);
    }
  }

}

module switch_hole() {
}

module vent_holes() {
  // ventilation/material saving holes on the side
  for(from_end=[0:6]) {
    for(from_top=[.8,.45,.1]) {
      translate([-1,inner_height*from_top-wall_thickness,wall_thickness*3.25+8*from_end]) {
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
