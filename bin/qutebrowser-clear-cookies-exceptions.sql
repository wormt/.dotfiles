#!/usr/bin/sqlite3
DELETE from Cookies
WHERE host_key NOT IN (
'example.com',
);
