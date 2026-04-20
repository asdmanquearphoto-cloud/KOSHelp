//Procedimientos predefinidos.
//***************************************** MECHJEB WRAPPERS **************************************.
set mj to addons:mj.

// Core status wrapper
set core to mj:core.

// Vessel state wrapper
set v    to mj:vessel.

// Info items wrapper
set info to mj:info.

// Ascent autopilot wrapper
set asc  to mj:ascent.
//*********************************************** MECHJEB WRAPPERS END ***********************************************.
global function LaunchSequenceSubOrbital {
    parameter engineName.
    print "Counting down for launch...".
    print "Engine detected " + engineName.
    set mechJeb to get_mechJeb_status().
    set countdown to 10.
    set startTime to time:seconds.
    until countdown < 0 {
        if time:seconds - startTime >= 1 {
            print "T-" + countdown.
        }  
        if countdown = 5 {
            if mechJeb = "active" {
                print "MechJeb using throttle control for launch.".
            } else {
                print "No MechJeb Throttle Control kOS using control for launch.".
                lock throttle to 1.
            }
        } 
        if countdown = 4 {
            print "Ignition sequence start".
            stage.
        }
        if countdown = 3 {
            print "Engine ignition".
        }
        set countdown to -1.
        set startTime to time:seconds.
    }
    wait 0.1.
        local t_spool to get_spoolup_time(engineName).
        print "Waiting for engine spool up: T- " + t_spool.
        wait t_spool.
        if info:ttwr < 1.2 {
            print "Engine malfunction detected, aborting launch".
            lock throttle to 0.
            toggle abort.
            }
        }
        // Wait for liftoff and check for engine shutoff.
        if info:ttwr < 1.2 {
            print "Engine malfunction detected, aborting launch".
            lock throttle to 0.
            toggle abort.
        wait until ship:verticalvelocity > 5.
        print "Liftoff detected, continuing ascent".
        }



//********************** VARIABLES AND FUNCTIONS ***********************.
       //Returns ship TWR
function shipTWR {
   RETURN AVAILABLETHRUST / (MASS*CONSTANT:g0).
}
function get_spoolup_time {
   parameter engineName.
   local spoolup_time is lexicon (
    "Model_39", 4
    ).
    local t_spool to 5.
    if spoolup_time:haskey(engineName) {
        set t_spool to spoolup_time[engineName].
    }
    return t_spool.

}
function get_mechJeb_status {
    if mj:core:running {
        return "active".
    } else {
        return "inactive".
    }
}