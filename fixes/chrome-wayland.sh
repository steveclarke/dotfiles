# chrome://flags/#ozone-platform-hint

cat <<EOF
When using Chrome in a Wayland session, drag and drop and setting default
profile don't work properly. This is because Chrome seems to use an X session
by default. To fix this, you can set the Ozone platform to "Auto" so it starts
with the correct platform.

In Chrome set the ozone-platform-hint flag to "auto" by visiting:

chrome://flags/#ozone-platform-hint
EOF
