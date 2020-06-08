include <./key_hole.scad>
include <./arc.scad>

$fn=100;

h=base_h;

planck=0;
numpad= true;
double_row = false;
grip = false;
ergo=false;
x_spacing=0.1;
y_spacing=0.1;

module straight_row( count = 5, grip = false, key_spacing = pcb_outer_l, width = pcb_outer_l ) {
  s=-(count/2)+0.5;
  e=s+count-1;
  difference() {
    translate([0,0,h/2])
    cube([width,count*(key_spacing+x_spacing),h],true);
    union() {
      for(i=[s:e]) {
        translate([0,i*key_spacing,0])
        key_hole( grip, x_spacing, y_spacing );
      }
    }
  }
}


if (false) {
for (i=[-1,1]) {
  for (j=[-1,1]){
    color([0,0,1])
    translate([i*(pcb_outer_l+x_spacing)/2,((j*2)+i)*(pcb_outer_l+y_spacing)/2,base_h/2])
    cube([(pcb_outer_l+x_spacing), (pcb_outer_l+y_spacing), base_h], true);
  }
}
}

if (double_row) {
  straight_row(2, grip);
}

if (planck > 0) {
  // Right
  for (i = [0:4]) {
    translate([pcb_outer_l*i,0,0])
    straight_row(planck);
  }

  // Middle
  for (i = [5:6]) {
    translate([pcb_outer_l*i, -pcb_outer_l/2,0])
    straight_row(planck-1);
  }
  translate([pcb_outer_l*5.5, pcb_outer_l * 2, 0])
  key_2U( false, x_spacing,y_spacing);

  // Left
  for (i = [7:11]) {
    translate([pcb_outer_l*i,0,0])
    straight_row(planck);
  }
}

if (numpad) {
  mcu_y=19;
  cr=2.1;
  mcu_x=36;
  mcu_z=15;

  mcu_hole=3/2;
  w=(pcb_outer_l+x_spacing)*4;
  h=(pcb_outer_l+y_spacing)*5;
  mcu_hole_x=(w/2)-10;
  mcu_hole_x_offset=12.7;
  mcu_hole_z=2.54*2;

  difference() {
    union() {
      translate([-1.5*pcb_outer_l, mcu_y/2,0])
      union() {
        for(i=[0:2]) {
          translate([pcb_outer_l*i,0,0])
          straight_row(5);
        }
        translate([pcb_outer_l*3, -pcb_outer_l, 0])
        straight_row(3);
        translate([pcb_outer_l*3, pcb_outer_l*1.5, 0])
        rotate([0,0,-90])
        key_2U(false);
      }

/*
      translate([0,-(pcb_outer_l*2.5),mcu_z/2])
      union() {
        color([1,0,0])
        union() {
          cube([mcu_x,mcu_y,mcu_z], true);
        }
        color([0,1,0])
        union() {
          for (i=[-1,1]) {
            translate([0,0,-mcu_z/2+mcu_hole_z])
            rotate([90,0,0])
            cylinder(mcu_y*2,mcu_hole,mcu_hole);
          }
        }
      }
*/
      difference() {
        union() {
          for(i=[-1,1]) {
            for (j=[-1,1]) {
              translate([i*pcb_outer_l*2, j*(pcb_outer_l*2.5+mcu_y/2) + (cr*(j-1)/2), 0])
              cylinder(base_h,cr,cr);
              translate([0, j*(pcb_outer_l*2.5+(cr+mcu_y)/2) + (cr*(j-1)/2), base_h/2])
              cube([pcb_outer_l*4,cr,base_h], true);
            }
            translate([i*(pcb_outer_l*2+cr/2),-cr/2, base_h/2])
            cube([cr,pcb_outer_l*5+mcu_y+cr,base_h], true);
            translate([i*pcb_outer_l*2, -(pcb_outer_l*2+cr), 0])
            cylinder(base_h,cr,cr);
          }
          color([1,0,0])
          translate([0, -(pcb_outer_l*2+cr/2), base_h/2])
          cube([pcb_outer_l*4,cr,base_h], true);
        }
        translate([0,mcu_y/2,base_h/2])
        cube([w-(pcb_tab_d*2), h-(pcb_tab_d*2), base_h],true);
      }
    }
    union() {
      for(i=[-1,1]) {
        translate([i*pcb_outer_l*2, 0, cr])
        cylinder(base_h,mcu_hole,mcu_hole);
        translate([i*pcb_outer_l*2, -(pcb_outer_l*2+cr), -cr])
        cylinder(base_h,mcu_hole,mcu_hole);
        for (j=[-1,1]) {
          translate([i*pcb_outer_l*2, j*(pcb_outer_l*2.5+mcu_y/2) + (cr*(j-1)/2), j+1])
          cylinder(base_h,mcu_hole,mcu_hole);
        }
      }
      translate([0,-pcb_outer_l*2, base_h-component_h/2])
      cube([pcb_outer_l*4, cr*4, component_h], true);
    }
  }
}

