#!/usr/bin/env bash

# Copyright © 2022 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

set -e -u

if [ -z "${C2_DL_NETWORK_TESTING-}" ]
then
    echo '1..0 # SKIP set C2_DL_NETWORK_TESTING=1 to enable tests that exercise network'
    exit 0
fi

pdir="${0%/*}/.."
prog="$pdir/c2-dl"

i=0
t()
{
    i=$((i + 1))
    out=$("$prog" "$@")
    if [[ "$out" = "$xout"* ]]
    then
        echo "ok $i $*"
    else
        # shellcheck disable=SC2001
        sed -e 's/^/# /' <<< "$out"
        echo "not ok $i $*"
    fi
}

echo 1..21
xout='A certain type of response by a developer to a known defect.'
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
xout='Welcome to the WikiWikiWeb, also known as "Wiki".'
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

# vim:ts=4 sts=4 sw=4 et ft=sh
