use <MCAD/2Dshapes.scad>;
use <hsi.scad>

/* [Build Options] */
// Build target
TARGET="nothing"; // ["nothing", "dummy", "demo_assy", "blocks"]
// Preview target
PREVIEW="2d_assy"; // ["2d_assy", "2d_led_cover", "2d_base", "2d_lkp_conn_cutout", "build"]

/* [General Parameters] */
// Minimum thickness of the base.
BASE_MIN_THICKNESS = 2;
// Thickness of the extended LED strip backing structure.
LED_BACKING_THICKNESS = 2;
// Width of the top extension.
TOP_EXT_WIDTH = 8;
// Width of the bottom extension.
BOTTOM_EXT_WIDTH = 8;
// Width of the bottom adhesive (must be <= BOTTOM_EXT_WIDTH. Recommended to be < BOTTOM_EXT_WIDTH for best Alpaca integration).
BOTTOM_EXT_ADH_WIDTH = 6.5;
// Width of the side extension.
SIDE_EXT_WIDTH = 4;
// Length of heat set inserts.
HSI_LENGTH = 3;

/* [LED Strip Parameters] */
// Width of the LED strip.
LED_STRIP_WIDTH = 12;
// Thickness of the LED strip.
LED_STRIP_THICKNESS = 3;
// Offset of LED strip. Positive = Move up. Note that the center of each LED must align with the overlay.
LED_STRIP_OFFSET = 0.0;

/* [Slider Parameters] */
// Width of the LKP PCB (40+-tolerance).
LKP_PCB_WIDTH = 40.5;
// Length of the LKP PCB.
LKP_PCB_TOTAL_LENGTH = 516;
// Thickness of the LKP PCB.
LKP_PCB_THICKNESS = 1.6;
// Offset of the mounting hole.
LKP_SIDE_TAB_MOUNTING_HOLE_OFFSET = 4;
// Width of the side tab.
LKP_SIDE_TAB_WIDTH = 8;
// Width of the overlay portion that is covered by the overlay clamp.
OVERLAY_EXT_WIDTH = 3;
// Thickness of the acrylic/PC overlay.
OVERLAY_THICKNESS = 2;


/* [Hidden] */
EPSILON=0.001;
// Lower width of the strip originating from center of each LED.
_LED_LOWER_WIDTH = LED_STRIP_WIDTH / 2 - LED_STRIP_OFFSET;
// Upper width of the strip originating from center of each LED.
_LED_UPPER_WIDTH = LED_STRIP_WIDTH / 2 + LED_STRIP_OFFSET;

// Width of the base
_BASE_WIDTH = BOTTOM_EXT_WIDTH
            + LKP_PCB_WIDTH
            + OVERLAY_EXT_WIDTH
            + LED_STRIP_THICKNESS
            + LED_BACKING_THICKNESS
            + TOP_EXT_WIDTH;

// How deep should the groove be
_LED_GROOVE_PADDING = _LED_LOWER_WIDTH + OVERLAY_THICKNESS / 2;
// How deep should the PCB cut-out be
_LKP_CUTOUT_DEPTH = LKP_PCB_THICKNESS + OVERLAY_THICKNESS;

// Minimum thickness + LED groove depth or PCB cut-out depth, whichever deeper.
_BASE_THICKNESS = BASE_MIN_THICKNESS
                + max(_LED_GROOVE_PADDING, _LKP_CUTOUT_DEPTH);

_LKP_ORIGIN = [BOTTOM_EXT_WIDTH, _BASE_THICKNESS - _LKP_CUTOUT_DEPTH];

// Width of the overlay
_OVERLAY_WIDTH = BOTTOM_EXT_ADH_WIDTH + LKP_PCB_WIDTH + OVERLAY_EXT_WIDTH;
_OVERLAY_CUTOUT = [
    _OVERLAY_WIDTH + EPSILON*2,
    OVERLAY_THICKNESS + EPSILON
];

_LKP_CUTOUT = [
    LKP_PCB_WIDTH,
    LKP_PCB_THICKNESS + OVERLAY_THICKNESS
];

_LED_GROOVE_ORIGIN = [
    BOTTOM_EXT_WIDTH + LKP_PCB_WIDTH + OVERLAY_EXT_WIDTH,
    _BASE_THICKNESS - _LED_GROOVE_PADDING
];

