
// Written by Volksswitch <www.volksswitch.org>
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
//
// keyguard.scad would not have been possible without the generous help of the following therapists and makers:
//	Justus Reynolds, Angela Albrigo, Kerri Hindinger, Sarah Winn, Matthew Provost, Jamie Cain Nimtz, Ron VanArsdale, 
//  Michael O Daly, Duane Dominick (JDD Printing), Joanne Roybal, Melissa Hoffmann, Annette M. A. Cooprider, 
//  Ashley Larisey, Janel Comerford, Joy Hyzny
//
//
// Version History:
//
// Version 2: added support for clip-on straps as a mounting method
// Version 3: rewritten to better support portrait mode and to use cuts to create openings to the screen surface rather than defining rails
//				fixed bug in where padding appeared - put it around the grid rather than around the screen
//				increased the depth of Velcro cut-outs to 3 mm, which roughly translates to 2 mm when printed
//				cut for home button is now made at 90 deg. to not encroach on the grid on tablets with narrow borders
// Version 4: added support for circular cut-outs and the option to specify the shape of the cut-outs
//              added support for covering one or more cells
//              added support for merging a cell cut-out and the next cell cut-out
// Version 5: can print out a plug for one of the cells in the keyguard by choosing "cell cover" in the 
//				Special Actions and Settings>generate pull-down
//				can add a fudge factor to the height and width of the tablet to accommodate filaments that shrink slightly when printing
//				can add add padding around the screen to make the keyguard stronger without affecting the grid and bars to account for cases
//                 that go right up to the edge of the screen
// Version 6: can control the slope of the edges of a message/command bar
// Version 7: moved padding options to Grid Layout section of the user interface to clarify that these affect only the grid region of the screen
//              changed the width of the right border of the iPad 5th generation tablet to match width of the left border
//              made some variable value changes so that it is easier to see the choices selected in the Thingiverse Customizer
//              changed cover_home_button and cover_camera to expose_home_button and expose_camera because the original options were confusing
// Version 8: reduced the maximum slide-in tab width from 30 mm to 10 mm
//            added the ability to merge circular cells horizontally and to merge both rectangular and circular cells vertically
// Version 9: added support rounding the corners of the keyguards, when they are placed in a case, to accommodate
//            cases that have rounded corners on their openings
//            combined functionality for both grid-based and free-form keyguards into a single designer
//	          can now create cell openings that are rounded-rectangles
//            can limit the borders of a keyguard to the size of the screen for testing layouts
// Version 10: reduced some code complexity by using the hull() command on hot dogs and rounded rectangles
//             removed options to compensate for height and width shrinkage, upon testing they are too simplistic and keyguards don't 
//                do well with annealing anyway
//             changed "raised tab thickness" to "preferred raised tab thickness" because the raised tab can't be thicker than the
//                keyguard or it won't slice properly - the keyguard will be raised off the print surface by the bottoms of the four
//                raised tabs
// Version 11: added support for iPad 6th Generation, iPad Pro 11-inch, and iPad Pro 12.9 inch 3rd Generation
//             added ability to offset the screen from one side of the case toward the other
//             fixed bug that caused rounded case corners not to appear in portrait mode
//             added ability to create outside corners on hybrid and freeform keyguards
//             added ability to change the width of slide-in and raised tabs and their relative location (changed the meaning of 
//                "width" as well)
// Version 12: extended the upper end of the padding options to 100 mm after seeing a GoTalk Now 2-button layout
//             minor corrections to a couple of iPad Air 2 measurements
//             added support for swapping the camera/home button sides
//             added support for sloped sides on outer arcs
// Version 13: added support for text engraving
// Version 14: added option to control the number of facets used in circles and arcs - the original value was 360 and the default is now
//                 40 which should greatly improve rendering times and eliminate issues for laptops with limited memory
//             separated the tablet data from the statement that selects the data to use with the intent of making it easier to update
//                 and change the data in Excel
//             migrated from using Apple's statement of "active area" dimension to calculating the size of the screen based on number 
//                 of pixels and pixel size - active area dimensions seemed to overestimate the size of the screen - also assume a single
//                 value for number of vertical pixels in a screen shot and therefore a single value for pixel to mm conversion based
//                 on the stated pixel size
//             added the ability to engrave text on the bottom of the keyguard
//             added support for a separate data file to hold cut information that sits outside of the screen area, will always
//                 be measured in millimeters and will always be measured from the lower left corner of the case opening - so now 
//                 there are two files for defining cuts: one for within the screen area and one for outside of the screen
// Version 15: added support for Nova Chat 10 (does not support exposing the camera)
//             cleaned up the logic around when to cut for home and camera to account for lack of a home button or camera on the
//                 face of the tablet
//             added support for additive features like bumps, walls and ridges
//             fixed bug with height and width compensation for tight cases 
//             added support for using clip-on straps with cases
//             added support for printing clips
//             added support for hiding and exposing the status bar at the top of the screen
// Version 16: changed code to use offset() command to create rounded corners rather than cutting the corners
//			   added a small chamfer to the top edge of the keyguard to reduce the chance of injury
//             changed code to add case and screen cuts "after" adding compensation for tight cases
//			   added support for the NOVAchat 10.5 (does not support exposing the camera)
//             changed filename extension of case_cuts and screen_cuts files from .scad to .info to reduce confusion about what is the 
//                main OpenSCAD program
// Version 17: changed code that creates rounded corner slide-in tabs to use the offset() command because original code was confusing the
//                Thingiverse Customizer
//             fixed bug that prevented adding bumps, ridges and walls in the case_openings.info file
//             added acknowledgements for all those who helped bring keyguard.scad to life
// Version 18: added support for splitting the keyguard into two halves for printing on smaller 3D printers
//             put small chamfer at the top edge of all openings including the home button opening
//                  - it's only visible with large edge slopes like 90 degrees
//             separated circle from hotdog when specifying screen and case openings
//             added minimal error checking for data in screen_openings.info and case_openings.info
//             fixed bug when placing additions from case_openings.info
//             moved pedestals for clip-on straps inward slightly to account for chamfer on the outside edge of keyguard
//             fixed bug that produced a static width for the vertical clip-on strap slots
// Version 19: changed upper limits on command and message bars from 25 mm to 40 mm to support large tablets
//             fixed bug that was exposed when adding height and width compensation to the keyguard for tight fitting cases with
//                  very large corner radii
//             made all radii, including those on the outer corners of the keyguard sensitive to the value of "smoothness_of_circles_and_arcs"
//             fixed a bug that clipped the underside of a clip-on pedestal when it is adjacent to a bar
// Version 20: added support for the iPad Air 3 and the Surface Pro 4
// Version 21: fixed bug involving clip-on straps and split keyguards
//			   fixed bug where cut for vertical clip-on strap (no case) was a different depth than the horizontal strap cuts
//             updated pixel sizes of 0.960 mm/pixel to a more accurate value of 0.962 mm/pixel
//             extended the upper bound for added thickness for tight cases from 15 mm to 20 mm
// Version 22: added number of horizontal pixels to the data for each tablet to properly support portrait mode for free-form and hybrid tablets
//             fixed several bugs associated with creating portrait free-form and hybrid tablets
// Version 23: allow raised tabs as thin as 1 mm
//             accounted for thin walls when using clip-on straps
//             added support for the NOVAchat 12
// Version 24: added support for the iPad 7th generation and iPad Mini 5
//	           changed all iPad data to use calculated screen size measurements rather than values of Active Area from Apple
//             added support for bold, italic, and bold-italic font styles to top and bottom text
// Version 25: added support for NovaChat 5 and 8
//             changed dimensions for NovaChat 10 based on feedback from Saltillo
//             added support for all Microsoft Surface tablets
//             fixed bugs with trim to screen and height and width compensation for tight cases
// Version 26: changed name of Surface Pro 2017 to Surface Pro 5
//             added support for the Fujitsu Stylistic Q665 (used in the Grid Pad 11 system)
//             added check for a zero mm/px corner radius used with a cut for a rounded rectangle and changes shape to a rectangle
//             fixed bugs associated with adding height and width compensation for tight cases
//             fixed bugs associated with trimming the keyguard to the size of the screen
//             fixed code so a zero width wall wouldn't appear between the message and command bar if both are exposed
//             modified outer arcs so that their chamfers would match the chamfers of other shapes in size
//             changed option for "slide_in_tab_thickness" to "preferred_slide_in_tab_thickness" and set actual thickness of tab to 
//                 depend on rail height minus outer chamfer
// Version 27: added support for Surface Pro 7 and Surface Pro X
//             added support for negative padding values
//             added support for dovetail joints, for a more reliable joint, when splitting a keyguard to print on a smaller printer
// Version 28: added support for independent widths for horizontal and vertical rails
//             added support for the Accent 1400 (AC14-20 & AC14-30) system
//             added support for systems (like the Accent) for which there is no tablet sizing information
//             added support for non-rectangular perimeters
//             added support for creating both loose and tight dovetail joints
//Version 29: extended tablet data to support non-iPad-style tablets by allowing for cameras and home buttons to be located on the
//                 long edge of the tablet and to have non-circular shapes
//            added support for clip-on straps to attach to long edge of keyguard, short edge, or both
//            added support for tablet-specific corner radii
//Version 30: added clip-on strap mounting pedestals and slide-in tabs to list of items that can be added to a keyguard in the 
//                  case_additions.info file - to make it possible to have a pedestals and tabs outside of the normal keyguard region 
//                  and into the case_additions regions
//            added support for two different "mini" clips - clips that don't wrap around to the underside of the tablet/case so that
//                   the clip won't interfere with the tablet mount
//            extended the spur of the clip an additional mm to better engage the slot in the pedestal
//            changed the width of the slots in clips to be a function of the clip width
//            added support for independently setting the widths of horizontal and vertical clips
//            fixed a bug with rounded-rectangle case additions when the corner radius is 0
//            fixed several bugs associated with creating cell covers
//Version 31: added support for Amazon Fire HD 8 (10th generation)
//            added support for the Accent 1000, the Dynavox 1-12+, and updated camera/home button info for NovaChat 8
//            changed camera and home button locations to be measured from the edge of the screen rather than the edge of the tablet
//            added support for cutting out the entire screen area - primarily to support validating dimensions for new tablets
//            fixed bug that improperly calculated trimming of towers for clips
//            refactored code associated with unequal case opening dimensions
//            added support for tablets where the screen doesn't sit exactly in the middle of the glass
//Version 32: added support for Dynavox Indi
//            added support for engraved and embossed SVG images
//Version 33: added support for Apple iPad models: iPad 8th generation, iPad Pro 12.9-inch 4th Generation, and iPad Air 4
//            fixed home button location and widened the camera opening for the iPad Pro 12.9-inch 3rd Generation
//            fixed bug in "swap camera and home button" when home button is not located on the face of the tablet
//            turned off creation of camera opening and home button opening if tablet is a system that requires a case
//Version 34: fixed bug in vridgef and hridge features
//			  added support for ridges around cells
//            removed support for walls in screen/case openings.info files
//Version 35: enlarged the opening for the home button in the Accent 1000 to make it easier to reach
//            added support for generating SVG/DXF files for laser-cutting a keyguard
//            limited slide-in tab length to 10 mm rather than 20 mm and set the minimum to 4 mm (exactly 3.175 mm for a
//                    laser-cut keyguard
//Version 36: fixed bug that allowed you to choose a mounting method other than slide-in tabs and no mount for a laser-cut keyguards
//            fixed bug that put a chamfer on outer arcs when type of keyguard is Laser-Cut
//            added support for displaying an SVG version of a screenshot below the keyguard
//            changed rules for shape of opening in laser cut keyguards to allow for circles and rounded rectangles with larger corner radii
//            changed rules to allow for SVG generation of first layer of 3D-Printed type of keyguard - used when testing fit of keyguard to screenshot
//Version 37: moved the home button location further from the edge of the screen and increased the height and width of the home button for
//                    the Accent 1000
//            fixed a bug associated with circular openings and cell ridges when changing rail widths
//            added support for the Fujitsu Stylistic 616 which is exactly like the Fujitsu Stylistic 665 and associated both with the GridPad
//            fixed bug that prevented height/width compensation from working with unequal left/bottom case openings
//            added support for adding height/width compensation to one side of the keyguard at a time
//            added a virtual tablet called "blank" that can be used to specify an arbitrary-sized keyguard - largely for laser-cutting
//            changed labels for "unit of measure" and "starting corner for measurements" to reinforce that they only apply to screen openings
//            added option to ignore Laser-Cutting best practices when creating a laser-cut keyguard
//            added ability to trim keyguard to an arbitrary rectangle by specifying the lower left and upper right coordinates relative to the
//                     lower left corner of the case opening
//            added the ability to use a large rectangle or rounded rectangle as an overall case addition
//            added temporary support for the Chat Fusion 10 from PRC/Saltillo, need verification of screen dimensions and camera/home button data
//            changed the x,y anchor point location for manual clip-on strap pedestals
//            fixed bug where engraved SVG images wouldn't rotate
//            added the ability to control the depth of an engraved svg image
//
//            
//
//
//preparing Lite version...
//Comment Sections 1 and 2 and set Lite to "yes"

//------------------------------------------------------------------
// User Inputs
//------------------------------------------------------------------

/*[Type of Keyguard]*/
type_of_keyguard = "3D-Printed"; // [3D-Printed,Laser-Cut]
use_Laser_Cutting_best_practices = "yes"; // [yes,no]

/*[Tablet]*/
type_of_tablet = "iPad"; //[iPad,iPad2,iPad 3rd generation,iPad 4th generation,iPad 5th generation,iPad 6th generation,iPad 7th generation,iPad 8th generation,iPad Pro 9.7-inch,iPad Pro 10.5-inch,iPad Pro 11-inch,iPad Pro 12.9-inch 1st Generation,iPad Pro 12.9-inch 2nd Generation,iPad Pro 12.9-inch 3rd Generation,iPad Pro 12.9-inch 4th Generation,iPad mini,iPad mini 2,iPad mini 3,iPad mini 4,iPad mini 5,iPad Air,iPad Air 2,iPad Air 3,iPad Air 4,Dynavox I-12+,Dynavox Indi,NovaChat 5,NovaChat 8,NovaChat 10,NovaChat 12,Chat Fusion 10, Surface 2,Surface 3,Surface Pro 3,Surface Pro 4,Surface Pro 5,Surface Pro 6,Surface Pro 7,Surface Pro X,Surface Go,Accent 1000,Accent 1400 AC14-20,Accent 1400 AC14-30,GridPad - Fujitsu Stylistic Q616,GridPad - Fujitsu Stylistic Q665,Amazon Fire HD 7,Amazon Fire HD 8,Amazon Fire HD 8 Plus,Amazon Fire HD 10,Lenovo TB-X103F,Lenovo TB-X103F Plate Holder,blank]
orientation = "landscape"; //[portrait,landscape]
expose_home_button = "yes"; //[yes,no]
expose_camera = "yes"; //[yes,no]
swap_camera_and_home_button = "no"; //[yes,no]

/*[Tablet Case]*/
have_a_case = "no"; //[yes,no]
height_of_opening_in_case = 150;// [50:1000]
width_of_opening_in_case = 200; //[50:1000]
case_opening_corner_radius = 0; //[0:100]

/*[App Layout]*/
status_bar_height = 0; //[0:10]
expose_status_bar = "no"; //[yes,no]

upper_message_bar_height = 0; //[0:40]
expose_upper_message_bar = "no"; //[yes,no]

upper_command_bar_height = 0; //[0:40]
expose_upper_command_bar = "no"; //[yes,no]

lower_message_bar_height = 0; //[0:40]
expose_lower_message_bar = "no"; //[yes,no]

lower_command_bar_height = 0; //[0:40]
expose_lower_command_bar = "no"; //[yes,no]

bar_edge_slope = 90; //[30:90]

/*[Grid Layout]*/
number_of_columns = 4;//[0:20]
number_of_rows = 3;//[0:20]
horizontal_rail_width = 5; //[1:25]
vertical_rail_width = 5; //[1:25]
preferred_rail_height = 5; //[1:15]
rail_slope = 60; //[30:90]

shape_of_opening = "rectangle"; //[rectangle, circle, rounded-rectangle]
rounded_rectangle_corner_radius = 1; //[1:20]
// example: [3, 6, 12] be sure to use brackets
cover_these_cells = [];
// example: [5, 8] merges cells 5&6 and 8&9, be sure to use brackets
merge_cells_horizontally_starting_at = [];
// example: [3, 4] merges cell 3 & the cell above and cell 4 & the cell above, be sure to use brackets
merge_cells_vertically_starting_at = [];
// example: [3, 6, 12] be sure to use brackets
add_a_ridge_around_these_cells = [];
height_of_ridge = 2; //[1:10]
thickness_of_ridge = 2; //[1:10]

top_padding = 0; //[-50:50]
bottom_padding = 0; //[-50:50]
left_padding = 0; //[-50:50]
right_padding = 0; //[-50:50]

/*[Mounting Method]*/
mounting_method = "No Mount"; // [No Mount,Suction Cups,Velcro,Screw-on Straps,Clip-on Straps,Slide-in Tabs - for cases,Raised Tabs - for cases]

/*[Velcro Info]*/
velcro_size = 1; // [1:10mm -3/8 in- Dots, 2:16mm -5/8 in- Dots, 3:20mm -3/4 in- Dots, 4:3/8 in Squares, 5:5/8 in Squares, 6:3/4 in Squares]

/*[Clip-on Straps Info]*/
clip_locations="horizontal only"; //[horizontal only, vertical only, horizontal and vertical]
horizontal_clip_width=20; //[15:30]
vertical_clip_width=20; //[15:30]
distance_between_horizontal_clips=60; //[20:120]
distance_between_vertical_clips=40; //[20:120]
case_width = 220; //[50:400]
case_height = 220; //[50:400]
case_thickness = 15; //[5:40]
clip_bottom_length = 35; //[15:45]
case_to_screen_depth = 5; // [1:10]
unequal_left_side_of_case = 0; //[0:50]
unequal_bottom_side_of_case = 0; //[0:50]

/*[Slide-in Tabs Info]*/
preferred_slide_in_tab_thickness = 2; // [1:5]
slide_in_tab_length = 5; // [3:10]
slide_in_tab_width=20; // [10:60]
distance_between_slide_in_tabs=60; //[20:120]

/*[Raised Tabs Info]*/
raised_tab_height=5; // [2:30]
raised_tab_length=10; // [3:30]
raised_tab_width=20; // [10:30]
preferred_raised_tab_thickness=3; // [1:5]
distance_between_raised_tabs=60; //[20:120]



//********* 1. Comment the following lines for the Lite version **********
/*[Free-form and Hybrid Keyguard Openings]*/
//set if grid rows or columns set to 0
free_form_keyguard_thickness = 5; //[1:10]
//px = pixels, mm = millimeters
unit_of_measure_for_screen = "px"; //[px,mm]
//which corner is (0,0)?
starting_corner_for_screen_measurements = "upper-left"; //[upper-left, lower-left]
//*********** stop commenting here *************


/*[Special Actions and Settings]*/
generate = "keyguard"; //[keyguard,first half of keyguard,second half of keyguard,horizontal clip,vertical clip,horizontal mini clip1,vertical mini clip1,horizontal mini clip2,vertical mini clip2,first layer for SVG/DXF file]

top_edge_compensation_for_tight_cases = 0; //[0:20]
bottom_edge_compensation_for_tight_cases = 0; //[0:20]
left_edge_compensation_for_tight_cases = 0; //[0:20]
right_edge_compensation_for_tight_cases = 0; //[0:20]
unequal_left_side_of_case_opening = 0; //[0:50]
unequal_bottom_side_of_case_opening = 0; //[0:50]
smoothness_of_circles_and_arcs = 40; //[5:360]
split_line = 0; //[-500:500]
split_line_type = "flat"; //[flat,dovetails]
approx_dovetail_width = 4; //[3:10]
//smaller numbers are looser, larger numbers are tighter (affects first half of keyguard only)
tightness_of_dovetail_joint = 5; //[0:10]
trim_to_screen = "no"; //[yes,no]
//specify the lower left coordinate (example: [10,50])
trim_to_rectangle_lower_left = [];
//specify the upper right coordinate (example: [80,125])
trim_to_rectangle_upper_right = [];
cut_out_screen = "no"; //[yes,no]
include_screenshot = "no"; //[yes,no]
//assuming 0.2 mm layers for a total of 0.4 mm
first_two_layers_only = "no"; //[yes,no]



