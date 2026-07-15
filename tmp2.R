# ============================================================
# Mock mutation frequency figure
# ggplot2 + patchwork version
# ============================================================

# install.packages(c("tidyverse", "patchwork", "svglite", "scales"))

suppressPackageStartupMessages({
  library(tidyverse)
  library(patchwork)
  library(svglite)
  library(scales)
})

set.seed(1234)

# ============================================================
# 1. Figure structure
# ============================================================

genes <- c(
           "IKZF1", "CDKN2A", "CDKN2B", "PAX5", "BTG1",
           "BTLA", "CD200", "ADD3", "RB1", "CHD4",
           "SLX4IP", "CBWD2", "ETV6", "ATP10A", "EBF1",
           "LEMD3", "TSC22D1", "EP300", "MEF2C", "SETD2",
           "TP53", "XBP1", "ARMC2", "ARPP21", "HDAC7",
           "SERP2", "TOX", "FHIT", "KMT2D", "RUNX1",
           "CXCR4", "NR3C1", "SESN1", "TCF4", "ARID2",
           "ATF7IP", "CDKN1B", "CREBBP", "FLNB", "FLT3",
           "KDM6A", "MBNL1", "TCF12", "CDK6", "CTCF",
           "ERG", "KIAA1958", "KMT2A", "KRAS", "NF1"
)

subtype_counts <- tribble(
                          ~subtype,            ~n,
                          "B-other",            15,
                          "BCL2/MYC",            3,
                          "DUX4",                3,
                          "HLF",                 1,
                          "Hyperdiploid",        7,
                          "KMT2A",               3,
                          "Low hypodiploid",     1,
                          "MEF2D",               1,
                          "PAX5 P80R",           1,
                          "PAX5alt",             9,
                          "Ph+",                54,
                          "Ph-like",             3,
                          "TCF3-PBX1",           1,
                          "ZNF384",             15,
                          "ZNF384-like",         2,
                          "iAMP21",              1
)

display_subtypes <- subtype_counts$subtype

# 元figureに近づけるため、表示subtype合計120例 + hidden 6例 = all 126例にする
total_n <- 126
hidden_n <- total_n - sum(subtype_counts$n)

# ============================================================
# 2. Mock patient table
# ============================================================

case_df_display <- subtype_counts |>
  mutate(subtype_clean = str_replace_all(subtype, "[^A-Za-z0-9]+", "_")) |>
  tidyr::uncount(n, .id = "within_subtype") |>
  group_by(subtype) |>
  mutate(
         case_id = sprintf("%s_%03d", first(subtype_clean), row_number())
         ) |>
  ungroup() |>
  select(case_id, subtype)

case_df_hidden <- if (hidden_n > 0) {
  tibble(
         case_id = sprintf("Other_%03d", seq_len(hidden_n)),
         subtype = "Other/Unclassified"
  )
} else {
  tibble(case_id = character(), subtype = character())
}

case_df <- bind_rows(case_df_display, case_df_hidden)

# subtype annotation for top labels
subtype_meta <- bind_rows(
                          subtype_counts,
                          tibble(subtype = "all", n = nrow(case_df))
                          ) |>
mutate(col = row_number())

            # gene annotation for y positions
            # rowが大きいほど上に表示される
            gene_meta <- tibble(
                                gene = genes,
                                gene_rank = seq_along(genes),
                                row = rev(seq_along(genes)),
                                base_prob = pmax(0.015, 0.32 * exp(-(gene_rank - 1) / 15))
            )

# ============================================================
# 3. Mock probability model
# ============================================================

subtype_effect <- tribble(
                          ~subtype,              ~mult,
                          "B-other",             0.85,
                          "BCL2/MYC",            0.80,
                          "DUX4",                0.75,
                          "HLF",                 0.65,
                          "Hyperdiploid",        0.75,
                          "KMT2A",               0.80,
                          "Low hypodiploid",     0.90,
                          "MEF2D",               0.65,
                          "PAX5 P80R",           0.75,
                          "PAX5alt",             1.05,
                          "Ph+",                 1.25,
                          "Ph-like",             1.05,
                          "TCF3-PBX1",           0.65,
                          "ZNF384",              1.00,
                          "ZNF384-like",         0.80,
                          "iAMP21",              0.75,
                          "Other/Unclassified",  0.45
)

