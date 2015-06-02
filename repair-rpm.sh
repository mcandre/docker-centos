#!/bin/sh

repair_db() {
  filename="$1"

  echo "Repairing ${filename}..."

  backup="${filename}.orig"
  mv $filename $backup
  db_dump $backup | db_load $filename && \
		/usr/lib/rpm/rpmdb_verify $filename && \
		rm $backup
}

rm -rf /var/lib/rpm/__db*

for f in $(find /var/lib/rpm -name '[A-Z]*'); do
  repair_db "$f"
done

rpm -v --rebuilddb
