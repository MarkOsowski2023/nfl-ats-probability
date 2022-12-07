library(tidyverse)
library(nflreadr)
library(nflplotR)
library(ggthemes)


# roster ID for ploting



game_qbs <- nflreadr::load_schedules(2001:2022)

home_qbs <- game_qbs |> 
  select(game_id, season, home_team, home_qb_id, home_qb_name) |> 
  rename(qb_id = home_qb_id,
         qb_name = home_qb_name,
         team = home_team)

away_qbs <- game_qbs |> 
  select(game_id, season, away_team, away_qb_id, away_qb_name) |> 
  rename(qb_id = away_qb_id,
         qb_name = away_qb_name,
         team = away_team)

all_qbs <- bind_rows(home_qbs, away_qbs)
# read in csv

unique(all_qbs$qb_id)


game_data <- read.csv("C:/Users/marko/NW_Challenges/nfl-ats-probability/Data/nfl_game_data.csv")

# Plots using ggplot2

# key spreads
key_spread_numbers <- c(-2.5, 2.5, -3.0, 3.0, -3.5, 3.5, -6.5, 6.5, -7.0, 7.0, -7.5, 7.5)


qbs_key_games <- all_qbs |> 
  inner_join(game_data) |> 
  mutate(era_2019 = case_when(
    season >= 2020 ~ "Tom Brady in Tampa",
    season < 2020 ~ "Tom Brady in NE"
  ))

# Tom Brady Move

TB_NE <- c("TB", "NE")


  
tb1 <- qbs_key_games |> 
  group_by(team, era_2019) |> 
  mutate(avg_epa = mean(epa)) |> 
  filter(spread_line %in% key_spread_numbers) |> 
  group_by(team, era_2019) |> 
  mutate(key_games = n()) |> 
  filter(ats_win == "win") |> 
  group_by(team, era_2019) |> 
  mutate(key_wins = n()) |> 
  group_by(team, era_2019) |> 
  summarise(
    key_games = mean(key_games),
    key_wins = mean(key_wins),
    avg_epa = mean(avg_epa),
    key_win_percentage = key_wins / key_games
  ) |> 
  mutate(colour = ifelse(team %in% TB_NE, NA, "b/w"),
         alpha = ifelse(team %in% TB_NE, 1, 0.15)) |> 
  ggplot(aes(x = avg_epa, y = key_win_percentage)) +
  nflplotR::geom_mean_lines(aes(v_var = avg_epa, h_var = key_win_percentage)) +
  nflplotR::geom_nfl_logos(aes(team_abbr = team, alpha = alpha, colour = colour), width = 0.055) +
  stat_smooth(
    method = "lm",
    formula = y ~ x,
    geom = "smooth",
    alpha = 0.2
  ) +
  labs(
    x = "Offensive EPA",
    y = "Win Percentage (ATS)", 
    caption = "DATA: @nflreadR",
    title = "Win Percentage Against the Spread vs. Offensive Expected Points Added",
    subtitle = "Seasons: 2001 - 2022 | Spread: 2.5, 3.0, 3.5, 6.5, 7.0, 7.5 | Minimum 50 Games"
  ) +
  scale_colour_identity() +
  theme_fivethirtyeight() +
  theme(
    plot.title = element_text(face = "bold", family = "mono"),
    plot.subtitle = element_text(family = "mono", size = 11),
    plot.title.position = "plot",
    axis.title.x = element_text(face = "bold", family = "mono", size = 15, margin = margin(r = 20)),
    axis.title.y = element_text(face = "bold", family = "mono", size = 15, margin = margin(r = 20)),
  ) +
  facet_grid(era_2019~.) +
  theme(
    strip.background = element_rect(
      color = "black",
      linewidth = 1.5,
      linetype = "solid"
    )
  )
  



# wins against the spread in key spreads

p1 <- game_data |> 
  group_by(team) |> 
  mutate(avg_epa = mean(epa)) |> 
  filter(spread_line %in% key_spread_numbers) |> 
  group_by(team) |> 
  mutate(key_games = n()) |> 
  filter(ats_win == "win") |> 
  group_by(team) |> 
  mutate(key_wins = n()) |> 
  group_by(team) |> 
  summarise(key_games = mean(key_games),
            key_wins = mean(key_wins),
            avg_epa = mean(avg_epa),
            key_win_percentage = key_wins / key_games) |> 
  filter(key_games > 50) |> 
  ggplot(aes(y = reorder(team, key_wins), x = key_wins)) +
  geom_col(aes(color = team, fill = team), width = 0.7) +
  nflplotR::scale_color_nfl(type = "secondary") +
  nflplotR::scale_fill_nfl(alpha = 0.4) +
  labs(
    x = "Wins (ATS)",
    y = "Team", 
    caption = "DATA: @nflreadR",
    title = "Team Wins Against the Spread",
    subtitle = "Seasons: 2001 - 2022 | Spread: 2.5, 3.0, 3.5, 6.5, 7.0, 7.5 | Minimum 50 Games"
  ) +
  theme_fivethirtyeight() +
  theme(
    plot.title = element_text(face = "bold", family = "mono"),
    plot.subtitle = element_text(family = "mono", size = 11),
    plot.title.position = "plot",
    axis.title.x = element_text(face = "bold", family = "mono", size = 15, margin = margin(r = 20)),
    axis.title.y = element_text(face = "bold", family = "mono", size = 15, margin = margin(r = 20)),
    axis.text.y = element_nfl_logo(size = 0.85)
  )

