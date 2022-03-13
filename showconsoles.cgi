#!/bin/bash

echo -e "Content-type: text/html\n\n"

echo "<h1>Consoles attached to $(hostname)</h1>"
echo "date $(date)"
echo "<pre>"
ls -l /dev/tty_* | awk '{ print $9,"\t",$6,$7,$8 }' | sed -e 's!/dev/!!'
echo "</pre>"