_LED_CABLE_HOLE_ORIGIN = [_LED_GROOVE_ORIGIN.x, 0];

_LED_KEEPOUT = [LED_STRIP_THICKNESS, LED_STRIP_WIDTH];
_LED_KEEPOUT_CABLE_HOLE = [
    LED_STRIP_THICKNESS,
    LED_STRIP_WIDTH+(_LED_GROOVE_ORIGIN.y-_LED_CABLE_HOLE_ORIGIN.y)
];

_LED_BACKING_ORIGIN = [
    _LED_GROOVE_ORIGIN.x + LED_STRIP_THICKNESS,
    _LED_GROOVE_ORIGIN.y
];

_LED_BACKING = [LED_BACKING_THICKNESS, LED_STRIP_WIDTH];

_LED_BACKING_EXT_HEIGHT = LED_STRIP_WIDTH + BASE_MIN_THICKNESS - _BASE_THICKNESS;

_LED_COVER_THICKNESS = OVERLAY_EXT_WIDTH + _LED_BACKING_EXT_HEIGHT;

_LKP_CUTOUT_LENGTH_PER_BLOCK = LKP_PCB_TOTAL_LENGTH / 3;

// TODO Parametric screws
_SCREW_HOLE_DEPTH_BOTTOM = _BASE_THICKNESS - OVERLAY_THICKNESS - 2;
_SCREW_HOLE_DEPTH_TOP = _BASE_THICKNESS + _LED_COVER_THICKNESS - 2;
_SCREW_HOLE_DEPTH_TOP_BASE = _BASE_THICKNESS;
_SCREW_HOLE_DEPTH_TOP_COVER = _BASE_THICKNESS;

_BLOCK_SCREW_HOLE_OFFSET = 30;
//_LED_COVER_SCREW_HOLE_OFFSET = 45;

_HSI_HOLE_DEPTH = HSI_LENGTH * 1.5;

// Total length of assembly
_ASSY_LENGTH = LKP_PCB_TOTAL_LENGTH+SIDE_EXT_WIDTH*2;

// Sensor center offsets
_SENSOR_ASSY_COFFSET = [0, _BASE_WIDTH / 2 - (BOTTOM_EXT_WIDTH+LKP_PCB_WIDTH/2)];
_SENSOR_OVERLAY_COFFSET = [0, _OVERLAY_WIDTH / 2 - (BOTTOM_EXT_ADH_WIDTH+LKP_PCB_WIDTH/2)];


// Exports
LKP_EXPORT_ASSY_DIM = [_ASSY_LENGTH, _BASE_WIDTH];
LKP_EXPORT_OVERLAY_DIM = [LKP_PCB_TOTAL_LENGTH, _OVERLAY_WIDTH];
LKP_EXPORT_ASSY_ZOFFSET = - _BASE_THICKNESS + OVERLAY_THICKNESS;

function lkp_get_assy_dim() = LKP_EXPORT_ASSY_DIM;
function lkp_get_overlay_dim() = LKP_EXPORT_ASSY_DIM;
function lkp_get_assy_zoffset() = LKP_EXPORT_ASSY_ZOFFSET;


function _bottom_screw_hole(off) = [
    BOTTOM_EXT_WIDTH / 2,
    // Bottom extension thickness
    _BASE_THICKNESS - OVERLAY_THICKNESS + EPSILON,
    off
];
function _top_screw_hole_base(off) = [
    _LED_BACKING_ORIGIN.x + LED_BACKING_THICKNESS + TOP_EXT_WIDTH / 2,
    _BASE_THICKNESS + EPSILON,
    off
];
function _top_screw_hole_cover(off) = [
    TOP_EXT_WIDTH / 2,
    _LED_COVER_THICKNESS + EPSILON,
    off
];

function _bottom_hsi(off) = [
    BOTTOM_EXT_WIDTH / 2,
    // Bottom extension thickness
    -EPSILON,
    off
];
function _top_hsi(off) = [
    _LED_BACKING_ORIGIN.x + LED_BACKING_THICKNESS + TOP_EXT_WIDTH / 2,
    -EPSILON,
    off
];
function _top_hsi_led_cover(off) = [
    _LED_BACKING_ORIGIN.x + LED_BACKING_THICKNESS + TOP_EXT_WIDTH / 2,
    _BASE_THICKNESS + EPSILON,
    off
];
function _led_cover_screw_hole(off) = [
    TOP_EXT_WIDTH / 2,
    _LED_COVER_THICKNESS,
    off
];

