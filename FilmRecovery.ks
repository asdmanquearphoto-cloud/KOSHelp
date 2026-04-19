//Testing kOS prelaunch script for sounding rockets.  

//*********************PARAMETERS AND VARIABLES**********************.
parameter mechJeb is true. // Set to true if using MechJeb for ascent control, false for manual throttle control.
set engineName to "Model 39". // Set to the name of the engine used for the mission, e.g. "Model 39" or "Mainsail".

//****************************************************************.
//*********************** MISSION SEQUENCE ***********************.
//****************************************************************.
runOncePath ("0:/common/ProcedimientosPredefinidos.ks"). 
//********************* Film Recovery Mission ********************.
clearscreen.
Print "Checking MechJeb status...".
wait 1.
if mechJeb {
    if mj:core:running {
        print "MechJeb is active, using MechJeb for ascent control.".
    } else {
        print "MechJeb is not active, switching to manual throttle control.".
        set mechJeb to false.
    }
} else {
    print "Manual throttle control selected, ensure MechJeb is not active.".
}
LaunchSequenceSuborbital().
lock throttle to 1.
when ship:altitude > 75000 then {
    print "Reached 75km altitude, deploying fairing.".
    toggle ag1.
    Wait 1.
    print "Fairing deployed, starting film.".
    }
when info:sdv   < 1 then {
    print "Fuel depleted, shutting down engines.".
    lock throttle to 0.
    wait 3.
    print "Waiting to reach Apoapsis...".
    }
when ship:apoapsis then {
    print "Reaching Apoapsis, deploying parachute.".
    toggle ag2.
}
when vessel:status = "Landed" then {
    print "Touchdown detected, recovery successful!".
}
wait 1.