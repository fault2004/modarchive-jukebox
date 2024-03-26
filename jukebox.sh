#!/usr/bin/env bash
# https://github.com/fault2004/modarchive-jukebox
# play random tracker music inside bash script from modarchive.org

CURL_USERAGENT="User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:123.0) Gecko/20100101 Firefox/123.0"
PLAYER="$(command -v mpv)"

play_file() {
	echo "Press CTRL+C to skip song while playing."
	echo "Double CTRL+C to end program."

	for ((;;))
	do
		download_file "$(ran_random)"
		"${PLAYER}" /tmp/playmod
	done
}

download_file() {
	echo "Downloading..."
	[ -f "/tmp/playmod" ] && rm -f /tmp/playmod
	curl -s -H "${CURL_USERAGENT}" "$1" --output /tmp/playmod
}

ran_random() {
	DATA="$(curl -s -H "${CURL_USERAGENT}" 'https://modarchive.org/index.php?request=view_random')"
	RET="$(echo "$DATA" | grep '<a href="https://api.modarchive.org/downloads.php?' | pup 'a attr{href}' | tail -n -1)"
	echo "$RET"
}
trap 'rm -f /tmp/playmod; exit 0' EXIT

play_file
