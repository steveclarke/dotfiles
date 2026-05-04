# 3-Monitor Setup

Hardware notes, current cabling layout, and lessons learned from getting three Dell S2725QC monitors running at 4K@120Hz on this machine.

## Hardware

- **dGPU**: AMD Radeon RX 7700/7800 XT — 3× DisplayPort + 1× HDMI on rear bracket
- **iGPU**: AMD Raphael (Ryzen 7000-series integrated) — DP + HDMI on motherboard rear I/O
- **Monitors**: 3× Dell S2725QC 27" 4K (3840×2160 @ 120Hz max)
  - Inputs: 1× HDMI, 1× USB-C (DisplayPort Alt Mode). **No native DisplayPort input.**
- **Cables**:
  - 1× HDMI 2.1 (8K rated)
  - 2× DisplayPort → USB-C (8K rated, **wide connector shells**)

## Current Layout

| Position | GPU port    | GPU             | Cable          | Monitor input  | Workspaces |
| -------- | ----------- | --------------- | -------------- | -------------- | ---------- |
| Left     | `HDMI-A-1`  | dGPU (Radeon)   | HDMI           | HDMI           | 4, 5, 6    |
| Middle   | `DP-2`      | dGPU (Radeon)   | DP → USB-C     | USB-C (DP Alt) | 1, 2, 3    |
| Right    | `DP-4`      | iGPU (Raphael)  | DP → USB-C     | USB-C (DP Alt) | 7, 8, 9    |

All three at **4K @ 120Hz**, scale 1.333333 (retina-class, logical 2880×1620 each).

The middle monitor is on the dGPU because it's the primary work surface (and gaming target). The right monitor lands on the iGPU due to a bracket clearance constraint described below.

## GPU Bracket Layout (Reference)

DRM port enumeration is **non-sequential** with respect to physical position on this card. Verified by isolating one cable at a time:

| Physical position (outer → inner) | Enumerates as |
| --------------------------------- | ------------- |
| Outermost DP                      | `DP-2`        |
| Middle DP                         | `DP-1`        |
| Innermost DP                      | `DP-3`        |
| HDMI                              | `HDMI-A-1`    |

HDMI sits adjacent to the innermost DP (`DP-3`).

## The Clearance Problem

The 8K-rated DP cables have noticeably thicker connector housings than older DP cables (more shielding to support 8K bandwidth). Two consequences:

1. **Two adjacent fat DP connectors do not physically fit.** You need at least one empty DP slot between any two DP cables.
2. **Fat DP cable adjacent to HDMI cable barely fits** — works in isolation, but "barely."

Combined, this means **no combination of three fat cables fits on the dGPU bracket**:

- 3 DPs in a row → adjacent-DP collision (impossible).
- 2 DPs (with one DP slot empty between) + HDMI → forces one DP into the innermost slot adjacent to HDMI; that DP cannot fully seat. EDID reads but link training fails (`0x0` resolution in Hyprland).

Solution: move one cable off the dGPU bracket entirely. The motherboard back I/O has its own DP and HDMI from the iGPU, with no clearance issues.

## Lessons Learned

### Hardware

- **Check physical clearance with the actual cables you'll use, before buying.** Cable specs say nothing about housing dimensions. 8K-rated cables are thicker than 4K cables.
- **AMD RX 7000-series dropped DP++ (dual-mode DisplayPort).** Passive DP→HDMI adapters won't work on this card. Only **active** DP→HDMI adapters (with a logic chip) work. Confirmed empirically — a passive adapter showed `connected` in DRM but failed to train a link.
- **Modern monitors are dropping native DisplayPort.** The S2725QC has only HDMI + USB-C. Plan cable purchases accordingly — DP→USB-C cables are commodity but vary wildly in shell width.
- **iGPU DP and HDMI handle 4K@120Hz fine** on AM5 boards (DP 1.4 with DSC). Performance for desktop work is indistinguishable from dGPU.

### Linux / Wayland

