include <configuration.scad>
use <x-end-motor.scad>
use <x-end-idler.scad>
use <gregs-x-carriage.scad>


xendmotor(endstop_mount=true,curved_sides=true,closed_end=true,luu_version=false);

translate([-10,33,0]) 
rotate(180)
xendidler(endstop_mount=false,curved_sides=true,closed_end=false,luu_version=false);
