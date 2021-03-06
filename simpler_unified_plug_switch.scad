include <common.scad>;
include <util.scad>;

extrusion_width      = 0.5;
extrusion_height     = 0.34;

spacer            = 0.5;
plug_width        = 27   + spacer;
plug_length       = 47.5 + spacer;

module plug_hole() {
  plug_angle_length = 8;
  plug_angle_offset = sqrt(pow(plug_angle_length,2)/2);
  plug_hole_spacing = 40;
  plug_hole_offset  = 1.4;
  hole_height       = 20;

  // mounting holes
  for (side=[front,rear]) {
    translate([plug_hole_offset,plug_hole_spacing/2*side,0]) {
      hole(4,hole_height,16);
    }
  }

  hull() {
    translate([plug_length/4,0,0]) {
      cube([plug_length/2,plug_width,hole_height],center=true);
    }

    // angled corners on plug side
    for (side=[1,-1]) {
      translate([-plug_length/2+plug_angle_offset,(plug_width/2-plug_angle_offset)*side,0]) {
        hole(plug_angle_length,hole_height,4);
      }
    }
  }
}

module cover() {
  spacer               = 0.2;
  dist_from_psu_to_end = 30;
  plug_dist_from_side  = 7;

  thick_wall_thickness = extrusion_width  * 4;
  thin_wall_thickness  = extrusion_width  * 2;
  end_thickness        = extrusion_height * 6;

  cavity_width  = psu_width  + spacer;
  cavity_height = psu_height + spacer;
  cavity_length = dist_from_psu_to_end + side_mount_hole_from_end + mount_hole_diam/2 + end_thickness * 2;

  side_mount_hole_from_end = 33;
  side_mount_hole_spacing  = 25;
  side_mount_hole_from_top = 13;

  wire_hole_width  = 6;
  wire_hole_height = 12;
  wire_hole_pos_y  = wire_hole_height/2;

  zip_tie_hole_width   = 2;
  zip_tie_hole_height  = 3;
  zip_tie_hole_spacing = 8;

  module body() {
    width  = cavity_width  + thick_wall_thickness * 2;
    height = cavity_height + thin_wall_thickness * 2;

    translate([0,0,cavity_length/2-end_thickness/2]) {
      cube([width,height,cavity_length+end_thickness],center=true);

      // reinforced corners
      for(side=[left,right]) {
        for(end=[front,rear]) {
          hull() {
            translate([width/2*side,(height/2-thick_wall_thickness)*end,0]) {
              rotate([0,0,22.5/2]) {
                hole(thick_wall_thickness*2,cavity_length+end_thickness,16);
              }
            }
            translate([width*.4*side,0,0]) {
              hole(thick_wall_thickness*2,cavity_length+end_thickness,16);
            }
          }
        }
      }
    }

    // reinforced zip tie hole
    reinforcement_height = 20;
    hull() {
      translate([left*(width/2),wire_hole_pos_y,reinforcement_height/2-end_thickness]) {
        hole(thick_wall_thickness*2,reinforcement_height-end_thickness*2,16);
        translate([thick_wall_thickness/2,0,0]) {
          cube([thick_wall_thickness,zip_tie_hole_spacing-zip_tie_hole_width,reinforcement_height],center=true);
        }
      }
    }
  }

  module holes() {
    // main cavity
    translate([0,0,cavity_length]) {
      cube([cavity_width,cavity_height,cavity_length*2],center=true);
    }

    // mount holes
    for(side=[front,rear]) {
      translate([0,side_mount_hole_spacing/2*side,dist_from_psu_to_end+side_mount_hole_from_end]) {
        rotate([0,90,0]) {
          hull() {
            translate([0,1*side,0]) {
              rotate([0,0,22.5]) {
                hole(mount_hole_diam,cavity_width*2,8);
              }
            }
            translate([0,.5*-side,0]) {
              rotate([0,0,22.5]) {
                hole(mount_hole_diam,cavity_width*2,8);
              }
            }
          }
        }
      }
    }

    // plug
    translate([cavity_width/2-plug_length/2-plug_dist_from_side,0,0]) {
      scale([1,1,10]) {
        plug_hole();
      }
    }

    // wire retainer/hole
    translate([left*(cavity_width/2-wire_hole_width/2-0),wire_hole_height/2,0]) {
      hull() {
        for(side=[front,rear]) {
          translate([0,side*(wire_hole_height/2-wire_hole_width/2),0]) {
            rotate([0,0,22.5/4]) {
              hole(wire_hole_width,cavity_length,32);
            }
          }
        }
      }

      for(side=[front,rear]) {
        translate([0,(zip_tie_hole_spacing/2)*side,end_thickness+1.5]) {
          hull() {
            rotate([0,90,0]) {
              rotate([0,0,22.5]) {
                hole(zip_tie_hole_width,cavity_height,8);
              }
            }
            translate([0,0,zip_tie_hole_height-zip_tie_hole_width]) {
              rotate([0,90,0]) {
                rotate([0,0,22.5]) {
                  hole(zip_tie_hole_width,cavity_height,8);
                }
              }
            }
          }
        }
      }
    }

    // vent holes
    hole_from_top_bottom = 5;
    hole_length = total_height-wall_thickness*2-hole_from_top_bottom*2;
    hole_width  = 4;
    hole_space_between = 6;
    hole_spacing = hole_width + hole_space_between;

    for(i=[0:4]) {
      translate([i*-hole_spacing-hole_width-1,0,end_thickness/2]) {
        cube([hole_width,hole_length,cavity_length/2],center=true);
      }
    }

    // material savings and mount hole access
    material_saving = 18;
    hull() {
      translate([0,0,cavity_length]) {
        cube([cavity_width-18*2,cavity_height*2,18*2],center=true);

        translate([0,0,1]) {
          cube([cavity_width,cavity_height*2,2],center=true);
        }
      }
    }
  }

  translate([0,0,end_thickness]) {
    difference() {
      body();
      holes();
    }
  }
}

module spacer() {
  spacer_height   = extrusion_height * 7;
  inner_diam      = mount_hole_diam+0.25;
  outer_diam      = inner_diam + extrusion_width*9;
  extrusion_width = 0.5;

  module body() {
    hole(outer_diam,spacer_height,72);
  }

  module holes() {
    hole(inner_diam,spacer_height+1,72);
  }

  translate([0,0,spacer_height/2]) {
    difference() {
      body();
      holes();
    }
  }
}

cover();

for(i=[-.375,-.125,.125,.375]) {
  translate([psu_width*i,-psu_height*.7,0]) {
    spacer();
  }
}
