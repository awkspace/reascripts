function update_timer()
  length = reaper.GetProjectLength(-1)
  reaper.SNM_SetDoubleConfigVar("projtimeoffs", -length)
  reaper.UpdateTimeline()
end

function main()
  update_timer()
  reaper.defer(main)
end

function reset()
  reaper.SNM_SetDoubleConfigVar("projtimeoffs", orig_offset)
  reaper.UpdateTimeline()
end

orig_offset = reaper.SNM_GetDoubleConfigVar("projtimeoffs", -1)
reaper.atexit(reset)
main()