/*[Hidden]*/
//laser-cut variables
acrylic_thickness = (use_Laser_Cutting_best_practices=="yes") ?  3 : preferred_rail_height;
acrylic_slide_in_tab_thickness = (use_Laser_Cutting_best_practices=="yes") ?  1 : preferred_slide_in_tab_thickness;
acrylic_slide_in_tab_length = (use_Laser_Cutting_best_practices=="yes") ?  3.175 : slide_in_tab_length;
acrylic_case_corner_radius = (use_Laser_Cutting_best_practices=="yes") ?  2 : case_opening_corner_radius;
camera_opening_increment = acrylic_thickness/tan(45)*2; //times 2 because this is a diameter increment
pref_rail_height_incl_acrylic = (type_of_keyguard=="Laser-Cut" && use_Laser_Cutting_best_practices=="yes") ? 3 : preferred_rail_height;

rs_inc_acrylic = (type_of_keyguard=="3D-Printed") ? rail_slope : 90;
bar_edge_slope_inc_acrylic = (type_of_keyguard=="3D-Printed") ? bar_edge_slope : 90;
m_m = (type_of_keyguard=="3D-Printed")  ? mounting_method : 
	(type_of_keyguard=="Laser-Cut" && mounting_method=="Slide-in Tabs - for cases") ? "Slide-in Tabs - for cases" :
	"No Mount";



//Tablet Parameters -- 0:Tablet Width, 1:Tablet Height, 2:Tablet Thickness, 3:Screen Width, 4:Screen Height, 
//                     5:Right Border Width, 6:Left Border Width, 7:Bottom Border Height, 8:Top Border Height, 
//                     9:Distance from edge of screen to Home Button, 10:Home Button Height, 11:Home Button Width, 12:Home Button Location,
//                     13:Distance from edge of screen to Camera, 14:Camera Height, 15:Camera Width, 16:Camera Location,
//                     17:Conversion Factors (# vertical pixels, # horizontal pixels, pixel size (mm)), 18:Tablet Corner Radius
iPad_data=[242.900,189.7,13.4,197.042,147.782,22.929,22.929,20.959,20.959,11.329,11.200,11.200,2,12.529,2.500,2.500,4,[768,1024,0.1924],10];
iPad2_data=[241.300,185.8,8.8,197.042,147.782,22.129,22.129,19.009,19.009,11.329,11.300,11.300,2,11.029,3.000,3.000,4,[768,1024,0.1924],10];
iPad3rdgeneration_data=[241.300,185.8,9.41,197.042,147.782,22.129,22.129,19.009,19.009,11.329,11.300,11.300,2,11.029,3.000,3.000,4,[1536,2048,0.0962],10];
iPad4thgeneration_data=[241.300,185.8,9.4,197.042,147.782,22.129,22.129,19.009,19.009,11.329,11.300,11.300,2,11.029,3.000,3.000,4,[1536,2048,0.0962],10];
iPad5thgeneration_data=[240.000,169.47,6.1,197.042,147.782,21.479,21.479,10.844,10.844,11.379,14.600,14.600,2,10.409,3.000,3.000,4,[1536,2048,0.0962],10];
iPad6thgeneration_data=[240.000,169.47,6.1,197.042,147.782,21.479,21.479,10.844,10.844,11.379,14.600,14.600,2,10.409,3.000,3.000,4,[1536,2048,0.0962],10];
iPad7thgeneration_data=[250.590,174.08,7.5,207.818,155.864,21.386,21.386,9.108,9.108,11.326,14.600,14.600,2,10.316,2.450,2.450,4,[1620,2160,0.0962],10];
iPad8thgeneration_data=[250.590,174.08,7.5,207.818,155.864,21.386,21.386,9.108,9.108,11.326,14.6,14.6,2,10.316,2.45,2.45,4,[1620,2160,0.0962],10];
iPadPro97inch_data=[240.000,169.47,6.1,197.042,147.782,21.479,21.479,10.844,10.844,11.379,14.600,14.600,2,10.379,3.000,3.000,4,[1536,2048,0.0962],10];
iPadPro105inch_data=[250.590,174.08,6.1,213.976,160.482,18.307,18.307,6.799,6.799,9.347,14.600,14.600,2,9.107,3.000,3.000,4,[1668,2224,0.0962],10];
iPadPro11inch_data=[247.640,178.52,5.953,229.755,160.482,8.943,8.943,9.019,9.019,0,0.000,0.000,2,4.573,3.090,3.090,4,[1668,2388,0.0962],10];
iPadPro129inch1stGeneration_data=[305.690,220.58,6.9,262.852,197.042,21.419,21.419,11.769,11.769,11.319,14.600,14.600,2,10.319,3.000,3.000,4,[2048,2732,0.0962],10];
iPadPro129inch2ndGeneration_data=[305.690,220.58,6.9,262.852,197.042,21.419,21.419,11.769,11.769,11.319,14.600,14.600,2,10.219,3.500,3.500,4,[2048,2732,0.0962],10];
iPadPro129inch3rdGeneration_data=[280.660,214.99,5.908,262.852,197.042,9.2,9.2,9.18,9.18,0,0,0,0,4.534,33,4,4,[2048,2732,0.0962],10];
iPadPro129inch4thGeneration_data=[280.660,214.99,5.908,262.852,197.042,9.2,9.2,9.18,9.18,0,0,0,0,4.534,33,4,4,[2048,2732,0.0962],10];
iPadmini_data=[200.100,134.7,7.2,159.568,119.676,20.266,20.266,7.512,7.512,11,10.000,10.000,2,10,3,3,4,[768,1024,0.1558],10];
iPadmini2_data=[200.100,134.7,7.5,159.568,119.676,20.266,20.266,7.512,7.512,11,10.000,10.000,2,10,3,3,4,[1536,2048,0.0779],10];
iPadmini3_data=[200.100,134.7,7.5,159.568,119.676,20.266,20.266,7.512,7.512,11,10.000,10.000,2,10,3,3,4,[1536,2048,0.0779],10];
iPadmini4_data=[203.160,134.75,6.1,159.568,119.676,21.796,21.796,7.537,7.537,12.286,10.600,10.600,2,11.296,4.000,4.000,4,[1536,2048,0.0779],10];
iPadmini5_data=[203.160,134.75,6.1,159.568,119.676,21.796,21.796,7.537,7.537,12.286,10.600,10.600,2,10.596,3.930,3.930,4,[1536,2048,0.0779],10];
iPadAir_data=[240.000,169.5,7.5,197.042,147.782,21.479,21.479,10.859,10.859,11.379,10.700,10.700,2,10.379,3.000,3.000,4,[1536,2048,0.0962],10];
iPadAir2_data=[240.000,169.47,6.1,197.042,147.782,21.479,21.479,10.844,10.844,11.379,14.600,14.600,2,10.409,2.450,2.450,4,[1536,2048,0.0962],10];
iPadAir3_data=[250.590,174.08,6.1,213.976,160.482,18.307,18.307,6.799,6.799,9.347,14.600,14.600,2,8.687,2.450,2.450,4,[1668,2224,0.0962],10];
iPadAir4_data=[247.64,178.51,6.123,227.061,157.788,10.04,10.04,10.03,10.03,0,0,0,0,5.03,4.5,4.5,4,[1640,2360,0.0962],12];
novachat_5_data=[156.200,76.2,5,121.616,68.409,17.292,17.292,3.896,3.896,0,0.000,0.000,0,0,0.000,0.000,0,[1080,1920,0.0633],5];
novachat_8_data=[198.600,134.8,5.6,162.56,121.92,18.02,18.02,6.44,6.44,8.2,16,6.5,2,11,2.5,2.5,0,[1536,2048,0.0794],5];
novachat10_data=[237.300,169,6,197.042,147.782,20.129,20.129,10.609,10.609,0,0.000,0.000,0,0,0.000,0.000,0,[1536,2048,0.0962],5];
novachat12_data=[295.600,204,8,263.255,164.534,16.172,16.172,19.733,19.733,0,0.000,0.000,0,0,0.000,0.000,0,[1600,2560,0.1028],5];
chatfusion10_data=[0,0,0,211.14,141.20,0,0,0,0,0,0.000,0.000,0,0,0.000,0.000,0,[1200,1920,0.1138],0];
surface_2_data=[275.000,173,8.9,234.462,131.885,20.269,20.269,20.558,20.558,0,0.000,0.000,0,0,0.000,0.000,0,[1080,1920,0.1221],5];
surface_3_data=[267.000,187,8.6,227.888,151.925,19.556,19.556,17.537,17.537,0,0.000,0.000,0,0,0.000,0.000,0,[1280,1920,0.1187],5];
surface_pro_3_data=[290.000,201,9.1,254,169.333,18,18,15.833,15.833,0,0.000,0.000,0,0,0.000,0.000,0,[1440,2160,0.1176],5];
surface_pro_4_data=[292.100,201.42,8.45,260.279,173.519,15.911,15.911,13.95,13.95,0,0.000,0.000,0,0,0.000,0.000,0,[1824,2736,0.0951],5];
surface_pro_5_data=[292.000,201,8.5,260.279,173.519,15.861,15.861,13.74,13.74,0,0.000,0.000,0,0,0.000,0.000,0,[1824,2736,0.0951],5];
surface_pro_6_data=[292.000,201,8.5,260.279,173.519,15.861,15.861,13.74,13.74,0,0.000,0.000,0,6.24,5.000,50.000,1,[1824,2736,0.0951],5];
surface_pro_7_data=[292.000,201,8.5,260.279,173.519,15.861,15.861,13.74,13.74,0,0.000,0.000,0,0,0.000,0.000,0,[1824,2736,0.0951],5];
surface_pro_x_data=[287.000,208,7.3,273.978,182.652,6.511,6.511,12.674,12.674,0,0.000,0.000,0,0,0.000,0.000,0,[1920,2880,0.0951],5];
surface_go_data=[245.000,175,8.3,210.691,140.461,17.154,17.154,17.27,17.27,0,0.000,0.000,0,0,0.000,0.000,0,[1200,1800,0.1171],5];
fujitsu_stylistic_q616_data=[294.800,192.4,11.9,257.11,144.63,18.952,18.952,23.948,23.948,0,0.000,0.000,0,0,0.000,0.000,0,[1080,1920,0.1339],5];
fujitsu_stylistic_q665_data=[294.800,192.4,11.9,257.11,144.63,18.952,18.952,23.948,23.948,0,0.000,0.000,0,0,0.000,0.000,0,[1080,1920,0.1339],5];
accent_1000_data=[0,0,0,216.80,135.50,0,0,0,0,10,10,10,3,10,4,4,1,[1200,1920,0.1129],0];
accent_1400_20_data=[0,0,0,308.66,173.62,0,0,0,0,0,0.000,0.000,0,0,0.000,0.000,0,[1080,1920,0.1608],0];
accent_1400_30_data=[0,0,0,231.13,130.01,0,0,0,0,0,0.000,0.000,0,0,0.000,0.000,0,[1080,1920,0.1204],0];
amazon_fire_hd_7_data=[192,115,9.6,152.10,89.12,19.949,19.949,12.939,12.939,0,0.000,0.000,0,7,3.000,3.000,1,[600,1024,0.1485],10];
amazon_fire_hd_8_data=[202,137,9.7,172.02,107.51,14.989,14.989,14.743,14.743,0,0.000,0.000,0,7,3.000,3.000,1,[800,1280,0.1344],10];
amazon_fire_hd_8_plus_data=[202,137,9.7,172.02,107.51,14.989,14.989,14.743,14.743,0,0.000,0.000,0,7,3.000,3.000,1,[800,1280,0.1344],10];
amazon_fire_hd_10_data=[262,157,9.8,217.71,136.07,22.143,22.143,11.464,11.464,0,0.000,0.000,0,7,3.000,3.000,1,[1200,1920,0.1134],10];
dynavox_i_12_plus_data=[288,222.5,23,246.33,184.75,21,21,13,24,0,0.000,0.000,0,14.5,5,5,1,[768,1024,0.2406],10];
dynavox_indi_data=[239,165,20,216.5,135.5,11.6,11.6,14,16,7,8,8,3,10,3.5,3.5,1,[1200,1920,0.1128],10];
lenovo_tb_x103f=[243,167,10,215,134,14.5,14.5,14.5,20,0,0.000,0.000,0,10,4.000,4.000,1,[800,1280,0.1678],5];

//Tablet Parameters -- 0:Tablet Width, 1:Tablet Height, 2:Tablet Thickness, 3:Screen Width, 4:Screen Height, 
//                     5:Right Border Width, 6:Left Border Width, 7:Bottom Border Height, 8:Top Border Height, 
//                     9:Distance from edge of screen to Home Button, 10:Home Button Height, 11:Home Button Width, 12:Home Button Location,
//                     13:Distance from edge of screen to Camera, 14:Camera Height, 15:Camera Width, 16:Camera Location,
//                     17:Conversion Factors (# vertical pixels, # horizontal pixels, pixel size (mm)), 18:Tablet Corner Radius


lenovo_tb_x103f_plateholder=[125,167,10,85.5,127.7,19.65,19.65,19.65,19.65,0,0.000,0.000,0,10,4.000,4.000,1,[800,1280,0.1678],5];
blank_data=[200,60,3,200,60,0,0,0,0,0,0,0,0,0,0,0,0,[60,200,1],0];

catch_all_data=[400,100,20,216.5,135.5,11.6,11.6,14,16,7,8,8,3,10,3.5,3.5,1,[1200,1920,0.1128],10];


//negative_padding = [238.160,204.750,6.100,200.2,168.3,18.980,18.980,18.225,18.225,9.510,10.600,11.200,3.930,[636,756,0.2648]];

tablet_params = 
    (type_of_tablet=="iPad")? iPad_data
  : (type_of_tablet=="iPad2")? iPad2_data
  : (type_of_tablet=="iPad 3rd generation")? iPad3rdgeneration_data
  : (type_of_tablet=="iPad 4th generation")? iPad4thgeneration_data
  : (type_of_tablet=="iPad 5th generation")? iPad5thgeneration_data
  : (type_of_tablet=="iPad 6th generation")? iPad6thgeneration_data
  : (type_of_tablet=="iPad 7th generation")? iPad7thgeneration_data
  : (type_of_tablet=="iPad 8th generation")? iPad8thgeneration_data
  : (type_of_tablet=="iPad Pro 9.7-inch")? iPadPro97inch_data
  : (type_of_tablet=="iPad Pro 10.5-inch")? iPadPro105inch_data
  : (type_of_tablet=="iPad Pro 11-inch")? iPadPro11inch_data
  : (type_of_tablet=="iPad Pro 12.9-inch 1st Generation")? iPadPro129inch1stGeneration_data
  : (type_of_tablet=="iPad Pro 12.9-inch 2nd Generation")? iPadPro129inch2ndGeneration_data
  : (type_of_tablet=="iPad Pro 12.9-inch 3rd Generation")? iPadPro129inch3rdGeneration_data
  : (type_of_tablet=="iPad Pro 12.9-inch 4th Generation")? iPadPro129inch4thGeneration_data
  : (type_of_tablet=="iPad mini")? iPadmini_data
  : (type_of_tablet=="iPad mini 2")? iPadmini2_data
  : (type_of_tablet=="iPad mini 3")? iPadmini3_data
  : (type_of_tablet=="iPad mini 4")? iPadmini4_data
  : (type_of_tablet=="iPad mini 5")? iPadmini5_data
  // : (type_of_tablet=="negative padding")? negative_padding
  : (type_of_tablet=="iPad Air")? iPadAir_data
  : (type_of_tablet=="iPad Air 2")? iPadAir2_data
  : (type_of_tablet=="iPad Air 3")? iPadAir3_data
  : (type_of_tablet=="iPad Air 4")? iPadAir4_data
  : (type_of_tablet=="NovaChat 5")? novachat_5_data
  : (type_of_tablet=="NovaChat 8")? novachat_8_data
  : (type_of_tablet=="NovaChat 10")? novachat10_data
  : (type_of_tablet=="NovaChat 12")? novachat12_data
  : (type_of_tablet=="Chat Fusion 10")? chatfusion10_data
  : (type_of_tablet=="Surface 2")? surface_2_data
  : (type_of_tablet=="Surface 3")? surface_3_data
  : (type_of_tablet=="Surface Pro 3")? surface_pro_3_data
  : (type_of_tablet=="Surface Pro 4")? surface_pro_4_data
  : (type_of_tablet=="Surface Pro 5")? surface_pro_5_data
  : (type_of_tablet=="Surface Pro 6")? surface_pro_6_data
  : (type_of_tablet=="Surface Pro 7")? surface_pro_7_data
  : (type_of_tablet=="Surface Pro X")? surface_pro_x_data
  : (type_of_tablet=="Surface Go")? surface_go_data
  : (type_of_tablet=="Accent 1000")? accent_1000_data
  : (type_of_tablet=="Accent 1400 AC14-20")? accent_1400_20_data
  : (type_of_tablet=="Accent 1400 AC14-30")? accent_1400_30_data
  : (type_of_tablet=="Amazon Fire HD 7")? amazon_fire_hd_7_data
  : (type_of_tablet=="Amazon Fire HD 8")? amazon_fire_hd_8_data
  : (type_of_tablet=="Amazon Fire HD 8 Plus")? amazon_fire_hd_8_plus_data
  : (type_of_tablet=="Amazon Fire HD 10")? amazon_fire_hd_10_data
  : (type_of_tablet=="Dynavox I-12+")? dynavox_i_12_plus_data
  : (type_of_tablet=="Dynavox Indi")? dynavox_indi_data
  : (type_of_tablet=="Lenovo TB-X103F")? lenovo_tb_x103f
  : (type_of_tablet=="Lenovo TB-X103F Plate Holder")? lenovo_tb_x103f_plateholder
  : (type_of_tablet=="GridPad - Fujitsu Stylistic Q616") ? fujitsu_stylistic_q616_data
  : (type_of_tablet=="GridPad - Fujitsu Stylistic Q665") ? fujitsu_stylistic_q665_data
  : (type_of_tablet=="blank") ? blank_data
  : catch_all_data;
                
// Tablet variables
tablet_width = (orientation=="landscape") ? tablet_params[0] : tablet_params[1];
tablet_height = (orientation=="landscape") ? tablet_params[1] : tablet_params[0];
tablet_corner_radius = tablet_params[18];
tablet_thickness = tablet_params[2];
right_border_width = (orientation=="landscape") ? tablet_params[5] : tablet_params[8];
left_border_width = (orientation=="landscape") ? tablet_params[6] : tablet_params[7];
top_border_height = (orientation=="landscape") ? tablet_params[8] : tablet_params[6];
bottom_border_height = (orientation=="landscape") ? tablet_params[7] : tablet_params[5];

distance_from_screen_to_home_button = tablet_params[9];
home_button_height = tablet_params[10];
home_button_width = tablet_params[11];
hb_loc = tablet_params[12];
home_loc = (orientation=="landscape") ? hb_loc : search(hb_loc,[0,4,1,2,3])[0];

distance_from_screen_to_camera = tablet_params[13];
camera_height = (type_of_keyguard=="3D-Printed") ? tablet_params[14] : tablet_params[14]+camera_opening_increment;
camera_width = (type_of_keyguard=="3D-Printed") ? tablet_params[15] : tablet_params[15]+camera_opening_increment;
c_loc = tablet_params[16];
cam_loc = (orientation=="landscape") ? c_loc : search(c_loc,[0,4,1,2,3])[0];

