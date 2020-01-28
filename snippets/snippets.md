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

- create and extract tar archive with gzip
  - `tar -zcvf archiveName.tar.gz folderName`
  - `tar -zxvf archiveName.tar.gz`

MySQL
-----

- Query by value in JSON
  - `SELECT * FROM tableName WHERE JSON_EXTRACT(columnName, "$.jsonKey") = "keyValue";`
- Select JSON value
  - `select JSON_EXTRACT(columnName, "$.jsonKey") from tableName;`

MongoDB
-------

- MongoDB shell enhancements
  - `npm install -g mongo-hacker`
- Delete index on collection
  - `db.runCommand({dropIndexes: "collection", index: "index_name"})`
- Delete document in collection
  - `db.collection.deleteOne({_id:ObjectId("5d70db81ec87c23ac2776fb2")})`
- Find and return only the selected fields of all documents in the collection
  - `db.collection.find({}, {"field_name": 1})`
- Group by and count (optionally filter first)
  - `db.collection.aggregate({$group: {_id: "$count_field", count: {$sum:1}}})`
  - `db.collection.aggregate([{$match: {filter_field: "value")}}, {$group: {_id: "$count_field", count: {$sum: 1}}}])`

s3cmd
-----

- List latest file (filter by .sql.gz.enc extension) from each s3 Bucket / DigitalOcean Space (needs s3cmd)
  - `for i in $(s3cmd ls | awk '{print $3}'); do; s3cmd ls $i --recursive | grep ".sql.gz.enc" | sort --reverse --unique | head -n1 ; done | sort`
- Remove buckets that match a filter (deletes all contents and the bucket itself)
  - `for i in $(aws s3 ls | awk '{print $3}'| grep <<filter>>); do; aws s3 rm "s3://$i" --recursive && aws s3 rb "s3://$i"; done`

ssh
---

- Create an ssh tunnel from localhost:3000 to host:3000
  - `ssh user@host -L 3000:localhost:3000 -Nf`

GitHub
------

- set diff mode, tab width and hide whitespaces changes in GitHub diffs
  - split - `javascript:location.href = location.origin + location.pathname + "?diff=split&w=1&ts=2";`
  - unified - `javascript:location.href = location.origin + location.pathname + "?diff=unified&w=1&ts=2";`
- make diffs fill the whole screen width
  - `javascript:document.body.classList.toggle('full-width');`
