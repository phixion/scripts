#!/bin/bash
# DEBUG: Be verbosy
# DRY_RUN: Don't update db
# CHECK: Check 'all' devices or only devices with 'alarms'
# fixes unifi SSH Host Key Verification Error
# see https://community.ui.com/questions/Failed-SSH-host-key-verification/9dba0454-9a46-47f1-8b60-210a9fc5370f#answer/419dba22-2810-4e00-8202-1df91a6a5edb

[[ -n "$DEBUG" ]] && set -x
CHECK=${CHECK:-all}

uni_mongo() {
    mongo --port 27117 --quiet --eval "$*" ace
}

all() {
    mongo_script=$(
        cat <<-'MONGO'
db.device.find().forEach( function(device) {
   print(`devSite='${device["site_id"]}' devName='${device["name"]}' devMAC='${device["mac"]}' devIP='${device["ip"]}' devKey='${device["x_ssh_hostkey"]}' devFp='${device["x_ssh_hostkey_fingerprint"]}'`);

});
MONGO
    )

    uni_mongo "$mongo_script"
}

alarms() {
    #$match alarms archived: false
    mongo_script=$(
        cat <<-'MONGO'
alarmed = db.alarm.aggregate([
   { $match: {key: { $regex: "EVT_[^_]+_HostKeyMismatch"}} },
   { $project: {
           "_id": false,
           "name": { $ifNull: ["$ap_name", { $ifNull: [ "$gw_name", "$sw_name" ]}] },
           "mac": { $ifNull: ["$ap", { $ifNull: [ "$gw", "$sw" ]}] },
           "site_id": true
       }},
   { $group: {
           "_id": { site_id: "$site_id", "mac": "$mac" },
           "name": { $last: "$name" }
       }},
   { $project: {
           "_id": false,
           "site_id": "$_id.site_id",
           "name": true,
           "mac": "$_id.mac"
       }},
   { $sort: { site_id: 1, name: 1 }}
]);

while(alarmed.hasNext()) {
   adev = alarmed.next();
   dev = db.device.find({ "site_id": adev["site_id"], "mac": adev["mac"] }, { "_id": false, "ip": true, "x_ssh_hostkey": true, "x_ssh_hostkey_fingerprint": true }).next();
   print(`devSite='${adev["site_id"]}' devName='${adev["name"]}' devMAC='${adev["mac"]}' devIP='${dev["ip"]}' devKey='${dev["x_ssh_hostkey"]}' devFp='${dev["x_ssh_hostkey_fingerprint"]}'`);

}
MONGO
    )

    uni_mongo "$mongo_script"
}

{
    case "$CHECK" in
    all) all ;;
    alarms) alarms ;;
    *)
        echo "Wrong CHECK"
        exit 1
        ;;
    esac
} | while read -r device; do
    unset devSite devKey devFp devName devIP devMAC devNFp devNKey

    eval "$device"
    echo -n "Checking device ${devName}... "

    devNKey=$(ssh-keyscan -t ssh-rsa "$devIP" 2>/dev/null)
    devNFp=$(echo "$devNKey" | ssh-keygen -lf - | cut -d' ' -f2)
    devNKey=$(echo "$devNKey" | cut -d' ' -f3)
    [[ -n "$devNKey" || -n "$devNFp" ]] || {
        echo "Unable to retrieve new key from $devIP!"
        continue
    }

    # echo -n "Compare \"$devKey\" to \"$devNKey\" "
    # echo -n "Compare \"$devFp\" to \"$devNFp\" "

    [[ "$devKey" == "$devNKey" && "$devFp" == "$devNFp" ]] && {
        echo "Key from $devIP in records seems fine"
        continue
    }

    echo "Device $devName was compromised!"
    [[ -z "$DRY_RUN" ]] || continue

    query='{site_id: "'$devSite'", mac: "'$devMAC'"}'
    update='{ $set: { x_ssh_hostkey: "'$devNKey'", x_ssh_hostkey_fingerprint: "'$devNFp'" }}'

    uni_mongo "db.device.update($query, $update)"
done