swap=[0,3,4,1,2];
home_button_location = (swap_camera_and_home_button=="no") ? home_loc : swap[home_loc];
camera_location = (swap_camera_and_home_button=="no") ? cam_loc : swap[cam_loc];

// Case and Screen variables
screen_width = (orientation=="landscape") ? tablet_params[3] : tablet_params[4];
screen_height = (orientation=="landscape") ? tablet_params[4] : tablet_params[3];

case_even_left = (width_of_opening_in_case-screen_width)/2;
case_even_bottom = (height_of_opening_in_case-screen_height)/2;
unequal_left_side_offset = (unequal_left_side_of_case_opening>0) ? unequal_left_side_of_case_opening-case_even_left : 0;
unequal_bottom_side_offset = (unequal_bottom_side_of_case_opening>0) ? unequal_bottom_side_of_case_opening-case_even_bottom : 0;

case_to_screen_offset_x = (unequal_left_side_of_case_opening != 0) ? unequal_left_side_of_case_opening : case_even_left;
case_to_screen_offset_y = (unequal_bottom_side_of_case_opening != 0) ? unequal_bottom_side_of_case_opening : case_even_bottom;

case_x0 = -width_of_opening_in_case/2;
case_y0 = -height_of_opening_in_case/2;

screen_x0 = (have_a_case == "no") ? -screen_width/2 : case_x0+case_to_screen_offset_x;
screen_y0 = (have_a_case == "no") ? -screen_height/2 :case_y0+case_to_screen_offset_y;

tablet_x0 = screen_x0 - left_border_width;
tablet_y0 = screen_y0 - bottom_border_height;

keyguard_x0 = (have_a_case == "yes") ? case_x0+width_of_opening_in_case/2 : tablet_x0+tablet_width/2;
keyguard_y0 = (have_a_case == "yes") ? case_y0+height_of_opening_in_case/2 : tablet_y0+tablet_height/2;



//********* 2. Comment the following lines for the Lite version **********
//Get data from screen_openings.info and case_openings.info
	include <screen_openings.info>;
	include <case_openings.info>;
	include <case_additions.info>;

	cf = tablet_params[17];
	screen_height_px = (orientation=="landscape") ? cf[0] : cf[1];
	screen_width_px = (orientation=="landscape") ? cf[1] : cf[0];
	pixel_size =  cf[2];

	screen_height_mm = screen_height;
	screen_width_mm	= screen_width;
	
	ffkt_incl_acrylic = (type_of_keyguard=="Laser-Cut" && use_Laser_Cutting_best_practices=="yes") ? 3: free_form_keyguard_thickness;
//*********** stop commenting here *************

//***************preparing Lite version...
//***************Comment Sections 1 and 2 and set Lite to "yes"
Lite = "no";
ffkt = (Lite == "yes") ? 5 : ffkt_incl_acrylic;
										   									   

case_opening_corner_radius_incl_acrylic = (type_of_keyguard=="3D-Printed" || len(case_additions)>0) ? case_opening_corner_radius : max(case_opening_corner_radius,acrylic_case_corner_radius);

//Grid variables
grid_width = screen_width - left_padding - right_padding;
grid_height = screen_height - status_bar_height - upper_message_bar_height - upper_command_bar_height - top_padding - bottom_padding - lower_message_bar_height - lower_command_bar_height;

grid_x0 = screen_x0 + left_padding;
grid_y0 = screen_y0 + bottom_padding + lower_message_bar_height + lower_command_bar_height;


//misc variables
fudge = 0.005;

chamfer_size=0.75;
chamfer_slices = 5;
chamfer_slice_size = chamfer_size/chamfer_slices;

$fn=smoothness_of_circles_and_arcs;

//handle the instance where a system like an Accent
system_with_no_case = ((tablet_width==0) || (tablet_height == 0)) && (have_a_case=="no");
column_count = (system_with_no_case || cut_out_screen == "yes") ? 0 : number_of_columns;
row_count = (system_with_no_case || cut_out_screen == "yes") ? 0 : number_of_rows;

max_cell_width=grid_width/column_count;
max_cell_height=grid_height/row_count;
minimum__acrylic_rail_width = (use_Laser_Cutting_best_practices=="no") ?  1 :
								(max(screen_width,screen_height)>200) ? 4 : 3; // midpoint is the screen width of an iPad
hrw = (type_of_keyguard=="3D-Printed") ? horizontal_rail_width : max(horizontal_rail_width,minimum__acrylic_rail_width);
vrw = (type_of_keyguard=="3D-Printed") ? vertical_rail_width : max(vertical_rail_width,minimum__acrylic_rail_width);
shape_of_cut = (type_of_keyguard=="Laser-Cut" && shape_of_opening == "rectangle" && use_Laser_Cutting_best_practices=="yes") ? "rounded-rectangle" : shape_of_opening;
actual_cell_width = (shape_of_cut!="circle") ? max_cell_width-vrw : min(max_cell_width-vrw,max_cell_height-hrw);
actual_cell_height = (shape_of_cut!="circle") ? max_cell_height-hrw : min(max_cell_width-vrw,max_cell_height-hrw);

max_actual_cell_dim = max(actual_cell_width,actual_cell_height);
min_actual_cell_dim = min(actual_cell_width,actual_cell_height);
acrylic_cell_rounded_rectangle_corner_radius = max(min_actual_cell_dim/10,rounded_rectangle_corner_radius);
rrcr = (type_of_keyguard=="Laser-Cut" && use_Laser_Cutting_best_practices=="yes") ? acrylic_cell_rounded_rectangle_corner_radius : rounded_rectangle_corner_radius;

min_rail_width = min(hrw,vrw);
tan_rail_slope=tan(rs_inc_acrylic);
max_rail_height= (column_count > 0 || row_count > 0 && type_of_keyguard=="3D-Printed") ? min_rail_width/2*tan_rail_slope : ffkt;
rail_height = (cut_out_screen=="no" && (column_count>0 && row_count>0)) ? min(max_rail_height,pref_rail_height_incl_acrylic) : ffkt;
raised_tab_thickness = min(rail_height-chamfer_size,preferred_raised_tab_thickness);
slide_in_tab_length_incl_acrylic = (type_of_keyguard=="3D-Printed") ? slide_in_tab_length : acrylic_slide_in_tab_length;
slide_in_tab_thickness = (type_of_keyguard=="3D-Printed") ? min(rail_height-0.65, preferred_slide_in_tab_thickness) : acrylic_slide_in_tab_thickness;

if (number_of_columns>0 && number_of_rows>0){
	echo(rail_height=rail_height,max_rail_height=max_rail_height);
	echo(str("max cell dimesion: ", max_actual_cell_dim, " mm."));
	echo(str("min cell dimension: ", min_actual_cell_dim, " mm."));
}

//home button and camera location variables
home_x_loc = (home_button_location==1) ? screen_x0+screen_width/2 
	: (home_button_location==2) ? screen_x0+screen_width+distance_from_screen_to_home_button 
	: (home_button_location==3) ? screen_x0+screen_width/2 
	: screen_x0-distance_from_screen_to_home_button;

home_y_loc = (home_button_location==1) ? screen_y0+screen_height+distance_from_screen_to_home_button 
	: (home_button_location==2) ? screen_y0+screen_height/2
	: (home_button_location==3) ? screen_y0-distance_from_screen_to_home_button 
	: screen_y0+screen_height/2 ;
	
cam_x_loc = (camera_location==1) ? screen_x0+screen_width/2 
	: (camera_location==2) ? screen_x0+screen_width+distance_from_screen_to_camera 
	: (camera_location==3) ? screen_x0+screen_width/2 
	: screen_x0-distance_from_screen_to_camera ;

cam_y_loc = (camera_location==1) ? screen_y0+screen_height+distance_from_screen_to_camera 
	: (camera_location==2) ? screen_y0+screen_height/2 
	: (camera_location==3) ? screen_y0-distance_from_screen_to_camera 
	: screen_y0+screen_height/2;

//velcro variables
velcro_diameter = 
    (velcro_size==1)? 10
  : (velcro_size==2)? 16
  : (velcro_size==3)? 20
  : (velcro_size==4)? 10
  : (velcro_size==5)? 16
  : 20;
  
strap_cut_to_depth = 9.25 - 3.1 - 3.5; // length of bolt - thickness of acrylic mount - height of nut

//clip-on strap variables
clip_loc = (orientation=="landscape" && clip_locations=="horizontal only") ? "horizontal only" 
			: (orientation=="landscape" && clip_locations=="vertical only") ? "vertical only"
			: (orientation=="portrait" && clip_locations=="horizontal only") ? "vertical only"
			: (orientation=="portrait" && clip_locations=="vertical only") ? "horizontal only"
			: "horizontal and vertical";
dist_between_horizontal_clips = (orientation=="landscape") ? distance_between_horizontal_clips : distance_between_vertical_clips;
dist_between_vertical_clips = (orientation=="landscape") ? distance_between_vertical_clips : distance_between_horizontal_clips;

horizontal_pedestal_width = horizontal_clip_width + 10;
vertical_pedestal_width = vertical_clip_width + 10;
pedestal_height = (have_a_case=="no")? 0 : max(case_to_screen_depth - rail_height,0);
horizontal_slot_width = horizontal_clip_width+2;
vertical_slot_width = vertical_clip_width+2;
vertical_offset = rail_height/2 + pedestal_height-3+fudge; // bottom of cut for clip-on strap


  
// ----------------------Main-----------------------------
if (type_of_keyguard=="3D-Printed" && (generate=="keyguard" || generate=="first half of keyguard" || generate=="second half of keyguard")){
	color("Turquoise")
	keyguard();
	
	if (include_screenshot=="yes"){
		show_screenshot();
	}
}
else if (type_of_keyguard=="Laser-Cut" && (generate=="keyguard" || generate=="first half of keyguard" || generate=="second half of keyguard")){
	color("Khaki")
	keyguard();
	issues();

	if (include_screenshot=="yes"){
		show_screenshot();
	}
}
else if (type_of_keyguard=="Laser-Cut" && generate=="first layer for SVG/DXF file"){
	color("Khaki")
	projection()
	keyguard();
	issues();
	key_settings();
}
else if (type_of_keyguard=="3D-Printed" && generate=="first layer for SVG/DXF file"){
	color("Turquoise")
	projection()
	keyguard();
}
else if (generate=="horizontal clip"){
	if (unequal_left_side_of_case == 0){
		clip_reach = (have_a_case=="no")? 6 : (case_width-width_of_opening_in_case)/2+5;
		create_clip(clip_reach,horizontal_clip_width);
	}
	else{  //if unequal_left_side_of_case>0 then assume that there is a case
		clip_reach_left = unequal_left_side_of_case + 5;

		clip_reach_right = case_width-width_of_opening_in_case-unequal_left_side_of_case+5;

		//left side clip
		translate([-35,0,horizontal_clip_width])
		rotate([0,180,0])
		translate([0,case_thickness/2+10,0])
		create_clip(clip_reach_left,horizontal_clip_width);
		
		//right side clip
		translate([0,-case_thickness/2-10,0])
		create_clip(clip_reach_right,horizontal_clip_width);
	}
}
else if (generate=="vertical clip"){
	if (unequal_bottom_side_of_case == 0){
		clip_reach = (have_a_case=="no")? 6 : (case_height-height_of_opening_in_case)/2+5;
		create_clip(clip_reach,vertical_clip_width);
	}
	else{  //if unequal_bottom_side_of_case>0 then assume that there is a case
		clip_reach_bottom = unequal_bottom_side_of_case + 5;

		clip_reach_top = case_height-height_of_opening_in_case-unequal_bottom_side_of_case+5;

		//top side clip
		translate([-35,0,vertical_clip_width])
		rotate([0,180,0])
		translate([0,case_thickness/2+10,0])
		create_clip(clip_reach_bottom,vertical_clip_width);
		
		//bottom side clip
		translate([0,-case_thickness/2-10,0])
		create_clip(clip_reach_top,vertical_clip_width);
	}
}
else if (generate=="horizontal mini clip1"){
	if (unequal_left_side_of_case == 0){
		clip_reach = (have_a_case=="no")? 6 : (case_width-width_of_opening_in_case)/2+5;
		create_mini_clip1(clip_reach,horizontal_clip_width);
	}
	else{  //if unequal_left_side_of_case>0 then assume that there is a case
		clip_reach_left = unequal_left_side_of_case + 5;

		clip_reach_right = case_width-width_of_opening_in_case-unequal_left_side_of_case+5;

		//left side clip
		translate([-35,0,horizontal_clip_width])
		rotate([0,180,0])
		translate([0,case_thickness/2+10,0])
		create_mini_clip1(clip_reach_left,horizontal_clip_width);
		
		//right side clip
		translate([0,-case_thickness/2-10,0])
		create_mini_clip1(clip_reach_right,horizontal_clip_width);
	}
}
else if (generate=="vertical mini clip1"){
	if (unequal_bottom_side_of_case == 0){
		clip_reach = (have_a_case=="no")? 6 : (case_height-height_of_opening_in_case)/2+5;
		create_mini_clip1(clip_reach,vertical_clip_width);
	}
	else{  //if unequal_bottom_side_of_case>0 then assume that there is a case
		clip_reach_bottom = unequal_bottom_side_of_case + 5;

		clip_reach_top = case_height-height_of_opening_in_case-unequal_bottom_side_of_case+5;

		//left side clip
		translate([-35,0,vertical_clip_width,vertical_clip_width])
		rotate([0,180,0])
		translate([0,case_thickness/2+10,0])
		create_mini_clip1(clip_reach_bottom);
		
		//right side clip
		translate([0,-case_thickness/2-10,0])
		create_mini_clip1(clip_reach_top,vertical_clip_width);
	}
}
else if (generate=="horizontal mini clip2"){
	if (unequal_left_side_of_case == 0){
		clip_reach = (have_a_case=="no")? 6 : (case_width-width_of_opening_in_case)/2+5;
		create_mini_clip2(clip_reach,horizontal_clip_width);
	}
	else{  //if unequal_left_side_of_case>0 then assume that there is a case
		clip_reach_left = unequal_left_side_of_case + 5;

		clip_reach_right = case_width-width_of_opening_in_case-unequal_left_side_of_case+5;

		//left side clip
		translate([-35,0,horizontal_clip_width])
		rotate([0,180,0])
		translate([0,case_thickness/2+10,0])
		create_mini_clip2(clip_reach_left,horizontal_clip_width);
		
		//right side clip
		translate([0,-case_thickness/2-10,0])
		create_mini_clip2(clip_reach_right,horizontal_clip_width);
	}
}
else if (generate=="vertical mini clip2"){
	if (unequal_bottom_side_of_case == 0){
		clip_reach = (have_a_case=="no")? 6 : (case_height-height_of_opening_in_case)/2+5;
		create_mini_clip2(clip_reach,vertical_clip_width);
	}
	else{  //if unequal_bottom_side_of_case>0 then assume that there is a case
		clip_reach_bottom = unequal_bottom_side_of_case + 5;

		clip_reach_top = case_height-height_of_opening_in_case-unequal_bottom_side_of_case+5;

		//left side clip
		translate([-35,0,vertical_clip_width,vertical_clip_width])
		rotate([0,180,0])
		translate([0,case_thickness/2+10,0])
		create_mini_clip2(clip_reach_bottom);
		
		//right side clip
		translate([0,-case_thickness/2-10,0])
		create_mini_clip2(clip_reach_top,vertical_clip_width);
	}
}
else{
	create_cell_cover();
}

// ---------------------Modules----------------------------

module keyguard(){
	orientation_rotation = (orientation=="landscape") ? [0,0,0] : [0,0,-90];

	difference(){
		union(){
			difference(){
			
				//base keyguard with cuts from opening.info files
				//adding slide-in & raised tabs & pedestals for clip-on straps (auto and manual)
				union(){
				
					// base keyguard with with cuts for mounting points if no case and cuts for bars and grids
					// and added thickness to walls if case is tight, one wall at a time
					// cuts for home button and camera for both case and no_case configurations
					// remove parts of keyguard outside of the screen if trimmed to screen or an arbitrary rectangle
					// cut screen and case openings from .info files
					difference(){
						
						// base keyguard with with cuts for mounting points if no case and cuts for bars and grids
						// and added thickness to walls if case is tight, one wall at a time
						union(){
						
							//base keyguard with cuts for mounting points if no case and
							//cut out of entire screen or cuts for bars and grids
							difference(){
								//-- base object: tablet body slab or case opening along with case additions if any
								translate([keyguard_x0,keyguard_y0,0])
								base_keyguard();

								//add cuts for certain non-case mounting points
								rotate(orientation_rotation)
								if (have_a_case=="no" && trim_to_screen=="no" && type_of_keyguard=="3D-Printed"){
									//add cuts for suction cups, velcro, clip-on straps and screw-on straps
									mounting_points();
								}
										
								//cut-out of entire screen or cut bars and grid cells
								if (cut_out_screen == "yes"){
									cut_screen();
								}
								else{
									bars();
									if (column_count>0 && row_count>0){
										cells();
									}
								}
							}
							
							//added thickness to walls if case is tight, one wall at a time
							if(have_a_case=="yes" && cut_out_screen == "no" && (top_edge_compensation_for_tight_cases>0 || bottom_edge_compensation_for_tight_cases>0 || left_edge_compensation_for_tight_cases>0 || right_edge_compensation_for_tight_cases>0)){
								tight_case(); 
							}

						}
					
						//home button and camera are cut for both case and no_case configurations
						if (!system_with_no_case) home_camera();
						
						//remove parts of keyguard outside of the screen if trimmed to screen or an arbitrary rectangle
						if (trim_to_screen == "yes") trim_to_the_screen();
						if (have_a_case=="yes" && len(trim_to_rectangle_lower_left)==2 && len(trim_to_rectangle_upper_right)==2) trim_to_rectangle();
						
						//cut screen and case openings
						if(Lite=="no"){
							if (len(screen_openings)>0){
								cut_screen_openings(screen_openings);
							}
							if (have_a_case=="yes"){
								if (len(case_openings)>0){
									cut_case_openings(case_openings);
								}
							}
						}
					}
				
					//add slide-in & raised tabs & pedestals for clip-on straps and ensure pedestals don't extend into screen area
					rotate(orientation_rotation)
					if (have_a_case=="yes" && trim_to_screen=="no"){
						difference(){
							case_mounts();
							if (m_m=="Clip-on Straps"){
								trim_pedestals(); // ensure pedestals don't extend into screen area
							}
						}
					}

					// adding clip-on pedestals manually
					if(Lite=="no" && have_a_case=="yes" && len(case_additions)>0){
						add_manual_mounts(case_additions);
					}
				}
					
				//final cut of slots for clip-on straps
				rotate(orientation_rotation)
				if (have_a_case=="yes" && m_m=="Clip-on Straps"){
					clip_on_straps();
				}
				// cut slots for manually added clip-on strap pedestals
				if (have_a_case=="yes" && len(case_additions)>0){
					add_manual_mount_slots(case_additions);
					trim_pedestals(); // ensure pedestals don't extend into screen area
				}
			}
	
			//add cell ridges	
			if (column_count>0 && row_count>0 && type_of_keyguard=="3D-Printed"){
				cell_ridges();
			}
			
			//add bumps and ridges
			if(Lite=="no" && type_of_keyguard=="3D-Printed"){
				if (len(screen_openings)>0){
					adding_plastic(screen_openings,"screen");
				}
				if (have_a_case=="yes"){
					if (len(case_openings)>0){
						adding_plastic(case_openings,"case");
					}
				}
			}
		}
		
		//splitting the keyguard
		if (generate=="first half of keyguard" || generate=="second half of keyguard"){
			split_keyguard();
		}
		
		//trim down to the first two layers
		if (first_two_layers_only=="yes"){
			translate([0,0,50-rail_height/2+0.4])
			cube([1000,1000,100],center=true);
		}
	}
}

