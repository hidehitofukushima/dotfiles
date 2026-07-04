#!/bin/bash

string="Hello"
cat << EOT
$string
\$string
EOT
