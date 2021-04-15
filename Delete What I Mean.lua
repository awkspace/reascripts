rewind_buffer = 5.0
adaptive_delete = reaper.NamedCommandLookup("_XENAKIOS_TSADEL")
start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

-- Check if a time range has been selected
if start_time ~= end_time then

  -- Lock UI updates
  reaper.PreventUIRefresh(1)

  -- Store the currently selected item(s)
  sel_items = {}
  for i=1, reaper.CountSelectedMediaItems() do
    sel_items[i] = reaper.GetSelectedMediaItem(0,i)
  end

  -- Unselect all items
  reaper.SelectAllMediaItems(0,0)

  if reaper.CountTracks() < 2 or reaper.SNM_GetIntConfigVar("projripedit", -1) == 2 then
    if reaper.SNM_GetIntConfigVar("projripedit", -1) > 0 then
      -- Remove contents of time selection (single undo)
      reaper.Main_OnCommand(40201, 0)

    else
      -- Split items at time selection
      reaper.Main_OnCommand(40061, 0)

      -- Select all items in current time selection
      reaper.Main_OnCommand(40717, 0)

      -- Perform delete
      reaper.Main_OnCommand(40697, 0)
    end
  else
    -- Select all items in time selection
    reaper.Main_OnCommand(40717, 0)

    tracks = {}
    -- Try to guess what track this delete should refer to
    i = 0
    while (i < reaper.CountSelectedMediaItems()) do
      deselect = false

      item = reaper.GetSelectedMediaItem(0,i)
      -- Deselect if muted
      if reaper.GetMediaItemInfo_Value(item, "B_MUTE") == 1 then
        deselect = true
      end
      -- Deselect if no take
      if reaper.GetActiveTake(item) == nil then
        deselect = true
      end

      track = reaper.GetMediaItem_Track(item)
      -- Deselect if track muted
      if reaper.GetMediaTrackInfo_Value(track, "B_MUTE") == 1 then
        deselect = true
      end
      if reaper.AnyTrackSolo() and reaper.GetMediaTrackInfo_Value(track, "I_SOLO") == 0 then
        deselect = true
      end

      -- Perform deselect
      if deselect then
        reaper.SetMediaItemInfo_Value(item, "B_UISEL", 0)
      else
        -- This track will be modified
        tracks[reaper.GetMediaItemTrack(item)] = true
        i = i + 1
      end
    end
    tracks_to_modify = 0
    for track_id, will_modify in pairs(tracks) do
      if will_modify then
        tracks_to_modify = tracks_to_modify + 1
      end
    end

    if tracks_to_modify > 1 and not reaper.AnyTrackSolo() then
      -- No reasonable guess could be made. Restore previous selections
      reaper.SelectAllMediaItems(0,0)
      for idx, selection in pairs(sel_items) do
        reaper.SetMediaItemInfo_Value(item, "B_UISEL", true)
      end
    end

    -- Adaptive delete
    reaper.Main_OnCommand(adaptive_delete, 0)
  end

  -- Remove time selection
  reaper.GetSet_LoopTimeRange(true, false, start_time, start_time, false)

  -- Unselect all items
  reaper.SelectAllMediaItems(0,0)

  -- Unlock UI updates
  reaper.PreventUIRefresh(-1)

else

  if reaper.CountSelectedMediaItems() > 0 then
    item = reaper.GetSelectedMediaItem(0,0)
    start_time = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
  end

  -- Perform delete
  reaper.Main_OnCommand(40697, 0)

end

edit_pos = reaper.GetCursorPosition()
play_pos = reaper.GetPlayPosition()

-- Check if ripple editing is on
if reaper.SNM_GetIntConfigVar("projripedit", -1) > 0 then

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
