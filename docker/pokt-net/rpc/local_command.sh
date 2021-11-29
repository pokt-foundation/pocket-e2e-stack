#!/usr/bin/expect

set timeout -1

if { $env(POCKET_CORE_KEY) eq "" }  {
    spawn pocket-core start
} else {
    spawn pocket-core accounts import-raw $env(POCKET_CORE_KEY)
    sleep 1
    send -- "yo\n"
    expect eof
    spawn pocket-core accounts set-validator $env(POCKET_ADDRESS)
    sleep 1
    send -- "yo\n"
    expect eof
    spawn pocket-core start --datadir=/home/app/.pocket --profileApp true --seeds $env(POCKET_CORE_SEEDS)
}

sleep 1

send -- "yo\n"

expect eof

exit