# ここで「それっぽい」subtype-specific enrichmentを入れる
hotspots <- tribble(
                    ~gene,      ~subtype,            ~extra,

                    "IKZF1",   "Ph+",                 0.45,
                    "IKZF1",   "Ph-like",             0.35,
                    "IKZF1",   "iAMP21",              0.35,
                    "IKZF1",   "ZNF384",              0.15,

                    "CDKN2A",  "Ph+",                 0.35,
                    "CDKN2A",  "Ph-like",             0.35,
                    "CDKN2A",  "PAX5alt",             0.25,
                    "CDKN2A",  "BCL2/MYC",            0.18,

                    "CDKN2B",  "Ph+",                 0.32,
                    "CDKN2B",  "Ph-like",             0.30,
                    "CDKN2B",  "PAX5alt",             0.18,

                    "PAX5",    "PAX5alt",             0.55,
                    "PAX5",    "PAX5 P80R",           0.70,
                    "PAX5",    "Ph+",                 0.20,

                    "BTG1",    "Ph+",                 0.25,
                    "BTG1",    "ZNF384",              0.25,
                    "BTG1",    "PAX5alt",             0.18,

                    "BTLA",    "Ph+",                 0.22,
                    "BTLA",    "PAX5alt",             0.18,
                    "BTLA",    "iAMP21",              0.35,

                    "CD200",   "Ph+",                 0.20,
                    "CD200",   "PAX5alt",             0.20,

                    "ADD3",    "Ph+",                 0.20,
                    "ADD3",    "PAX5alt",             0.15,

                    "RB1",     "Low hypodiploid",     0.70,
                    "RB1",     "Ph+",                 0.15,
                    "RB1",     "ZNF384",              0.22,

                    "CHD4",    "PAX5alt",             0.25,
                    "CHD4",    "ZNF384",              0.30,

                    "ETV6",    "B-other",             0.20,
                    "ETV6",    "ZNF384",              0.35,
                    "ETV6",    "ZNF384-like",         0.35,

                    "ATP10A",  "KMT2A",               0.40,
                    "ATP10A",  "Ph+",                 0.20,

                    "EBF1",    "PAX5alt",             0.20,
                    "EBF1",    "ZNF384",              0.25,
                    "EBF1",    "iAMP21",              0.35,

                    "TSC22D1", "Ph+",                 0.18,
                    "TSC22D1", "Ph-like",             0.18,

                    "EP300",   "ZNF384",              0.22,

                    "MEF2C",   "B-other",             0.18,
                    "MEF2C",   "BCL2/MYC",            0.15,

                    "SETD2",   "Ph+",                 0.18,
                    "SETD2",   "iAMP21",              0.28,

                    "TP53",    "Low hypodiploid",     0.85,
                    "TP53",    "Hyperdiploid",        0.20,

                    "XBP1",    "Ph+",                 0.18,
                    "XBP1",    "iAMP21",              0.28,

                    "ARMC2",   "ZNF384",              0.22,
                    "ARPP21",  "Ph-like",             0.20,
                    "HDAC7",   "KMT2A",               0.25,
                    "SERP2",   "Ph-like",             0.25,

                    "KMT2D",   "ZNF384",              0.25,
                    "RUNX1",   "iAMP21",              0.35,
                    "CXCR4",   "iAMP21",              0.30,
                    "NR3C1",   "PAX5alt",             0.18,
                    "SESN1",   "ZNF384",              0.24,

                    "ARID2",   "KMT2A",               0.25,
                    "ATF7IP",  "BCL2/MYC",            0.22,
                    "CDKN1B",  "ZNF384",              0.25,
                    "CDKN1B",  "ZNF384-like",         0.30,
                    "CREBBP",  "ZNF384",              0.18,

                    "FLT3",    "Hyperdiploid",        0.28,
                    "KDM6A",   "ZNF384-like",         0.35,
                    "KDM6A",   "iAMP21",              0.40,

                    "CDK6",    "Ph+",                 0.18,
                    "CTCF",    "TCF3-PBX1",           0.75,
                    "CTCF",    "ZNF384-like",         0.30,
                    "ERG",     "DUX4",                0.65,
                    "KIAA1958","ZNF384-like",         0.35,
                    "KMT2A",   "KMT2A",               0.75,
                    "KRAS",    "Ph+",                 0.18,
                    "NF1",     "ZNF384",              0.15
)

