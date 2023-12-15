function upgrade-all
    sudo nala upgrade

    if command -q flatpak
        and flatpak upgrade
    end

    and brew upgrade
end
