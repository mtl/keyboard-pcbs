include <./arc.scad>

show_demo=false;
show_demo_r=false;
show_demo_r_back=false;
show_double=false;
if (show_demo) {
    x_spacing=0;
    y_spacing=0;
    z_spacing=0;
    z_spacing_n=0;
    if (show_demo_r) {
        r=105;
        color([1,0,0])
        translate([0,0,-r])
        key_r(x_spacing,r);
        if (show_demo_r_back) {
            color([0,1,0])
            translate([0,0,-r])
            key_r_back(x_spacing, r);
        }
    } else {
        key(x_spacing,y_spacing,z_spacing, z_spacing_n);
        if (show_double) {
            translate([0,(pcb_outer_l+y_spacing),0])
            key_2U(x_spacing,y_spacing,z_spacing, z_spacing_n);
        }
    }
}

/***** Printing Play ************************************************************/
// Adjust this based on your desired tolerances
h_play=0.2; // PCB Horizontal Play
v_play=0.2; // PCB Vertical Play
// Cherry Horizontal Play
cherry_h_play=0.2;


/***** Cherry *******************************************************************/
 // Distance betwenn top of PCB and top of mounting plate
cherry_board_to_board=5; // ~ 0.2*25.4;
// Metal Frame Thickness
cherry_metal_frame=1.5; // ~ 0.06*25.4;

// Key Top
cherry_key_top_side=17;

// Cut out
cherry_key_side=14+cherry_h_play; // ~ 0.551*25.4;
// Side Extensions
cherry_key_side_x=0.8;
cherry_key_side_y=3.5;
cherry_key_side_y_offset=4.25;
// Length of slot for key clipping mechansim
cherry_clip_l=5;
cherry_clip_d=(cherry_key_top_side-cherry_key_side)/2;

cherry_2U_play_x=0.7;
cherry_2U_play_y=0.5;

/***** PCB **********************************************************************/
pcb_outer_l=19.2;
pcb_inner_l=16.5 + h_play;
pcb_h=1.6+h_play;
pcb_x_tab_l=11.5 + h_play;
pcb_y_tab_l=8.5 + h_play;
pcb_tab_d=(pcb_outer_l - pcb_inner_l)/2;
pcb_x_tab_l2=(pcb_outer_l-pcb_x_tab_l)/2-pcb_tab_d;
pcb_y_tab_l2=(pcb_outer_l-pcb_y_tab_l)/2-pcb_tab_d;

pcb_mount_x_offset=8.5;
pcb_mount_hole_r=2/2; // ~2.4 - play
pcb_mount_stub_r=3/2;

/***** Components ***************************************************************/
component_h=2;
cut_out=false;
pcb_n_comp_h=pcb_h+component_h;

/***** Cumulative Numbers *******************************************************/
base_h=cherry_board_to_board+pcb_h+component_h;

module key_block( x_spacing = 0, y_spacing = 0, z_spacing = 0, z_spacing_n = 0 ) {
    z=(pcb_h+component_h+cherry_board_to_board+z_spacing+z_spacing_n);
    translate([0,0,z/2-z_spacing])
    cube([pcb_outer_l+x_spacing,pcb_outer_l+y_spacing,z], true);
}

module key_hole( grip = true, x_spacing = 0, y_spacing = 0, z_spacing = 0, z_spacing_n = 0, side_cut_outs = true, key_cap = true ) {
    // Cutout for keycap
    x = (pcb_outer_l)/2;
    y = (pcb_outer_l+y_spacing)/2;
    x2 = (pcb_outer_l+x_spacing)/2;
    y2= (pcb_outer_l+y_spacing)/2;
    if (key_cap) {
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
    }