module split_keyguard(){
	if (orientation=="landscape"){
		maskwidth = (have_a_case == "no") ? tablet_width : width_of_opening_in_case;
		maskheight = (have_a_case == "no") ? tablet_height : height_of_opening_in_case;
		
		if (split_line==0 && row_count > 0 && column_count > 0){
			odd_num_columns = column_count/2 - floor(column_count/2) > 0;
			max_cell_width=grid_width/column_count;
			cut_line = (odd_num_columns) ? 
				(column_count/2 + 0.5)*max_cell_width :
				(column_count/2)*max_cell_width;
			split_x0 = (generate=="first half of keyguard")?
				grid_x0+cut_line:
				grid_x0+cut_line-(maskwidth*2);
			if (split_line_type=="flat"){
				translate([maskwidth+split_x0,0,0])
				cube([maskwidth*2,maskheight*2,100],center=true);
			}
			else{
				translate([maskwidth+split_x0-1,0,0])
				difference(){
					union(){
						cube([maskwidth*2,maskheight*2,100],center=true);
						translate([maskwidth+1-fudge,0,0])
						rotate([0,0,90])
						dovetails(generate);
					}
					translate([-maskwidth+1-fudge,0,0])
					rotate([0,0,90])
					dovetails(generate);
				}
			}
		}
		else{
			split_x0 = (generate=="first half of keyguard")? (maskwidth*2)/2 + split_line : -(maskwidth*2)/2 + split_line;
			if (split_line_type=="flat"){
				translate([split_x0,0,0])
				cube([maskwidth*2,maskheight*2,100],center=true);
			}
			else{
				translate([split_x0-1,0,0])
				difference(){
					union(){
						cube([maskwidth*2,maskheight*2,100],center=true);
						translate([maskwidth+1-fudge,0,0])
						rotate([0,0,90])
						dovetails(generate);
					}
					translate([-maskwidth+1-fudge,0,0])
					rotate([0,0,90])
					dovetails(generate);
				}
			}
		}
	}
	else{
		maskwidth = (have_a_case == "no") ? tablet_width : width_of_opening_in_case;
		maskheight = (have_a_case == "no") ? tablet_height : height_of_opening_in_case;

		if (split_line==0 && row_count > 0 && column_count > 0){
			odd_num_rows = row_count/2 - floor(row_count/2) > 0;
			max_cell_height=grid_height/row_count;
			cut_line = (odd_num_rows) ? 
				(row_count/2 + 0.5)*max_cell_height :
				(row_count/2)*max_cell_height;
				
			split_y0 = (generate=="first half of keyguard")? -maskwidth+grid_y0+cut_line : maskwidth+grid_y0+cut_line;

			if (split_line_type=="flat"){
				translate([0,split_y0,0])
				cube([maskheight*2,maskwidth*2,100],center=true);
			}
			else{
				translate([0,split_y0+0.5,0])
				difference(){
					union(){
						cube([maskheight*2,maskwidth*2,100],center=true);
						translate([0,-maskwidth+fudge,0])
						rotate([0,0,0])
						dovetails(generate);
					}
					translate([0,maskwidth+fudge,0])
					rotate([0,0,0])
					dovetails(generate);
				}
			}
		}
		else{
			split_y0 = (generate=="first half of keyguard")? -(maskwidth*2)/2 + split_line : (maskwidth*2)/2 + split_line;
			if (split_line_type=="flat"){
				translate([0,split_y0,0])
				cube([maskheight*2,maskwidth*2,100],center=true);
			}
			else{
				translate([0,split_y0+1,0])
				difference(){
					union(){
						cube([maskheight*2,maskwidth*2,100],center=true);
						translate([0,-maskwidth-1+fudge,0])
						rotate([0,0,0])
						dovetails(generate);
					}
					translate([0,maskwidth-1-fudge,0])
					rotate([0,0,0])
					dovetails(generate);
				}
			}
		}
	}
}

module dovetails(half){
	targetIntvlLen = approx_dovetail_width*3/2;
	cutLen = (have_a_case=="no") ? tablet_height+fudge*2 : 
			 (len(case_additions)>0) ? height_of_opening_in_case*2+fudge*2 : height_of_opening_in_case+fudge*2;
	doveTailCount = floor(cutLen/(targetIntvlLen));
	intvLen=(cutLen/doveTailCount);
	doveTailWidth=(intvLen+2)/2;
	doveTailHeight = 100;
	gap = (half == "first half of keyguard") ? -(tightness_of_dovetail_joint - 5)/10 : 0;
	for (i=[-cutLen/2+doveTailWidth/2-1:doveTailWidth*2-2:cutLen/2]){
		translate([i,-1,-doveTailHeight/2])
		linear_extrude(height=doveTailHeight)
		polygon([[0+gap,0],[doveTailWidth-gap,0],[doveTailWidth-1-gap,2],[1+gap,2]]);
	}
}

module case_mounts() {
	major_dim = max(width_of_opening_in_case,height_of_opening_in_case);
	minor_dim = min(width_of_opening_in_case,height_of_opening_in_case);

	//add mounting points for cases
	if (m_m=="Slide-in Tabs - for cases"){
			add_slide_in_tabs(major_dim,minor_dim);
	}
	else if (m_m=="Raised Tabs - for cases" && type_of_keyguard=="3D-Printed"){
		difference(){
			add_raised_tabs(major_dim,minor_dim);
			round_tab_corners(raised_tab_height-rail_height/2,raised_tab_thickness,raised_tab_length-raised_tab_height,raised_tab_width,distance_between_raised_tabs,major_dim,minor_dim);	
		}
	}
	else if (m_m=="Clip-on Straps" && type_of_keyguard=="3D-Printed"){
		if(clip_loc=="horizontal only" || clip_loc=="horizontal and vertical"){
			//build pedestals for later clip-on strap slots, assumes a case
			translate([-major_dim/2+4.2, -dist_between_horizontal_clips/2-horizontal_pedestal_width/2+4, rail_height/2])
			linear_extrude(height=pedestal_height,scale=.8)
			square([7,horizontal_pedestal_width],center=true);
			
			translate([-major_dim/2+4.2, dist_between_horizontal_clips/2+horizontal_pedestal_width/2-4, rail_height/2])
			linear_extrude(height=pedestal_height,scale=.8)
			square([7,horizontal_pedestal_width],center=true);
			
			translate([major_dim/2-7+2.8, -dist_between_horizontal_clips/2-horizontal_pedestal_width/2+4, rail_height/2])
			linear_extrude(height=pedestal_height,scale=.8)
			square([7,horizontal_pedestal_width],center=true);
			
			translate([major_dim/2-7+2.8, dist_between_horizontal_clips/2+horizontal_pedestal_width/2-4, rail_height/2])
			linear_extrude(height=pedestal_height,scale=.8)
			square([7,horizontal_pedestal_width],center=true);
		}
		if(clip_loc=="vertical only" || clip_loc=="horizontal and vertical"){
			translate([-dist_between_vertical_clips/2-vertical_pedestal_width/2+4, -minor_dim/2+4.2, rail_height/2])
			linear_extrude(height=pedestal_height,scale=.8)
			square([vertical_pedestal_width,7],center=true);
			
			translate([dist_between_vertical_clips/2+vertical_pedestal_width/2-4, -minor_dim/2+4.2, rail_height/2])
			linear_extrude(height=pedestal_height,scale=.8)
			square([vertical_pedestal_width,7],center=true);
			
			translate([-dist_between_vertical_clips/2-vertical_pedestal_width/2+4, minor_dim/2-4.2, rail_height/2])
			linear_extrude(height=pedestal_height,scale=.8)
			square([vertical_pedestal_width,7],center=true);
			
			translate([dist_between_vertical_clips/2+vertical_pedestal_width/2-4, minor_dim/2-4.2, rail_height/2])
			linear_extrude(height=pedestal_height,scale=.8)
			square([vertical_pedestal_width,7],center=true);
		}
	}
	else {
		//No Mount option
	}
}

module trim_pedestals(){
	//create block the size of the screen and height of the pedestals for clip-on mounts
	cut_width = screen_width - left_edge_compensation_for_tight_cases - right_edge_compensation_for_tight_cases;	
	cut_height = screen_height - top_edge_compensation_for_tight_cases - bottom_edge_compensation_for_tight_cases;
	

	translate([screen_x0+left_edge_compensation_for_tight_cases, screen_y0+bottom_edge_compensation_for_tight_cases, rail_height/2 - fudge])
	cube([cut_width, cut_height, pedestal_height + fudge*2]);
}

module add_slide_in_tabs(major_dim,minor_dim) {
	left_slide_in_tab_offset = -major_dim/2-slide_in_tab_length_incl_acrylic;
	
	translate([left_slide_in_tab_offset+slide_in_tab_length_incl_acrylic,case_y0+height_of_opening_in_case/2-distance_between_slide_in_tabs/2-slide_in_tab_width/2,-rail_height/2])
	mirror([1,0,0])
	create_slide_in_tab();
	
	translate([left_slide_in_tab_offset+slide_in_tab_length_incl_acrylic,case_y0+height_of_opening_in_case/2+distance_between_slide_in_tabs/2+slide_in_tab_width/2,-rail_height/2])
	mirror([1,0,0])
	create_slide_in_tab();
	
	right_slide_in_tab_offset = major_dim/2;
	
	translate([right_slide_in_tab_offset,case_y0+height_of_opening_in_case/2-distance_between_slide_in_tabs/2-slide_in_tab_width/2,-rail_height/2])
	create_slide_in_tab();
	
	translate([right_slide_in_tab_offset,case_y0+height_of_opening_in_case/2+distance_between_slide_in_tabs/2+slide_in_tab_width/2,-rail_height/2])
	create_slide_in_tab();
}

module create_slide_in_tab(){
	x1_offset = -slide_in_tab_length_incl_acrylic/2;
	x2_offset = slide_in_tab_length_incl_acrylic/2-2;
	
	translate([x2_offset,0,0])
	linear_extrude(height = slide_in_tab_thickness)
	difference(){
		offset(r=2)
		square([slide_in_tab_length_incl_acrylic,slide_in_tab_width-4],center=true);
		
		translate([x1_offset,0,0])
		square([4,slide_in_tab_width+2],center=true);
	}
	
	translate([1.5,slide_in_tab_width/2+1.5,0])
	linear_extrude(height = slide_in_tab_thickness)
	difference(){
		square(3,center=true);
		circle(d=3);
		
		translate([.75,0,0])
		square([1.5,3],center=true);
		
		translate([0,.75,0])
		square([3,1.5],center=true);
	}
	
	translate([1.5,-slide_in_tab_width/2-1.5,0])
	linear_extrude(height = slide_in_tab_thickness)
	difference(){
		square(3,center=true);
		circle(d=3);
		
		translate([.75,0,0])
		square([1.5,3],center=true);
		
		translate([0,-.75,0])
		square([3,1.5],center=true);
	}
}

module add_raised_tabs(major_dim,minor_dim) {
	a1 = raised_tab_thickness;
	b1 = rail_height;
	c1 = b1 - a1;
	d1 = raised_tab_height;
	e1 = raised_tab_length;
	f1 = d1 - a1 - c1;
	g1 = d1 - b1 + a1;
	h1 = g1 + a1;
		
	translate([-major_dim/2,-distance_between_raised_tabs/2-raised_tab_width,rail_height-raised_tab_thickness-rail_height/2-chamfer_size])
	rotate([-90,180,0])
	linear_extrude(height = raised_tab_width)
	polygon(points=[[0,a1],[0,0],[d1,g1],[e1,g1],[e1,h1],[d1,h1]]);

	translate([-major_dim/2,distance_between_raised_tabs/2,rail_height-raised_tab_thickness-rail_height/2-chamfer_size])
	rotate([-90,180,0])
	linear_extrude(height = raised_tab_width)
	polygon(points=[[0,a1],[0,0],[d1,g1],[e1,g1],[e1,h1],[d1,h1]]);

	translate([major_dim/2,-distance_between_raised_tabs/2,rail_height-raised_tab_thickness-rail_height/2-chamfer_size])
	rotate([90,0,0])
	linear_extrude(height = raised_tab_width)
	polygon(points=[[0,a1],[0,0],[d1,g1],[e1,g1],[e1,h1],[d1,h1]]);
	
	translate([major_dim/2,distance_between_raised_tabs/2+raised_tab_width,rail_height-raised_tab_thickness-rail_height/2-chamfer_size])
	rotate([90,0,0])
	linear_extrude(height = raised_tab_width)
	polygon(points=[[0,a1],[0,0],[d1,g1],[e1,g1],[e1,h1],[d1,h1]]);
}

module round_tab_corners(tab_height,tab_thickness,tab_length,tab_width,distance_between_tabs,major_dim,minor_dim) {
	left_side_tab_offset = -major_dim/2- raised_tab_height - (raised_tab_length-raised_tab_height)+tab_length/2;
	right_side_tab_offset = major_dim/2 + raised_tab_height+tab_length/2;
	  
	tab_base = -rail_height/2+raised_tab_thickness/2+raised_tab_height-chamfer_size;

	translate([left_side_tab_offset,case_y0+height_of_opening_in_case/2-distance_between_tabs/2-tab_width+tab_length/2,tab_base])
	create_cutting_tool(180, tab_length, raised_tab_thickness+fudge*2, 90, "rt");
	translate([left_side_tab_offset,case_y0+height_of_opening_in_case/2-distance_between_tabs/2-tab_length/2,tab_base])
	create_cutting_tool(90, tab_length, raised_tab_thickness+fudge*2, 90, "rt");
	
	translate([left_side_tab_offset,case_y0+height_of_opening_in_case/2+distance_between_tabs/2+tab_length/2,tab_base])
	create_cutting_tool(180, tab_length, raised_tab_thickness+fudge*2, 90, "rt");
	translate([left_side_tab_offset,case_y0+height_of_opening_in_case/2+distance_between_tabs/2+tab_width-tab_length/2,tab_base])
	create_cutting_tool(90, tab_length, raised_tab_thickness+fudge*2, 90, "rt");
	
	translate([right_side_tab_offset,case_y0+height_of_opening_in_case/2-distance_between_tabs/2-tab_width+tab_length/2,tab_base])
	create_cutting_tool(-90, tab_length,raised_tab_thickness+fudge*2, 90, "rt");
	translate([right_side_tab_offset,case_y0+height_of_opening_in_case/2-distance_between_tabs/2-tab_length/2,tab_base])
	create_cutting_tool(0, tab_length,raised_tab_thickness+fudge*2, 90, "rt");
	
	translate([right_side_tab_offset,case_y0+height_of_opening_in_case/2+distance_between_tabs/2+tab_length/2,tab_base])
	create_cutting_tool(-90, tab_length, raised_tab_thickness+fudge*2, 90, "rt");
	translate([right_side_tab_offset,case_y0+height_of_opening_in_case/2+distance_between_tabs/2+tab_width-tab_length/2,tab_base])
	create_cutting_tool(0, tab_length, raised_tab_thickness+fudge*2, 90, "rt");
}

module create_cutting_tool(rotation,diameter,thickness,slope,type){
	rotate([0,0,rotation])
	difference(){
		translate([0,0,-thickness/2-fudge/2])
		cube(size=[diameter/2+fudge*2,diameter/2+fudge*2,thickness+fudge]);
		intersection(){
			cylinder(h=thickness+fudge*4,r1=diameter/2,r2=diameter/2-(thickness/tan(slope)),center=true);
			if (type=="oa" && type_of_keyguard=="3D-Printed"){ //outer arcs are chamfered
				chamfer_circle_radius1 = diameter/2+(tan(45)*(thickness-.6)); // bottom radius
				chamfer_circle_radius2 = diameter/2 -.6; //top radius
				cylinder(h=thickness+fudge*2,r1=chamfer_circle_radius1,r2=chamfer_circle_radius2,center=true);
			}
		}
	}
}

module home_camera(){
	//deal with home button
	if (home_button_location!=0 && expose_home_button=="yes" && home_button_height > 0 && home_button_width > 0){
		translate([home_x_loc,home_y_loc,0])
		if (home_button_height==home_button_width){
			circular_cutter(home_button_height,90);
		}
		else{
			cut_width = (orientation=="landscape") ? home_button_width : home_button_height;
			cut_height = (orientation=="landscape") ? home_button_height : home_button_width;
			hotdog_cutter(cut_width,cut_height,90);
		}
	}
	//deal with camera
	if (camera_location!=0 && expose_camera=="yes" && camera_height > 0 && camera_width > 0){
		translate([cam_x_loc,cam_y_loc,0])
		if (camera_height==camera_width){
			if (type_of_keyguard=="3D-Printed"){
				circular_cutter(camera_height,45);
			}
			else{
				circular_cutter(camera_height,90);
			}
		}
		else{
			cut_width = (orientation=="landscape") ? camera_width : camera_height;
			cut_height = (orientation=="landscape") ? camera_height : camera_width;
			if (type_of_keyguard=="3D-Printed"){
				hotdog_cutter(cut_width,cut_height,45);
			}
			else{
				hotdog_cutter(cut_width,cut_height,90);
			}
		}
	}
}

module mounting_points(){
	if (m_m=="Suction Cups"){
		suction_cups();
	}
	else if (m_m=="Velcro"){
		velcro();
	}
	else if (m_m=="Screw-on Straps"){
		screw_on_straps();
	}
	else if (m_m=="Clip-on Straps"){
		clip_on_straps();
	}
	else {
		//No Mount option
	}
}

module suction_cups(){
	major_dim = max(tablet_width,tablet_height);
	minor_dim = min(tablet_width,tablet_height);

	// translate([tablet_x0+left_border_width/2, tablet_y0+tablet_height/2 + 40, 0])
	translate([-major_dim/2+left_border_width/2, 40, 0])
	cylinder(h=rail_height*3, d=7.5, center=true);
	translate([-major_dim/2+left_border_width/2, 40-5, 0])
	cylinder(h=rail_height*3, d=4.5, center=true);
	
	translate([-major_dim/2+left_border_width/2, -40, 0])
	cylinder(h=rail_height*3, d=7.5, center=true);
	translate([-major_dim/2+left_border_width/2, -40+5, 0])
	cylinder(h=rail_height*3, d=4.5, center=true);
	
	translate([major_dim/2-right_border_width/2, 40, 0])
	cylinder(h=rail_height*3, d=7.5, center=true);
	translate([major_dim/2-right_border_width/2, 40-5, 0])
	cylinder(h=rail_height*3, d=4.5, center=true);
	
	translate([major_dim/2-right_border_width/2, -40, 0])
	cylinder(h=rail_height*3, d=7.5, center=true);
	translate([major_dim/2-right_border_width/2, -40+5, 0])
	cylinder(h=rail_height*3, d=4.5, center=true);
	
	translate([-major_dim/2+left_border_width/2-5, 30.5,-rail_height/2+2])
	cube(size=[10,15,rail_height]);
	
	translate([-major_dim/2+left_border_width/2-5, -45.5,-rail_height/2+2])
	cube(size=[10,15,rail_height]);

	translate([major_dim/2-right_border_width/2-5, 30.5,-rail_height/2+2])
	cube(size=[10,15,rail_height]);
	
	translate([major_dim/2-right_border_width/2-5, -45.5,-rail_height/2+2])
	cube(size=[10,15,rail_height]);
}

module velcro(){
	major_dim = max(tablet_width,tablet_height);
	minor_dim = min(tablet_width,tablet_height);

	//create recessed shapes on the bottom of the surround to mount velcro
	
	if (m_m=="Velcro"){
		if (velcro_size<=3){ //round velcros
			translate([-major_dim/2+velcro_diameter/2+2, 30, -rail_height/2+.5])
			cylinder(h=2.5, d=velcro_diameter, center=true);
			
			translate([-major_dim/2+velcro_diameter/2+2, -30, -rail_height/2+.5])
			cylinder(h=2.5, d=velcro_diameter, center=true);
			
			translate([major_dim/2-velcro_diameter/2-2, 30, -rail_height/2+.5])
			cylinder(h=2.5, d=velcro_diameter, center=true);
			
			translate([major_dim/2-velcro_diameter/2-2, -30, -rail_height/2+.5])
			cylinder(h=2.5, d=velcro_diameter, center=true);
		}
		else{ //square velcros
			translate([-major_dim/2+velcro_diameter/2+2, 30, -rail_height/2+.5])
			cube(size=[velcro_diameter,velcro_diameter,2.5],center=true);
			
			translate([-major_dim/2+velcro_diameter/2+2, -30, -rail_height/2+.5])
			cube(size=[velcro_diameter,velcro_diameter,2.5],center=true);
			
			translate([major_dim/2-velcro_diameter/2-2, 30, -rail_height/2+.5])
			cube(size=[velcro_diameter,velcro_diameter,2.5],center=true);
			
			translate([major_dim/2-velcro_diameter/2-2, -30, -rail_height/2+.5])
			cube(size=[velcro_diameter,velcro_diameter,2.5],center=true);
		}
	}
}

