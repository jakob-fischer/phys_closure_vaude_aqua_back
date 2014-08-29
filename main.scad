a=33.0;
b=31.3;
R=4;
r=7;
h=1.5;


//translate([-40,0,0])

module notch(h_, a_, b_, R_, r_) {
    linear_extrude(height = h_) {
        translate([-b_/2+R_,a_/2])
            circle(R_, $fn = 60);

        translate([-b_/2+R_,-a_/2])
            circle(R_, $fn = 60);

        translate([+b_/2-r_,a_/2])
            circle(r_, $fn = 60);

        translate([+b_/2-r_,-a_/2])
            circle(r_, $fn = 60);

        scale([b_, a_])
            square ([1,1],center = true);

        polygon( points=[[-b_/2+R_,a_/2+R_],[-b_/2+R_,-a_/2-R_],[b_/2-r_,-a_/2-r_],[b_/2-r_,a_/2+r_]] );
    }
}

//translate([-40,0,0]) {
//    notch(4, a, b, R, r);
//
//    translate([0,0,-h/2])
//        notch(h, a+20, b+20, R, r);
//}

l1=2.65;
l2=25;
l3=8.5;
w1=33.5;
w2=5.5;

h1=6.0;
h2=8.3;
hooks_length=8;
hooks_width1=4.5;
hooks_width2=5.5;
nose_width=1.5;
fence_width=10;
fence_strength=3;

base_top_strength=3;



module sledge() {
    translate([0,0,-0.5])
    linear_extrude(height = h1+1) {
        
        polygon( points=[[l1,w1/2],
                         [l1+hooks_length,w1/2],
                         [l1+hooks_length,w1/2-hooks_width2],
                         [l1,w1/2-hooks_width1]] );

        polygon( points=[[l1,-w1/2],
                         [l1+hooks_length,-w1/2],
                         [l1+hooks_length,-w1/2+hooks_width2],
                         [l1,-w1/2+hooks_width1]] );

        translate([l1+l2-l3/2, 0])
            square([l3, nose_width], center=true);

        translate([l1+l2+fence_strength/2, 0])
            square([fence_strength, fence_width], center=true);
    }
}

//sledge();

module free_space() {
    linear_extrude(height = h2) {
        difference() {
            translate([(l1+l2-l3)/2,0])
                scale([l1+l2-l3, w1])
                    square ([1,1],center = true);

            translate([l1+l2-l3, w1/2])
                scale([l2-l3, (w1-w2)/2])
                    circle(1, $fn = 60);

            translate([l1+l2-l3, -w1/2])
                scale([l2-l3, (w1-w2)/2])
                    circle(1, $fn = 60);
        }
    }
}


module catcher() {
    difference() {
        union() {
            translate([0,-w1/2, -base_top_strength])
                cube([l1+l2+fence_strength, w1,base_top_strength]);

            difference() {
                translate([l1,-w1/2, h1])
                    cube([l2+fence_strength, w1,base_top_strength]);

                translate([l1+l2, w1/2])
                    linear_extrude(height = 20)
                        scale([l2-hooks_length,(w1-fence_width)/2])
                            circle(1, $fn = 60);

                translate([l1+l2, -w1/2])
                    linear_extrude(height = 20)
                        scale([l2-hooks_length,(w1-fence_width)/2])
                            circle(1, $fn = 60);
            }

            sledge();
        }

        translate([0,0,-(h2-h1)/2])
            free_space();  
    }
}


catcher();

translate([15,0,-5]) {
    notch(4, a, b, R, r);

    translate([0,0,-h/2])
        notch(h, a+20, b+20, R, r);
}

