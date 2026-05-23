#!/usr/bin/env bash
installing_banner "ollama"
omarchy-pkg-add ollama
sudo systemctl enable --now ollama.service