module screw_on_straps(){
	major_dim = max(tablet_width,tablet_height);
	minor_dim = min(tablet_width,tablet_height);

	//drill holes for screw-on straps and cut slots if needed for thick keyguards
	if (strap_cut_to_depth<rail_height) {  //cuts slot and flanges (the cylinders) for Keyguard AT's acrylic tabs
		translate([-major_dim/2-1,34.5,-rail_height/2+strap_cut_to_depth])
		cube(size=[12,11,rail_height]);
		translate([-major_dim/2-1,34.5,-rail_height/2+strap_cut_to_depth])
		cylinder(h=rail_height,d=7,$fn=3);
		translate([-major_dim/2-1,45.5,-rail_height/2+strap_cut_to_depth])
		cylinder(h=rail_height,d=7,$fn=3);
		
		translate([-major_dim/2-1,-45.5,-rail_height/2+strap_cut_to_depth])
		cube(size=[12,11,rail_height]);
		translate([-major_dim/2-1,-45.5,-rail_height/2+strap_cut_to_depth])
		cylinder(h=rail_height,d=7,$fn=3);
		translate([-major_dim/2-1,-34.5,-rail_height/2+strap_cut_to_depth])
		cylinder(h=rail_height,d=7,$fn=3);

		translate([major_dim/2-11,34.5,-rail_height/2+strap_cut_to_depth])
		cube(size=[12,11,rail_height]);
		translate([major_dim/2,34.5,-rail_height/2+strap_cut_to_depth])
		rotate([0,0,180])
		cylinder(h=rail_height,d=7,$fn=3);
		translate([major_dim/2,45.5,-rail_height/2+strap_cut_to_depth])
		rotate([0,0,180])
		cylinder(h=rail_height,d=7,$fn=3);
		
		translate([major_dim/2-11,-45.5,-rail_height/2+strap_cut_to_depth])
		cube(size=[12,11,rail_height]);
		translate([major_dim/2,-45.5,-rail_height/2+strap_cut_to_depth])
		rotate([0,0,180])
		cylinder(h=rail_height,d=7,$fn=3);
		translate([major_dim/2,-34.5,-rail_height/2+strap_cut_to_depth])
		rotate([0,0,180])
		cylinder(h=rail_height,d=7,$fn=3);
	}
	//cut holes for screw
	translate([-major_dim/2+5.5, 40, -rail_height/2])
	cylinder(h=rail_height*3, d=6, center=true);
	
	translate([-major_dim/2+5.5, - 40, -rail_height/2])
	cylinder(h=rail_height*3, d=6, center=true);
	
	translate([major_dim/2-5.5, 40, -rail_height/2])
	cylinder(h=rail_height*3, d=6, center=true);
	
	translate([major_dim/2-5.5, -40, -rail_height/2])
	cylinder(h=rail_height*3, d=6, center=true);
}

module clip_on_straps(){
	major_dim = (have_a_case=="no") ? max(tablet_width,tablet_height) : max(width_of_opening_in_case,height_of_opening_in_case);
	minor_dim = (have_a_case=="no") ? min(tablet_width,tablet_height): min(width_of_opening_in_case,height_of_opening_in_case);

	x0 = -major_dim/2;
	y0 = -minor_dim/2;
	height_offset = (have_a_case=="no") ? tablet_height : height_of_opening_in_case;
	width_offset = (have_a_case=="no") ? tablet_width : width_of_opening_in_case;
		
	if(clip_loc=="horizontal only" || clip_loc =="horizontal and vertical"){
		translate([-major_dim/2 + 2, -dist_between_horizontal_clips/2, vertical_offset])
		rotate([90,0,0])
		linear_extrude(height = horizontal_clip_width + 2)
		polygon(points=[[0,0],[3,0],[4,3],[1,3]]);
		
		translate([-major_dim/2 + 2, dist_between_horizontal_clips/2+(horizontal_clip_width+2), vertical_offset])
		rotate([90,0,0])
		linear_extrude(height = horizontal_clip_width + 2)
		polygon(points=[[0,0],[3,0],[4,3],[1,3]]);
		
		translate([major_dim/2 - 5, -dist_between_horizontal_clips/2, vertical_offset])
		rotate([90,0,0])
		linear_extrude(height = horizontal_clip_width + 2)
		polygon(points=[[0,0],[3,0],[2,3],[-1,3]]);
		
		translate([major_dim/2 - 5, dist_between_horizontal_clips/2+(horizontal_clip_width+2), vertical_offset])
		rotate([90,0,0])
		linear_extrude(height = horizontal_clip_width + 2)
		polygon(points=[[0,0],[3,0],[2,3],[-1,3]]);
	}
	
	if(clip_loc=="vertical only" || clip_loc =="horizontal and vertical"){
		translate([-dist_between_vertical_clips/2-(vertical_clip_width+2), -minor_dim/2 + 2,  vertical_offset])
		rotate([90,0,90])
		linear_extrude(height = vertical_clip_width + 2)
		polygon(points=[[0,0],[3,0],[4,3],[1,3]]);
		
		translate([dist_between_vertical_clips/2, -minor_dim/2 + 2,  vertical_offset])
		rotate([90,0,90])
		linear_extrude(height = vertical_clip_width + 2)
		polygon(points=[[0,0],[3,0],[4,3],[1,3]]);
		
		translate([-dist_between_vertical_clips/2, minor_dim/2 - 2,  vertical_offset])
		rotate([90,0,-90])
		linear_extrude(height = vertical_clip_width + 2)
		polygon(points=[[0,0],[3,0],[4,3],[1,3]]);
		
		translate([dist_between_vertical_clips/2 + vertical_clip_width + 2, minor_dim/2 - 2,  vertical_offset])
		rotate([90,0,-90])
		linear_extrude(height = vertical_clip_width + 2)
		polygon(points=[[0,0],[3,0],[4,3],[1,3]]);
	}
}

module bars(){
	// creates upper and lower command and message bars - will be part of a difference function
		
	//status bar
	if(expose_status_bar=="yes" && status_bar_height > 0) {
		translate([screen_x0+screen_width/2,screen_y0+screen_height-status_bar_height/2,0])
		if(type_of_keyguard=="3D-Printed" || (type_of_keyguard=="Laser-Cut" && use_Laser_Cutting_best_practices=="no")){
			rectangular_cutter(screen_width,status_bar_height+fudge,90,90,90,90);
		}
		else{
			rounded_rectangular_cutter(screen_width,status_bar_height,90,status_bar_height/10);
		}
	}

	//upper message bar
	if(expose_upper_message_bar=="yes" && upper_message_bar_height > 0) {
		translate([screen_x0+screen_width/2,screen_y0+screen_height-status_bar_height-upper_message_bar_height/2,0])
		if(type_of_keyguard=="3D-Printed" || (type_of_keyguard=="Laser-Cut" && use_Laser_Cutting_best_practices=="no")){
			rectangular_cutter(screen_width,upper_message_bar_height,90,bar_edge_slope_inc_acrylic,90,90);
		}
		else{
			rounded_rectangular_cutter(screen_width,upper_message_bar_height,90,upper_message_bar_height/10);
		}
	}

	//upper command bar
	if(expose_upper_command_bar=="yes" && upper_command_bar_height > 0) {
		translate([screen_x0+screen_width/2,screen_y0+screen_height-status_bar_height-upper_message_bar_height-upper_command_bar_height/2,0])
		if(type_of_keyguard=="3D-Printed" || (type_of_keyguard=="Laser-Cut" && use_Laser_Cutting_best_practices=="no")){
			rectangular_cutter(screen_width,upper_command_bar_height+fudge,bar_edge_slope_inc_acrylic,90,90,90);
		}
		else{
			rounded_rectangular_cutter(screen_width,upper_command_bar_height,90,upper_command_bar_height/10);
		}
	}
		
	//lower message bar
	if(expose_lower_message_bar=="yes" && lower_message_bar_height > 0) {
		translate([screen_x0+screen_width/2,screen_y0+lower_command_bar_height+lower_message_bar_height/2,0])
		if(type_of_keyguard=="3D-Printed" || (type_of_keyguard=="Laser-Cut" && use_Laser_Cutting_best_practices=="no")){
			rectangular_cutter(screen_width,lower_message_bar_height,90,bar_edge_slope_inc_acrylic,90,90);
		}
		else{
			rounded_rectangular_cutter(screen_width,lower_message_bar_height,90,lower_message_bar_height/10);
		}
	}
		
	//lower command bar
	if(expose_lower_command_bar=="yes" && lower_command_bar_height > 0) {
		translate([screen_x0+screen_width/2,screen_y0+lower_command_bar_height/2,0])
		if(type_of_keyguard=="3D-Printed" || (type_of_keyguard=="Laser-Cut" && use_Laser_Cutting_best_practices=="no")){
			rectangular_cutter(screen_width,lower_command_bar_height+fudge,bar_edge_slope_inc_acrylic,90,90,90);
		}
		else{
			rounded_rectangular_cutter(screen_width,lower_command_bar_height,90,lower_command_bar_height/10);
		}
	}
	
	if(type_of_keyguard=="Laser-Cut"){
		//clean-up any pieces of rounded rectangle corners if adjacent bars are exposed
		if((expose_status_bar=="yes" && status_bar_height > 0)&&(expose_upper_message_bar=="yes" && upper_message_bar_height > 0)){
			translate([screen_x0+screen_width/2,screen_y0+screen_height-status_bar_height-upper_message_bar_height/2+upper_message_bar_height/10+fudge,0])
			rectangular_cutter(screen_width,upper_message_bar_height,90,90,90,90);
		}
		
		if((expose_upper_message_bar=="yes" && upper_message_bar_height > 0)&&(expose_upper_command_bar=="yes" && upper_command_bar_height > 0)){
			translate([screen_x0+screen_width/2,screen_y0+screen_height-status_bar_height-upper_message_bar_height-upper_command_bar_height/2+upper_command_bar_height/10+fudge,0])
			rectangular_cutter(screen_width,upper_command_bar_height+fudge,bar_edge_slope_inc_acrylic,90,90,90);
		}
	
		if((expose_lower_message_bar=="yes" && lower_message_bar_height > 0)&&(expose_lower_command_bar=="yes" && lower_command_bar_height > 0)){
			translate([screen_x0+screen_width/2,screen_y0+lower_command_bar_height/2+lower_command_bar_height/10+fudge,0])
			rectangular_cutter(screen_width,lower_command_bar_height+fudge,bar_edge_slope_inc_acrylic,90,90,90);
		}
	}
}

module cells(){
	for (i = [0:row_count-1]){
		for (j = [0:column_count-1]){
			current_cell = j+1+i*column_count;
			cell_x0 = grid_x0 + j*max_cell_width + max_cell_width/2;
			cell_y0 = grid_y0 + i*max_cell_height + max_cell_height/2;
			// cell_y0 = grid_y0 + i*max_cell_height + max_cell_height/2 - hrw/2;
			
			if (!search(current_cell,cover_these_cells)){
				if (shape_of_cut=="rectangle"){
					if ((search(current_cell,merge_cells_horizontally_starting_at))&&(j!=column_count-1)){
						translate([cell_x0+max_cell_width/2,cell_y0,0])
						rectangular_cutter(2*max_cell_width-vrw,max_cell_height-hrw,rs_inc_acrylic,rs_inc_acrylic,rs_inc_acrylic,rs_inc_acrylic);
					}
					if((search(current_cell,merge_cells_vertically_starting_at))&&(i!=row_count-1)){
						translate([cell_x0,cell_y0+max_cell_height/2,0])
						rectangular_cutter(max_cell_width-vrw,2*max_cell_height-hrw,rs_inc_acrylic,rs_inc_acrylic,rs_inc_acrylic,rs_inc_acrylic);
					}
					//clean up center pyramid if a cell is in both horizontal and vertical merge and next cell is also in the vertical merge
					if((search(current_cell,merge_cells_horizontally_starting_at))&&(search(current_cell,merge_cells_vertically_starting_at))&&(search(current_cell+1,merge_cells_vertically_starting_at))){
						translate([cell_x0+max_cell_width/2,cell_y0+max_cell_height/2,0])
						rectangular_cutter(max_cell_width-vrw,2*max_cell_height-hrw,rs_inc_acrylic,rs_inc_acrylic,rs_inc_acrylic,rs_inc_acrylic);
					}
					//basic, no-merge cell cut these two statements will have no impact if cell has been merged
					translate([cell_x0,cell_y0,0])
					rectangular_cutter(max_cell_width-vrw,max_cell_height-hrw,rs_inc_acrylic,rs_inc_acrylic,rs_inc_acrylic,rs_inc_acrylic);
				}
				else if (shape_of_cut=="circle") {
					circle_diameter = actual_cell_width;
					if ((search(current_cell,merge_cells_horizontally_starting_at))&&(j!=column_count-1)){
						translate([cell_x0+max_cell_width/2,cell_y0,0])
						hotdog_cutter(max_cell_width+circle_diameter,circle_diameter,rs_inc_acrylic);
					}
					if((search(current_cell,merge_cells_vertically_starting_at))&&(i!=row_count-1)){
						translate([cell_x0,cell_y0+max_cell_height/2,0])
						hotdog_cutter(circle_diameter,max_cell_height+circle_diameter,rs_inc_acrylic);
					}
					//clean up center pyramid if a cell is in both horizontal and vertical merge and next cell is also in the vertical merge
					if((search(current_cell,merge_cells_horizontally_starting_at))&&(search(current_cell,merge_cells_vertically_starting_at))&&(search(current_cell+1,merge_cells_vertically_starting_at))){
						translate([cell_x0+max_cell_width/2,cell_y0+max_cell_height/2,0])
						rectangular_cutter(max_cell_height,max_cell_width,90,90,rs_inc_acrylic,rs_inc_acrylic);
						translate([cell_x0+max_cell_width/2,cell_y0+max_cell_height/2,0])
						rectangular_cutter(max_cell_width,max_cell_height,rs_inc_acrylic,rs_inc_acrylic,90,90);
					}
					//these two statements will have no impact if cell has been merged
					translate([cell_x0,cell_y0,0])
					hotdog_cutter(circle_diameter,circle_diameter,rs_inc_acrylic);
				}
				else{
				//rounded rectangle
					if ((search(current_cell,merge_cells_horizontally_starting_at))&&(j!=column_count-1)){
						translate([cell_x0+max_cell_width/2,cell_y0,0])
						rounded_rectangular_cutter(2*max_cell_width-vrw,max_cell_height-hrw,rs_inc_acrylic,rrcr);	
					}
					if((search(current_cell,merge_cells_vertically_starting_at))&&(i!=row_count-1)){
						translate([cell_x0,cell_y0+max_cell_height/2,0])
						rounded_rectangular_cutter(max_cell_width-vrw,2*max_cell_height-hrw,rs_inc_acrylic,rrcr);	
					}
					//clean up center pyramid if a cell is in both horizontal and vertical merge and next cell is also in the vertical merge
					if((search(current_cell,merge_cells_horizontally_starting_at))&&(search(current_cell,merge_cells_vertically_starting_at))&&(search(current_cell+1,merge_cells_vertically_starting_at))){
						translate([cell_x0+max_cell_width/2,cell_y0+max_cell_height/2,0])
						rectangular_cutter(max_cell_width-vrw,2*max_cell_height-hrw,rs_inc_acrylic,rs_inc_acrylic,rs_inc_acrylic,rs_inc_acrylic);
					}
					//basic, no-merge cell cut these two statements will have no impact if cell has been merged
					translate([cell_x0,cell_y0,0])
					rounded_rectangular_cutter(max_cell_width-vrw,max_cell_height-hrw,rs_inc_acrylic,rrcr);
				}
			}
		}
	}
}

module cell_ridges(){
	max_cell_width=grid_width/column_count;
	max_cell_height=grid_height/row_count;

	for (i = [0:row_count-1]){
		for (j = [0:column_count-1]){
			current_cell = j+1+i*column_count;
			cell_x0 = grid_x0 + j*max_cell_width + max_cell_width/2;
			cell_y0 = grid_y0 + i*max_cell_height + max_cell_height/2;
		
			if (search(current_cell,add_a_ridge_around_these_cells)){
				if(shape_of_cut == "rectangle"){
					slope_adjust = rail_height/tan(rs_inc_acrylic);
					translate([cell_x0,cell_y0,rail_height/2])
					rectangle_wall(max_cell_width-vrw+slope_adjust*2,max_cell_height-hrw+slope_adjust*2,thickness_of_ridge,height_of_ridge);
				}
				else if(shape_of_cut == "circle"){
					circle_diameter = actual_cell_width;
					
					slope_adjust = rail_height/tan(rs_inc_acrylic);
					translate([cell_x0,cell_y0,-rail_height/2])
					circular_wall(circle_diameter+slope_adjust*2,thickness_of_ridge,height_of_ridge+rail_height);
				}
				else if(shape_of_cut == "rounded-rectangle"){
					corner_radius = min(rrcr,(max_cell_width-vrw)/2,(max_cell_height-hrw)/2);
					slope_adjust = rail_height/tan(rs_inc_acrylic);
					translate([cell_x0,cell_y0,-rail_height/2])
					rounded_rectangle_wall(max_cell_width-vrw+slope_adjust*2,max_cell_height-hrw+slope_adjust*2,corner_radius+slope_adjust,thickness_of_ridge,height_of_ridge+rail_height);
				}
			}
		}
	}
}

module circular_wall(ID,thickness,hgt){
	rotate_extrude($fn=60)
	polygon([[ID/2,0],[ID/2+thickness,0],[ID/2+thickness,hgt-.5],[ID/2+thickness-.5,hgt],[ID/2+.5,hgt],[ID/2,hgt-.5]]);
}

module rounded_rectangle_wall(width,hgt,corner_radius,thickness,hgt2){
	rr_wall1(width,hgt,corner_radius,thickness,hgt2);
	mirror([0,1,0])
	rr_wall1(width,hgt,corner_radius,thickness,hgt2);
	
	rr_wall2(width,hgt,corner_radius,thickness,hgt2);
	mirror([1,0,0])
	rr_wall2(width,hgt,corner_radius,thickness,hgt2);

	rr_corner_wall(width,hgt,corner_radius,thickness,hgt2);
	mirror([1,0,0])
	rr_corner_wall(width,hgt,corner_radius,thickness,hgt2);
	mirror([0,1,0])
	rr_corner_wall(width,hgt,corner_radius,thickness,hgt2);
	mirror([1,0,0])
	mirror([0,1,0])
	rr_corner_wall(width,hgt,corner_radius,thickness,hgt2);
}

module rr_wall1(width,hgt,corner_radius,thickness,hgt2){
	translate([width/2-corner_radius,-hgt/2,0])
	rotate([0,0,-90])
	rotate([90,0,0])
	linear_extrude(height=width-corner_radius*2)
	polygon([[0,0],[thickness,0],[thickness,hgt2-.5],[thickness-.5,hgt2],[.5,hgt2],[0,hgt2-.5]]);
}

module rr_wall2(width,hgt,corner_radius,thickness,hgt2){
	translate([-width/2-thickness,hgt/2-corner_radius,0])
	rotate([90,0,0])
	linear_extrude(height=hgt-corner_radius*2)
	polygon([[0,0],[thickness,0],[thickness,hgt2-.5],[thickness-.5,hgt2],[.5,hgt2],[0,hgt2-.5]]);
}

