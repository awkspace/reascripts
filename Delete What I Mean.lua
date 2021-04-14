rewind_buffer = 5.0

-- Check if a time range has been selected
start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

if start_time ~= end_time then

  -- Unselect all items
  reaper.SelectAllMediaItems(0,0)

  -- Check if ripple editing is on
  if reaper.SNM_GetIntConfigVar("projripedit", -666) == 1 then

    -- Remove contents of time selection
    reaper.Main_OnCommand(40201, 0)

  else

    -- Split items at time selection (bug: generates undo)
    reaper.Main_OnCommand(40061, 0)

    -- Select all items in current time selection
    reaper.Main_OnCommand(40717, 0)

    -- Remove time selection
    reaper.GetSet_LoopTimeRange(true, false, start_time, start_time, false)

  end

else

  if reaper.CountSelectedMediaItems() > 0 then
    item = reaper.GetSelectedMediaItem(0,0)
    start_time = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
  end

end

-- Perform delete
reaper.Main_OnCommand(40697, 0)

edit_pos = reaper.GetCursorPosition()
play_pos = reaper.GetPlayPosition()
-- Check if ripple editing is on
if reaper.SNM_GetIntConfigVar("projripedit", -666) == 1 then

  if reaper.GetPlayState() == 1 then
    if play_pos > start_time - rewind_buffer then
      -- Move playhead
      reaper.SetEditCurPos(start_time - rewind_buffer, true, true)
      -- Restore edit cursor
      reaper.SetEditCurPos(edit_pos, false, false)
    end
  else
    reaper.SetEditCurPos(start_time, true, true)
  end

end
