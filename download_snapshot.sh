#!/bin/bash

export GCP_BILLING_PROJECT="adminscripts-355709";
export GCP_STORAGE_URL="gs://fil-mainnet-archival-snapshots/historical-exports"
export SNAPSHOT_LOCAL_PATH="latest.zst"
export MIN_AGE=2;

function get_current_timestamp {
    date +"%s";
}

function hours_to_seconds {
    local HOURS=$1;
    echo $(( $HOURS * 60 * 60 ));
}

function list_snapshots {
    gcloud storage --billing-project=$GCP_BILLING_PROJECT ls $GCP_STORAGE_URL;
}

function extract_timestamp {
    local URL=$1;

    echo $URL | cut -d "_" -f 4 | cut -d "." -f 1
}

function download_snapshot {
    local URL=$1;

    gcloud storage --billing-project=$GCP_BILLING_PROJECT cp $URL $SNAPSHOT_LOCAL_PATH;
}


# Save current timestamp for consistency
NOW=$(get_current_timestamp);

# The number of seconds in a day
ONE_DAY=$(hours_to_seconds 24);

# End with snapshots that are 1 day old
END_TIMESTAMP=$(( $NOW - $MIN_AGE * $ONE_DAY ))

# Start with snapshots that are 2 days old
START_TIMESTAMP=$(( $END_TIMESTAMP - $ONE_DAY ));



# Save snapshots list for consistency and efficiency
echo "List existing snapshots...";
SNAPSHOTS=$(list_snapshots)
SNAPSHOTS_COUNT=$(echo "$SNAPSHOTS" | wc -l)
echo "Found $SNAPSHOTS_COUNT snapshots.";

echo "Start timestamp: $START_TIMESTAMP";
echo "End timestamp: $END_TIMESTAMP";

for URL in $SNAPSHOTS; do
    SNAPSHOT_TIMESTAMP=$(extract_timestamp $URL)
    if [ $SNAPSHOT_TIMESTAMP -gt $START_TIMESTAMP ] && [ $SNAPSHOT_TIMESTAMP -lt $END_TIMESTAMP ]; then
        echo "Selected snapshot: $URL";
        echo "Downloading the snapshot to $SNAPSHOT_LOCAL_PATH...";
        download_snapshot $URL;
        echo "Done.";
    fi
done
