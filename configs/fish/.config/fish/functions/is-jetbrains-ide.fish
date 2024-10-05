function is-jetbrains-ide
    set -l env_var $GIO_LAUNCHED_DESKTOP_FILE
    if string match -q "*jetbrains*" $env_var
        # echo "We are in a JetBrains IDE"
        return 0
    else
        # echo "We are NOT in a JetBrains IDE"
        return 1
    end
end
