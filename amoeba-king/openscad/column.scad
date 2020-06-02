include <./key_hole.scad>

h=base_h;

straight_row(2);
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