function code
  # On macOS, just use the original VSCode CLI tool
  if test (uname) = "Darwin"
    command code $argv
  else
    # On Linux, use Wayland flags
    command code --enable-features=UseOzonePlatform --ozone-platform=wayland $argv
  end
end
