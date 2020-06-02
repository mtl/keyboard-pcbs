// TODO add key-cap cutout
// TODO extend board insert down ?

$fn=20;

show_demo=false;
if (show_demo) {
    x_spacing=0;
    y_spacing=0;
    z_spacing=0;
    z_spacing_n=0;
    difference() {
        key_cutout(x_spacing,y_spacing, z_spacing, z_spacing_n);
        key_hole(x_spacing,y_spacing,z_spacing, z_spacing_n);
    }
}

/***** Printing Play ************************************************************/
// Adjust this based on your desired tolerances
h_play=0.3; // Horizontal Play
v_play=0.2; // Vertical Play


/***** Cherry *******************************************************************/
 // Distance betwenn top of PCB and top of mounting plate
cherry_board_to_board=5; // ~ 0.2*25.4;
// Metal Frame Thickness
cherry_metal_frame=1.5; // ~ 0.06*25.4;

// Key Top
cherry_key_top_side=17;

// Cut out
cherry_key_side=14; // ~ 0.551*25.4;
// Length of slot for key clipping mechansim
cherry_clip_l=5;
cherry_clip_d=(cherry_key_top_side-cherry_key_side)/2;

/***** PCB **********************************************************************/
pcb_outer_l=19;
pcb_inner_l=16.5 + h_play;
pcb_h=1.6+h_play;
pcb_x_tab_l=11.5 + h_play;
pcb_y_tab_l=8.5 + h_play;
pcb_tab_d=(pcb_outer_l - pcb_inner_l)/2;
pcb_x_tab_l2=pcb_x_tab_l/2-pcb_tab_d*2;
pcb_y_tab_l2=pcb_y_tab_l/2-pcb_tab_d*2;

/***** Components ***************************************************************/
component_h=2;

/***** Cumulative Numbers *******************************************************/
base_h=cherry_board_to_board+pcb_h+component_h;

module key_cutout( x_spacing = 0, y_spacing = 0, z_spacing = 0, z_spacing_n = 0 ) {
    z=(pcb_h+component_h+cherry_board_to_board+z_spacing+z_spacing_n);
    translate([0,0,z/2-z_spacing])
    cube([pcb_outer_l+x_spacing,pcb_outer_l+y_spacing,z], true);
}



module key_hole( x_spacing = 0, y_spacing = 0, z_spacing = 0, z_spacing_n = 0 ) {
    // Cutout for keycap
    x = (pcb_outer_l)/2;
    y = (pcb_outer_l)/2;
    x2 = (pcb_outer_l+x_spacing)/2;
    y2= (pcb_outer_l+y_spacing)/2;
    polyhedron([
        [x,y,0],
        [-x,y,0],
        [-x,-y,0],
        [x,-y,0],
        [x2,y2,-z_spacing],
        [-x2,y2,-z_spacing],
        [-x2,-y2,-z_spacing],
        [x2,-y2,-z_spacing]
    ],[
        [0,1,2,3],
        [4,7,6,5],
        [0,3,7,4],
        [0,4,5,1],
        [1,5,6,2],
        [2,6,7,3]
    ]);

    // Extra bottom extension
    z_fixer=0.001;
    translate([0,0,(z_spacing_n-z_fixer)/2+cherry_board_to_board+pcb_h+component_h])
    union() {
        cube([x*2,y*2,z_spacing_n+z_fixer], true);
        translate([0,0,-component_h/2])
        union() {
            cube([pcb_x_tab_l,pcb_tab_offset_x+pcb_tab_d*2,z_spacing_n+z_fixer+component_h], true);
            cube([pcb_tab_offset_y+pcb_tab_d*2,pcb_tab_d,z_spacing_n+z_fixer+component_h], true);
        }
    }

    // Main Key body and mounting plate cutout
    translate([0,0,(cherry_board_to_board+pcb_h-z_spacing)/2])
    cube([cherry_key_side + h_play, cherry_key_side + h_play, cherry_board_to_board+pcb_h+z_spacing], true);

    // Slots for Key side clips, needed to clip 
    cherry_clip_offset_z=(cherry_board_to_board+cherry_metal_frame)/2;
    cherry_clip_offset_y=cherry_key_side/2;
    for (i=[-1,1]) {
        translate([0,i*cherry_clip_offset_y,cherry_clip_offset_z+pcb_h/2])
        cube([cherry_clip_l, cherry_clip_d, cherry_board_to_board-cherry_metal_frame+pcb_h], true);
    }

