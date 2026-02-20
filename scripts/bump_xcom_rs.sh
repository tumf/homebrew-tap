#!/usr/bin/env bash
set -euo pipefail

crate="xcom-rs"
formula="Formula/xcom_rs.rb"

if [[ ! -f "${formula}" ]]; then
	echo "Formula not found: ${formula}" >&2
	exit 1
fi

latest_version=$(
	curl -fsSL "https://crates.io/api/v1/crates/${crate}" |
		ruby -rjson -e 'print JSON.parse(STDIN.read).fetch("crate").fetch("max_version")'
)

download_url="https://crates.io/api/v1/crates/${crate}/${latest_version}/download"

sha256=$(
	if command -v sha256sum >/dev/null 2>&1; then
		curl -fsSL -L "${download_url}" | sha256sum | awk '{print $1}'
	else
		curl -fsSL -L "${download_url}" | shasum -a 256 | awk '{print $1}'
	fi
)

DOWNLOAD_URL="${download_url}" SHA256="${sha256}" FORMULA_FILE="${formula}" ruby <<'RUBY'
download_url = ENV.fetch("DOWNLOAD_URL")
sha256 = ENV.fetch("SHA256")
formula_file = ENV.fetch("FORMULA_FILE")

contents = File.read(formula_file)
updated = contents.dup

updated.gsub!(/^([ \t]*url\s+)"[^"]*"\s*$/, "\\1\"#{download_url}\"")
updated.gsub!(/^([ \t]*sha256\s+)"[0-9a-f]{64}"\s*$/, "\\1\"#{sha256}\"")

if updated == contents
  puts "No changes needed: #{formula_file}"
  exit 0
end

File.write(formula_file, updated)
puts "Updated #{formula_file}"
RUBY

:
