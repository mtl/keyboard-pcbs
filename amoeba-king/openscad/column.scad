include <./key_hole.scad>
include <./arc.scad>

$fn=100;

h=base_h;

double_row=true;
ergo=false;

module straight_row( count = 5, key_spacing = pcb_outer_l, width = pcb_outer_l ) {
  s=-(count/2)+0.5;
  e=s+count-1;
  difference() {
    translate([0,0,h/2])
    cube([width,count*key_spacing,h],true);
    union() {
      for(i=[s:e]) {
        translate([0,i*key_spacing,0])
        key_hole();
      }
    }
  }
}

if (double_row) {
  straight_row(2);
}

module dactyl_row( count = 5, width = pcb_outer_l, radius = 105, angle = 11, rotation = 0, key_2U = false) {
  s=-(count/2)+0.5;
  e=s+count-1;

  for(i=[s:e]) {
    rotate([angle*i + rotation,0,0])
    key_r(width - pcb_outer_l, radius, angle, key_2U);
  }
}


module dactly_ergo() {
  ergo = [
// [count, width, radius (finger + keycap), angle, rotation offset, x offset, z offset ]    
    [5,19,100,12, 0, 0, 0], // Pinky
    [5,19,100,12, 0, 19, 0],
    [5,20,105,12, 0, 38, 0], // Ring
    [5,20,110,12, 0, 58, 0], // Middle
    [5,20,105,12, 0, 78, 0], //Left
    [4,19,105,12, 5.5, 97, 0],
    [3,19,105,12, 5.5, 116, 2 ],
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
    dactyl_row(2,19,105,11,-5.5, true);
    rotate([0,0,0])
    union() {
      dactyl_row(1,19,105,11,16.5);
      translate([19,0,0])
      dactyl_row(3,19,105,11,5.5);
    }
  }
}

if (ergo) {
  dactly_ergo();
  translate([145,68,0])
  rotate([0,-30,45])
  dactyl_ergo_thumb();
}
