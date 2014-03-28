// configure your bracelet here
bracelet_diameter	= 65; // mm
bracelet_width		= 12.5;
bracelet_thickness	= 2;
bracelet_text		= "RepRp"; // message must be array
bracelet_font		= "DejaVu Sans:style=Bold";
bracelet_font_size	= 7;
bracelet_spacing		= 7;
bracelet_text_rep	= 3; // number of times to repeat message
bracelet_voffset		= 3; // nudge the text up/down
// advanced configuration
bracelet_kerning		= 0;//[0,7,13.4,20.1,27.1,33.1]; //must be same len as message
logo_enabled			= 0;
logo_offset			= -7;
bevel_size			= 0.5;

fudge = 0.1;
detail = 100;
pi = 3.142;

difference() {
  cylinder(r = bracelet_diameter / 2,
	  	   h = bracelet_width,
	  	   $fn = detail);
  translate([0,0,-fudge])
    cylinder(r = bracelet_diameter / 2 - bracelet_thickness,
			h = bracelet_width + 2 * fudge,
			$fn = detail);

  for(j = [0 : 360 / bracelet_text_rep : 360]) {
    rotate([0,0,j]) {
      // the text
      if(bracelet_kerning) {
        for (i = [0 : len(bracelet_text) - 1]) {
          rotate([0,0,(bracelet_kerning[i] / (bracelet_diameter / 2)) * (180 / pi)])
            translate([-bracelet_font_size / 2,
					-bracelet_diameter / 2 + bracelet_thickness / 2,
					bracelet_voffset]) rotate([90,0,0])
              linear_extrude(height = bracelet_thickness)
                text(t = bracelet_text[i],
				  font = bracelet_font,
				  size = bracelet_font_size);
        }
      } else {
       for (i = [0 : len(bracelet_text) - 1]) {
          rotate([0,0,i * (bracelet_spacing / (bracelet_diameter / 2)) * (180 / pi)])
            translate([-bracelet_font_size / 2,
					-bracelet_diameter / 2 + bracelet_thickness / 2,
					bracelet_voffset]) rotate([90,0,0])
              linear_extrude(height = bracelet_thickness)
                text(t = bracelet_text[i],
				  font = bracelet_font,
				  size = bracelet_font_size);
        }
      }

    //the logo
    if(logo_enabled) {
      rotate([0,0,(logo_offset / (bracelet_diameter / 2)) * (180 / pi)])
        translate([0,-bracelet_diameter / 2 + bracelet_thickness / 2,bracelet_width / 2])
          logo();
      }
    }
  }

  //bevel
  if(bevel_size) {
    translate([0,0,-fudge])
      cylinder(r1 = bracelet_diameter / 2 - bracelet_thickness + bevel_size,
			   r2 = bracelet_diameter / 2 - bracelet_thickness,
			   h = bevel_size,
			   $fn = detail);
    translate([0,0,bracelet_width - bevel_size + fudge])
      cylinder(r2 = bracelet_diameter / 2 - bracelet_thickness + bevel_size,
			   r1 = bracelet_diameter / 2 - bracelet_thickness,
			   h = bevel_size,
			   $fn = detail);
    translate([0,0,-fudge]) difference() {
      cylinder(r = bracelet_diameter / 2 + fudge, h = bevel_size, $fn = detail);
      cylinder(r1 = bracelet_diameter / 2 - bevel_size,
			  r2 = bracelet_diameter / 2 + fudge,
			  h = bevel_size,
			  $fn = detail);
    }
    translate([0,0,bracelet_width - bevel_size + fudge]) difference() {
      cylinder(r = bracelet_diameter / 2 + fudge, h = bevel_size, $fn = detail);
      cylinder(r2 = bracelet_diameter / 2 - bevel_size,
			  r1 = bracelet_diameter / 2 + fudge,
			  h = bevel_size,
			  $fn = detail);
    }
  }
}

module logo() {
  // you can put any logo in here
  rotate([90,0,0])
    hull() {
      cylinder(r = 3, h = bracelet_thickness, $fn = detail / 4);
      translate([-fudge / 2,3 / cos(45),0])
        cube([fudge,fudge,bracelet_thickness]);
  }
}