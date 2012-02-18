#!/bin/sh

DMENU_SCHEME="history"
DMENU_OPTIONS="xmms vertical resize"

. "$UZBL_UTIL_DIR/dmenu.sh"
. "$UZBL_UTIL_DIR/uzbl-dir.sh"

[ -r "$UZBL_HISTORY_FILE" ] || exit 1

current="$( tail -n 1 "$UZBL_HISTORY_FILE" | cut -d ' ' -f 3 )"
goto="$( ( echo "$current"; awk '{ print $3 }' "$UZBL_HISTORY_FILE" | grep -v "^$current\$" | sort -u ) | $DMENU )"

if [ -n "$goto" ]; then
    if [ $1 = "new_tab" ]; then
        echo "event NEW_TAB $goto" > "$UZBL_FIFO"
    else
        echo "uri $goto" > "$UZBL_FIFO"
    fi
fi
