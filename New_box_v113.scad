use <lib/braille.scad>
// use <lib/qrcode.scad>
//use <lib/battery_box_2.0.scad>;
use <lib/sensors.scad>;
use <lib/utilities.scad>;
// Openscad config:
// minimum angle
$fa = 1;
// minimum size
$fs = 0.4;
// number of fragments 
$fn = 48;

showwall=false;
showlid=false;

x=100;
y=95;
xoffs = 0;
yoffs = 20;

// boxheight=20;
boxheight=50;
showbox = true;
makeObjects = true;
showpcb=true;
// mountDia = 2.1;
mountDia = 2.1;

// Include battery 
// The batteries me19asure 18 mm (0.71 in) in diameter by 65 mm (2.56 in) in length, giving them the name 18650.

if (showbox) {
    //color("pink") makeBattSupport();
    difference() {
    makeBox();
    {
    makeDevice();
    antennaPlacement(tolerance=1);
    makeBattCutout();
    makeBatt();
    // translate([15,-7,-10]) cylinder(20, d=10); 
    // translate([15,+102,-10]) cylinder(20, d=6); 
    translate([-xoffs,-yoffs,0]) rectangleOfObjects(x+2*xoffs, y+2*yoffs, z=10, d=8, dx=15, dy=yoffs/2, n=4, type="cylinder");
    /*
    x,y: size of board (specify hole offset with dx, dy)
         or: size of rectangle of holes (dx=dy=0)
             specifiy offset with ddx, ddy.
    n:   number of cylinders to make
    inch: values for x,y,dx,dy,ddx,ddy are specified in tenth of inch.
    d:   diameter of cylinders (always in mm)
    z:   height of cylinder (always in mm)
    */  
    makeBoxTopHoles();
    };
    };    
}

if (makeObjects) { 
    makeDevice(); 
    antennaPlacement(tolerance=0);
    makeBattCutout();
    makeBatt();
    makeBoxTopHoles();
};


module makeBattCutout() {
    xxx = +0;
    translate([xxx,-15,0]) cutout1();
    translate([xxx,15,0]) cutout1();    
    module cutout1() {
        translate([95,35,18]) color("purple") cube([10,10,3]);
        translate([76,35,8]) color("purple") rotate([0,90,0]) cube([10,10,3]);
    };
};

module makeBattSupport() {
    //batt support
    translate([79,20,+1]) color("yellow") cube([3,40,3]);
};

module makeBatt() {
    translate([88,5,12]) rotate([0,90,90]) {
    color("pink") cylinder(d=18, h=65);
    xx=13;
    //translate([-9+xx,-9,0]) color("red") cube([18-xx, 18, 65]);    
    }
}

module antennaPlacement(tolerance=0) {
    translate([57,+136,-15]) rotate([0,0,180]) {
    antenna(tolerance=tolerance);
    // makeAntennaMount();
    };
};

module makeBox() {
    // Box
    translate([-xoffs,-yoffs,0]) color("black") frame(x+2*xoffs,y+2*yoffs,thickness="", height=3, inset=0, cornerspace=2, cornerarch=true, cornerinsidearch=false);
    // walls
    color("grey") frame(x,y,thickness=3, height=boxheight, inset=0, cornerspace=2, cornerarch=true, cornerinsidearch=false);
    // curve in the lid
    translate([0,0,boxheight-1]) color("grey") frame(x,y,thickness=9, height=3, inset=0, cornerspace=2, cornerarch=true, cornerinsidearch=false);
};

module makeBoxTopHoles() {
    translate([0,0,boxheight-5]) floatMount(x, y, z=10, d=mountDia, d2=0, rex="", rey="", dx=6, dy=6);
}

module makeAntennaMount() { 
    qq=1;
    // antenna
    translate([0,0,0]) {
        difference() {
            makeMount();
            translate([0,-0.01,0]) antenna(tolerance=1);
        };
        if (makeObjects) antenna();
    };        
    
    module makeMount() {
        //mount
        // translate([-3,30,0]) cube([6,24,25]);
        translate([2,5,0]) {
            color("lightblue") translate([-3-6+qq,50.5,22]) cube([10,2,13]);
            translate([-3-6+qq,0,22]) cube([10,5,15]);
        };
                         
    };
    
};

module antenna(tolerance=0) {
    qq=1;
    //antenna
    translate([10,-10,10]) {
    translate([-3+qq,0,+30]) {
        rotate([-90,0,0]) {
            cylinder(60, d=5.5+tolerance);
            color("orange") cylinder(50, d=8+tolerance);
        };
    };    
    };
};

module makeDevice() {
// Main PCBs
translate([10,17,6]) {
    //PCB1
    translate([0,0,0]) cube([60,46,1.5]);
    //PCB2
    translate([0,0,20])  cube([60,46,1.5]) ;
    translate([0,0,-10]) floatMount(60,46, z=40, d=mountDia, d2=0, rex=54, rey=40);
    if (showpcb) {
    translate([0,0,-6]) color("grey") rotate([0,0,90]) translate([146,-160,7]) { 
    translate([0,0,0]) rotate([90,0,0]) import("lib/kicard-models/logger.stl");
    translate([0,0,20]) rotate([90,0,0]) import("lib/kicard-models/sensor.stl");
    }
}
}

// LoRa
translate([39,+81,40]) rotate([0,90,90]) { 
    color("red") translate([0,0,0])  cube([36,31.9,5]) ;
    translate([0,0,-12]) floatMount(36,31.9, z=50, d=mountDia, d2=0, rex=25.9, rey=24.3);
}

//Display
translate([6,+7,4]) {
    rotate([90,0,0]) { 
    color("orange") translate([0,0,0])  cube([68.260,36.4,1.5]) ;
    offs=7;
    offsy=3;
    diffy=-1.5;
    color("yellow") translate([offs,offs-offsy+diffy,+1])  cube([68.260-2*offs,36.4-2*offs+2*offsy,8]) ;
    translate([0,0,-5]) floatMount(68.260,36.4,z=50, d=mountDia, d2=0, rex=62.260, rey=36.4);
    };
    if (showpcb) {
    translate([88.3,0,-83.6]) rotate([0,-90,90]) translate([210,-70,0]) rotate([90,0,0]) import("lib/kicard-models/display.stl");
    }
}

// amigo - green
translate([95,89,7])rotate([90,0,180]) { 
    color("green") translate([0,0,0])  cube([35.00,23,2]) ;
    translate([-25,11.5/2,-10]) color("yellow") translate([0,0,0])  cube([30.00,11.5,10]) ;
    translate([0,0,-5]) floatMount(35.00, 23, z=50, d=mountDia, d2=0, rex="", rey="", dx=2.5, dy=2.5);
}

}

if (1==2) {
translate([0,0,0]) boxmodel2(
    y=115, x=85,z=25, 
    lid=10, poplid=20, flange=20,
    wallthickness=3, 
    cornerradius=7, 
     showwall=showwall, showlid=showlid,
    rex=40, rey=54,
    designation="Node - too small", 
    brand="new", 
    label="new",
    showpcb=false

);



color("green") translate([0,-2,5]) {
    translate([192,160,0]) rotate([-90,0,0]) import("lib/kicard-models/lora.stl");
}

translate([+20,27,5]) sensor(
        number=10,
        showsensor=false,
        showcol=true,
        diameter="", 
        diameterfraction="",
        makeheader=true, 
        mountabove=false, 
        makelabel=true,
        showcube=true    
        );

};