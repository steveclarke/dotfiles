# Linux: /tmp is a size-capped tmpfs that agent builds fill. Temp files go on
# the home disk instead; user-tmpfiles.d/tmpdir.conf clears them after 2 days.
if test (uname) = Linux
    set -gx TMPDIR $HOME/.cache/tmp
end