prob_df <- tidyr::crossing(
                           gene = genes,
                           subtype = unique(case_df$subtype)
                           ) |>
left_join(gene_meta |> select(gene, base_prob), by = "gene") |>
left_join(subtype_effect, by = "subtype") |>
left_join(hotspots, by = c("gene", "subtype")) |>
mutate(
       mult = replace_na(mult, 0.5),
       extra = replace_na(extra, 0),
       prob = pmin(0.85, base_prob * mult + extra)
       ) |>
select(gene, subtype, prob)

                    # ============================================================
                    # 4. Generate mock mutation events
                    # ============================================================

                    type_levels <- c("SNV/INDEL", "Deletion/CNV", "SV", "Fusion", "Other")

type_bias <- tibble(gene = genes) |>
  mutate(
         profile = case_when(
                             gene %in% c("IKZF1", "CDKN2A", "CDKN2B", "PAX5", "BTG1", "RB1") ~ "cnv",
                             gene %in% c("KMT2A", "ERG", "CTCF") ~ "sv",
                             gene %in% c("KRAS", "FLT3", "CXCR4", "TP53", "NR3C1") ~ "snv",
                             TRUE ~ "mixed"
                             ),
         p_snv = case_when(
                           profile == "cnv"   ~ 0.35,
                           profile == "sv"    ~ 0.25,
                           profile == "snv"   ~ 0.75,
                           TRUE               ~ 0.62
                           ),
         p_cnv = case_when(
                           profile == "cnv"   ~ 0.48,
                           profile == "sv"    ~ 0.15,
                           profile == "snv"   ~ 0.10,
                           TRUE               ~ 0.20
                           ),
         p_sv = case_when(
                          profile == "cnv"   ~ 0.08,
                          profile == "sv"    ~ 0.35,
                          profile == "snv"   ~ 0.05,
                          TRUE               ~ 0.08
                          ),
         p_fusion = case_when(
                              profile == "cnv"   ~ 0.04,
                              profile == "sv"    ~ 0.20,
                              profile == "snv"   ~ 0.03,
                              TRUE               ~ 0.05
                              ),
         p_other = 1 - p_snv - p_cnv - p_sv - p_fusion
  )

event_candidates <- tidyr::expand_grid(
                                       case_df,
                                       gene = genes
                                       ) |>
left_join(prob_df, by = c("gene", "subtype")) |>
mutate(
       altered = rbinom(n(), size = 1, prob = prob) == 1
)

event_df <- event_candidates |>
  filter(altered) |>
  left_join(type_bias, by = "gene") |>
  rowwise() |>
  mutate(
         alteration_type = sample(
                                  type_levels,
                                  size = 1,
                                  prob = c(p_snv, p_cnv, p_sv, p_fusion, p_other)
         )
         ) |>
  ungroup() |>
  select(case_id, subtype, gene, alteration_type)

# ============================================================
# 5. Summarise to plot data
# ============================================================

# subtype別frequency
freq_subtype <- event_df |>
  filter(subtype %in% display_subtypes) |>
  distinct(subtype, gene, case_id) |>
  count(subtype, gene, name = "n_altered") |>
  right_join(
             tidyr::crossing(subtype = display_subtypes, gene = genes),
             by = c("subtype", "gene")
             ) |>
  mutate(n_altered = replace_na(n_altered, 0L)) |>
  left_join(subtype_counts, by = "subtype") |>
  mutate(freq = n_altered / n)

