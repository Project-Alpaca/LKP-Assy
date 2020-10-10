use <hsi.scad>;

$fn=30;
difference() {
    translate([0, 0, -5]) cube([10, 10, 10], center=true);
    hsi(3.6, 3*1.5, d_taper=4.2, depth_taper=0.8);
}
