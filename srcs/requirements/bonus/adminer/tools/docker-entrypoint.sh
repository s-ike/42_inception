#!/bin/sh
set -eu

if [ ! -e index.php ]; then
    echo >&2 "Adminer not found in $PWD - download now..."

    ADMINER_VERSION=4.8.1
    ADMINER_DOWNLOAD_SHA256=2fd7e6d8f987b243ab1839249551f62adce19704c47d3d0c8dd9e57ea5b9c6b3
    ADMINER_SRC_DOWNLOAD_SHA256=ef832414296d11eed33e9d85fff3fb316c63f13f05fceb4a961cbe4cb2ae8712

    curl -fsSL https://github.com/vrana/adminer/releases/download/v$ADMINER_VERSION/adminer-$ADMINER_VERSION.php -o index.php
    echo "$ADMINER_DOWNLOAD_SHA256  index.php" |sha256sum -c -
fi

if [ ! -e adminer.css ]; then
    echo >&2 "adminer.css not found in $PWD - download now..."
    curl -O https://raw.githubusercontent.com/Niyko/Hydra-Dark-Theme-for-Adminer/master/adminer.css
    if [ $? -eq 0 ]; then
        echo >&2 "Complete! adminer.css has been successfully downloaded to $PWD"
    else
        echo >&2 "FAILED! adminer.css wan not download to $PWD"
    fi
fi

exec "$@"
