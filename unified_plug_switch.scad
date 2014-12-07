include <common.scad>;

cavity_depth = 30;
total_depth = get_total_depth(cavity_depth);

plug_width = 27.5;
plug_height = 47.5;
plug_hole_from_switch_end = 22.5;
plug_hole_width = 40;

top_bottom_support_width = 6;
side_support_width = 5;
top_shortness = screw_terminal_inset;
bottom_shortness = cavity_depth-wall_thickness;

module topbottom_vent_holes() {
  hole_width = 9;
  hole_height = 5;
  space_between_across = 9.5;
  space_between_down = 5;
  spacing_across = space_between_across + hole_width;
  spacing_down = space_between_down + hole_height;
  total_avail_across = psu_width - top_bottom_support_width*2;
  total_avail_down = total_depth - cavity_depth - end_thickness*2;

  num_holes_across = floor((total_avail_across+space_between_across) / spacing_across);
  num_holes_down = floor((total_avail_down+space_between_down)/spacing_down);

  echo(num_holes_down);

  is_odd = num_holes_across % 2;
  start_index = 1 - is_odd;

  function get_x(index) = (start_index*spacing_across/2+((index-start_index)*spacing_across));
  function get_z(index) = end_thickness+hole_height/2+wall_thickness+spacing_down*index;

  /*
  for(side=[left,right]) {
    for(x=[start_index:floor(num_holes_across/2)]) {
      for(z=[0:num_holes_down-1]) {
        translate([side*get_x(x),0,get_z(z)])
          cube([hole_width,total_height+1,hole_height],center=true);
      }
    }
  }
  */
}

module side_vent_holes() {
  hole_width = 7;
  hole_height = 5;
  space_between_across = 9.5;
  space_between_down = 5;
  spacing_across = space_between_across + hole_width;
  spacing_down = space_between_down + hole_height;
  total_avail_across = total_height - side_support_width*2;
  total_avail_down = total_depth - end_thickness*3 - mount_hole_diam - hole_height;

  num_holes_across = floor((total_avail_across+space_between_across) / spacing_across);
  num_holes_down = floor((total_avail_down+space_between_down)/spacing_down);

  echo(num_holes_down);

  is_odd = num_holes_across % 2;
  start_index = 1 - is_odd;

  function get_y(index) = (start_index*spacing_across/2+((index-start_index)*spacing_across));
  function get_z(index) = end_thickness+hole_height+wall_thickness+spacing_down*index;

  /*
  for(side=[left,right]) {
    for(y=[start_index:floor(num_holes_across/2)]) {
      for(z=[0:num_holes_down-1]) {
        translate([0,side*get_y(y),get_z(z)])
          cube([total_width+1,hole_width,hole_height],center=true);
      }
    }
  }
  */
}

module end_vent_holes() {
  hole_length = total_height-wall_thickness*2-side_support_width*2;
  hole_width  = 4;
  hole_space_between = 6;
  hole_spacing = hole_width + hole_space_between;

  for(i=[0:4]) {
    translate([i*-hole_spacing-hole_width,0,end_thickness/2])
      cube([hole_width,hole_length,end_thickness+1],center=true);
  }
}

cover();
module cover() {
  plug_wall_space = 5;

  difference() {
    translate([0,0,total_depth/2])
      cube([total_width,total_height,total_depth],center=true);

    // main cavity
    translate([0,0,end_thickness+total_depth/2])
      cube([psu_width,psu_height,total_depth],center=true);

    mount_holes();

    translate([0,0,total_depth]) {
      // material saving top
      translate([0,-psu_height/2,0])
        cube([psu_width - top_bottom_support_width*2,wall_thickness*3,top_shortness*2],center=true);

      // material saving bottom
      translate([0,psu_height/2,0])
        cube([psu_width - top_bottom_support_width*2,wall_thickness*3,bottom_shortness*2],center=true);
    }

    topbottom_vent_holes();
    side_vent_holes();
    end_vent_holes();

    // plug
    translate([total_width/2-wall_thickness-plug_height/2-plug_wall_space,0,0])
      scale([1,1,10]) rotate([0,0,180]) plug_hole();

    // wire hole
    translate([-total_width/2+wall_thickness+wire_hole_height/2,total_height/4-wire_hole_width/2,end_thickness/2])
      cube([wire_hole_height,wire_hole_width,end_thickness+1],center=true);
  }
}

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
