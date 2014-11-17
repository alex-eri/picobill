#!/bin/sh 

DBFILE=$(uci get pico.radius.dbfile)
[ -z $DBFILE ] && uci set pico.radius.dbfile=/pico/db/radius.db

SCHEMA=$(uci get pico.radius.schema)
[ -z $SCHEMA ] && uci set pico.radius.schema=/pico/sql/radius.sql

BILDBFILE=$(uci get pico.billing.dbfile)
[ -z $BILDBFILE ] && uci set pico.billing.dbfile=/pico/db/billing.db

BILSCHEMA=$(uci get pico.billing.schema)
[ -z $BILSCHEMA ] && uci set pico.billing.schema=/pico/sql/billing.sql

uci commit pico

[ -n $DBFILE ] && [ -n $SCHEMA ] && [[ -f $DBFILE ]] || cat $SCHEMA | sqlite3 $DBFILE
[ -n $BILDBFILE ] && [ -n $BILSCHEMA ] && [[ -f $BILDBFILE ]] || cat $BILSCHEMA | sqlite3 $BILDBFILE
