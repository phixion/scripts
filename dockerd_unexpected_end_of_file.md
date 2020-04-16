# Issue

While running `docker container logs` you see errors such as this:

    Error streaming logs: invalid character ':' after object key:value pair

or:

    Error streaming logs: invalid character 'e' in string escape code

where the more general format is:

    Error streaming logs: invalid character

or:

    got error while decoding json error="unexpected EOF"

followed by a single character delimited by single quotes, followed by (but not necessarily limited to) one of:

- `after object key:value pair`
- `after object key`
- `in string escape code`
- `looking for beginning of value`

##### Prerequisites

Before performing these steps, you must meet the following requirements:

- You must be using the [JSON File logging driver](https://docs.docker.com/config/containers/logging/json-file/) (which is the default unless otherwise specified)

##### Root Cause

`The cause appears to be most likely the result of an ungraceful shutdown, corrupting one or more container log files. When the container is started back up (eg, after an OS reboot), the engine's JSON log file parser is at odds with the contents of the logfile, resulting in the reported errors.`

##### Resolution

Rather than attempt to reconstruct the corrupted logs, the best and quickest approach to recovery is as follows:

1.Identify the corrupted files (as root):

      for FILE in /var/lib/docker/containers/*/*-json.log
      do
          jq '.' $FILE >/dev/null || echo "CORRUPT: $FILE"
      done

2.Stop the engine:

      systemctl stop docker

depending on your OS.

3.(Optional) Make a backup copy of the corrupted log files (as reported by the script above).

4.Zero out the corrupted log files by executing the following for each corrupted log file:

      cat /dev/null > /path/to/corrupted/logfile

5.(Optional) Set `json-file` log limits in `/etc/docker/daemon.json`. For example:

      {
        "log-driver": "json-file",
        "log-opts": {"max-size": "10m", "max-file": "3"}
      }

6.Start the engine:

      systemctl start docker

or

      service docker start

depending on your OS.
