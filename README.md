# Snapshot downloader

## Summary

This repository contains a script and a Docker manifest that allow to download a Lotus snapshot that is at least N days old from the requester-pays Google storage.

## Environment variables

To configure the container, specify the following environment variables.

| Name | Description | Example value |
| --- | --- | ---|
| `GCP_BILLING_PROJECT` | GCP Billing project | `adminscripts-355709` |
| `GCP_STORAGE_URL` | URL to GCP storage containing snapshots | `gs://fil-mainnet-archival-snapshots/historical-exports` |
| `SNAPSHOT_LOCAL_PATH` | Local path to save the snapshot to | `latest.zst` (current directory) |
| `MIN_AGE` | Minimal snapshot age | `1` |
| `GOOGLE_APPLICATION_CREDENTIALS` | Path to service account credentials | `/credentials.json` |
