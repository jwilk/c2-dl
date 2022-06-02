#!/usr/bin/env bash

# Copyright © 2022 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

set -e -u

pdir="${0%/*}/.."
prog="$pdir/c2-dl"

declare -i i=0
t()
{
    i+=1
    out=$("$prog" "$@")
    if [[ "$out" = "https://c2.com/wiki/remodel/pages/$pg" ]]
    then
        echo "ok $i $*"
    else
        # shellcheck disable=SC2001
        sed -e 's/^/# /' <<< "$out"
        echo "not ok $i $*"
    fi
}

export http_proxy='http://localhost:9'
export https_proxy='http://localhost:9'

tmpdir=$(mktemp -d -t c2-dl.test.XXXXXX)
cat <<'EOF' > "$tmpdir/curl"
#!/bin/sh
exec jq -n '{text: $text}' --arg text "$1"
EOF
chmod u+x "$tmpdir/curl"
PATH="$tmpdir:${PATH:?}"
echo 1..21
pg='WorksForMe'
t 'http://c2.com/cgi-bin/wiki?WorksForMe'
t 'https://c2.com/cgi-bin/wiki?WorksForMe'
t 'http://c2.com/cgi/wiki?WorksForMe'
t 'https://c2.com/cgi/wiki?WorksForMe'
t 'http://www.c2.com/cgi-bin/wiki?WorksForMe'
t 'https://www.c2.com/cgi-bin/wiki?WorksForMe'
t 'http://www.c2.com/cgi/wiki?WorksForMe'
t 'https://www.c2.com/cgi/wiki?WorksForMe'
t 'http://wiki.c2.com/?WorksForMe'
t 'https://wiki.c2.com/?WorksForMe'
t 'WorksForMe'
pg='WelcomeVisitors'
t 'http://c2.com/cgi-bin/wiki'
t 'https://c2.com/cgi-bin/wiki'
t 'http://c2.com/cgi/wiki'
t 'https://c2.com/cgi/wiki'
t 'http://www.c2.com/cgi-bin/wiki'
t 'https://www.c2.com/cgi-bin/wiki'
t 'http://www.c2.com/cgi/wiki'
t 'https://www.c2.com/cgi/wiki'
t 'http://wiki.c2.com/'
t 'https://wiki.c2.com/'
rm -rf "$tmpdir"

# vim:ts=4 sts=4 sw=4 et ft=sh
