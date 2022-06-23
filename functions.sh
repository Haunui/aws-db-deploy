# FUNCTIONS

gen_cred() {
	str=$(echo "$(date +%s)$RANDOM" | md5sum | awk '{print $1}')
	echo "$(echo "$str" | cut -c 1-8):$(echo "$str" | cut -c 9-24)"
}
