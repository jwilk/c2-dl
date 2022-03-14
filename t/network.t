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
    url="$1"
    xout="$2"
    out=$("$prog" "$url")
    if [[ "$out" = "$xout"* ]]
    then
        echo "ok $i $url"
    else
        # shellcheck disable=SC2001
        sed -e 's/^/# /' <<< "$out"
        echo "not ok $i $url"
    fi
}

echo 1..2
t 'https://wiki.c2.com/?WorksForMe' 'A certain type of response by a developer to a known defect.'
t 'https://wiki.c2.com/' 'Welcome to the WikiWikiWeb, also known as "Wiki".'

# vim:ts=4 sts=4 sw=4 et ft=sh