# epa and wins in key spreads

p2 <- game_data |> 
  group_by(team) |> 
  mutate(avg_epa = mean(epa)) |> 
  filter(spread_line %in% key_spread_numbers) |> 
  group_by(team) |> 
  mutate(key_games = n()) |> 
  filter(ats_win == "win") |> 
  group_by(team) |> 
  mutate(key_wins = n()) |> 
  group_by(team) |> 
  summarise(key_games = mean(key_games),
            key_wins = mean(key_wins),
            avg_epa = mean(avg_epa),
            key_win_percentage = key_wins / key_games) |> 
  filter(key_games > 50) |> 
  ggplot(aes(x = avg_epa, y = key_win_percentage)) +
  nflplotR::geom_mean_lines(aes(v_var = avg_epa, h_var = key_win_percentage)) +
  nflplotR::geom_nfl_logos(aes(team_abbr = team), width = 0.055) +
  stat_smooth(
    method = "lm",
    formula = y ~ x,
    geom = "smooth",
    alpha = 0.2
  ) +
  labs(
    x = "Offensive EPA",
    y = "Win Percentage (ATS)", 
    caption = "DATA: @nflreadR",
    title = "Win Percentage Against the Spread vs. Offensive Expected Points Added",
    subtitle = "Seasons: 2001 - 2022 | Spread: 2.5, 3.0, 3.5, 6.5, 7.0, 7.5 | Minimum 50 Games"
  ) +
  theme_fivethirtyeight() +
  theme(
    plot.title = element_text(face = "bold", family = "mono"),
    plot.subtitle = element_text(family = "mono", size = 11),
    plot.title.position = "plot",
    axis.title.x = element_text(face = "bold", family = "mono", size = 15, margin = margin(r = 20)),
    axis.title.y = element_text(face = "bold", family = "mono", size = 15, margin = margin(r = 20)),
  )

# defensive epa vs. wins ats percentage key numbers

p3 <- game_data |> 
  group_by(team) |> 
  mutate(avg_def_epa = mean(def_epa)) |> 
  filter(spread_line %in% key_spread_numbers) |> 
  group_by(team) |> 
  mutate(key_games = n()) |> 
  filter(ats_win == "win") |> 
  group_by(team) |> 
  mutate(key_wins = n()) |> 
  group_by(team) |> 
  summarise(key_games = mean(key_games),
            key_wins = mean(key_wins),
            avg_def_epa = mean(avg_def_epa),
            key_win_percentage = key_wins / key_games) |> 
  filter(key_games > 50) |> 
  ggplot(aes(x = avg_def_epa, y = key_win_percentage)) +
  nflplotR::geom_mean_lines(aes(v_var = avg_def_epa, h_var = key_win_percentage)) +
  nflplotR::geom_nfl_logos(aes(team_abbr = team), width = 0.055) +
  stat_smooth(
    method = "lm",
    formula = y ~ x,
    geom = "smooth",
    alpha = 0.2
  ) +
  labs(
    x = "Defensive EPA",
    y = "Win Percentage (ATS)", 
    caption = "DATA: @nflreadR",
    title = "Win Percentage Against the Spread vs. Defensive Expected Points Added",
    subtitle = "Seasons: 2001 - 2022 | Spread: 2.5, 3.0, 3.5, 6.5, 7.0, 7.5 | Minimum 50 Games"
  ) +
  theme_fivethirtyeight() +
  theme(
    plot.title = element_text(face = "bold", family = "mono"),
    plot.subtitle = element_text(family = "mono", size = 11),
    plot.title.position = "plot",
    axis.title.x = element_text(face = "bold", family = "mono", size = 15, margin = margin(r = 20)),
    axis.title.y = element_text(face = "bold", family = "mono", size = 15, margin = margin(r = 20)),
  ) +
  scale_x_reverse()


# save the plots

ggsave("wins_against_the_spread.png", plot = p1)
ggsave("win_percentage_ats_and_epa.png", plot = p2)
ggsave("win_percentage_ats_and_def_epa.png", plot = p3)
ggsave("tom_brady_off_epa.png", plot = tb1)
