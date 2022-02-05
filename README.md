# awk’s Reaper scripts

## Delete What I Mean

Meant to be bound to the delete key (surprise!)

If the time selection is active, it deletes what is under the time selection.
Otherwise it will delete the selected item(s).

If ripple editing is enabled, the script will rewind the playhead to where the
deletion occurred. If ripple editing is enabled, the playhead is past the
deletion point, and the recording is playing back, the script rewinds the
playhead two seconds before the deletion point for a quick review of the
removal. Otherwise it will leave the playhead alone.

## Countdown Timer

Turns the transport timer into a countdown to the end of the project, as
determined by the end of the last item in the project.
