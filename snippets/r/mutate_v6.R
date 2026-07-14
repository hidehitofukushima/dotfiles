mutate(age_years = case_when(
                             age_unit == "years"  ~ age,       # 年齢が年単位の場合
                             age_unit == "months" ~ age/12,    # 年齢が月単位の場合、値を 12 で割る
                             is.na(age_unit)      ~ age)) 
