#!/bin/bash

SABAYON_USER=$(cat /etc/sabayon/steambox-user 2>/dev/null)
. /sbin/sabayon-functions.sh

_set_gdm_session() {
    if [ ! -x /usr/bin/gdm ]; then
        return 0
    fi

    if [ -x "/usr/libexec/gdm-set-default-session" ]; then
        # TODO: remove this in 6 months
        # oh my fucking glorious god, this
        # is AccountsService bullshit
        # cross fingers
        /usr/libexec/gdm-set-default-session "${1}"
    fi
    if [ -x "/usr/libexec/gdm-set-session" ]; then
        # GDM 3.6 support
        /usr/libexec/gdm-set-session "${LIVE_USER}" "${1}"
    fi
}

if sabayon_is_steambox; then

    _HOME="/home/${LIVE_USER}"
    echo "Sabayon Steam Box mode enabled, user: ${LIVE_USER}"

    echo "[Desktop]" > "${_HOME}"/.dmrc
    echo "Session=steambox" >> "${_HOME}"/.dmrc
    chown "${LIVE_USER}" "${_HOME}"/.dmrc
    _set_gdm_session steambox
    sabayon_setup_autologin

    # dive into the final executable
    exec /usr/libexec/steambox-consolekit
fi

# if we get here, we need to loop forever.
if ! sabayon_is_live && ! sabayon_is_steambox; then
    echo "Sabayon Steam Box mode disabled"
    sabayon_disable_autologin
    _set_gdm_session gnome
fi

while true; do
    sleep 7d
done