module rr_corner_wall(width,hgt,corner_radius,thickness,hgt2){
	translate([width/2-corner_radius,hgt/2-corner_radius,0])
	rotate_extrude(angle=90,$fn=60)
	translate([corner_radius,0,0])
	polygon([[0,0],[thickness,0],[thickness,hgt2-.5],[thickness-.5,hgt2],[.5,hgt2],[0,hgt2-.5]]);
}

module rectangle_wall(width,hgt,thickness,hgt2){
	difference(){
		union(){
			r_wall1(width,hgt,thickness,hgt2);
			mirror([0,1,0])
			r_wall1(width,hgt,thickness,hgt2);
			r_wall2(width,hgt,thickness,hgt2);
			mirror([1,0,0])
			r_wall2(width,hgt,thickness,hgt2);
	}
		
		r_wall_chamfer(width,hgt,thickness,hgt2);
		mirror([1,0,0])
		r_wall_chamfer(width,hgt,thickness,hgt2);
		mirror([0,1,0])
		r_wall_chamfer(width,hgt,thickness,hgt2);
		mirror([1,0,0])
		mirror([0,1,0])
		r_wall_chamfer(width,hgt,thickness,hgt2);
	}
}

module r_wall1(width,hgt,thickness,hgt2){
	translate([-width/2-thickness,-(hgt+thickness)/2,0])
	hridge(width+thickness*2,thickness,hgt2);
}

module r_wall2(width,hgt,thickness,hgt2){
	translate([-width/2-thickness/2,-hgt/2-thickness,0])
	vridge(hgt+thickness*2,thickness,hgt2);
}

module r_wall_chamfer(width,hgt,thickness,hgt2){
	translate([-width/2-thickness-fudge,hgt/2+thickness-.5+fudge,-rail_height-fudge])
	linear_extrude(height=hgt2+rail_height)
	polygon([[0,0],[.5,.5],[0,.5]]);
}


module rectangular_cutter(hole_width,hole_height,top_slope,bottom_slope,left_slope,right_slope){
	r_c(hole_width,hole_height,top_slope,bottom_slope,left_slope,right_slope,rail_height);
	if (generate!="cell cover" && type_of_keyguard=="3D-Printed"){
		//this code adds chamfer to the top edge of a opening with a steep slope
		translate([0,0,rail_height/2-fudge*2])
		r_c(hole_width,hole_height,45,45,45,45,1);
	}
}

module r_c(hole_width,hole_height,top_slope,bottom_slope,left_slope,right_slope,cut_height){
	kt=cut_height + 0.01;
	hw=hole_width;
	hh=hole_height;

	lxo = kt/tan(left_slope); //left x offset
	rxo = kt/tan(right_slope);
	tyo = kt/tan(top_slope);
	byo = kt/tan(bottom_slope);

	A_x = -hw/2; A_y = -hh/2;
	B_x = hw/2; B_y = -hh/2;
	C_x = hw/2; C_y = hh/2;
	D_x = -hw/2; D_y = hh/2;

	E_x = D_x - lxo; E_y = D_y + tyo;
	F_x = A_x - lxo; F_y = A_y - byo;
	G_x = B_x + rxo; G_y = B_y - byo;
	H_x = C_x + rxo; H_y = C_y + tyo;

	CubePoints = [
	  [A_x, A_y, -kt/2],  //0
	  [B_x, B_y, -kt/2],  //1
	  [C_x, C_y, -kt/2],  //2
	  [D_x, D_y, -kt/2],  //3
	  [F_x, F_y, kt/2],  //4
	  [G_x, G_y, kt/2],  //5
	  [H_x, H_y, kt/2],  //6
	  [E_x, E_y, kt/2]]; //7
	  
	CubeFaces = [
	  [0,1,2,3],  // bottom
	  [4,5,1,0],  // front
	  [7,6,5,4],  // top
	  [5,6,2,1],  // right
	  [6,7,3,2],  // back
	  [7,4,0,3]]; // left
	  
	polyhedron( CubePoints, CubeFaces );
}

module hotdog_cutter(cut_width,cut_height,slope){
	if (cut_width > cut_height){
		//circles at either end, cut_height in diameter
		hull(){
			translate([-cut_width/2 + cut_height/2, 0, 0])
			c_c(cut_height,slope,rail_height);
			translate([cut_width/2 - cut_height/2, 0, 0])
			c_c(cut_height,slope,rail_height);
		}
		if (generate!="cell cover" && type_of_keyguard=="3D-Printed"){
			//this code adds chamfer to the top edge of a opening with a steep slope
			hull(){
				translate([-cut_width/2 + cut_height/2, 0, rail_height/2-fudge*2])
				c_c(cut_height,45,1);
				translate([cut_width/2 - cut_height/2, 0, rail_height/2-fudge*2])
				c_c(cut_height,45,1);
			}
		}
	}
	else{
		//circles at either end, cut_width in diameter
		hull(){
			translate([0,cut_height/2 - cut_width/2 , 0])
			c_c(cut_width,slope,rail_height);
			translate([0,cut_width/2 - cut_height/2, 0])
			c_c(cut_width,slope,rail_height);
		}
		if (generate!="cell cover" && type_of_keyguard=="3D-Printed"){
			//this code adds chamfer to the top edge of a opening with a steep slope
			hull(){
				translate([0,cut_height/2 - cut_width/2 , rail_height/2-fudge*2])
				c_c(cut_width,45,1);
				translate([0,cut_width/2 - cut_height/2, rail_height/2-fudge*2])
				c_c(cut_width,45,1);
			}
		}
	}
}

module circular_cutter(circle_diameter,slope){
	c_c(circle_diameter,slope,rail_height);
	if (generate!="cell cover" && type_of_keyguard=="3D-Printed"){
		//this code adds chamfer to the top edge of a opening with a steep slope
		translate([0,0,rail_height/2-fudge*2])
		c_c(circle_diameter,45,1);	
	}
}

module c_c(circle_diameter,slope,cut_height){
	cell_cutter_height = cut_height + 0.01;
	cell_cutter_bottom = circle_diameter;
	tan_slope = tan(slope);
	cell_cutter_top = cell_cutter_bottom+(2*cell_cutter_height/tan_slope);

	cc_scale=cell_cutter_top/cell_cutter_bottom;
	
	linear_extrude(height=cell_cutter_height, scale=[cc_scale,cc_scale], center=true)
	circle(d=cell_cutter_bottom);
}

module rounded_rectangular_cutter(cut_width,cut_height,slope,corner_radius){
	//verify that the value of corner_radius isn't greater than the length of a side of the cell
	min_cell_dimension = min(cut_width,cut_height);
	cr = (min_cell_dimension>=corner_radius*2) ? corner_radius : (min_cell_dimension - 1)/2;
	
	//circles at four corners, corner_radius * 2 in diameter
	corner_diameter = 2 * cr;
	
	hull(){
		translate([-cut_width/2 + cr, cut_height/2 - cr, 0])
		c_c(corner_diameter,slope,rail_height);
		
		translate([-cut_width/2 + cr, -cut_height/2 + cr, 0])
		c_c(corner_diameter,slope,rail_height);
		
		translate([cut_width/2 - cr, cut_height/2 - cr, 0])
		c_c(corner_diameter,slope,rail_height);
		
		translate([cut_width/2 - cr, -cut_height/2 + cr, 0])
		c_c(corner_diameter,slope,rail_height);
	}
	if (generate!="cell cover" && type_of_keyguard=="3D-Printed"){
		//this code adds chamfer to the top edge of a opening with a steep slope
		hull(){
			translate([-cut_width/2 + cr, cut_height/2 - cr, rail_height/2-fudge*2])
			c_c(corner_diameter,45,1);
			
			translate([-cut_width/2 + cr, -cut_height/2 + cr, rail_height/2-fudge*2])
			c_c(corner_diameter,45,1);
			
			translate([cut_width/2 - cr, cut_height/2 - cr, rail_height/2-fudge*2])
			c_c(corner_diameter,45,1);
			
			translate([cut_width/2 - cr, -cut_height/2 + cr, rail_height/2-fudge*2])
			c_c(corner_diameter,45,1);
		}
	}
}

module create_cell_cover(){
	max_cell_width=grid_width/column_count - vrw;
	max_cell_height=grid_height/row_count - hrw;
	min_cell_dimension = min(max_cell_width + vrw,max_cell_height + hrw);
	max_rail_width = max(vrw,hrw);
	circle_diameter = min_cell_dimension - max_rail_width;
	
	// rotate([180,0,0])
	if (shape_of_cut=="rectangle"){
		rectangular_cutter(max_cell_width,max_cell_height,rs_inc_acrylic,rs_inc_acrylic,rs_inc_acrylic,rs_inc_acrylic);
	}
	else if (shape_of_cut=="circle"){
		circular_cutter(circle_diameter,rs_inc_acrylic);
	}
	else{ //rounded-rectangle
		rounded_rectangular_cutter(max_cell_width,max_cell_height,rs_inc_acrylic,rrcr);
	}
}

module cut_screen_openings(screen_openings){
	for(i = [0 : len(screen_openings)-1]){
		opening = screen_openings[i]; //0:ID, 1:x, 2:y, 3:width,  4:height, 5:shape, 6:top slope, 7:bottom slope, 8:left slope, 9:right slope, 10:corner_radius, 11:other
		
		// validate_data(opening);
		
		opening_ID = opening[0];
		opening_x = opening[1];
		opening_y = opening[2];
		opening_width = (opening[3]==undef) ? 0 : opening[3];
		opening_height = opening[4];
		//check for "rr" with "corner radius = 0"
		opening_shape = (opening[5]=="rr" && opening[10]==0) ? "r" : opening[5];
		opening_top_slope = ((opening[5]=="r" || opening[5]=="rr") && opening[6]==0 || type_of_keyguard=="Laser-Cut") ? 90 : opening[6];
		opening_bottom_slope = (opening[5]=="r" && opening[7]==0 || type_of_keyguard=="Laser-Cut") ? 90 : opening[7];
		opening_left_slope = (opening[5]=="r" && opening[8]==0 || type_of_keyguard=="Laser-Cut") ? 90 : opening[8];
		opening_right_slope = (opening[5]=="r" && opening[9]==0 || type_of_keyguard=="Laser-Cut") ? 90 : opening[9];
		opening_corner_radius = opening[10];
		opening_other = opening[11];
			
		opening_width_mm = (unit_of_measure_for_screen=="px") ? opening_width * pixel_size : opening_width;
		opening_height_mm = (unit_of_measure_for_screen=="px") ? opening_height * pixel_size : opening_height;
		opening_x_mm = (unit_of_measure_for_screen=="px") ? opening_x * pixel_size : opening_x;
		opening_corner_radius_mm = (unit_of_measure_for_screen=="px") ? opening_corner_radius * pixel_size : opening_corner_radius;

		if (starting_corner_for_screen_measurements == "upper-left"){
			opening_y_mm = (unit_of_measure_for_screen=="px") ? (screen_height_px - opening_y) * pixel_size : (screen_height - opening_y);
			translate([screen_x0+opening_x_mm,screen_y0+opening_y_mm,0])
			cut_opening(opening_ID, opening_width_mm, opening_height_mm, opening_shape, opening_top_slope, opening_bottom_slope, opening_left_slope, opening_right_slope, opening_corner_radius_mm, opening_other);
		}
		else{
			opening_y_mm = (unit_of_measure_for_screen=="px") ? opening_y * pixel_size : opening_y;
			
			translate([screen_x0+opening_x_mm,screen_y0+opening_y_mm,0])
			cut_opening(opening_ID, opening_width_mm, opening_height_mm, opening_shape, opening_top_slope, opening_bottom_slope, opening_left_slope, opening_right_slope, opening_corner_radius_mm, opening_other);
		}
	}
}

module cut_case_openings(case_openings){

	for(i = [0 : len(case_openings)-1]){
		opening = case_openings[i]; //0:ID, 1:x, 2:y, 3:width,  4:height, 5:shape, 6:top slope, 7:bottom slope, 8:left slope, 9:right slope, 10:corner_radius, 11:other

		// validate_data(opening);
		
		opening_ID = opening[0];
		opening_x = opening[1];
		opening_y = opening[2];
		opening_width = opening[3];
		opening_height = opening[4];
		//check for "rr" with "corner radius = 0"
		opening_shape = (opening[5]=="rr" && opening[10]==0) ? "r" : opening[5];
		opening_top_slope = ((opening[5]=="r" || opening[5]=="rr") && opening[6]==0 || type_of_keyguard=="Laser-Cut") ? 90 : opening[6];
		opening_bottom_slope = (opening[5]=="r" && opening[7]==0 || type_of_keyguard=="Laser-Cut") ? 90 : opening[7];
		opening_left_slope = (opening[5]=="r" && opening[8]==0 || type_of_keyguard=="Laser-Cut") ? 90 : opening[8];
		opening_right_slope = (opening[5]=="r" && opening[9]==0 || type_of_keyguard=="Laser-Cut") ? 90 : opening[9];
		opening_corner_radius = opening[10];
		opening_other = opening[11];
		
		translate([case_x0+opening_x,case_y0+opening_y,0])
		cut_opening(opening_ID, opening_width, opening_height, opening_shape, opening_top_slope, opening_bottom_slope, opening_left_slope, opening_right_slope, opening_corner_radius, opening_other);
	}
}

module cut_opening(ID, cut_width, cut_height, shape, top_slope, bottom_slope, left_slope, right_slope, corner_radius, other){
		if (shape=="r"){
			if (cut_width > 0 && cut_height > 0){
				translate([cut_width/2,cut_height/2,0])
				rectangular_cutter(cut_width,cut_height,top_slope,bottom_slope,left_slope,right_slope);
			}
		}
		else if (shape=="c"){
			if (cut_width > 0){
				translate([0,0,0])
				circular_cutter(cut_width,top_slope);
			}
		}
		else if (shape=="hd"){
			if (cut_width > 0 && cut_height > 0){
				translate([0,0,0])
				hotdog_cutter(cut_width,cut_height,top_slope);
			}
		}
		else if (shape=="rr"){
			if (cut_width > 0 && cut_height > 0){
				translate([cut_width/2,cut_height/2,0])
				rounded_rectangular_cutter(cut_width,cut_height,top_slope,corner_radius);
			}
		}	
		else if (shape=="oa1"){
			if (corner_radius > 0){
				translate([-corner_radius,-corner_radius,0])
				create_cutting_tool(0, corner_radius*2, rail_height+0.05, top_slope, "oa");
			}
		}
		else if (shape=="oa2"){
			if (corner_radius > 0){
				translate([-corner_radius,corner_radius,0])
				create_cutting_tool(-90, corner_radius*2, rail_height+0.05, top_slope, "oa");	
			}
		}
		else if (shape=="oa3"){
			if (corner_radius > 0){
				translate([corner_radius,corner_radius,0])
				create_cutting_tool(180, corner_radius*2, rail_height+0.05, top_slope, "oa");
			}
		}
		else if (shape=="oa4"){

			if (corner_radius > 0){
				translate([corner_radius,-corner_radius,0])
				create_cutting_tool(90, corner_radius*2, rail_height+0.05, top_slope, "oa");	
			}
		}
		else if (shape=="ttext" && type_of_keyguard=="3D-Printed"){
			font_style = 
				(bottom_slope==1)? "Liberation Sans:style=Bold"
			  : (bottom_slope==2)? "Liberation Sans:style=Italic"
			  : (bottom_slope==3)? "Liberation Sans:style=Bold Italic"
			  : "Liberation Sans";
			  
			if (cut_height > 0){
				translate([0,0,rail_height/3])
				rotate([0,0,top_slope])
				linear_extrude(height=rail_height/2 + 1)
				text(str(other),font = font_style, size=cut_height,valign="bottom");
			}
		}
		else if (shape=="btext" && type_of_keyguard=="3D-Printed"){
			font_style = 
				(bottom_slope==1)? "Liberation Sans:style=Bold"
			  : (bottom_slope==2)? "Liberation Sans:style=Italic"
			  : (bottom_slope==3)? "Liberation Sans:style=Bold Italic"
			  : "Liberation Sans";
			  
			if (cut_height > 0){
				translate([0,0,-rail_height/3])
				rotate([0,180,0])
				rotate([0,0,top_slope])
				linear_extrude(height=rail_height/2 + 1)
				text(str(other),font = font_style,size=cut_height,valign="bottom");
			}
		}
		else if (shape=="svg" && type_of_keyguard=="3D-Printed"){
			if (cut_width > 0 && cut_height > 0 && corner_radius<=0){
				// translate([0,0,rail_height/3])
				translate([0,0,rail_height/2+corner_radius+fudge])
				rotate([0,0,-top_slope])
				resize([cut_width,cut_height,-corner_radius])
				linear_extrude(height=1)
				offset(delta = .005)
				import(file = other,center=true);
			}
		}
}

module adding_plastic(additions,where){
	for(i = [0 : len(additions)-1]){
		addition = additions[i]; //0:ID, 1:x, 2:y, 3:width,  4:height, 5:shape, 6:top slope, 7:bottom slope, 8:left slope, 9:right slope, 10:corner_radius, 11:other
		
		// validate_data(addition);
		
		addition_ID = addition[0];
		addition_x = addition[1];
		addition_y = addition[2];
		addition_width = addition[3];
		addition_height = addition[4];
		addition_shape = addition[5];
		addition_top_slope = addition[6];
		addition_bottom_slope = addition[7];
		addition_left_slope = addition[8];
		addition_right_slope = addition[9];
		addition_corner_radius = addition[10];
		addition_other = addition[11];
		
		x0 = (where=="screen") ? screen_x0 : case_x0;
		y0 = (where=="screen") ? screen_y0 : case_y0;
		
		
		if (addition_shape == "bump" || addition_shape == "hridge" || addition_shape == "vridge" || addition_shape == "svg") {
		
			addition_width_mm = (unit_of_measure_for_screen=="px" && where=="screen") ? addition_width * pixel_size : addition_width;
			addition_height_mm = (unit_of_measure_for_screen=="px" && where=="screen") ? addition_height * pixel_size : addition_height;
			addition_x_mm = (unit_of_measure_for_screen=="px" && where=="screen") ? addition_x * pixel_size : addition_x;
			addition_corner_radius_mm = (unit_of_measure_for_screen=="px" && where=="screen") ? addition_corner_radius * pixel_size : addition_corner_radius;
			addition_top_slope_mm = (unit_of_measure_for_screen=="px" && where=="screen") ? addition_top_slope * pixel_size : addition_top_slope;
			addition_bottom_slope_mm = (unit_of_measure_for_screen=="px" && where=="screen") ? addition_bottom_slope * pixel_size : addition_bottom_slope;
			

			if (starting_corner_for_screen_measurements == "upper-left" && where=="screen"){
				addition_y_mm = (unit_of_measure_for_screen=="px") ? (screen_height_px - addition_y) * pixel_size : (screen_height - addition_y);
				translate([x0+addition_x_mm,y0+addition_y_mm,rail_height/2-fudge])
				place_addition(addition_ID, addition_width_mm, addition_height_mm, addition_shape, addition_top_slope, addition_top_slope_mm, addition_bottom_slope, addition_bottom_slope_mm, addition_left_slope, addition_right_slope, addition_corner_radius_mm, addition_other);
			}
			else{
				addition_y_mm = (unit_of_measure_for_screen=="px" && where=="screen") ? addition_y * pixel_size : addition_y;
				
				translate([x0+addition_x_mm,y0+addition_y_mm,rail_height/2-fudge])
				place_addition(addition_ID, addition_width_mm, addition_height_mm, addition_shape, addition_top_slope, addition_top_slope_mm, addition_bottom_slope, addition_bottom_slope_mm, addition_left_slope, addition_right_slope, addition_corner_radius_mm, addition_other);
			}
		}
	}
}