# all列
freq_all <- event_df |>
  distinct(gene, case_id) |>
  count(gene, name = "n_altered") |>
  right_join(tibble(gene = genes), by = "gene") |>
  mutate(
         n_altered = replace_na(n_altered, 0L),
         subtype = "all",
         n = nrow(case_df),
         freq = n_altered / n
  )

  freq_df <- bind_rows(freq_subtype, freq_all) |>
    left_join(gene_meta, by = "gene") |>
    left_join(subtype_meta |> select(subtype, col), by = "subtype") |>
    mutate(
           subtype = factor(subtype, levels = subtype_meta$subtype),
           gene = factor(gene, levels = genes)
    )

    # 左側stacked bar用
    bar_df <- event_df |>
      count(gene, alteration_type, name = "n_events") |>
      tidyr::complete(
                      gene = genes,
                      alteration_type = type_levels,
                      fill = list(n_events = 0L)
                      ) |>
      mutate(
             alteration_type = factor(alteration_type, levels = type_levels),
             freq = n_events / nrow(case_df)
             ) |>
      left_join(gene_meta |> select(gene, row), by = "gene") |>
      arrange(row, alteration_type) |>
      group_by(gene, row) |>
      mutate(
             xmin = lag(cumsum(freq), default = 0),
             xmax = cumsum(freq),
             ymin = row - 0.31,
             ymax = row + 0.31
             ) |>
      ungroup()

    # ============================================================
    # 6. Plot settings
    # ============================================================

    n_gene <- length(genes)
    n_subtype <- nrow(subtype_meta)

    # top annotation用に、heatmapの上に余白を作る
    y_top <- n_gene + 7.3

    bar_xmax <- max(0.50, ceiling(max(bar_df$xmax, na.rm = TRUE) * 10) / 10)
    bar_breaks <- seq(0, bar_xmax, by = 0.2)

    type_cols <- c(
                   "SNV/INDEL"    = "#F60C0C",
                   "Deletion/CNV" = "#638FFF",
                   "SV"           = "#8A33FF",
                   "Fusion"       = "#00A878",
                   "Other"        = "#222222"
    )

    heat_cols <- c(
                   "#FFFFFF",
                   "#F7DFA5",
                   "#E1AE2F",
                   "#2589E8",
                   "#0B4F8A"
    )

    # ============================================================
    # 7. Left stacked bar
    # ============================================================

    p_bar <- ggplot(bar_df) +
      geom_rect(
                aes(
                    xmin = xmin,
                    xmax = xmax,
                    ymin = ymin,
                    ymax = ymax,
                    fill = alteration_type
                    ),
                color = NA
                ) +
      annotate(
               "rect",
               xmin = 0,
               xmax = bar_xmax,
               ymin = 0.5,
               ymax = n_gene + 0.5,
               fill = NA,
               color = "black",
               linewidth = 0.25
               ) +
      scale_fill_manual(values = type_cols, guide = "none") +
      scale_x_continuous(
                         limits = c(0, bar_xmax),
                         breaks = bar_breaks,
                         expand = expansion(mult = c(0, 0.02))
                         ) +
      scale_y_continuous(
                         limits = c(0.5, y_top),
                         expand = expansion(mult = c(0, 0))
                         ) +
      labs(x = "group", y = NULL) +
      theme_classic(base_family = "Arial", base_size = 10) +
      theme(
            axis.text.x = element_text(angle = 90, hjust = 0.5, vjust = 0.5),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            axis.line.y = element_blank(),
            axis.title.x = element_text(size = 11),
            plot.margin = margin(t = 0, r = 4, b = 0, l = 2)
      )

      # ============================================================
      # 8. Middle vertical label
      # ============================================================

      p_ylabel <- ggplot() +
        annotate(
                 "text",
                 x = 1,
                 y = (n_gene + 1) / 2,
                 label = "Genes altered in >2 % of B-ALL",
                 angle = 90,
                 size = 4.2,
                 family = "Arial"
                 ) +
        scale_x_continuous(limits = c(0.5, 1.5), expand = c(0, 0)) +
        scale_y_continuous(limits = c(0.5, y_top), expand = c(0, 0)) +
        theme_void(base_family = "Arial") +
        theme(
              plot.margin = margin(t = 0, r = 2, b = 0, l = 2)
        )

        # ============================================================
        # 9. Main heatmap
        # ============================================================

        p_heatmap <- ggplot(freq_df, aes(x = col, y = row, fill = freq)) +
          geom_tile(
                    width = 0.96,
                    height = 0.96,
                    color = NA
                    ) +
          annotate(
                   "rect",
                   xmin = 0.5,
                   xmax = n_subtype + 0.5,
                   ymin = 0.5,
                   ymax = n_gene + 0.5,
                   fill = NA,
                   color = "#BFBFBF",
                   linewidth = 0.25
                   ) +
          geom_text(
                    data = gene_meta,
                    aes(
                        x = n_subtype + 0.68,
                        y = row,
                        label = gene
                        ),
                    inherit.aes = FALSE,
                    hjust = 0,
                    vjust = 0.5,
                    family = "Arial",
                    fontface = "italic",
                    size = 3.35
                    ) +
          geom_text(
                    data = subtype_meta,
                    aes(
                        x = col,
                        y = n_gene + 1.15,
                        label = n
                        ),
                    inherit.aes = FALSE,
                    family = "Arial",
                    fontface = "bold",
                    size = 3.25
                    ) +
          geom_text(
                    data = subtype_meta,
                    aes(
                        x = col,
                        y = n_gene + 2.25,
                        label = subtype
                        ),
                    inherit.aes = FALSE,
                    angle = 90,
                    hjust = 0,
                    vjust = 0.5,
                    family = "Arial",
                    size = 3.25
                    ) +
          scale_fill_gradientn(
                               colors = heat_cols,
                               values = scales::rescale(c(0, 0.12, 0.25, 0.55, 0.80)),
                               limits = c(0, 0.80),
                               breaks = c(0, 0.2, 0.4, 0.6, 0.8),
                               labels = c("0", "0.2", "0.4", "0.6", "0.8"),
                               oob = scales::squish,
                               name = "Mutation Frequency"
                               ) +
          scale_x_continuous(
                             limits = c(0.5, n_subtype + 3.7),
                             expand = expansion(mult = c(0, 0))
                             ) +
          scale_y_continuous(
                             limits = c(0.5, y_top),
                             expand = expansion(mult = c(0, 0))
                             ) +
          coord_cartesian(clip = "off") +
          guides(
                 fill = guide_colorbar(
                                       title.position = "top",
                                       title.hjust = 0,
                                       barwidth = grid::unit(4, "mm"),
                                       barheight = grid::unit(32, "mm"),
                                       ticks = TRUE
                 )
                 ) +
          labs(
               title = "Mutation Frequency per subtype"
               ) +
          theme_void(base_family = "Arial") +
          theme(
                plot.title = element_text(
                                          family = "Arial",
                                          size = 14,
                                          face = "plain",
                                          hjust = 0.5,
                                          margin = margin(b = 6)
                                          ),
                legend.position = "right",
                legend.title = element_text(
                                            family = "Arial",
                                            size = 9,
                                            face = "bold"
                                            ),
                legend.text = element_text(
                                           family = "Arial",
                                           size = 8
                                           ),
                plot.margin = margin(t = 0, r = 4, b = 0, l = 0)
          )

          # ============================================================
          # 10. Combine with patchwork
          # ============================================================

          fig <- p_bar + p_ylabel + p_heatmap +
            plot_layout(
                        widths = c(0.24, 0.045, 1.00),
                        guides = "keep"
            )

          fig

          # ============================================================
          # 11. Export
          # ============================================================

          ggsave(
                 filename = "mock_mutation_frequency_per_subtype.svg",
                 plot = fig,
                 device = svglite::svglite,
                 width = 10,
                 height = 12,
                 units = "in"
          )

          ggsave(
                 filename = "mock_mutation_frequency_per_subtype.pdf",
                 plot = fig,
                 device = grDevices::cairo_pdf,
                 width = 10,
                 height = 12,
                 units = "in"
          )
