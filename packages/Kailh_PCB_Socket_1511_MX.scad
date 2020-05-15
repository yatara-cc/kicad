/* Datasheet via NovelKeys */
/* https://novelkeys.xyz/products/kailh-pcb-sockets */
/* https://cdn.shopify.com/s/files/1/3099/8088/files/CPG151101S11_MX_Socket.pdf?4656976507916097806 */

/* https://cdn.shopify.com/s/files/1/3099/8088/files/CPG135001S30_Choc_PCB_Socket.pdf?11560148761728190369  */

unit = 1.27;
base_height = 1.8;
base_length = 10.9;
base_width = 5.89;
base_r1 = unit * 0.2;  // Small corner radius
base_r2 = unit;  // Large corner radius
base_r3 = unit * 1.75;  // Internal radius
base_w1 = 4.0;  // Short side
stud_height = 3.05;
stud_diameter = 3.00;
stud_ch_xy = 0.25;
stud_ch_z = 0.5;
stud_dx = 6.35;
stud_dy = 2.54;
cx = unit * 0.5;
cy = unit * 3;

module stud () {
     hull() {
          translate([0, 0, base_height + stud_ch_z - stud_height]) {
               cylinder(d=stud_diameter, h=stud_height - stud_ch_z);
          }
          translate([0, 0, base_height - stud_height]) {
               cylinder(d=stud_diameter - stud_ch_xy, h=stud_height);
          }
     }
}

module base_2d () {
     left = cx - base_length / 2;
     right = cx + base_length / 2;
     bottom = cy - base_width / 2;
     top = cy + base_width / 2;

     b1_sy = base_w1 - base_r1;
     b1_sx = 3.75;
     
     angle = 20;

     // Positive circle
     cpr = base_r1;
     cpx = right - b1_sx;
     cpy = bottom + cpr;

     // Negative circle
     cnr = base_r3;
     cny = top - base_w1 - cnr;

     th = cpr + cnr;
     ty = cpy - cny;
     tx = sqrt(th * th - ty * ty);

     cnx = cpx - tx;
     
     iy = cny + ty * cnr / th;


     union () {
          translate([left, top - b1_sy]) {
               square([base_length - base_r2, b1_sy]);
          }
          translate([right - b1_sx, bottom]) {
               square([b1_sx, base_width - base_r2]);
          }
          translate([left + base_r1, top - base_w1]) {
               square([base_length - base_r1 - base_r2, base_r1]);
          }

          translate([left + base_r1, top - b1_sy]) {
               circle(r=base_r1, $fn=16);
          }
          translate([right - base_r2, top - base_r2]) {
               circle(r=base_r2, $fn=32);
          }
          translate([cpx, cpy]) {
               circle(r=cpr, $fn=16);
          }
          difference() {
               translate([cnx, iy]) {
                    square([th, th]);
               }
               translate([cnx, cny]) {
                    circle(r=cnr, $fn=48);
               }
          }
     }
}

color("grey") {
     union () {
          linear_extrude(base_height) {
               base_2d();
          }

          translate([unit * -2, unit * 4, 0]) {
               stud($fn=32);
          }
          translate([unit * 3, unit * 2, 0]) {
               stud($fn=32);
          }
     }
}
