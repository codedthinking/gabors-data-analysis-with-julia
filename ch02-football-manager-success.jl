using Kezdi

data_dir = "data/da_data_repo/football/clean"

# look at entire clean data table on games
games = @use "$(data_dir)/epl_games.dta"
@with games begin
    @sort team_home
    @sort season team_home
    @keep @if season == 2016
    @list
end

# look at data for team-game level
team_games = @use "$(data_dir)/epl_teams_games.dta"
@with team_games begin
    @sort team
    @sort season team
    @keep @if season == 2016
    @sort date
    @list
end

# look at data table on managers
managers = @use "$(data_dir)/football-managers.dta"
@with managers @list

# look at the clean merged file 
workfile = @use "$(data_dir)/football-managers-workfile.dta"
@with workfile begin
    @sort season team
    @list

    @egen manager_games = rowcount(_n), by(team, manager_id)
    @egen manager_points = sum(points), by(team, manager_id)
    @generate manager_win_ratio = manager_points / manager_games

    @collapse manager_games = mean(manager_games) manager_points = mean(manager_points) manager_win_ratio = mean(manager_win_ratio), by(manager_name, team)
    @sort manager_win_ratio
    @sort manager_win_ratio, desc
    @list @if manager_win_ratio >= 2

    # denote caretakers
    @generate care_taker = (manager_games < 18)
    @generate manager_win_ratio1 = manager_win_ratio @if care_taker
    @generate manager_win_ratio0 = manager_win_ratio @if !care_taker
end