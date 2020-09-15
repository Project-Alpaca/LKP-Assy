module hsi(d_min, depth, d_taper=-1, depth_taper=-1) {
    translate([0, 0, -depth]) cylinder(d=d_min, h=depth);
    if (d_taper > 0 && depth_taper > 0) {
        translate([0, 0, -depth_taper]) cylinder(d1=d_min, d2=d_taper, h=depth_taper);
    } else if (d_taper > 0 || depth_taper > 0) {
        echo("hsi: Ignoring invalid taper parameter.");
    }
}

// Non-tapered hole
//hsi(5.2, 3.8*1.5);

// Tapered hole
//hsi(5.2, 3.8*1.5, 5.6, 1);