module place_addition(ID, addition_width, addition_height, shape, top_slope, top_slope_mm, bottom_slope, bottom_slope_mm, left_slope, right_slope, corner_radius, other){
	if (shape=="bump"){
		if(addition_width>0){
			difference(){
				sphere(d=addition_width,$fn=40);
				translate([0,0,-addition_width])
				cube([addition_width*2, addition_width*2,addition_width*2],center=true);
			}
		}
	}
	else if (shape=="hridge"){
		if(addition_width>1 && bottom_slope_mm>1 && top_slope_mm>1){
			hridge(addition_width, bottom_slope_mm, top_slope_mm);
		}
	}	
	else if (shape=="vridge"){
		if(addition_height>1 && bottom_slope_mm>1 && top_slope_mm>1){
			vridge(addition_height, bottom_slope_mm, top_slope_mm);
		}
	}
	else if (shape=="svg"){
		if(addition_height>0 && addition_width>0 && corner_radius>0){
			rotate([0,0,-top_slope])
			resize([addition_width,addition_height,corner_radius])
			linear_extrude(height=corner_radius)
			offset(delta = .005)
			import(file = other,center=true);
		}
	}	
}

module hridge(length, thickness, hite){
	translate([0,-thickness/2,0])
	difference(){
		translate([0,0,-rail_height])
		rotate([90,0,0])
		rotate([0,90,0])
		linear_extrude(height=length)
		polygon([[0,0],[thickness,0],[thickness,hite-.5+rail_height],[thickness-.5,hite+rail_height],[.5,hite+rail_height],[0,hite-.5+rail_height]]);
		
		translate([0-fudge,thickness,hite-.5+fudge])
		rotate([90,0,0])
		linear_extrude(height=thickness)
		polygon([[0,0],[.5,.5],[0,.5]]);
	
		translate([length+fudge,thickness,hite-.5+fudge])
		rotate([90,0,0])
		linear_extrude(height=thickness)
		polygon([[0,0],[-.5,.5],[0,.5]]);
	}
}

module vridge(length, thickness, hite){
	translate([thickness/2,0,0])
	difference(){
		translate([0,0,-rail_height])
		rotate([0,0,180])
		rotate([90,0,0])
		linear_extrude(height=length)
		polygon([[0,0],[thickness,0],[thickness,hite-.5+rail_height],[thickness-.5,hite+rail_height],[.5,hite+rail_height],[0,hite-.5+rail_height]]);
		
		translate([0,length+fudge,hite-.5+fudge])
		rotate([0,0,-90])
		rotate([90,0,0])
		linear_extrude(height=thickness)
		polygon([[0,0],[.5,.5],[0,.5]]);
	
		translate([0,0-fudge,hite-.5+fudge])
		rotate([0,0,-90])
		rotate([90,0,0])
		linear_extrude(height=thickness)
		polygon([[0,0],[-.5,.5],[0,.5]]);
	}
}

module validate_data(opening);{	
//known values: screen_height_px, screen_width_px, screen_height_mm, screen_width_mm	

	// opening_ID = opening[0];
	// opening_x = opening[1];
	// opening_y = opening[2];
	// opening_width = opening[3];
	// opening_height = opening[4];
	// opening_shape = opening[5];
	// opening_top_slope = opening[6];
	// opening_bottom_slope = opening[7];
	// opening_left_slope = opening[8];
	// opening_right_slope = opening[9];
}

module tight_case(){
	//add keyguard padding for cases that extend to the edge of the screen
	cut_width = screen_width - left_edge_compensation_for_tight_cases - right_edge_compensation_for_tight_cases;	
	cut_height = screen_height - top_edge_compensation_for_tight_cases - bottom_edge_compensation_for_tight_cases;
	
	difference(){
		base_keyguard();
		
		translate([left_edge_compensation_for_tight_cases/2 - right_edge_compensation_for_tight_cases/2 + unequal_left_side_offset, bottom_edge_compensation_for_tight_cases/2 - top_edge_compensation_for_tight_cases/2 + unequal_bottom_side_offset,0])
		cube([cut_width, cut_height, rail_height*2+0.01], center=true);
	}
}

module create_clip(clip_reach,clip_width){
	base_thickness = 4;
	clip_thickness = 3;
	keyguard_thick = (column_count > 0 && row_count > 0) ? rail_height : ffkt;
	case_thick = (have_a_case=="no")? tablet_thickness+keyguard_thick : case_thickness+max(keyguard_thick-case_to_screen_depth,0);
	fudge = 0.05;
	slot_to_case_edge_distance = clip_reach - clip_thickness;
	strap_cut = clip_width-4;

	difference(){
		union(){
			//base leg
			translate([-clip_bottom_length,-base_thickness,0])
			cube([clip_bottom_length+clip_thickness,base_thickness,clip_width]);

			//vertical leg
			translate([0,0,0])
			cube([clip_thickness,case_thick,clip_width]);

			//reach leg
			translate([-clip_reach,case_thick,0])
			cube([clip_reach+clip_thickness,clip_thickness,clip_width]);

			//spur
			translate([-clip_reach,case_thick,0])
			linear_extrude(height = clip_width)
			polygon(points=[[0,0],[1,-3],[3,-3],[2,0]]);
		}

		//chamfers for short edges of reach leg
		translate([clip_thickness-2,case_thick+clip_thickness-2,-fudge])
		linear_extrude(height = clip_width + fudge*2)
		polygon(points=[[0,2.1],[2.1,2.1],[2.1,0]]);
		translate([-clip_reach-fudge,case_thick+clip_thickness-2,-fudge])
		linear_extrude(height = clip_width + fudge*2)
		polygon(points=[[0,0],[0,2.1],[2.1,2.1]]);

		//chamfers for vertical leg
		translate([1,-base_thickness-fudge,2])
		rotate([-90,0,0])
		linear_extrude(height = base_thickness+case_thick+clip_thickness + fudge*2)
		polygon(points=[[0,2.1],[2.1,2.1],[2.1,0]]);
		translate([1,-base_thickness-fudge,clip_width+fudge])
		rotate([-90,0,0])
		linear_extrude(height = base_thickness+case_thick+clip_thickness + fudge*2)
		polygon(points=[[0,0],[2.1,0],[2.1,2.1]]);

		//chamfers for long edges of reach leg
		translate([-clip_reach,case_thick+clip_thickness-2,2-fudge])
		rotate([0,90,0])
		linear_extrude(height = clip_reach+clip_thickness + fudge*2)
		polygon(points=[[0,2.1],[2.1,2.1],[2.1,0]]);
		translate([clip_thickness,case_thick+clip_thickness+fudge,clip_width-2])
		rotate([0,-90,0])
		linear_extrude(height = clip_reach+clip_thickness + fudge*2)
		polygon(points=[[0,0],[2.1,0],[2.1,-2.1]]);
		
		//recess for bumper
		if (clip_bottom_length>=30){
			// translate([-15+clip_thickness,-base_thickness+1,clip_width/2])
			translate([-8+clip_thickness,-base_thickness+1,clip_width/2])
			rotate([90,0,0])
			cylinder(d=11,h=1.05);
		}

		//slots for strap
		translate([-clip_bottom_length+7.5-fudge,0,clip_width/2])
		union(){
			translate([0,-5,0])
			cube([15,2,strap_cut],center=true);
			
			translate([0,0,0])
			cube([15,2,strap_cut],center=true);
			
			translate([-2.5,-3,0])
			cube([5,6,strap_cut],center=true);
			
			translate([5,-3,0])
			cube([5,6,strap_cut],center=true);
		}
	}
}

module create_mini_clip1(clip_reach,clip_width){
	base_thickness = 4;
	clip_thickness = 5;
	keyguard_thick = (column_count > 0 && row_count > 0) ? rail_height : ffkt;
	case_thick = (have_a_case=="no")? tablet_thickness+keyguard_thick : case_thickness+max(keyguard_thick-case_to_screen_depth,0);
	// fudge = 0.05;
	slot_to_case_edge_distance = clip_reach - clip_thickness;
	strap_cut = clip_width-4;

	difference(){
		union(){
			//vertical leg
			translate([0,0,0])
			cube([clip_thickness,case_thick,clip_width]);

			//reach leg
			translate([-clip_reach,case_thick,0])
			cube([clip_reach+clip_thickness,clip_thickness,clip_width]);

			//spur
			translate([-clip_reach,case_thick,0])
			linear_extrude(height = clip_width)
			polygon(points=[[0,0],[1,-3],[3,-3],[2,0]]);
		}

		//chamfers for short edges of reach leg
		translate([clip_thickness-2,case_thick+clip_thickness-2,-fudge])
		linear_extrude(height = clip_width + fudge*2)
		polygon(points=[[0,2.1],[2.1,2.1],[2.1,0]]);
		translate([-clip_reach-fudge,case_thick+clip_thickness-2,-fudge])
		linear_extrude(height = clip_width + fudge*2)
		polygon(points=[[0,0],[0,2.1],[2.1,2.1]]);

		//chamfers for vertical leg
		translate([3,-base_thickness-fudge,2])
		rotate([-90,0,0])
		linear_extrude(height = base_thickness+case_thick+clip_thickness + fudge*2)
		polygon(points=[[0,2.1],[2.1,2.1],[2.1,0]]);
		translate([3,-base_thickness-fudge,clip_width+fudge])
		rotate([-90,0,0])
		linear_extrude(height = base_thickness+case_thick+clip_thickness + fudge*2)
		polygon(points=[[0,0],[2.1,0],[2.1,2.1]]);

		//chamfers for long edges of reach leg
		translate([-clip_reach,case_thick+clip_thickness-2,2-fudge])
		rotate([0,90,0])
		linear_extrude(height = clip_reach+clip_thickness + fudge*2)
		polygon(points=[[0,2.1],[2.1,2.1],[2.1,0]]);
		translate([clip_thickness,case_thick+clip_thickness+fudge,clip_width-2])
		rotate([0,-90,0])
		linear_extrude(height = clip_reach+clip_thickness + fudge*2)
		polygon(points=[[0,0],[2.1,0],[2.1,-2.1]]);
		
		//slots for strap
		translate([-1+fudge,7.5-fudge,clip_width/2])
		rotate([0,0,90])
		union(){
			translate([0,-1,0])
			cube([15,2,strap_cut],center=true);
			
			translate([-2.5,-3,0])
			cube([5,6,strap_cut],center=true);
			
			translate([5,-3,0])
			cube([5,6,strap_cut],center=true);
		}
	}
}

module create_mini_clip2(clip_reach,clip_width){
	// base_thickness = 5;
	base_thickness = 4;
	clip_thickness = 5;
	keyguard_thick = (column_count > 0 && row_count > 0) ? rail_height : ffkt;
	case_thick = (have_a_case=="no")? tablet_thickness+keyguard_thick : case_thickness+max(keyguard_thick-case_to_screen_depth,0);
	// fudge = 0.05;
	slot_to_case_edge_distance = clip_reach - clip_thickness;
	strap_cut = clip_width-4;

	difference(){
		union(){
			// //vertical leg
			// translate([0,0,0])
			// cube([clip_thickness,case_thick,clip_width]);

			//reach leg
			translate([-clip_reach,case_thick,0])
			cube([clip_reach+clip_thickness,clip_thickness,clip_width]);

			//spur
			translate([-clip_reach,case_thick,0])
			linear_extrude(height = clip_width)
			polygon(points=[[0,0],[1,-3],[3,-3],[2,0]]);
		}

		//chamfers for short edges of reach leg
		translate([clip_thickness-2,case_thick+clip_thickness-2,-fudge])
		linear_extrude(height = clip_width + fudge*2)
		polygon(points=[[0,2.1],[2.1,2.1],[2.1,0]]);
		translate([-clip_reach-fudge,case_thick+clip_thickness-2,-fudge])
		linear_extrude(height = clip_width + fudge*2)
		polygon(points=[[0,0],[0,2.1],[2.1,2.1]]);

		//chamfers for vertical leg
		translate([3,-base_thickness-fudge,2])
		rotate([-90,0,0])
		linear_extrude(height = base_thickness+case_thick+clip_thickness + fudge*2)
		polygon(points=[[0,2.1],[2.1,2.1],[2.1,0]]);
		translate([3,-base_thickness-fudge,clip_width+fudge])
		rotate([-90,0,0])
		linear_extrude(height = base_thickness+case_thick+clip_thickness + fudge*2)
		polygon(points=[[0,0],[2.1,0],[2.1,2.1]]);

		//chamfers for long edges of reach leg
		translate([-clip_reach,case_thick+clip_thickness-2,2-fudge])
		rotate([0,90,0])
		linear_extrude(height = clip_reach+clip_thickness + fudge*2)
		polygon(points=[[0,2.1],[2.1,2.1],[2.1,0]]);
		translate([clip_thickness,case_thick+clip_thickness+fudge,clip_width-2])
		rotate([0,-90,0])
		linear_extrude(height = clip_reach+clip_thickness + fudge*2)
		polygon(points=[[0,0],[2.1,0],[2.1,-2.1]]);
		
		//slots for strap
		translate([-2.4,17-fudge,clip_width/2])
		rotate([180,180,0])
		union(){
			translate([0,-1,0])
			cube([15,2,strap_cut],center=true);
			
			translate([-2.5,-3,0])
			cube([5,6,strap_cut],center=true);
			
			translate([5,-3,0])
			cube([5,6,strap_cut],center=true);
		}
	}
}

module base_keyguard(){
	if (system_with_no_case){
		union(){
			text_string1 = str("The ",type_of_tablet," tablet requires a case.");
			translate([-140,0,0])
			text(text_string1);
			text_string2 = "Set 'have a case' to 'yes' in the Tablet Case section.";
			translate([-140,-15,0])
			text(text_string2);
		}
	}
	else{
		if (have_a_case=="no"){
			difference(){
				translate([0,0,-rail_height/2])
				shape(tablet_width,tablet_height,tablet_corner_radius);
				
				if (type_of_keyguard=="3D-Printed"){  //add chamfer
					translate([0,0,-rail_height/2+fudge])
					for (i = [1:1:chamfer_slices]) { 
						chamfer_slice(i,tablet_width,tablet_height,tablet_corner_radius);
					}
				}
			}
		}
		else{
			difference(){
				translate([case_x0+width_of_opening_in_case/2,case_y0+height_of_opening_in_case/2,-rail_height/2])
				shape(width_of_opening_in_case,height_of_opening_in_case,case_opening_corner_radius_incl_acrylic);
				
				if (type_of_keyguard=="3D-Printed"){  //add chamfer
					translate([0,0,-rail_height/2+fudge])
					for (i = [1:1:chamfer_slices]) { 
						chamfer_slice(i,width_of_opening_in_case,height_of_opening_in_case,case_opening_corner_radius_incl_acrylic);
					}
				}
			}
		}
	}
}

module chamfer_slice(layer,shape_width,shape_height,corner_radius){
	slice_width = chamfer_slice_size*(chamfer_slices-layer+1);
	slice_height = rail_height-chamfer_slice_size*layer;
	
	translate([0,0,slice_height])
	linear_extrude(height=chamfer_slice_size+fudge)
	difference(){
		offset(delta=fudge)
		shape_2d(shape_width,shape_height,corner_radius);

		offset(delta=-slice_width)
		shape_2d(shape_width,shape_height,corner_radius);
	}
}

module shape(shape_width,shape_height,corner_radius){
	linear_extrude(height=rail_height)
	shape_2d(shape_width,shape_height,corner_radius);
}

module shape_2d(shape_x,shape_y,corner_radius){
		union(){
			//core keyguard
			offset(r=corner_radius)
			square([shape_x-corner_radius*2,shape_y-corner_radius*2],center=true);
			
			if(Lite=="no"){
				if (have_a_case=="yes" && trim_to_screen=="no"){
					if (len(case_additions)>0){
						add_case_additions(case_additions);
					}
				}
			}
		}
}

module add_case_additions(case_additions){
	for(i = [0 : len(case_additions)-1]){
		addition = case_additions[i]; //0:ID, 1:x, 2:y, 3:width,  4:height, 5:shape, 6:thickness, 7:trim_above, 8:trim_below, 9:trim_to_right, 10:trim_to_left, 11:corner_radius, 12:other

		// validate_data(opening);
		
		addition_ID = addition[0];
		addition_x = addition[1];
		addition_y = addition[2];
		addition_width = addition[3];
		addition_height = addition[4];
		//check for "rr" with "corner radius = 0"
		s = addition[5];
		addition_shape = (s=="rr1" && addition[11]==0) ? "r1" : 
						 (s=="rr2" && addition[11]==0) ? "r2" : 
						 (s=="rr3" && addition[11]==0) ? "r3" :
						 (s=="rr4" && addition[11]==0) ? "r3" :
						 (s=="rr" && addition[11]==0) ? "r" : s;
						 
		addition_thickness = addition[6];
		addition_trim_above = addition[7];
		addition_trim_below = addition[8];
		addition_trim_to_right = addition[9];
		addition_trim_to_left = addition[10];
		addition_corner_radius = addition[11];
		addition_other = addition[12];
			
		difference(){
			translate([addition_x ,addition_y])
			build_addition(addition_width, addition_height, addition_shape, addition_thickness, addition_corner_radius, addition_other);

			if (addition_trim_below > -999){
				translate([0,-height_of_opening_in_case+case_y0+addition_trim_below])
				square([width_of_opening_in_case*2,height_of_opening_in_case*2],center=true);
			}
			if (addition_trim_above > -999){
				translate([0,height_of_opening_in_case+case_y0+addition_trim_above])
				square([width_of_opening_in_case*2,height_of_opening_in_case*2],center=true);
			}
			if (addition_trim_to_right > -999){
				translate([-case_x0+addition_trim_to_right,0])
				square([width_of_opening_in_case*2,height_of_opening_in_case*2],center=true);
			}
			if (addition_trim_to_left > -999){
				translate([case_x0-width_of_opening_in_case+addition_trim_to_left,0])
				square([width_of_opening_in_case*2,height_of_opening_in_case*2],center=true);
			}
		}
	}
}

module build_addition(addition_width, addition_height, addition_shape, addition_thickness, addition_corner_radius, addition_other){
		