    // Extra bottom extension
    z_fixer=0.001;
    translate([0,0,(z_spacing_n-z_fixer)/2+cherry_board_to_board+pcb_h+component_h])
    union() {
        cube([x*2,y*2,z_spacing_n+z_fixer], true);
        translate([0,0,-component_h/2])
        union() {
            cube([pcb_x_tab_l,pcb_outer_l+y_spacing*2,z_spacing_n+z_fixer+component_h], true);
            cube([pcb_outer_l+x_spacing,pcb_y_tab_l,z_spacing_n+z_fixer+component_h], true);
        }
    }

    // Main Key body and mounting plate cutout
    translate([0,0,(cherry_board_to_board+pcb_h-z_spacing)/2])
    cube([cherry_key_side + h_play, cherry_key_side + h_play, cherry_board_to_board+pcb_h+z_spacing], true);

    // Side Cut Outs
    if (side_cut_outs) {
        for (i=[-1,1]) {
            for (j=[-1,1]) {
                translate([i*(cherry_key_side+cherry_key_side_x)/2,j*cherry_key_side_y_offset,(cherry_board_to_board+pcb_h-z_spacing)/2])
                cube([cherry_key_side_x,cherry_key_side_y, cherry_board_to_board+pcb_h+z_spacing],true);
            }
        }
    }

    // Slots for Key side clips, needed to clip 
    cherry_clip_offset_z=(cherry_board_to_board+cherry_metal_frame)/2;
    cherry_clip_offset_y=cherry_key_side/2;
    for (i=[-1,1]) {
        translate([0,i*cherry_clip_offset_y,cherry_clip_offset_z+pcb_h/2])
        cube([cherry_clip_l, cherry_clip_d, cherry_board_to_board-cherry_metal_frame+pcb_h], true);
    }

    // A cutout to slide PCB in better
    if (cut_out) {
        etw=pcb_x_tab_l+h_play;
        etl=(pcb_outer_l-cherry_key_side)/2;
        translate([-etw/2,cherry_key_side/2,cherry_board_to_board+z_fixer])
        rotate([0,90,0])
        extruded_triangle(etl,etl,etw);
    }

    pcb_tab_offset=(pcb_outer_l-pcb_tab_d)/2;
    pcb_tab_offset_x=(pcb_outer_l-pcb_x_tab_l2)/2;
    pcb_tab_offset_y=(pcb_outer_l-pcb_y_tab_l2)/2;
    pcb_tab_offset_fillet=pcb_outer_l/2;
    pcb_tab_offset_fillet_x=pcb_x_tab_l/2 + pcb_tab_d;
    pcb_tab_offset_fillet_y=pcb_y_tab_l/2 + pcb_tab_d;

