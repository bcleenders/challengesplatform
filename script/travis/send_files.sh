#!/usr/bin/expect -f
exp_internal 1
# set timeout -1
set file [lindex $argv 0]
spawn scp $file travis@198.199.77.172:~/www
expect "key fingerprint"
send "yes\r"
expect "password:"
send $env(SECRET_BUNDLE_PASS)
send "\r"
expect "100%"
expect eof
