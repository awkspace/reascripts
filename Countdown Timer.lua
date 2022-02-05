function end_of_project()
  project_end = 0
  for i = 0, reaper.CountMediaItems()-1 do
    item = reaper.GetMediaItem(0, i)
    pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
    item_end = pos + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
    if item_end > project_end then
      project_end = item_end
    end
  end
  return project_end
end

function update_timer()
  reaper.SNM_SetDoubleConfigVar("projtimeoffs", -end_of_project())
  reaper.UpdateTimeline()
end

function main()
  update_timer()
  reaper.defer(main)
end

main()
