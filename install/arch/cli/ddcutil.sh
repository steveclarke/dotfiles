#!/usr/bin/env bash
installing_banner "ddcutil"

# CLI for reading/writing external monitor settings (brightness, contrast,
# RGB gains, color preset) over DDC/CI. Foundation for vdu_controls and any
# direct ddcutil scripting. I2C access is configured by setups/arch/monitor-ddc.sh.
omarchy-pkg-add ddcutil
