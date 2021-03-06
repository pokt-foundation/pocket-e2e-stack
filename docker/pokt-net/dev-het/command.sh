#!/usr/bin/expect

set command $argv; # Grab the first command line parameter
set timeout -1

if { $env(POCKET_CORE_KEY) eq "" }  {
    spawn sh -c "$command"
} else {
    spawn sh -c "$command"
}

sleep 1

expect eof

exit
