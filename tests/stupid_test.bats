@test "Check script exit if there is no configfile" {
	run ./check-backup.sh -t toto -c toto
	[[ "$output" == *"Something happens while loading toto" ]]
	[[ "$status" == 1 ]]
}
