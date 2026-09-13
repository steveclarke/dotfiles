# Release

The marketplace listing, the review and the version badge all bind to one
commit. The release is that commit, tagged and never moved.

## Repository surface

- `manifest.json` with a `version` matching the tag.
- README with requirements, install, use, update and removal. Install and
  removal commands copyable and symmetric.
- `LICENSE`, plus notes on external packages the plugin needs.
- Root `preview.png` for anything with UI.
- CI that runs the real tests (bats, node, qmllint, `bin/check`), not only a
  JSON parse.
- What the plugin writes, launches and leaves behind on removal.

## Sequence

1. Bump `manifest.json` `version` and write the release notes.
2. Run the release checks in `testing.md` on the intended Omarchy version.
3. Push and wait for green CI.
4. Confirm a clean tree and record the full 40-character SHA.
5. Create an annotated tag at that SHA: `git tag -a vX.Y.Z -m "vX.Y.Z" <sha>`,
   then `git push origin vX.Y.Z`. Lightweight tags carry no message, date or
   tagger and are not what a release should point at.
6. `gh release create vX.Y.Z --notes-file <notes>` from that tag.
7. Submit or re-validate the marketplace issue against that SHA
   (`marketplace.md`). Leave HEAD alone until approval.

Never move or re-point a published tag. A change after tagging is a new version.

## Compatibility statement

Name the Omarchy version tested, the plugin SHA, the hardware or display scope,
and what was not tested. The plugin API is still changing; never write "works
on all Omarchy versions". A passing marketplace baseline is a pattern scan of
one commit, not a security audit, and the notes say so if they mention it.

Adapted from the `omarchy-plugin-release` skill in
github.com/tcballard/build-omarchy-plugins (MIT).