module lkp_assy_profile() {
    square(LKP_EXPORT_ASSY_DIM, center=true);
}

module lkp_assy_sensor_center() {
    translate(_SENSOR_ASSY_COFFSET) children();
}

module lkp_overlay_sensor_center() {
    translate(_SENSOR_OVERLAY_COFFSET) children();
}

module iso7380_m3(length, headless=false) {
    dk = 6.0;
    d = 3.0 + 0.4;
    head_depth = 2;
    if (!headless) {
        translate([0, 0, -head_depth]) {
            cylinder(h=head_depth+EPSILON, d=dk);
        }
        translate([0, 0, -head_depth-length]) {
            cylinder(h=length+EPSILON, d=d);
        }
    } else {
        translate([0, 0, -length]) {
            cylinder(h=length+EPSILON, d=d);
        }
    }
}

module hsi_m3x3_od4mm() {
    hsi(3.6, _HSI_HOLE_DEPTH + EPSILON, d_taper=4.2, depth_taper=0.8);
}

module base_ex(side_ext=false) {
    union() {
        // Cutouts
        difference() {
            // Base shape
            square([_BASE_WIDTH, _BASE_THICKNESS]);
            // Cut out for LKP PCB and overlay
            if (!side_ext) {
                translate(_LKP_ORIGIN) {
                    union() {
                        // PCB
                        square(_LKP_CUTOUT);
                        // Overlay (above PCB)
                        translate([-EPSILON-BOTTOM_EXT_ADH_WIDTH, LKP_PCB_THICKNESS])
                        square(_OVERLAY_CUTOUT);
                    }
                }
            }
            if (side_ext) {
                translate(_LED_CABLE_HOLE_ORIGIN)
                    square(_LED_KEEPOUT_CABLE_HOLE);
            } else {
                // LED groove
                translate(_LED_GROOVE_ORIGIN) square(_LED_KEEPOUT);
            }
        }
        // Additions
        // LED backing
        translate(_LED_BACKING_ORIGIN) square(_LED_BACKING);
    }
}

module led_cover_ex() {
    union() {
        // Cover main body
        square([TOP_EXT_WIDTH, _LED_COVER_THICKNESS]);
        // Overlay clamp annex
        translate([-LED_BACKING_THICKNESS-EPSILON, _LED_BACKING_EXT_HEIGHT]) {
            square([
                LED_BACKING_THICKNESS + TOP_EXT_WIDTH + EPSILON,
                OVERLAY_EXT_WIDTH
            ]);
        }
        // Overlay clamp
        _overlay_annex_2_height = _LED_COVER_THICKNESS
                                - LED_STRIP_THICKNESS
                                - OVERLAY_EXT_WIDTH;
        _overlay_annex_2_origin = -LED_BACKING_THICKNESS
                                - LED_STRIP_THICKNESS
                                - OVERLAY_EXT_WIDTH;
        // Rounded clamp will collide with the overlay
        if (_overlay_annex_2_height < 0) {
            echo("Rounded clamp will collide with the overlay, fallback to square.");
            translate([_overlay_annex_2_origin, 0]) {
                square([OVERLAY_EXT_WIDTH, _LED_COVER_THICKNESS]);
                translate([0, _LED_BACKING_EXT_HEIGHT]) square([
                    LED_STRIP_THICKNESS+OVERLAY_EXT_WIDTH,
                    OVERLAY_EXT_WIDTH
                ]);
            }
        } else {
            translate([-LED_BACKING_THICKNESS, _overlay_annex_2_height])
            donutSlice(
                innerSize=LED_STRIP_THICKNESS,
                outerSize=LED_STRIP_THICKNESS + OVERLAY_EXT_WIDTH,
                start_angle=90,
                end_angle=180
            );
            if (_overlay_annex_2_height != 0) {
                translate([_overlay_annex_2_origin, 0])
                square([OVERLAY_EXT_WIDTH, _overlay_annex_2_height]);
            }
        }
    }
}

module lkp_connector_cutout_ex() {
    translate([-15.625, 0]) square([12, 24], center=true);
    translate([15.625, 0]) square([12, 24], center=true);
}

module base_bare() {
    // To lay flat horizontally, use
    //rotate([90, 0, 90])
    linear_extrude(_LKP_CUTOUT_LENGTH_PER_BLOCK) {
        base_ex();
    }
}

