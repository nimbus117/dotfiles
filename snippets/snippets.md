# Snippets


### Bash

* Find and delete all files that start with ti_session that havn't been modified for more than 30 days
  * `find -type f -iname "ti_session*" -mtime +30 -exec rm {} +`

* Find and delete all files ending in .swp
  * `find . -iname "*.swp*" -exec rm {} \;`

* Find the  10 largest php files in a directory recursively
  * `find ./ -iname "*.php" -printf "%s\t%p\n" | sort -nr | sed 10q`

* Show file count (inodes) used per folder
  * `sudo find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -nr`

* Show memory stats (Linux)
  * `cat /proc/meminfo`

* Top 10 processes by memory usage
  * `ps aux | awk '{print $6/1024 " MB\t" $11}' | sort -nr | head -n10`

* AWK comparison/filter - print field 2 and 4 for lines where field 4 is greater than 0
  * `awk '$4 > 0 {print $2,$4}' file | sort -n -k2 -r | column -t`

* Show all cowfile pictures
  * `for f in `cowsay -l | sed "1d"`; do cowsay -f $f "I am $f"; done | less`

* create and extract tar archive with gzip
  * `tar -zcvf archiveName.tar.gz folderName`
  * `tar -zxvf archiveName.tar.gz`

### MySQL

* Query by value in JSON
  * `SELECT * FROM tableName WHERE JSON_EXTRACT(columnName, "$.jsonKey") = "keyValue";`

### s3cmd

* List latest file (filter by .sql.gz.enc extension) from each s3 Bucket / DigitalOcean Space (needs s3cmd)
  * `for i in $(s3cmd ls | awk '{print $3}'); do; s3cmd ls $i --recursive | grep ".sql.gz.enc" | sort --reverse --unique | head -n1 ; done | sort`

