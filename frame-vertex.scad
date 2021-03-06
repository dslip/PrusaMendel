// PRUSA Mendel  
// Frame vertex
// GNU GPL v2
// Greg Frost
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel

// Based on http://www.thingiverse.com/thing:2003 aka Viks footed 
// frame vertex, which is based on http://www.thingiverse.com/thing:1780 
// aka Tonokps parametric frame vertex
// Thank you guys for your great work

include <configuration.scad>
use <teardrop.scad>

vertex(with_foot=true);

%import_stl("frame-vertex.stl");

vfvertex_height=m8_diameter+4.5;

/**
 * @name Frame vertex
 * @category Printed
 * @link frame-vertex
 * @using 8 m8nut
 * @using 8 m8washer
 */
/**
 * @name Frame vertex with foot
 * @category Printed
 * @link frame-vertex-foot
 * @using 8 m8nut
 * @using 8 m8washer
 */

hole_separation=58.5;
vertex_end_major_d=30.15;
vertex_end_minor_d=18.5;
vertex_horizontal_hole_offset=11.75;
hole_flat_radius=8.5; // flat surface around holes.
foot_depth=26.25;
end_round_translation=vertex_horizontal_hole_offset-hole_flat_radius;

module vertex(with_foot=true)
{
	peg_r=12;
	peg1=[hole_separation+vertex_end_major_d/2-peg_r,
		vertex_horizontal_hole_offset+hole_flat_radius];
	peg2=rotate_vec([hole_separation+vertex_end_major_d/2-peg_r,
		-vertex_horizontal_hole_offset-hole_flat_radius],60);

	inner_peg_r=12;
	peg3=[hole_separation-vertex_end_major_d/2+inner_peg_r,
		vertex_horizontal_hole_offset+hole_flat_radius];
	peg4=rotate_vec([hole_separation-vertex_end_major_d/2+inner_peg_r,
		-vertex_horizontal_hole_offset-hole_flat_radius],60);

	a1_r=11;
	a2_r=11;
	a3_r=3;
	a4_r=3;

	a1=[hole_separation-vertex_end_major_d/2+a1_r,
		vertex_horizontal_hole_offset-hole_flat_radius];
	a2=[hole_separation+vertex_end_major_d/2-a2_r,
		vertex_horizontal_hole_offset-hole_flat_radius];
	a3=[hole_separation-vertex_end_major_d/2+a1_r,-foot_depth+a3_r];
	a4=[hole_separation+vertex_end_major_d/2-a2_r,-foot_depth+a4_r];

//	translate([-hole_separation-vertex_end_major_d/2,-vertex_horizontal_hole_offset,-vfvertex_height/2])
	translate([-18.5,9,0])
	difference ()
	{
		union ()
		{
			for (hole=[(with_foot?1:0):1])
			rotate(hole*60)
			translate([hole_separation,end_round_translation-hole*2*end_round_translation,0])
			scale([1,(vertex_end_minor_d+2*end_round_translation)/vertex_end_major_d,1])
			cylinder(r=vertex_end_major_d/2,h=vfvertex_height); 

			for (block=[0:1])
			rotate(block*60)
			translate([hole_separation,
				vertex_horizontal_hole_offset-block*2*vertex_horizontal_hole_offset,
				vfvertex_height/2])
			cube([vertex_end_major_d,
				2*hole_flat_radius,vfvertex_height],center=true);

			linear_extrude(height=vfvertex_height)
			{
				// The outer curve.
				barbell(peg1,peg2,peg_r,peg_r,200,30);
				// The inner curve.
				barbell(peg3,peg4,inner_peg_r,inner_peg_r,20,200);

				if (with_foot)
				{
					// Curves for the feet
					barbell(a1,a3,a1_r,a3_r,200,20);
					barbell(a2,a4,a2_r,a4_r,20,200);

					// The flat bit on the bottom of the foot.
					polygon(points=[a3+[0,-a3_r],a4+[0,-a4_r],(a3+a4)/2+[0,5]],
						paths=[[0,1,2]]);
				}
			}
		}

		for (hole=[0:1])
		rotate(hole*60)
		translate([hole_separation,0,-1])
		cylinder(h=vfvertex_height+2,r=(m8_diameter/2)); 

		for (block=[0:1])
		rotate(block*60)
		translate([hole_separation-vertex_end_major_d/2-1,
			vertex_horizontal_hole_offset-2*block*vertex_horizontal_hole_offset,
			vfvertex_height/2])
		teardrop(r=m8_diameter/2,h=vertex_end_major_d+2);
	}
}

module barbell (x1,x2,r1,r2,r3,r4) 
{
	x3=triangulate (x1,x2,r1+r3,r2+r3);
	x4=triangulate (x2,x1,r2+r4,r1+r4);
	render()
	difference ()
	{
		union()
		{
			translate(x1)
			circle (r=r1);
			translate(x2)
			circle(r=r2);
			polygon (points=[x1,x3,x2,x4]);
		}
		translate(x3)
		circle(r=r3,$fa=5);
		translate(x4)
		circle(r=r4,$fa=5);
	}
}

function triangulate (point1, point2, length1, length2) = 
point1 + 
length1*rotated(
atan2(point2[1]-point1[1],point2[0]-point1[0])+
angle(distance(point1,point2),length1,length2));

function distance(point1,point2)=
sqrt((point1[0]-point2[0])*(point1[0]-point2[0])+
(point1[1]-point2[1])*(point1[1]-point2[1]));

function angle(a,b,c) = acos((a*a+b*b-c*c)/(2*a*b)); 

function rotated(a)=[cos(a),sin(a),0];
function rotate_vec(v,a)=[cos(a)*v[0]-sin(a)*v[1],sin(a)*v[0]+cos(a)*v[1]];