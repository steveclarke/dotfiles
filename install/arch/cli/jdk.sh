#!/usr/bin/env bash
# OpenJDK 21 (LTS) — required by Android build tools (AGP 9, Android CLI, Gradle)
installing_banner "jdk21-openjdk"
omarchy-pkg-add jdk21-openjdk

# Make 21 the system default when no other JDK is set
if is_installed archlinux-java; then
  current="$(archlinux-java get 2>/dev/null || true)"
  if [[ -z "$current" || "$current" == "no default" ]]; then
    sudo archlinux-java set java-21-openjdk
  fi
fi
