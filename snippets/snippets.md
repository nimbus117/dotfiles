# Snippets


### Bash

* Show inodes used per folder
  * `sudo find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -nr`

* List latest file (filter by .sql.gz.enc extension) from each s3 Bucket / DigitalOcean Space (needs s3cmd)
  * `for i in $(s3cmd ls | awk '{print $3}'); do; s3cmd ls $i --recursive | grep ".sql.gz.enc" | sort --reverse --unique | head -n1 ; done | sort`

* Show memory stats (Linux)
  * `cat /proc/meminfo`

* Top 10 processes by memory usage
  * `ps aux | awk '{print $6/1024 " MB\t" $11}' | sort -nr | head -n10`

* Find the  10 largest php files in a directory recursively
  * `find ./ -iname "*.php" -printf "%s\t%p\n" | sort -nr | sed 10q`

### MySQL

* Query by value in JSON
  * `SELECT * FROM tableName WHERE JSON_EXTRACT(columnName, "$.jsonKey") = "keyValue";`
