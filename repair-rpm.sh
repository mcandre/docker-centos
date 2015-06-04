#!/bin/sh

repair_db() {
  filename="$1"

  echo "Repairing ${filename}..."

  backup="${filename}.orig"
  mv $filename $backup
  db_dump $backup | db40_load $filename
  rm $backup
}

rm -rf /var/lib/rpm/__db*

for f in $(find /var/lib/rpm -name '[A-Z]*'); do
  repair_db "$f"
done

rpm -v --rebuilddb
