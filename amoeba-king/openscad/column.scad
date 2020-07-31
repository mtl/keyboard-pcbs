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
case_shell=2.1; // Wall Thickness of case

m3_test = false;

module straight_row( count = 5, grip = false, xs = x_spacing, ys = y_spacing ) {
  s=-(count/2)+0.5;
  e=s+count-1;
  key_spacing = pcb_outer_l;
  difference() {
    translate([0,0,h/2])
    union() {
      cube([pcb_outer_l,count*key_spacing,h],true);
      cube([pcb_outer_l + ys,count*key_spacing,h-component_h],true);
    }
    union() {
      for(i=[s:e]) {
        translate([0,i*key_spacing,0])
        key_hole( grip, xs, ys );
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

m3_screw_hole = 3/2;
m3_screw_wrap=7/2;
m3_screw_head_slop=0.25;
m3_screw_head = 6/2;
m3_screw_head_h = 2;
module m3_hole( thread_h, head = false ) {
  cylinder( thread_h, m3_screw_hole, m3_screw_hole );
  if (head) {
    translate([0,0,thread_h])
    cylinder( m3_screw_head_h, m3_screw_hole + m3_screw_head_slop, m3_screw_head + m3_screw_head_slop );
  }
}
module m3_support( thread_h, head = false ) {
  cylinder( thread_h, m3_screw_wrap, m3_screw_wrap );
  if (head) {
    translate([0,0,thread_h])
    cylinder( m3_screw_head_h, m3_screw_wrap + m3_screw_head_slop, m3_screw_wrap + m3_screw_head_slop );
  }
}

if (m3_test) {
  difference() {
    union() {
      translate([0,0,2])
      cube([m3_screw_head*4,m3_screw_head*4,4], true);
      m3_support(10, true);
    }
    m3_hole(10, true);
  }
}

module numpad_shell( base_h, mirrored = 1, cutout = true, mcu_y = 19 ) {
  w=(pcb_outer_l+x_spacing)*4;
  h=(pcb_outer_l+y_spacing)*5;
  m3_offset = (m3_screw_wrap - case_shell);
  difference() {
    union() {
      // Bottom Left Corner
      translate([mirrored * (pcb_outer_l*2-m3_offset), (pcb_outer_l*2.5+mcu_y/2-m3_offset), 0])
      m3_support(base_h);

      // Bottom Right Corner
      translate([mirrored * -(pcb_outer_l*2-m3_offset), (pcb_outer_l*2.5+mcu_y/2-m3_offset), 0])
      difference() {
        m3_support(base_h);
        translate([mirrored*case_shell, -case_shell,base_h/2])
        cube([m3_screw_wrap*2, m3_screw_wrap*2, base_h],true);
      }


      for(i=[-1,1]) {
        // Top Corners
        translate([mirrored * i*(pcb_outer_l*2-m3_offset), -(pcb_outer_l*2.5+mcu_y/2-m3_offset) - case_shell, 0])
        m3_support(base_h);

        for (j=[-1,1]) {
          translate([0, j*(pcb_outer_l*2.5+(case_shell+mcu_y)/2) + (case_shell*(j-1)/2), base_h/2])
          cube([pcb_outer_l*4-m3_offset*2,case_shell,base_h], true);
        }
        translate([mirrored * i*(pcb_outer_l*2-m3_offset), -(pcb_outer_l*2+case_shell), 0])
        m3_support(base_h);
        translate([mirrored * i*(pcb_outer_l*2+case_shell/2),-case_shell/2, base_h/2])
        cube([case_shell,pcb_outer_l*5+mcu_y+case_shell-m3_offset*2,base_h], true);
      }

      // Cross support
      if (cutout) {
        color([1,0,0])
        translate([0, -(pcb_outer_l*2+case_shell/2), (base_h - component_h)/2])
        cube([pcb_outer_l*4,case_shell,base_h-component_h], true);
      }
    }
    translate([0,mcu_y/2,base_h/2])
    cube([w-(pcb_tab_d*2), h-(pcb_tab_d*2), base_h],true);
  }

  if (!cutout) {
    l = (pcb_outer_l+y_spacing)*5+mcu_y+case_shell;
    translate([0,-case_shell/2, base_h/2])
    cube([(pcb_outer_l+x_spacing)*4,l,base_h], true);
  }
}

module numpad_middle( mcu_y = 19 ) {
  mcu_x=36;
  mcu_z=15;
  m3_offset = (m3_screw_wrap - case_shell);

  /*
  mcu_hole_x=(w/2)-10;
  mcu_hole_x_offset=12.7;
  mcu_hole_z=2.54*2;
  */

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

      numpad_shell(base_h);
    }
    union() {
      for(i=[-1,1]) {
        // Top middle holes
        translate([i*(pcb_outer_l*2-m3_offset), -(pcb_outer_l*2+case_shell), -case_shell])
        m3_hole(base_h);

        // Corner holes Top
        translate([i*(pcb_outer_l*2-m3_offset), -1*(pcb_outer_l*2.5+mcu_y/2-m3_offset) - case_shell, 0])
        m3_hole(base_h);

      }
      // middle hole
      translate([0, 0, case_shell])
      m3_hole(base_h);

      // Corner hole Bottom Left
      translate([(pcb_outer_l*2-m3_offset), (pcb_outer_l*2.5+mcu_y/2-m3_offset), 2])
      m3_hole(base_h);
      // Corner hole Bottom Right
      translate([-(pcb_outer_l*2-m3_offset), (pcb_outer_l*2), 2])
      m3_hole(base_h);
    }
  }
}

module numpad_back( mcu_y = 19 ) {
  bt=2; // Back Thickness
  gap=1;
  bh=bt+gap;
  m3_offset = (m3_screw_wrap - case_shell);

  x = pcb_outer_l + x_spacing;
  y = pcb_outer_l + y_spacing;
  translate([-pcb_outer_l*5, 0, 0])
  union() {
    difference() {
      union () {
        translate([0, 0, bt])
        numpad_shell(gap, -1);
        numpad_shell(bt, -1, false);
        translate([0, 0, 0])
        m3_support(bh);
        translate([(pcb_outer_l*2-m3_offset), (y*2), 0])
        m3_support(bh);
        translate([0,0,bt])
        difference() {
          numpad_shell(gap*2, -1, false);
          union() {
            translate([0,0,base_h])
            rotate([0,180,0])
            numpad_middle();
            translate([0,-case_shell/2, gap])
            cube([x*4-gap*2,pcb_outer_l*5+mcu_y+case_shell-m3_offset*2,gap*2], true);
          }
        }
      }

      translate([0,0,bh])
      rotate([0,180,0])
      union() {
        // Bottom holes
        translate([(pcb_outer_l*2-m3_offset), (pcb_outer_l*2.5+mcu_y/2-m3_offset), -gap])
        m3_hole(bh - m3_screw_head_h+gap, true);
        translate([-(pcb_outer_l*2-m3_offset), (pcb_outer_l*2), -gap])
        m3_hole(bh - m3_screw_head_h+gap, true);

        // Top Holes
        for(i=[-1,1]) {
          translate([i*(pcb_outer_l*2-m3_offset), -(pcb_outer_l*2.5+mcu_y/2-m3_offset) - case_shell, -gap])
          m3_hole(bh - m3_screw_head_h+gap, true);
        }
        
        // Middle Hole
        translate([0, 0, -gap])
        m3_hole(bh - m3_screw_head_h+gap, true);
      }
    }

    // Key Supports
    translate([-x*1.5,-y*1.5,bt])
    union () {
      for (j=[0:2]) {
        translate([0, x*j, 0])
        key_back_support(gap, x_spacing, y_spacing);
      }
      translate([0, y*3.5, 0])
      rotate([0,0,90])
      key_back_support(gap, x_spacing, y_spacing);
      for(j=[0:4]) {
        for(i=[1:3]) {
          translate([x*i, y*j, 0])
          key_back_support(gap, x_spacing, y_spacing);
        }
      }
    }

  }
}

if (numpad) {
  //numpad_middle();
  numpad_back();
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