- **DRM connector names don't match physical port order** — verify with one-cable-at-a-time isolation, not by guessing.
- **Hyprland's `preferred` mode honors EDID's preferred timing**, which Dell flags as 60Hz on the S2725QC. To get 120Hz, specify `3840x2160@120` explicitly in `monitors.conf`.
- **Hyprland workspace-to-monitor pinning loses windows on monitor disconnect.** When you unplug the monitor whose workspace contains a window, the workspace migrates but doesn't necessarily stay active on the receiving monitor — the window ends up "alive but hidden" on a non-displayed workspace.
  - During cabling/debugging work: replace pinned config with wildcard `monitor = , preferred, auto, <scale>` and skip workspace pinning until cabling stabilizes.
  - For a session-critical window (e.g. terminal you're using to debug): float + pin via `hyprctl dispatch togglefloating` and `hyprctl dispatch pin` so it's visible on every workspace.
- **Marginal DP link symptom**: monitor description and serial appear in `hyprctl monitors` (EDID is readable over the AUX channel) but resolution shows `0x0`. Means the high-speed lanes failed link training while the low-speed lanes still work. Almost always a seating/clearance issue, not a software issue.

### Dual-GPU Gaming

- Apps render on the GPU that owns their display monitor by default.
- Games on the **right monitor (iGPU)** will get iGPU performance — significantly worse than dGPU.
- For full Radeon performance on the right monitor, force PRIME render offload:
  ```
  DRI_PRIME=1 <game-binary>
  ```
  In Steam, paste `DRI_PRIME=1 %command%` in Launch Options.
- Practical advice: **don't game on the right monitor.** Keep it for chat, dashboards, reference, music. Game on the middle (or fullscreen on the left) and you'll never notice the iGPU.

## Diagnostic Commands

```bash
# Connected DRM connectors (pre-Hyprland, kernel level)
for p in /sys/class/drm/card*-*/status; do
  s=$(cat "$p"); [ "$s" = "connected" ] && echo "$p"
done

# Hyprland's view (with mode and position)
hyprctl monitors | grep -E "^Monitor|^\s+[0-9]+x[0-9]+@|description"

# Available modes per monitor
hyprctl monitors all -j | jq '.[] | {name, modes: .availableModes[:5]}'

# Identify which physical monitor is which port
hyprctl keyword monitor "DP-2, disable" && sleep 3 && \
  hyprctl keyword monitor "DP-2, preferred, auto, 1.333333"
# Watch which monitor blacks out
```

## Future Paths to a Full-dGPU 3-Monitor Setup

If having all three monitors on the discrete card matters later:

1. **Slim DP→USB-C cables (chosen path).** The current UGREEN 8K cables have unnecessarily wide shells. Almost every USB-C → DP 1.4 cable on the market is labeled "8K@60 / 4K@120" — the label is marketing, what matters is physical construction. Confirmed-slim option: **Silkland USB-C to DisplayPort 1.4 (amazon.ca, B09M38CXZ3)** — DP 1.4 / HBR3 / 4K@120Hz, 6.6ft, compact aluminum housing visible in product photo. Two ordered as the primary fix.
2. **Right-angle DP adapter** (~$10) on one of the inner DP ports. Bends the plug 90° away from the HDMI cable. Important: must be the **vertical (up/down)** variant, not the **flat (left/right)** variant — flat adapters route the cable parallel to the bracket, recreating the same collision in a different plane.
3. **Active DP→HDMI adapter** on a dGPU DP port → HDMI cable into a monitor's HDMI input. **Must be active** (RX 7000 has no DP++). Limited utility since each monitor has only 1 HDMI input.

### Validation procedure for replacement cables

When the new cables arrive:

1. Hold the new cable's DP connector next to a UGREEN DP connector. Confirm it's visibly slimmer.
2. Plug the new cable into the dGPU's **innermost DP slot** (DP-3, adjacent to HDMI). If it seats fully without HDMI interference, the clearance problem is solved.
3. Replace the second cable, move the right monitor from motherboard DP-4 to dGPU DP-3, and update `monitors.conf` to reflect the new port assignment.

## Hyprland Config Files

- `configs/hypr/.config/hypr/monitors.conf` — monitor positions, scales, refresh rates, workspace pinning
- `configs/hypr/.config/hypr/bindings.conf` — workspace switching (Super + Numpad 1–9)
