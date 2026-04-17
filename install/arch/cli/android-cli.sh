#!/usr/bin/env bash
#
# Android CLI — Google's agentic Android tooling (preview, v0.7+).
# Docs: https://developer.android.com/tools/agents/android-cli
#
# Installs the single `android` binary to ~/.local/bin (no sudo).
# Manages the Android SDK via `android sdk install`, skills via `android skills add`,
# and ships an embedded knowledge base via `android docs`.

installing_banner "android-cli"

bin_dir="${HOME}/.local/bin"
bin_path="${bin_dir}/android"
url="https://dl.google.com/android/cli/latest/linux_x86_64/android"

mkdir -p "${bin_dir}"

# Always refetch — the binary self-updates via `android update`, but on a fresh
# box we want the latest upstream build. This is idempotent and cheap (~few MB).
tmp_file="$(mktemp)"
if curl -fsSL "${url}" -o "${tmp_file}"; then
  mv "${tmp_file}" "${bin_path}"
  chmod +x "${bin_path}"
  # First-run bootstrap (fetches embedded resources); safe to re-run.
  ANDROID_CLI_FRESH_INSTALL=1 "${bin_path}" >/dev/null 2>&1 || true
  success "android-cli installed to ${bin_path}"
else
  rm -f "${tmp_file}"
  error "android-cli download failed from ${url}"
fi

# Companion Arch packages: adb/fastboot + udev rules for USB device access.
installing_banner "android-tools (adb/fastboot)"
omarchy-pkg-add android-tools

installing_banner "android-udev (USB device rules)"
omarchy-pkg-add android-udev
