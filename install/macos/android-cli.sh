#!/usr/bin/env bash
#
# Android CLI — Google's agentic Android tooling (preview, v0.7+).
# Docs: https://developer.android.com/tools/agents/android-cli
#
# Installs the single `android` binary to ~/.local/bin (no sudo).
# JDK comes from the `temurin@21` cask in the Brewfile.

installing_banner "android-cli"

bin_dir="${HOME}/.local/bin"
bin_path="${bin_dir}/android"
url="https://dl.google.com/android/cli/latest/darwin_arm64/android"

mkdir -p "${bin_dir}"

tmp_file="$(mktemp)"
if curl -fsSL "${url}" -o "${tmp_file}"; then
  mv "${tmp_file}" "${bin_path}"
  chmod +x "${bin_path}"
  ANDROID_CLI_FRESH_INSTALL=1 "${bin_path}" >/dev/null 2>&1 || true
  success "android-cli installed to ${bin_path}"
else
  rm -f "${tmp_file}"
  error "android-cli download failed from ${url}"
fi
