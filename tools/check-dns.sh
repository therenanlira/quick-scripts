#!/bin/bash

GOOGLEDNS=8.8.8.8
LOCALDNS=0.0.0.0
ENDPOINTS="domain1.com.br domain2.com.br"

for ENDPOINT in $ENDPOINTS; do
    echo "Check $ENDPOINT"
    echo "CNAME external"
    dig @$GOOGLEDNS CNAME $ENDPOINT +short
    echo "A externa"
    dig @$GOOGLEDNS A origin-$ENDPOINT +short
    echo "A internal"
    dig @$LOCALDNS A $ENDPOINT +short
    echo ""
done
