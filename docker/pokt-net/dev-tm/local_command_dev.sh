#!/usr/bin/expect

set timeout -1

if { $env(POCKET_CORE_KEY) eq "" || $env(POCKET_ADDRESS) eq "" } {
    send "Node is not a validator...\n"
    spawn pocket start
} else {
    send "Importing validator keys...\n"
    spawn pocket accounts import-raw $env(POCKET_CORE_KEY)
    sleep 1
    send -- "$env(POCKET_CORE_PASSPHRASE)\n"
    expect eof
    spawn pocket accounts set-validator $env(POCKET_ADDRESS)
    sleep 1
    send -- "$env(POCKET_CORE_PASSPHRASE)\n"
    expect eof
    spawn /bin/bash -c "./prepare-tendermint.sh"
    spawn /bin/bash -c "export POCKET_CORE_SEEDS=$env(POCKET_CORE_SEEDS) && ./watch.sh"
}

sleep 1

expect eof

exit
