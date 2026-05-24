function upgrade-all
    sudo nala upgrade

    if command -q flatpak
        # Strip flatpak's noisy "runtime is end-of-life" info blocks; keep real errors and update output.
        and flatpak upgrade 2>&1 | awk '
            /^Info: runtime .* is end-of-life/ {skip=1; next}
            /^Info: applications using this (runtime|extension)/ {skip=1; next}
            skip && /^$/ {skip=0; next}
            skip {next}
            {print}
        '
    end

    and brew upgrade
end
