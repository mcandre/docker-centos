#!/bin/sh

repair_db() {
  filename="$1"

  echo "Repairing ${filename}..."

  backup="${filename}.orig"
  mv $filename $backup
  db_dump $backup | db33_load $filename
  rm $backup
}

rm -rf /chroot/var/lib/rpm/__db*

for f in $(find /chroot/var/lib/rpm -name '[A-Z]*'); do
  repair_db "$f"
done

chroot /chroot rpm -v --rebuilddb
