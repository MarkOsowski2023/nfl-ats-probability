library(nflreadr)
library(tidyverse)


play_by_play_data <- nflreadr::load_pbp(2000:2022)

game_result_data <- nflreadr::load_schedules(2000:2022)


# filter data by home and away teams, mutate column for when team wins, lose, or push against the spread


away_team_ats <- game_result_data |> 
  mutate(ats_win = case_when(
    result < spread_line ~ "win",
    result > spread_line ~ "lose",
    result == spread_line ~ "push"
  )) |> 
  filter(game_type == "REG") |> 
  select(game_id, season, away_team, home_team, spread_line, away_coach, roof, ats_win) |> 
  rename(opponent = home_team,
         team = away_team,
         coach = away_coach) |> 
  mutate(location = "away")





home_team_ats <- game_result_data |> 
  mutate(ats_win = case_when(
    result > spread_line ~ "win",
    result < spread_line ~ "lose",
    result == spread_line ~ "push"
  )) |> 
  filter(game_type == "REG") |> 
  select(game_id, season, home_team, away_team, spread_line, home_coach, roof, ats_win) |> 
  rename(opponent = away_team,
         team = home_team,
         coach = home_coach) |> 
  mutate(location = "home")

team_ats <- home_team_ats |> 
  bind_rows(away_team_ats)


# using the play by play data:
# select stats we want to use and merge with team_ats dataframe
# then export to csv file

str(play_by_play_data$interception)

game_stats <- play_by_play_data |> 
  filter(!is.na(posteam)) |> 
  filter(play_type == "pass" | play_type == "run") |> 
  group_by(game_id, posteam) |> 
  summarise(epa = mean(epa, na.rm = TRUE),
            pass_yds_per_attempt = mean(passing_yards, na.rm = TRUE),
            rush_yds_per_attempt = mean(rushing_yards, na.rm = TRUE),
            int = sum(interception),
            fumbles_lost = sum(fumble_lost),
            penalty_yards = sum(penalty_yards, na.rm = TRUE)) |> 
  rename(team = posteam)

def_game_stats <- play_by_play_data |> 
  filter(!is.na(defteam)) |> 
  filter(play_type == "pass" | play_type == "run") |> 
  group_by(game_id, defteam) |> 
  summarise(def_epa = mean(epa, na.rm = TRUE),
            def_pass_yds_per_attempt = mean(passing_yards, na.rm = TRUE),
            def_rush_yds_per_attempt = mean(rushing_yards, na.rm = TRUE),
            def_int = sum(interception),
            forced_fumbles = sum(fumble_lost),
            def_penlty_yards = sum(penalty_yards, na.rm = TRUE)) |> 
  rename(team = defteam)


team_game_stats <- game_stats |> 
  inner_join(def_game_stats)

# weather

unique(play_by_play_data$weather)

unique(game_result_data$temp)

unique(game_result_data$wind)

away_weather_data <- game_result_data |> 
  select(game_id, away_team, wind, temp) |> 
  rename(team = away_team)

home_weather_data <- game_result_data |> 
  select(game_id, home_team, wind, temp) |> 
  rename(team = home_team)

game_weather_data <- home_weather_data |> 
  bind_rows(away_weather_data)


# inner join ats data, and game stats

