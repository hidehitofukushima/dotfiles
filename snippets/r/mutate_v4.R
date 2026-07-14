mutate(source_known = ifelse(!is.na(source), "known", "unknown"))
