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
  reaper.SNM_SetDoubleConfigVar("projtimeoffs", 0)
  reaper.UpdateTimeline()
end

reaper.atexit(reset)
main()