    // A cutout to slide PCB in better
    etw=pcb_x_tab_l+h_play;
    etl=(pcb_outer_l-cherry_key_side)/2;
    translate([-etw/2,cherry_key_side/2,cherry_board_to_board+z_fixer])
    rotate([0,90,0])
    extruded_triangle(etl,etl,etw);

    pcb_tab_offset=(pcb_outer_l-pcb_tab_d)/2;
    pcb_tab_offset_x=(pcb_outer_l-pcb_x_tab_l2)/2;
    pcb_tab_offset_y=(pcb_outer_l-pcb_y_tab_l2)/2;
    pcb_tab_offset_fillet=pcb_outer_l/2;
    pcb_tab_offset_fillet_x=pcb_tab_offset_x - pcb_x_tab_l2/2;
    pcb_tab_offset_fillet_y=pcb_tab_offset_y - pcb_y_tab_l2/2;
    pcb_n_comp_h=pcb_h+component_h;
    translate([0,0,pcb_n_comp_h/2 + cherry_board_to_board])
    // Centor part
    difference() {
        cube([pcb_outer_l,pcb_outer_l,pcb_n_comp_h],true);
        union() {
            for (i=[-1,1]) {
                // Y Tab Corners Top
                translate([i*pcb_tab_offset_y, pcb_tab_offset, 0])
                cube([pcb_y_tab_l2, pcb_tab_d, pcb_n_comp_h], true);
                translate([i*pcb_tab_offset_fillet_y, pcb_tab_offset_fillet,-pcb_n_comp_h/2])
                cylinder(pcb_n_comp_h, pcb_tab_d, pcb_tab_d);
                // Y Tab Corners Bottom
                translate([i*pcb_tab_offset_y, -pcb_tab_offset, -component_h/2])
                cube([pcb_y_tab_l2, pcb_tab_d, pcb_h], true);
                translate([i*pcb_tab_offset_fillet_y, -pcb_tab_offset_fillet,-(pcb_n_comp_h/2)])
                cylinder(pcb_h, pcb_tab_d, pcb_tab_d);


                // X Tab Corners
                translate([i*pcb_tab_offset, pcb_tab_offset_x, 0])
                cube([pcb_tab_d, pcb_x_tab_l2, pcb_n_comp_h], true);
                translate([i*pcb_tab_offset_fillet, pcb_tab_offset_fillet_x,-pcb_n_comp_h/2])
                cylinder(pcb_n_comp_h, pcb_tab_d, pcb_tab_d);

                // X Tab Corners Cut
                difference() {
                    union() {
                        translate([i*pcb_tab_offset, -pcb_tab_offset_x, 0])
                        cube([pcb_tab_d, pcb_x_tab_l2, pcb_n_comp_h], true);
                        translate([i*pcb_tab_offset_fillet, -pcb_tab_offset_fillet_x,-pcb_n_comp_h/2])
                        cylinder(pcb_n_comp_h, pcb_tab_d, pcb_tab_d);
                    }
                    translate([pcb_outer_l/2,-(pcb_tab_offset_fillet_x-pcb_tab_d),component_h])
                    rotate([180,90,0])
                    extruded_triangle(component_h, component_h, pcb_outer_l);
                }

            }

            translate([pcb_outer_l/2, pcb_outer_l/2, 0])
            rotate([0,0,180])
            extruded_triangle(pcb_y_tab_l2+pcb_tab_d,pcb_x_tab_l2+pcb_tab_d,component_h);

            translate([-pcb_outer_l/2, pcb_outer_l/2, component_h])
            rotate([0,180,180])
            extruded_triangle(pcb_y_tab_l2+pcb_tab_d,pcb_x_tab_l2+pcb_tab_d,component_h);
        }
    }
}


module extruded_triangle( w,l,h ) {
    polyhedron([
        [0,0,0],
        [w,0,0],
        [0,l,0],
        [0,0,h],
        [w,0,h],
        [0,l,h]       
    ],[
        [0,1,2],
        [0,3,4,1],
        [0,2,5,3],
        [1,4,5,2],
        [3,5,4]
    ]);
}
