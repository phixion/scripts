# Here's the whole flow from just a pair of username/password to using the local API

## Prerequisites

- grpcurl
- proto files
- jq

### 1. Get an access token with the script

- Download get_tokens.py
- Fill in username and password

```bash
python3 get_tokens.py
# Note down the access token printed.
```

### 2. Use the access token and get home graph

This prints the json and uses jq to parse and filter out the fields deviceName and localAuthToken
This will give a list of all devices and their local auth tokens

```bash
./grpcurl -H 'authorization: Bearer ya29.a0Af****' \
  -import-path /path/to/protos \
  -proto /path/to/protos/google/internal/home/foyer/v1.proto \
  googlehomefoyer-pa.googleapis.com:443 \
  google.internal.home.foyer.v1.StructuresService/GetHomeGraph | jq '.home.devices[] | {deviceName, localAuthToken}'
# Note down the local auth token for the device you want.
```

### 3. Make calls to the local device using the local auth token

```bash
# example for a GET get bluetooth status
curl -H "cast-local-authorization-token: LOCAL_AUTH_TOKEN" \
--verbose --insecure https://192.168.0.18:8443/setup/bluetooth/status
```

```bash
# example for a POST: connect to a bluetooth device
curl -H "cast-local-authorization-token: LOCAL_AUTH_TOKEN" \
-H "Content-Type: application/json" \
-X POST -d '{"mac_address":"c4:30:18:4a:d5:59","connect": true,"profile": 2}' \
--insecure --verbose https://192.168.0.18:8443/setup/bluetooth/connect
```

Full API Doc: <https://rithvikvibhu.github.io/GHLocalApi/>
