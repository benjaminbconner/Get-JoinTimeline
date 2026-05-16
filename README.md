# Get-JoinTimeline

## Overview

This PowerShell script collects and correlates Windows Task Scheduler and Device Registration logs to help analyze Hybrid Azure AD Join behavior during device setup.

The script is designed to build a timeline of when the Automatic-Device-Join task runs and how the device responds during enrollment.

This is useful for troubleshooting scenarios where device join does not complete on the first attempt or appears delayed.

---

## What It Does

- Collects recent Task Scheduler events related to:
- Automatic-Device-Join
- Collects Device Registration events from:
- Microsoft-Windows-User Device Registration/Admin
- Filters events to a recent time window (default: last 2 hours)
- Combines and sorts events into a single timeline
- Exports results to a CSV file for analysis

---

## Use Case

This script is intended for:

- Device enrollment troubleshooting
- Hybrid Azure AD Join timing analysis
- Validating join behavior across multiple devices
- Collecting evidence for pattern-based issues

---

## Output

The script generates a CSV file with:

- TimeCreated
- Event ID
- Log source
- Message

Example output location:


C:\Temp\DeviceJoinTimeline_YYYYMMDD_HHMMSS.csv