    translate([0,0,pcb_n_comp_h/2 + cherry_board_to_board])
    // Center part
    difference() {
        cube([pcb_outer_l,pcb_outer_l,pcb_n_comp_h],true);
        union() {
            for (i=[-1,1]) {
                // Y Tab Corners Top
                translate([i*pcb_tab_offset_x, pcb_tab_offset, 0])
                cube([pcb_x_tab_l2, pcb_tab_d, pcb_n_comp_h], true);
                translate([i*pcb_tab_offset_fillet_x, pcb_tab_offset_fillet,-pcb_n_comp_h/2])
                cylinder(pcb_n_comp_h, pcb_tab_d, pcb_tab_d);
                // Y Tab Corners Bottom
                if (grip) {
                    translate([i*pcb_tab_offset_x, -pcb_tab_offset, -component_h/2])
                    cube([pcb_x_tab_l2, pcb_tab_d, pcb_h], true);
                    translate([i*pcb_tab_offset_fillet_x, -pcb_tab_offset_fillet,-(pcb_n_comp_h/2)])
                    cylinder(pcb_h, pcb_tab_d, pcb_tab_d);
                } else {
                    translate([i*pcb_tab_offset_x, -pcb_tab_offset, 0])
                    cube([pcb_x_tab_l2, pcb_tab_d, pcb_n_comp_h], true);
                    translate([i*pcb_tab_offset_fillet_x, -pcb_tab_offset_fillet,-(pcb_n_comp_h/2)])
                    cylinder(pcb_n_comp_h, pcb_tab_d, pcb_tab_d);
                }

                // X Tab Corners
                translate([i*pcb_tab_offset, pcb_tab_offset_y, 0])
                cube([pcb_tab_d, pcb_y_tab_l2, pcb_n_comp_h], true);
                translate([i*pcb_tab_offset_fillet, pcb_tab_offset_fillet_y,-pcb_n_comp_h/2])
                cylinder(pcb_n_comp_h, pcb_tab_d, pcb_tab_d);

                translate([i*pcb_tab_offset, -pcb_tab_offset_y, -component_h/2])
                cube([pcb_tab_d, pcb_y_tab_l2, pcb_h], true);
                translate([i*pcb_tab_offset_fillet, -pcb_tab_offset_fillet_y,-pcb_n_comp_h/2])
                cylinder(pcb_h, pcb_tab_d, pcb_tab_d);
            }

            if (grip) {
                translate([pcb_outer_l/2, pcb_outer_l/2, 0])
                rotate([0,0,180])
                extruded_triangle(pcb_x_tab_l2+pcb_tab_d,pcb_y_tab_l2+pcb_tab_d,component_h);

                translate([-pcb_outer_l/2, pcb_outer_l/2, component_h])
                rotate([0,180,180])
                extruded_triangle(pcb_x_tab_l2+pcb_tab_d,pcb_y_tab_l2+pcb_tab_d,component_h);
            } else {

            }
        }
    }
}

module key_hole_2U( grip = true, x_spacing = 0, y_spacing = 0, z_spacing = 0, z_spacing_n = 0) {
    key_hole( grip, x_spacing*2 + pcb_outer_l, y_spacing, z_spacing, z_spacing_n, false, false );

    // Cutout for keycap
    x = (pcb_outer_l*2)/2;
    y = (pcb_outer_l)/2;
    x2 = (pcb_outer_l+x_spacing);
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

    variant_one = false;
    if (variant_one) {
        extension_x_x=0.825;
        extension_x_y=2.785;
        support_x=6.75;
        support_y=12.3;
        support_x_gap=1.525;

        extension_x_y_top_offset=4.7;
        extension_x_x_offset=(cherry_key_side+extension_x_x)/2+support_x+support_x_gap;
        support_x_gap_y=14-(extension_x_y_top_offset*2);
        extension_x_y_offset=(support_x_gap_y-extension_x_y)/2;

        support_x_offset=(cherry_key_side+support_x)/2+support_x_gap;
        support_y_offset=(4.47-3.23)/2;

        extension_y_x=3.3;
        extension_y_y=1.2;
        extension_y_x_offset = support_x_offset;
        extension_y_y_offset = support_y_offset+(support_y+extension_y_y)/2;

        full_h=base_h+z_spacing+z_spacing_n;
        z_offset= (base_h+z_spacing_n+z_spacing)/2;

        plate_bottom_x=support_x+extension_x_x+1;
        plate_bottom_y=pcb_outer_l;
        plate_bottom_z=full_h-1.5;
        plate_bottom_offset_x= support_x_offset + extension_x_x/2+1;
        plate_bottom_offset_y= 0;
        plate_bottom_offset_z= z_offset+1.5/2;

        support_tri_x=(pcb_outer_l-cherry_key_side-support_x_gap)/2;
        for(i=[-1,1]) {
            translate([i*support_x_offset,support_y_offset,(cherry_board_to_board)/2])
            difference() {
                cube([support_x, support_y, cherry_board_to_board], true);
                rotate([0,0,90*(i-1)])
                translate([-(support_x/2),-(cherry_key_side/2),(cherry_board_to_board)/2])
                rotate([-90,0,0])
                extruded_triangle(support_tri_x, pcb_tab_d, cherry_key_side);
            }

            translate([i*(cherry_key_side+support_x_gap)/2, 0, z_offset])
            cube([support_x_gap+support_tri_x*2,support_x_gap_y,full_h], true);
            translate([i*extension_x_x_offset, -extension_x_y_offset, z_offset])
            cube([extension_x_x, extension_x_y, full_h], true);
            translate([i*extension_y_x_offset,extension_y_y_offset, z_offset])
            cube([extension_y_x, extension_y_y, full_h],true);

            translate([i*plate_bottom_offset_x, plate_bottom_offset_y, plate_bottom_offset_z])
            cube([plate_bottom_x, plate_bottom_y, plate_bottom_z], true);
        }
    } else {
        sw=3+cherry_2U_play_y;
        sh=13.5+cherry_2U_play_x;
        for (i=[-1,1]) {
            translate([i*(23.5/2),0,base_h/2])
            cube([sw,sh,base_h],true);
            translate([i*(23.5/2),0,base_h/2+1.5])
            cube([sw+2,sh+2,base_h],true);
        }
    }
}

