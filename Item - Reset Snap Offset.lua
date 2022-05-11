for i=0, reaper.CountSelectedMediaItems()-1 do
  item = reaper.GetSelectedMediaItem(0,i)
  reaper.SetMediaItemInfo_Value(item, "D_SNAPOFFSET", 0.0)
end

reaper.UpdateArrange()
