#!/usr/bin/python
import json
import requests

# Note: Change localhost to the correct IP if needed.
r = requests.get('http://localhost/admin/api.php')
rstats = json.loads(r.text)

stats = {}
for x in rstats:
    stats[x] = float(rstats[x].replace(',', ''))

print json.dumps(stats)