---@diagnostic disable: undefined-global

return {
	s("date", t(os.date("%Y-%m-%d"))),
	s("mail", t("hidehitofukushima@gmail.com")),
	s("(", { t("("), i(1), t(")") }),
	s("[", { t("["), i(1), t("]") }),
	s("{", { t("{"), i(1), t("}") }),
	s("$", { t("$"), i(1), t("$") }),
	s({ trig = "heiso", snippetType = "autosnippet" },
		fmta([[
<>
平素より大変お世話になっております。福島です。
<>
大変お手数おかけしてしまい恐縮でございますが、何卒よろしくお願い申し上げます。
福島　拝
		]], { i(1), i(2) })
	),
}


