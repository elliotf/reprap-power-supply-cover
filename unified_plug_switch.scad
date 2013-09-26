include <common.scad>;

cavity_depth = 30;

plug_width = 27.5;
plug_height = 47.5;
plug_hole_from_switch_end = 22.5;
plug_hole_width = 40;

cover();
module cover() {
  % translate([0,0,cavity_depth+end_thickness]) psu(); // FIXME: should be by end_thickness, not wall_thickness
  translate([-total_width/2,-total_height/2,0])
  difference() {
    cube([total_width,total_height,get_total_depth(cavity_depth)]);

    // main cavity
    translate([wall_thickness,wall_thickness,end_thickness]) cube([psu_width,psu_height,psu_length]);

    // mounting holes
    translate([0,wall_thickness + side_mount_hole_from_top,cavity_depth + side_mount_hole_from_end + end_thickness]) {
      translate([0,0,0])                rotate([90,0,0]) rotate([0,90,0]) cylinder(r=4*da6, h=psu_width * 4, center=true, $fn=6);
      translate([0,side_mount_hole_spacing,0]) rotate([90,0,0]) rotate([0,90,0]) cylinder(r=4*da6, h=psu_width * 4, center=true, $fn=6);
    }

    // plug hole
    translate([total_width - wall_thickness*2 - plug_height/2 - 3, psu_height/2 + 2, -1]) {
      scale([1,1,10]) rotate([0,0,180]) plug_hole();
    }

    vent_holes();

    // wire hole
    translate([wall_thickness,total_height-wire_hole_width-wall_thickness*5,-1]) cube([wire_hole_height,wire_hole_width,psu_length]);

    // shorter bottom
    translate([wall_thickness + 6,wall_thickness*4,wall_thickness*7.5+cavity_depth]) cube([psu_width - 12,psu_height,psu_length]);

    // shorter top
    translate([wall_thickness + 6,wall_thickness*-4,wall_thickness*4+cavity_depth+screw_terminal_inset]) cube([psu_width - 12,psu_height,psu_length]);
  }
}

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