module dactyl_row( count = 5, width = pcb_outer_l, radius = 105, angle = 11, rotation = 0, key_2U = false) {
  s=-(count/2)+0.5;
  e=s+count-1;

  for(i=[s:e]) {
    rotate([angle*i + rotation,0,0])
    key_r( true, width - pcb_outer_l, radius, angle, key_2U);
  }
}


module dactly_ergo() {
  ergo = [
// [count, width, radius (finger + keycap), angle, rotation offset, x offset, z offset ]    
    [5,pcb_outer_l,100,12, 0, 0, 0], // Pinky
    [5,pcb_outer_l,100,12, 0, 19, 0],
    [5,pcb_outer_l+1,105,12, 0, 38, 0], // Ring
    [5,pcb_outer_l+1,110,12, 0, 58, 0], // Middle
    [5,pcb_outer_l+1,105,12, 0, 78, 0], //Left
    [4,pcb_outer_l,105,12, 5.5, 97, 0],
    [3,pcb_outer_l,105,12, 5.5, 116, 2 ],
  ];

  r = 12 * 5/2;
  x1=ergo[5][5]+ergo[5][1];
  x2=ergo[4][5]+ergo[4][1];
  ar=ergo[0][2];
  ah=ergo[3][2]-ar+base_h + 1;
  z=-ergo[4][2];
  rs=1;
  translate([0,0,z])
  union () {
    for (i = [0:6]) {
      translate([ergo[i][5],0, -ergo[i][6]])
      dactyl_row(ergo[i][0], ergo[i][1], ergo[i][2], ergo[i][3], ergo[i][4]);
    }

    translate([x2 - ergo[6][1]/2,0,0])
    rotate([-r,0,0])
    rotate([0,-90,0])
    arc_extrude(ar, ah, rs, x2 );

    translate([x1 - ergo[6][1]/2,0,0])
    rotate([r,0,0])
    rotate([0,-90,0])
    arc_extrude(ar, ah, rs, x1 );

    translate([-ergo[0][1]/2,0,0])
    rotate([0,-90,0])
    arc_extrude(ar, ah, ergo[0][3]*5+rs, 1 );
   }
}

module dactyl_ergo_thumb() {
  translate([0,0,-110])
  union() {
    rotate([0,0,90])
    dactyl_row(2,pcb_outer_l,105,11,-5.5, true);
    rotate([0,0,0])
    union() {
      dactyl_row(1,pcb_outer_l,105,11,16.5);
      translate([pcb_outer_l,0,0])
      dactyl_row(3,pcb_outer_l,105,11,5.5);
    }
  }
}

if (ergo) {
  dactly_ergo();
  translate([145,68,0])
  rotate([0,-30,45])
  dactyl_ergo_thumb();
}
