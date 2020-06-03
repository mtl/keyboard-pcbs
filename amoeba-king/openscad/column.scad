include <./key_hole.scad>
include <./arc.scad>

$fn=100;

h=base_h;

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

module dactyl_row( count = 5, width = pcb_outer_l, radius = 105, angle = 11, rotation = 0 ) {
  s=-(count/2)+0.5;
  e=s+count-1;

  for(i=[s:e]) {
    rotate([angle*i + rotation,0,0])
    key_r(width - pcb_outer_l, radius, angle);
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
  translate([0,0,-110])
  for (i = [0:6]) {
    translate([ergo[i][5],0, -ergo[i][6]])
    dactyl_row(ergo[i][0], ergo[i][1], ergo[i][2], ergo[i][3], ergo[i][4]);
  }
}
dactly_ergo();


module dactyl_ergo_thumb() {
  translate([0,0,-110])
  union() {
    rotate([0,0,90])
    dactyl_row(2,19,105,11,-5.5,19*1.5,0);
    rotate([0,0,0])
    union() {
      dactyl_row(1,19,105,11,16.5,19,0);
      translate([19,0,0])
      dactyl_row(3,19,105,11,5.5,38,0);
    }
  }
}

translate([145,68,0])
rotate([0,-30,45])
dactyl_ergo_thumb();
