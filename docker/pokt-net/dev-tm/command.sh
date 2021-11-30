#!/usr/bin/expect

set command $argv; # Grab the first command line parameter
set timeout -1

if { $env(POCKET_CORE_KEY) eq "" }  {
    spawn sh -c "$command"
} else {
    # TODO(olshansky, hamza): Importing the keys here conflicts with the
    # import and validator set in `local_command_dev.sh`. Commenting out for
    # now but we shold discuss what to do here next.
    # spawn pocket accounts import-raw $env(POCKET_CORE_KEY)
    # sleep 1
    # send -- "$env(POCKET_CORE_PASSPHRASE)\n"
    # expect eof
    spawn sh -c "$command"
}

sleep 1

expect eof

exit
