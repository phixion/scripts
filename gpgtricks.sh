#!/bin/bash
# gpgtricks by stkie

# echo the usage
usage_f ()
{
	echo ""
	echo $"usage:		$0 {command}"
	echo "" 
	echo "commands:	detach [sigfile.sig] [inputfile]			- creates a detached signature/file combination"
    echo "			verify [sigfile.sig] [inputfile]			- verifies a signature/file combination"
	echo "			export [keyid]								- exports a key"
	echo "			sign [sender id] [receiver id] [inputfile] 	- signs and encrypts a file"
	echo "			msg [sender id] [receiver id] [outputfile] 	- creates an encrypted message interactivly"
	echo ""
}

# main functions
detach_f () {
	gpg --output "$1" --detach-sig "$2"
}
verify_f () {
	gpg --verify "$1" "$2"
}
export_f () {
	gpg -a --export "$1"
}
sign_f () {
	gpg -u "$1" -r "$2" --armor --sign --encrypt "$3"
}
msg_f () {
	gpg -ase -u "$1" -r "$2" --output "$3"
}

# execute
case "$1" in
  detach)
	detach_f "$2" "$3"
	;;
  verify)
	verify_f "$2" "$3"
	;;
  export)
	export_f "$2"
	;;
  sign)
	sign_f "$2" "$3" "$4"
	;;
  msg)
	msg_f "$2" "$3" "$4"
	;;
  *)
	usage_f
	exit 2
esac

# EOF