mutate(date_death = if_else(outcome == "Death", date_outcome, NA_real_))
