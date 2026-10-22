# Craft and safety rules

Learned in real runs. Read before writing a prompt for imagery, video, motion or any web build.


- **Imagery.** Generated people are fine when they read as real: one
  reference image per character so the face holds from shot to shot, one
  lighting look, natural skin. Historical and illustrative scenes (a Bible
  story, a period setting) are fair game. Never a generated person or place
  presented as a real, identifiable one (a real member, a real event, a real
  local street); locals know, so those come from real photographs. Check
  generated detail for accuracy (a pelican on a coast that has none fails).
- **Resolution.** Generated stills are soft at 4K; use real footage for large
  motion.
- **Sharp on every screen, measured.** Every web build's self-check runs a
  window matrix, not two widths: phone at DPR 3, laptop at DPR 2, 1920 and
  2560 at DPR 1, a 6K monitor full and half-width at DPR 2 (a half-width window
  on a big monitor is taller than wide, so it must not be treated as a phone).
  For every image, poster and video, measure in the browser rendered size x DPR
  against the file's natural size; anything stretched past 1.15x fails. Media
  is chosen by the physical pixels it covers (`srcset` with `w` and `sizes`;
  for video, computed coverage), never by orientation or a CSS-width
  breakpoint. Lighthouse never sees a big high-density screen, so a perfect
  score proves nothing here.
- **Stills before motion.** Approve one still per scene before animating.
- **Name a style, don't describe one.** A named reference gives pacing, type
  and transitions; without one the model falls back to its default look.
- **Real components for product UI,** from the project's real library.
- **Heavy work** (encoding, renders) is spread over available machines, and an
  agent never stops a process it did not start.
- **Two agents on one piece of work:** one owns the content, the other the
  look. Each commits only its own named paths.
- **Record rules as the human sharpens them,** in the prompt and the log.