module led_cover_bare() {
    linear_extrude(_LKP_CUTOUT_LENGTH_PER_BLOCK) {
        led_cover_ex();
    }
}

module side_ext_base() {
    linear_extrude(SIDE_EXT_WIDTH + EPSILON) {
        base_ex(side_ext=true);
    }
}

module side_ext_led_cover() {
    linear_extrude(SIDE_EXT_WIDTH + EPSILON) {
        led_cover_ex();
    }
}

module lkp_hsi(off) {
    translate([_LKP_ORIGIN.x + (LKP_PCB_WIDTH / 2), _LKP_ORIGIN.y+EPSILON, off]) {
        translate([15, 0, 0]) rotate([-90, 0, 0]) hsi_m3x3_od4mm();
        translate([-15, 0, 0]) rotate([-90, 0, 0]) hsi_m3x3_od4mm();
    }
}


module base() {
    loff = _BLOCK_SCREW_HOLE_OFFSET;
    roff = _LKP_CUTOUT_LENGTH_PER_BLOCK - _BLOCK_SCREW_HOLE_OFFSET;
    coff = _LKP_CUTOUT_LENGTH_PER_BLOCK / 2;
    difference() {
        base_bare();
        translate(_bottom_hsi(loff)) rotate([90, 0, 0])
        hsi_m3x3_od4mm();
        translate(_bottom_hsi(roff)) rotate([90, 0, 0])
        hsi_m3x3_od4mm();
        translate(_top_hsi(coff)) rotate([90, 0, 0])
        hsi_m3x3_od4mm();
        translate(_top_hsi_led_cover(loff)) rotate([-90, 0, 0])
        hsi_m3x3_od4mm();
        translate(_top_hsi_led_cover(roff)) rotate([-90, 0, 0])
        hsi_m3x3_od4mm();
    }
}

module led_cover() {
    loff = _BLOCK_SCREW_HOLE_OFFSET;
    roff = _LKP_CUTOUT_LENGTH_PER_BLOCK - _BLOCK_SCREW_HOLE_OFFSET;
    difference() {
        led_cover_bare();
        translate(_led_cover_screw_hole(loff)) rotate([-90, 0, 0])
        #iso7380_m3(_LED_COVER_THICKNESS-2+EPSILON);
        translate(_led_cover_screw_hole(roff)) rotate([-90, 0, 0])
        #iso7380_m3(_LED_COVER_THICKNESS-2+EPSILON);
    }
}

module base_l() {
    difference() {
        // Base with ext
        union() {
            base();
            translate([0, 0, -SIDE_EXT_WIDTH]) side_ext_base();
        }
        // Screw holes for LKP PCB
        lkp_hsi(LKP_SIDE_TAB_MOUNTING_HOLE_OFFSET);
    }
}

module base_r() {
    difference() {
        // Base with ext
        union() {
            base();
            translate([0, 0, _LKP_CUTOUT_LENGTH_PER_BLOCK - EPSILON]) side_ext_base();
        }
        // Screw holes for LKP PCB
        lkp_hsi(_LKP_CUTOUT_LENGTH_PER_BLOCK - LKP_SIDE_TAB_MOUNTING_HOLE_OFFSET);
    }
}

module base_c() {
    difference() {
        base();
        translate([
            _LKP_ORIGIN.x + (LKP_PCB_WIDTH / 2),
            -EPSILON,
            _LKP_CUTOUT_LENGTH_PER_BLOCK / 2
        ]) rotate([-90, 90, 0]){
            linear_extrude(_LKP_ORIGIN.y + 2 * EPSILON) lkp_connector_cutout_ex();
        }
    }
}

module led_cover_l() {
    led_cover();
    translate([0, 0, -SIDE_EXT_WIDTH]) side_ext_led_cover();
}

module led_cover_r() {
    led_cover();
    translate([0, 0, _LKP_CUTOUT_LENGTH_PER_BLOCK - EPSILON]) side_ext_led_cover();
}

module led_cover_c() {
    led_cover();
}


module top_blocks() {
    overlay_clamp_len = LED_STRIP_THICKNESS + OVERLAY_EXT_WIDTH + LED_BACKING_THICKNESS;
    translate([SIDE_EXT_WIDTH, -10-_BASE_WIDTH, 0]) rotate([90, 0, 90])
    base_l();
    translate([0, 10, 0]) rotate([90, 0, 90])
    base_r();
    translate([200, 10, 0]) rotate([90, 0, 90])
    base_c();

