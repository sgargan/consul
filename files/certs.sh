#!/bin/bash

openssl genrsa -out consul.key 4096

openssl req -new -x509 -days 365 -key consul.key -subj '/C=US/ST=Somestate/L=sometown/O=somecompany/OU=someorg/CN=someguy' -out consul_ca.crt

openssl req -new -key consul.key -out consul.csr -subj '/C=US/ST=Somestate/L=sometown/O=somecompany/OU=someorg/CN=*'

openssl x509 -extfile openssl.conf -extensions ssl_client -req -days 365 -in consul.csr -CA consul_ca.crt -CAkey consul.key -out consul.crt -set_serial 01
