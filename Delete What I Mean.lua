buffer = 2.0

-- check if a time range has been selected
loop_set = false
loop_start = 0
start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

if start_time ~= end_time then

  -- Remove contents of time selection
  reaper.Main_OnCommand(40201, 0)
  
  -- Unselect all items
  reaper.SelectAllMediaItems(0,0)

else

  if reaper.CountSelectedMediaItems() > 0 then
    item = reaper.GetSelectedMediaItem(0,0)
    start_time = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
  end 
  
  -- perform delete
  reaper.Main_OnCommand(40697, 0)
  
end

cur_pos = reaper.GetCursorPosition()
-- check if ripple editing is on
if reaper.SNM_GetIntConfigVar("projripedit", -666) == 1 then

  if reaper.GetPlayState() == 1 then
    if cur_pos > start_time - buffer then
      reaper.SetEditCurPos(start_time - buffer, true, true)
      reaper.SetEditCurPos(cur_pos, false, false)
    end
  else
    reaper.SetEditCurPos(start_time, true, true)
    reaper.SetEditCurPos(start_time, false, false)
  end
 
end
