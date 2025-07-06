# Install essential development libraries and tools
# This must run first (hence the "1-" prefix) to provide dependencies for other installations

# Development tools and compilers
apt_install build-essential pkg-config autoconf bison clang rustc

# SSL and crypto libraries
apt_install libssl-dev

# Development libraries
apt_install libreadline-dev zlib1g-dev libyaml-dev libncurses5-dev libffi-dev libgdbm-dev

# Performance and multimedia libraries
apt_install libjemalloc2 libvips imagemagick libmagickwand-dev

# PDF tools
apt_install mupdf mupdf-tools

# System monitoring libraries
apt_install gir1.2-gtop-2.0 gir1.2-clutter-1.0

# Database tools and clients
apt_install redis-tools sqlite3 libsqlite3-0

# Database development libraries
apt_install libmysqlclient-dev libpq-dev

# PostgreSQL client tools
apt_install postgresql-client postgresql-client-common
