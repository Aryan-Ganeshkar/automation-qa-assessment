#!/usr/bin/env bash
# Reproduces the Task 1 bugs against the gothinkster Django RealWorld backend.
# Start backend first: python manage.py runserver 127.0.0.1:8000
B=${B:-http://localhost:8000/api}; H='Content-Type: application/json'
reg(){ curl -s -X POST $B/users -H "$H" -d "{\"user\":{\"username\":\"$1\",\"email\":\"$1@t.com\",\"password\":\"password123\"}}"; }
tok(){ python3 -c 'import sys,json;print(json.load(sys.stdin)["user"]["token"])'; }
TA=$(reg ua$RANDOM | tok); TB=$(reg ub$RANDOM | tok)
SLUG=$(curl -s -X POST $B/articles -H "$H" -H "Authorization: Token $TA" -d '{"article":{"title":"Owned by A","description":"d","body":"b"}}' | python3 -c 'import sys,json;print(json.load(sys.stdin)["article"]["slug"])')
echo "#1 B edits A's article (expect 403):"; curl -s -o /dev/null -w "%{http_code}\n" -X PUT $B/articles/$SLUG -H "$H" -H "Authorization: Token $TB" -d '{"article":{"body":"HACKED"}}'
echo "#4 DELETE article (expect 204):"; curl -s -o /dev/null -w "%{http_code}\n" -X DELETE $B/articles/$SLUG -H "Authorization: Token $TA"
echo "#3 feed (expect 200):"; curl -s -o /dev/null -w "%{http_code}\n" $B/articles/feed -H "Authorization: Token $TA"
echo "#5 weak password (expect 422):"; curl -s -o /dev/null -w "%{http_code}\n" -X PUT $B/user -H "$H" -H "Authorization: Token $TB" -d '{"user":{"password":"1"}}'
echo "#7 no auth (expect 401):"; curl -s -o /dev/null -w "%{http_code}\n" $B/user
echo "#10 comments unknown article (expect 404):"; curl -s -o /dev/null -w "%{http_code}\n" $B/articles/does-not-exist/comments
