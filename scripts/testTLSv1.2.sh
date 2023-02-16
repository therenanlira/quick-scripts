#!/bin/bash

ENDPOINTS="domain1.com.br domain2.com.br"

for ENDPOINT in $ENDPOINTS; do
  nmap --script ssl-enum-ciphers -p 443 $ENDPOINT | grep TLSv1.2 > /dev/null;
  if [ $? -eq 0 ]; then
    echo $ENDPOINT OK;
    else
    echo $ENDPOINT NOK;
  fi
done
