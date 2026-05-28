#!/usr/bin/env bash

set -euo pipefail

# this is the correct GitHub homepage where releases can be downloaded for redis-cli.
TOOL_NAME="redis-cli"
TOOL_TEST="redis-cli --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if redis-cli is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_all_versions() {
	curl -fsSL https://download.redis.io/releases/ |
		grep -o 'href="redis-.*\.tar\.gz"' |
		sed 's/href="redis-//' |
		sed 's/\.tar\.gz"//'
}

latest_stable_version() {
	local query="${1:-}"
	local latest=""

	while IFS= read -r version; do
		[ -z "$version" ] && continue
		[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || continue
		if [ -n "$query" ] && [ "${version#"$query"}" = "$version" ]; then
			continue
		fi
		latest="$version"
	done < <(list_all_versions | sort_versions)

	[ -n "$latest" ] || fail "No stable version found matching '${query}'"
	printf "%s\n" "$latest"
}

resolve_version() {
	local version="$1"

	case "$version" in
	latest)
		latest_stable_version
		;;
	latest:*)
		latest_stable_version "${version#latest:}"
		;;
	*)
		printf "%s\n" "$version"
		;;
	esac
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"
	url="https://download.redis.io/releases/redis-${version}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="$3"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	local resolved_version
	resolved_version=$(resolve_version "$version")

	(
		mkdir -p "$install_path"/bin
		cp -r "$ASDF_DOWNLOAD_PATH"/src/redis-cli "$install_path"/bin/

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

		echo "$TOOL_NAME $resolved_version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error ocurred while installing $TOOL_NAME $resolved_version."
	)
}