    translate([200+SIDE_EXT_WIDTH, -10-overlay_clamp_len, 0]) rotate([90, 0, 90])
    led_cover_l();
    translate([200, -30-overlay_clamp_len, 0]) rotate([90, 0, 90])
    led_cover_r();
    translate([200, -50-overlay_clamp_len, 0]) rotate([90, 0, 90])
    led_cover_c();
}

module demo_assy() {
    echo("Demo models are for demostration only. DO NOT print!");
    rotate([90, 0, 90]) {
        base_l();
        translate([0, 0, _LKP_CUTOUT_LENGTH_PER_BLOCK]) base_c();
        translate([0, 0, _LKP_CUTOUT_LENGTH_PER_BLOCK * 2]) base_r();
        translate([_LED_BACKING_ORIGIN.x + _LED_BACKING.x, _BASE_THICKNESS, 0]) {
            led_cover_l();
            translate([0, 0, _LKP_CUTOUT_LENGTH_PER_BLOCK]) led_cover_c();
            translate([0, 0, _LKP_CUTOUT_LENGTH_PER_BLOCK * 2]) led_cover_r();
        }
    }
}

// Demo assembly. Centered at sensor center.
module lkp_demo_assy_centered() {
    translate([-LKP_PCB_TOTAL_LENGTH/2, -BOTTOM_EXT_WIDTH-LKP_PCB_WIDTH/2, 0]) demo_assy();
}

module lkp_overlay_profile() {
    difference() {
        square(LKP_EXPORT_OVERLAY_DIM, center=true);
        // Left screw holes
        translate([-LKP_PCB_TOTAL_LENGTH/2 + LKP_SIDE_TAB_MOUNTING_HOLE_OFFSET, 0])
                translate(-_SENSOR_OVERLAY_COFFSET) {
            translate([0, -15, 0]) circle(d=3.4);
            translate([0, 15, 0]) circle(d=3.4);
        }

        // Right screw holes
        translate([LKP_PCB_TOTAL_LENGTH/2 - LKP_SIDE_TAB_MOUNTING_HOLE_OFFSET, 0])
                translate(-_SENSOR_OVERLAY_COFFSET) {
            translate([0, -15, 0]) circle(d=3.4);
            translate([0, 15, 0]) circle(d=3.4);
        }
    }
}

module lkp_assy_zposition() {
    translate([0, 0, LKP_EXPORT_ASSY_ZOFFSET]) children();
}

// Print dimension info
echo("*** Begin Dimension Info ***");
echo("Extrusion Profile")
echo(led_groove_padding=_LED_GROOVE_PADDING, lkp_cutout_depth=_LKP_CUTOUT_DEPTH);
echo(base_width=_BASE_WIDTH, base_thickness=_BASE_THICKNESS);
echo(overlay_width=_OVERLAY_WIDTH);
echo(led_cover_thickness=_LED_COVER_THICKNESS);

echo("3D Block Profile")
echo(
    screw_hole_depth_bottom=_SCREW_HOLE_DEPTH_BOTTOM,
    screw_hole_depth_top=_SCREW_HOLE_DEPTH_TOP
);
echo(assy_length=_ASSY_LENGTH);
echo("*** End Dimension Info ***");


// TODO parameters for generating dummies
if ($preview && PREVIEW != "build") {
    if (PREVIEW == "2d_assy") {
        base_ex();
        translate([_LED_BACKING_ORIGIN.x + _LED_BACKING.x, _BASE_THICKNESS]) {
            led_cover_ex();
        }
    } else if (PREVIEW == "2d_led_cover") {
        led_cover_ex();
    } else if (PREVIEW == "2d_base") {
        base_ex();
    } else if (PREVIEW == "2d_lkp_conn_cutout") {
        lkp_connector_cutout_ex();
    }
} else {
    $fn=40;
    if (TARGET == "dummy") {
        linear_extrude(10) {
            base_ex();
        }
        translate([0, 10]) linear_extrude(10) {
            led_cover_ex();
        }
    } else if (TARGET == "demo_assy") {
        demo_assy();
    } else if (TARGET == "blocks") {
        top_blocks();
    }
}