		if (addition_shape=="r"){
			if (addition_width > 0 && addition_height > 0){
				translate([case_x0,case_y0])
				square([addition_width,addition_height],center=true);
			}
		}
		else if (addition_shape=="r1"){
			if (addition_width > 0 && addition_height > 0){
				translate([case_x0,case_y0+addition_height/2-fudge])
				square([addition_width,addition_height],center=true);
			}
		}
		else if (addition_shape=="r2"){
			if (addition_width > 0 && addition_height > 0){
				translate([case_x0+addition_width/2-fudge,case_y0])
				square([addition_width,addition_height],center=true);
			}
		}
		else if (addition_shape=="r3"){
			if (addition_width > 0 && addition_height > 0){
				translate([case_x0,case_y0-addition_height/2+fudge])
				square([addition_width,addition_height],center=true);
			}
		}
		else if (addition_shape=="r4"){
			if (addition_width > 0 && addition_height > 0){
				translate([case_x0-addition_width/2+fudge,case_y0])
				square([addition_width,addition_height],center=true);
			}
		}
		else if (addition_shape=="c"){
			if (addition_width > 0){
				translate([case_x0,case_y0])
				circle(d=addition_width);
			}
		}
		else if (addition_shape=="t1"){
			translate([case_x0-fudge,case_y0-fudge])
			if (addition_width > 0 && addition_height > 0){
				polygon([[0,0],[addition_width,0],[0,addition_height]]);
			}
		}
		else if (addition_shape=="t2"){
			translate([case_x0-fudge,case_y0+fudge])
			if (addition_width > 0 && addition_height > 0){
				polygon([[0,0],[addition_width,0],[0,-addition_height]]);
			}
		}
		else if (addition_shape=="t3"){
			translate([case_x0+fudge,case_y0-fudge])
			if (addition_width > 0 && addition_height > 0){
				polygon([[0,0],[-addition_width,0],[0,addition_height]]);
			}
		}
		else if (addition_shape=="t4"){
			translate([case_x0+fudge,case_y0+fudge])
			if (addition_width > 0 && addition_height > 0){
				polygon([[0,0],[-addition_width,0],[0,-addition_height]]);
			}
		}
		else if (addition_shape=="f1"){
			translate([case_x0-fudge,case_y0-fudge])
			if (addition_width > 0){
				difference(){
					translate([0,0])
					square([addition_width,addition_width]);
					translate([addition_width,addition_width])
					circle(r=addition_width);
				}
			}
		}
		else if (addition_shape=="f2"){
			translate([case_x0-fudge,case_y0+fudge])
			if (addition_width > 0){
				difference(){
					translate([0,-addition_width])
					square([addition_width,addition_width]);
					translate([addition_width,-addition_width])
					circle(r=addition_width);
				}
			}
		}
		else if (addition_shape=="f3"){
			translate([case_x0+fudge,case_y0+fudge])
			if (addition_width > 0){
				difference(){
					translate([-addition_width,-addition_width])
					square([addition_width,addition_width]);
					translate([-addition_width,-addition_width])
					circle(r=addition_width);
				}
			}
		}
		else if (addition_shape=="f4"){
			translate([case_x0+fudge,case_y0-fudge])
			if (addition_width > 0){
				difference(){
					translate([-addition_width,0])
					square([addition_width,addition_width]);
					translate([-addition_width,addition_width])
					circle(r=addition_width);
				}
			}
		}
		else if (addition_shape=="cm1"){
			if (addition_width > 0 && addition_height > 0){
				$fn=360;

				d1 = addition_height;
				d2 = addition_width/2 - case_opening_corner_radius_incl_acrylic*2;
				Cx = (d2*d2)/(2*d1) - d1/2;
				radius = Cx + d1;

				translate([case_x0,case_y0-fudge])
				rotate([0,0,90])
				difference(){
					translate([-Cx,0])
					circle(r=radius);

					translate([-radius*2-10,-radius-5-fudge])
					square([radius*2+10,radius*2+10]);
					
				}
			}
		}
		else if (addition_shape=="cm2"){
			if (addition_width > 0 && addition_height > 0){
				$fn=360;

				d1 = addition_width;
				d2 = addition_height/2 - case_opening_corner_radius_incl_acrylic*2;
				Cx = (d2*d2)/(2*d1) - d1/2;
				radius = Cx + d1;

				translate([case_x0-fudge,case_y0])
				difference(){
					translate([-Cx,0])
					circle(r=radius);

					translate([-radius*2-10-fudge,-radius-5])
					square([radius*2+10,radius*2+10]);
				}
			}
		}
		else if (addition_shape=="cm3"){
			if (addition_width > 0 && addition_height > 0){
				$fn=360;

				d1 = addition_height;
				d2 = addition_width/2 - case_opening_corner_radius_incl_acrylic*2;
				Cx = (d2*d2)/(2*d1) - d1/2;
				radius = Cx + d1;

				translate([case_x0,case_y0+fudge])
				rotate([0,0,-90])
				difference(){
					translate([-Cx,0])
					circle(r=radius);

					translate([-radius*2-10,-radius-5+fudge])
					square([radius*2+10,radius*2+10]);
					
				}
			}
		}
		else if (addition_shape=="cm4"){
			if (addition_width > 0 && addition_height > 0){
				$fn=360;

				d1 = addition_width;
				d2 = addition_height/2 - case_opening_corner_radius_incl_acrylic*2;
				Cy = 0;
				Cx = (d2*d2)/(2*d1) - d1/2;
				radius = Cx + d1;

				translate([case_x0+fudge,case_y0])
				difference(){
					translate([Cx,0])
					circle(r=radius);

					translate([0+fudge,-radius-5])
					square([radius*2+10,radius*2+10]);
				}
			}
		}
		else if (addition_shape=="rr"){
			translate([case_x0,case_y0])
			if (addition_width > 0 && addition_height > 0 && addition_corner_radius > 0){
				square([addition_width-addition_corner_radius*2,addition_height],center=true);
				square([addition_width,addition_height-addition_corner_radius*2],center=true);
				translate([-addition_width/2+addition_corner_radius,addition_height/2-addition_corner_radius])
				circle(r=addition_corner_radius);
				translate([-addition_width/2+addition_corner_radius,-addition_height/2+addition_corner_radius])
				circle(r=addition_corner_radius);
				translate([addition_width/2-addition_corner_radius,addition_height/2-addition_corner_radius])
				circle(r=addition_corner_radius);
				translate([addition_width/2-addition_corner_radius,-addition_height/2+addition_corner_radius])
				circle(r=addition_corner_radius);
			}
		}
		else if (addition_shape=="rr1"){
			translate([case_x0,case_y0-fudge])
			if (addition_width > 0 && addition_height > 0 && addition_corner_radius > 0){
				translate([-addition_width/2+addition_corner_radius,0])
				square([addition_width-addition_corner_radius*2,addition_height]);
				translate([-addition_width/2,0])
				square([addition_width,addition_height-addition_corner_radius]);
				translate([-addition_width/2+addition_corner_radius,addition_height-addition_corner_radius])
				circle(r=addition_corner_radius);
				translate([addition_width/2-addition_corner_radius,addition_height-addition_corner_radius])
				circle(r=addition_corner_radius);
			}
		}
		else if (addition_shape=="rr2"){
			translate([case_x0-fudge,case_y0])
			if (addition_width > 0 && addition_height > 0 && addition_corner_radius > 0){
				translate([0,-addition_height/2])
				square([addition_width-addition_corner_radius,addition_height]);
				translate([addition_width-addition_corner_radius,-(addition_height-addition_corner_radius*2)/2])
				square([addition_corner_radius,addition_height-addition_corner_radius*2]);
				translate([addition_width-addition_corner_radius,addition_height/2-addition_corner_radius])
				circle(r=addition_corner_radius);
				translate([addition_width-addition_corner_radius,-addition_height/2+addition_corner_radius])
				circle(r=addition_corner_radius);
			}
		}
		else if (addition_shape=="rr3"){
			translate([case_x0,case_y0+fudge])
			if (addition_width > 0 && addition_height > 0 && addition_corner_radius > 0){
				translate([-addition_width/2+addition_corner_radius,-addition_height])
				square([addition_width-addition_corner_radius*2,addition_height]);
				translate([-addition_width/2,-addition_height+addition_corner_radius])
				square([addition_width,addition_height-addition_corner_radius]);
				translate([-addition_width/2+addition_corner_radius,-addition_height+addition_corner_radius])
				circle(r=addition_corner_radius);
				translate([addition_width/2-addition_corner_radius,-addition_height+addition_corner_radius])
				circle(r=addition_corner_radius);
			}
		}		
		else if (addition_shape=="rr4"){
			translate([case_x0+fudge,case_y0])
			if (addition_width > 0 && addition_height > 0 && addition_corner_radius > 0){
				translate([-(addition_width-addition_corner_radius),-addition_height/2])
				square([addition_width-addition_corner_radius,addition_height]);
				translate([-addition_width,-(addition_height-addition_corner_radius*2)/2])
				square([addition_corner_radius,addition_height-addition_corner_radius*2]);
				translate([-addition_width+addition_corner_radius,addition_height/2-addition_corner_radius])
				circle(r=addition_corner_radius);
				translate([-addition_width+addition_corner_radius,-addition_height/2+addition_corner_radius])
				circle(r=addition_corner_radius);
			}
		}
}

module add_manual_mounts(case_additions){
	for(i = [0 : len(case_additions)-1]){
		addition = case_additions[i]; //0:ID, 1:x, 2:y, 3:width,  4:height, 5:shape, 6:thickness, 7:trim_above, 8:trim_below, 9:trim_to_right, 10:trim_to_left, 11:corner_radius, 12:other

		// validate_data(opening);
		
		addition_ID = addition[0];
		addition_x = addition[1];
		addition_y = addition[2];
		addition_width = addition[3];
		addition_height = addition[4];
		//check for "rr" with "corner radius = 0"
		s = addition[5];
		addition_shape = ((s=="rr1" || s=="rr2" || s=="rr3" || s=="rr4")  && addition[11]==0) ? "r" : s;
		addition_thickness = addition[6];
		addition_trim_above = addition[7];
		addition_trim_below = addition[8];
		addition_trim_to_right = addition[9];
		addition_trim_to_left = addition[10];
		addition_corner_radius = addition[11];
		addition_other = addition[12];
			
		translate([addition_x,addition_y])
		if(addition_shape=="ped1"){
			translate([case_x0,case_y0-3.5,rail_height/2])
			rotate([0,0,-90])
			linear_extrude(height=pedestal_height,scale=.8)
			square([7,vertical_pedestal_width],center=true);
		}
		else if(addition_shape=="ped3"){
			translate([case_x0,case_y0+3.5,rail_height/2])
			rotate([0,0,-90])
			linear_extrude(height=pedestal_height,scale=.8)
			square([7,vertical_pedestal_width],center=true);
		}
		else if(addition_shape=="ped2"){
			translate([case_x0-3.5,case_y0,rail_height/2])
			rotate([0,0,0])
			linear_extrude(height=pedestal_height,scale=.8)
			square([7,horizontal_pedestal_width],center=true);
		}
		else if(addition_shape=="ped4"){
			translate([case_x0+3.5,case_y0,rail_height/2])
			rotate([0,0,0])
			linear_extrude(height=pedestal_height,scale=.8)
			square([7,horizontal_pedestal_width],center=true);
		}
		else if(addition_shape=="stab1"){
			translate([0,-fudge,-rail_height/2])
			linear_extrude(height=slide_in_tab_thickness)
			build_addition(slide_in_tab_width, slide_in_tab_length_incl_acrylic, "rr1", addition_thickness, slide_in_tab_length_incl_acrylic/2, addition_other);
		}
		else if(addition_shape=="stab3"){
			translate([0,fudge,-rail_height/2])
			linear_extrude(height=slide_in_tab_thickness)
			build_addition(slide_in_tab_width, slide_in_tab_length_incl_acrylic, "rr3", addition_thickness, slide_in_tab_length_incl_acrylic/2, addition_other);
		}
		else if(addition_shape=="stab2"){
			translate([-fudge,0,-rail_height/2])
			linear_extrude(height=slide_in_tab_thickness)
			build_addition(slide_in_tab_length_incl_acrylic, slide_in_tab_width, "rr2", addition_thickness, slide_in_tab_length_incl_acrylic/2, addition_other);
		}
		else if(addition_shape=="stab4"){
			translate([fudge,0,-rail_height/2])
			linear_extrude(height=slide_in_tab_thickness)
			build_addition(slide_in_tab_length_incl_acrylic, slide_in_tab_width, "rr4", addition_thickness, slide_in_tab_length_incl_acrylic/2, addition_other);
		}
	}
}

module add_manual_mount_slots(case_additions){
	for(i = [0 : len(case_additions)-1]){
		addition = case_additions[i]; //0:ID, 1:x, 2:y, 3:width,  4:height, 5:shape, 6:thickness, 7:trim_above, 8:trim_below, 9:trim_to_right, 10:trim_to_left, 11:corner_radius, 12:other

		// validate_data(opening);
		
		addition_ID = addition[0];
		addition_x = addition[1];
		addition_y = addition[2];
		addition_width = addition[3];
		addition_height = addition[4];
		//check for "rr" with "corner radius = 0"
		s = addition[5];
		addition_shape = ((s=="rr1" || s=="rr2" || s=="rr3" || s=="rr4")  && addition[11]==0) ? "r" : s;
		addition_thickness = addition[6];
		addition_trim_above = addition[7];
		addition_trim_below = addition[8];
		addition_trim_to_right = addition[9];
		addition_trim_to_left = addition[10];
		addition_corner_radius = addition[11];
		addition_other = addition[12];
			
		translate([case_x0+addition_x ,case_y0+addition_y])
		if(addition_shape=="ped1"){
			translate([vertical_slot_width/2,-1.25-chamfer_size,vertical_offset])
			rotate([90,0,-90])
			linear_extrude(height = vertical_slot_width)
			polygon(points=[[0,0],[3,0],[4,3],[1,3]]);
		}
		else if(addition_shape=="ped3"){
			translate([-vertical_slot_width/2,1.25+chamfer_size,vertical_offset])
			rotate([90,0,90])
			linear_extrude(height = vertical_slot_width)
			polygon(points=[[0,0],[3,0],[4,3],[1,3]]);
		}
		else if(addition_shape=="ped2"){
			translate([-chamfer_size-1.25,-horizontal_slot_width/2,vertical_offset])
			rotate([90,0,180])
			linear_extrude(height = horizontal_slot_width)
			polygon(points=[[0,0],[3,0],[4,3],[1,3]]);
		}
		else if(addition_shape=="ped4"){
			translate([chamfer_size+1.25,horizontal_slot_width/2,vertical_offset])
			rotate([90,0,0])
			linear_extrude(height = horizontal_slot_width)
			polygon(points=[[0,0],[3,0],[4,3],[1,3]]);
		}
	}
}
 
module trim_to_the_screen(){
	major_dim = (have_a_case=="no") ? max(tablet_width,tablet_height) : max(width_of_opening_in_case,height_of_opening_in_case);
	minor_dim = (have_a_case=="no") ? min(tablet_width,tablet_height): min(width_of_opening_in_case,height_of_opening_in_case);

	difference(){
		final_rotation = (orientation=="landscape") ? [0,0,0] : [0,0,-90];
		rotate(final_rotation)
		cube([major_dim+fudge*2,minor_dim+fudge*2,rail_height+fudge*2],true);
		cube([screen_width-fudge,screen_height-fudge,rail_height+fudge*4],true);
	}
}

module trim_to_rectangle(){
	major_dim = (have_a_case=="no") ? max(tablet_width,tablet_height) : max(width_of_opening_in_case,height_of_opening_in_case);
	minor_dim = (have_a_case=="no") ? min(tablet_width,tablet_height): min(width_of_opening_in_case,height_of_opening_in_case);
	
	x1 = trim_to_rectangle_lower_left[0];
	y1 = trim_to_rectangle_lower_left[1];
	x2 = trim_to_rectangle_upper_right[0];
	y2 = trim_to_rectangle_upper_right[1];
	
	if (x1!=0 && y1!=0 && x2!=0 && y2!=0){
		w=x2-x1;
		h=y2-y1;
		
		translate([case_x0+w/2+x1,case_y0+h/2+y1,0])
		difference(){
			final_rotation = (orientation=="landscape") ? [0,0,0] : [0,0,-90];
			rotate(final_rotation)
			cube([major_dim*3,minor_dim*3,rail_height+fudge*2],true);
			cube([w-fudge,h-fudge,rail_height+fudge*4],true);
		}
	}
}

module cut_screen(){
	translate([screen_x0,screen_y0,-rail_height/2-fudge])
	cube([screen_width+2*fudge,screen_height+2*fudge,rail_height+2*fudge]);
}

module show_screenshot(){
	color("DarkMagenta")
	translate([unequal_left_side_offset,unequal_bottom_side_offset,-rail_height/2-0.5])
	resize([screen_width,screen_height,0.5])
	linear_extrude(height=1)
	offset(delta = .005)
	import(file = "screenshot.svg",center=true);
}


module issues(){
	if(have_a_case=="yes"){
		perimeter1 = (height_of_opening_in_case - screen_height)/2;
		perimeter1_offset = (expose_status_bar=="yes" && status_bar_height>0) ? 0 :
							(expose_upper_message_bar=="yes" && upper_message_bar_height>0) ? status_bar_height :
							(expose_upper_command_bar=="yes" && upper_command_bar_height>0) ? status_bar_height + upper_message_bar_height :
							status_bar_height + upper_message_bar_height+upper_command_bar_height+hrw/2+top_padding-unequal_bottom_side_offset;
		top_perimeter = max(perimeter1+perimeter1_offset,top_edge_compensation_for_tight_cases);
		
		perimeter3 = (height_of_opening_in_case - screen_height)/2;
		perimeter3_offset = (expose_lower_command_bar=="yes" && lower_command_bar_height>0) ? 0 :
							(expose_lower_message_bar=="yes" && lower_message_bar_height>0) ? lower_command_bar_height :
							lower_command_bar_height+lower_message_bar_height+hrw/2+bottom_padding+unequal_bottom_side_offset;
		bottom_perimeter = max(perimeter3+perimeter3_offset,bottom_edge_compensation_for_tight_cases);
		
		perimeter2 = (width_of_opening_in_case - screen_width)/2;
		perimeter2_offset = (expose_status_bar=="yes" && status_bar_height>0) ? 0 :
							(expose_upper_message_bar=="yes" && upper_message_bar_height>0) ? 0 :
							(expose_upper_command_bar=="yes" && upper_command_bar_height>0) ? 0 :
							(expose_lower_command_bar=="yes" && lower_command_bar_height>0) ? 0 :
							(expose_lower_message_bar=="yes" && lower_message_bar_height>0) ? 0 :
							vrw/2+right_padding-unequal_left_side_offset;
		right_perimeter = max(perimeter2+perimeter2_offset,right_edge_compensation_for_tight_cases);
		
		perimeter4 = (width_of_opening_in_case - screen_width)/2;
		perimeter4_offset = (expose_status_bar=="yes" && status_bar_height>0) ? 0 :
							(expose_upper_message_bar=="yes" && upper_message_bar_height>0) ? 0 :
							(expose_upper_command_bar=="yes" && upper_command_bar_height>0) ? 0 :
							(expose_lower_command_bar=="yes" && lower_command_bar_height>0) ? 0 :
							(expose_lower_message_bar=="yes" && lower_message_bar_height>0) ? 0 :
							vrw/2+left_padding+unequal_left_side_offset;
		left_perimeter = max(perimeter4+perimeter4_offset,left_edge_compensation_for_tight_cases);
		

		echo();
		echo();
		if(top_perimeter<minimum__acrylic_rail_width) echo(str("!!!!!!! ISSUE !!!!!!! -- The top perimeter rail is: ", top_perimeter, " mm wide."));
		if(bottom_perimeter<minimum__acrylic_rail_width) echo(str("!!!!!!! ISSUE !!!!!!! -- The bottom perimeter rail is: ", bottom_perimeter, " mm wide."));
		if(right_perimeter<minimum__acrylic_rail_width) echo(str("!!!!!!! ISSUE !!!!!!! -- The right side perimeter rail is: ", right_perimeter, " mm wide."));
		if(left_perimeter<minimum__acrylic_rail_width) echo(str("!!!!!!! ISSUE !!!!!!! -- The left side perimeter rail is: ", left_perimeter, " mm wide."));
		echo();
		echo();
	}
}

module key_settings(){
	echo(str("******* SETTING ******** -- type of tablet: ", type_of_tablet));
	echo(str("******* SETTING ******** -- use Laser Cutting best practices: ", use_Laser_Cutting_best_practices));
	echo(str("******* SETTING ******** -- orientation: ", orientation));
	echo(str("******* SETTING ******** -- have a case? ", have_a_case));
	if(have_a_case=="yes"){
		echo(str("******* SETTING ******** -- height of opening in case: ", height_of_opening_in_case, " mm."));
		echo(str("******* SETTING ******** -- width of opening in case: ", width_of_opening_in_case, " mm."));
	}
	echo(str("******* SETTING ******** -- number of columns: ", number_of_columns));
	echo(str("******* SETTING ******** -- number of rows: ", number_of_rows));
	echo(str("******* SETTING ******** -- vertical rail width: ", vrw, " mm."));
	echo(str("******* SETTING ******** -- horizontal rail width: ", hrw, " mm."));
	echo(str("******* SETTING ******** -- mounting method: ", m_m));
	if(m_m=="Slide-in Tabs - for cases"){
		echo(str("******* SETTING ******** -- slide-in tab length: ", slide_in_tab_length_incl_acrylic, " mm."));
		echo(str("******* SETTING ******** -- slide-in tab width: ", slide_in_tab_width, " mm."));
	}
	echo();
	echo();
	if (Lite=="no"){
		echo(str("******* SETTING ******** -- number of custom screen openings: ",len(screen_openings)));
		echo(str("******* SETTING ******** -- number of custom case opeings: ",len(case_openings)));
		echo(str("******* SETTING ******** -- number of custom case additions: ",len(case_additions)));
		echo();
		echo();
	}
}

