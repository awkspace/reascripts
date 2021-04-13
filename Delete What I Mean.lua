rewind_buffer = 2.0

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

cur_pos = reaper.GetCursorPosition()
-- Check if ripple editing is on
if reaper.SNM_GetIntConfigVar("projripedit", -666) == 1 then

  if reaper.GetPlayState() == 1 then
    if cur_pos > start_time - rewind_buffer then
      reaper.SetEditCurPos(start_time - rewind_buffer, true, true)
      reaper.SetEditCurPos(cur_pos, false, false)
    end
  else
    reaper.SetEditCurPos(start_time, true, true)
    reaper.SetEditCurPos(start_time, false, false)
  end

end
