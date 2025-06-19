Snippets
========

Bash
----

- Find and delete all files that start with ti_session that havn't been modified for more than 30 days ('+' = as many filenames as possible are passed as arguments to a single command)
  - `find -type f -iname "ti_session*" -mtime +30 -exec rm {} +`

- Find and delete all files ending in .swp (';' = command is run once for each file)
  - `find . -iname "*.swp*" -exec rm {} \;`

- Find the 10 largest php files in a directory recursively (handles spaces in filenames)
  - `find . -name '*.php' -type f -print0 | xargs -0 ls -Ssh1 | sed 10q`

- Show file count (inodes) used per folder
  - `sudo find . -xdev -type f | cut -d "/" -f 2 | sort | uniq -c | sort -nr`

- Show memory stats (Linux)
  - `cat /proc/meminfo`

- Top 10 processes by memory usage
  - `ps aux | awk '{print $6/1024 " MB\t" $11}' | sort -nr | head -n10`

- AWK comparison/filter - print field 2 and 4 for lines where field 4 is greater than 0
  - `awk '$4 > 0 {print $2,$4}' file | sort -n -k2 -r | column -t`

- Show all cowfile pictures
  - `for f in `cowsay -l | sed "1d"`; do cowsay -f $f "I am $f"; done | less`

- Create and extract tar archive with gzip
  - `tar -zcvf archiveName.tar.gz folderName`
  - `tar -zxvf archiveName.tar.gz`

- Convert unix timestamp
    - date -r 1624104159

MySQL
-----

- Query by value in JSON
  - `SELECT * FROM tableName WHERE JSON_EXTRACT(columnName, "$.jsonKey") = "keyValue";`
- Select JSON value
  - `select JSON_EXTRACT(columnName, "$.jsonKey") from tableName;`

MongoDB
-------

- Delete index on collection
  - `db.runCommand({dropIndexes: "collection", index: "index_name"})`
- Group by and count (optionally filter first)
  - `db.collection.aggregate({$group: {_id: "$count_field", count: {$sum:1}}})`
  - `db.collection.aggregate([{$match: {filter_field: "value")}}, {$group: {_id: "$count_field", count: {$sum: 1}}}])`
- Convert ObjectId to Date
  - new Date(parseInt(ObjectId.substring(0, 8), 16) * 1000)

s3cmd
-----

- List latest file (filter by .sql.gz.enc extension) from each s3 Bucket / DigitalOcean Space (needs s3cmd)
  - `for i in $(s3cmd ls | awk '{print $3}'); do; s3cmd ls $i --recursive | grep ".sql.gz.enc" | sort --reverse --unique | head -n1 ; done | sort`
- Remove buckets that match a filter (deletes all contents and the bucket itself)
  - `for i in $(aws s3 ls | awk '{print $3}'| grep <<filter>>); do; aws s3 rm "s3://$i" --recursive && aws s3 rb "s3://$i"; done`

ssh
---

- Create a ssh tunnel from localhost:3000 to host:3000 (-f = background ssh, -N = no command)
  - `ssh user@host -NfL 3000:localhost:3000`
- Create a ssh tunnel from localhost:3389 to host and forward to otherhost:3389
  - `ssh user@host -NL 3389:otherhost:3389`

GitHub
------

- set diff mode, tab width and hide whitespaces changes in GitHub diffs
  - split - `javascript:location.href = location.origin + location.pathname + "?diff=split&w=1&ts=2";`
  - unified - `javascript:location.href = location.origin + location.pathname + "?diff=unified&w=1&ts=2";`
- make diffs fill the whole screen width
  - `javascript:document.body.classList.toggle('full-width');`

eslint
------

- run eslint against changed files
  - `eslint $(git diff --name-only HEAD | grep -E '\.(ts|tsx)$' | xargs)`

PHP
---

- dump to a file in the directory of the application
    - file_put_contents('dump.txt', $data);


Setup Basic Typescript Project
------------------------------

`npm init`
`npm install typescript prettier ts-node -D`
`npx tsc --init`
`npm init @eslint/config@latest`
`git init`