module key_2U( grip = true, x_spacing = 0, y_spacing = 0, z_spacing = 0, z_spacing_n = 0 ) {
    difference() {
        key_block( pcb_outer_l + x_spacing*2, y_spacing, z_spacing, z_spacing_n);
        key_hole_2U( grip, x_spacing,y_spacing,z_spacing, z_spacing_n);
    }
}


module key( grip = true, x_spacing = 0, y_spacing = 0, z_spacing = 0, z_spacing_n = 0 ) {
    difference() {
        key_block(x_spacing,y_spacing, z_spacing, z_spacing_n);
        key_hole( grip, x_spacing,y_spacing,z_spacing, z_spacing_n);
    }
}

module key_r( grip = true, x_spacing = 0, radius = 105, angle = 11, key_2U = false ) {
    w = (pcb_outer_l + x_spacing) * (key_2U ? 2 : 1);
    y_spacing = 6;
    z_spacing= 0.7;
    z_spacing_2 = z_spacing;

    h = base_h + z_spacing;
    difference() {
        translate([w/2,0,0])
        rotate([0,-90,0])
        arc_extrude(radius, h, angle, w);
        translate([0,0,radius])
        if (key_2U) {
            key_hole_2U( grip, x_spacing,y_spacing,z_spacing,z_spacing_2);
        } else {
            key_hole( grip, x_spacing,y_spacing,z_spacing, z_spacing_2);
        }
    }
}

module key_r_back( x_spacing = 0, radius = 105, angle = 11, key_2U = false ) {
    w = (pcb_outer_l + x_spacing) * (key_2U ? 2 : 1);
    difference() {
        translate([w/2,0,0])
        rotate([0,-90,0])
        arc_extrude(radius+base_h,2,angle, w);
        translate([0,0,radius])
        key_r(x_spacing, radius, angle, key_2U);
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

module key_back_support( z_spacing = 0, x_spacing = 0, y_spacing = 0 ) {
    h = pcb_n_comp_h + z_spacing;
    intersection() {
        translate([0,0,h/2])
        cube([pcb_outer_l+x_spacing, pcb_outer_l+y_spacing, h], true);
        union () {
            for (i=[-1,1]) {
                translate([i*pcb_outer_l/2, 0, 0])
                union() {
                    cylinder(component_h+z_spacing, pcb_mount_stub_r, pcb_mount_stub_r);
                    cylinder(h, pcb_mount_hole_r, pcb_mount_hole_r);
                }
                translate([pcb_outer_l/2-pcb_mount_x_offset,i*pcb_outer_l/2, 0])
                union() {
                    cylinder(component_h+z_spacing, pcb_mount_stub_r, pcb_mount_stub_r);
                    cylinder(h, pcb_mount_hole_r, pcb_mount_hole_r);
                }
            }
        }
    }
}