#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for pdftk.
GH_REPO="https://gitlab.com/pdftk-java/pdftk"
TOOL_NAME="pdftk"
TOOL_TEST="pdftk --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' | LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" | grep -o 'refs/tags/.*' | cut -d/ -f3- | grep '^v[0-9]\+\.[0-9]\+\.[0-9]\+$' | sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url java_filename strip_components os arch
	version="$1"
	filename="$2"
	java_filename="$3"

	url="https://gitlab.com/api/v4/projects/5024297/packages/generic/pdftk-java/v${version}/pdftk-all.jar"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"

	echo "* Downloading dependancies for $TOOL_NAME $version..."
	os=$(uname -s | tr '[:upper:]' '[:lower:]')
	if [ "$os" == "darwin" ]; then
		os="mac"
		strip_components=3
	else
		strip_components=1
	fi

	arch=$(uname -m)
	if [ "$arch" == "x86_64" ]; then
		arch="x64"
	elif [ "$arch" == "arm64" ]; then
		arch="aarch64"
	fi

	java_url="https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.29%2B7/OpenJDK11U-jre_${arch}_${os}_hotspot_11.0.29_7.tar.gz"
	curl -L "$java_url" -o "$java_filename"

	#  Extract contents of tar.gz file into the download directory
	mkdir -p "$ASDF_DOWNLOAD_PATH/jre"
	tar -xzf "$java_filename" -C "$ASDF_DOWNLOAD_PATH/jre" --strip-components="$strip_components" || fail "Could not extract $java_filename"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		touch "$install_path/pdftk"
		echo "#!/usr/bin/env bash" >"$install_path/pdftk"
		echo "$install_path/jre/bin/java -jar $install_path/pdftk-all.jar \"\$@\"" >>"$install_path/pdftk"
		echo "exit \$?" >>"$install_path/pdftk"
		chmod +x "$install_path/pdftk"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
