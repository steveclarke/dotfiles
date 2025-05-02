# https://forum.cursor.com/t/cannot-launch-cursor-without-no-sandbox/35261/2

echo 'kernel.apparmor_restrict_unprivileged_userns = 0' | 
  sudo tee /etc/sysctl.d/20-apparmor-donotrestrict.conf
