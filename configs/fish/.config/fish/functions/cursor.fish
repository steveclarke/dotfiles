function cursor
    if not test -f /opt/cursor.appimage
        echo "Cursor AI IDE is not installed. Please run the installer first."
        return 1
    end
    
    /opt/cursor.appimage --no-sandbox $argv[1..-1] >/dev/null 2>&1 & disown
end
