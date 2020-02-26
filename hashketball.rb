def game_hash
  gh = {
    :home => {
      :team_name => "Brooklyn Nets",
      :colors => ["Black", "White"],
      :players => [
      {
        :player_name => "Alan Anderson",
        :number => 0,
        :shoe => 16,
        :points => 22,
        :rebounds => 12,
        :assists => 12,
        :steals => 3,
        :blocks => 1,
        :slam_dunks => 1
      },
      {
        :player_name => "Reggie Evans",
        :number => 30,
        :shoe => 14,
        :points => 12,
        :rebounds => 12,
        :assists => 12,
        :steals => 12,
        :blocks => 12,
        :slam_dunks => 7
      },
      {
        :player_name => "Brook Lopez",
        :number => 11,
        :shoe => 17,
        :points => 17,
        :rebounds => 19,
        :assists => 10,
        :steals => 3,
        :blocks => 1,
        :slam_dunks => 15
      },
      {
        :player_name => "Mason Plumlee",
        :number => 1,
        :shoe => 19,
        :points => 26,
        :rebounds => 11,
        :assists => 6,
        :steals => 3,
        :blocks => 8,
        :slam_dunks => 5
      },
      {
        :player_name => "Jason Terry",
        :number => 31,
        :shoe => 15,
        :points => 19,
        :rebounds => 2,
        :assists => 2,
        :steals => 4,
        :blocks => 11,
        :slam_dunks => 1
      }
    ]
    },
    :away => {
      :team_name => "Charlotte Hornets",
      :colors => ["Turquoise", "Purple"],
      :players => [
      {
        :player_name => "Jeff Adrien",
        :number => 4,
        :shoe => 18,
        :points => 10,
        :rebounds => 1,
        :assists => 1,
        :steals => 2,
        :blocks => 7,
        :slam_dunks => 2
      },
      {
        :player_name => "Bismack Biyombo",
        :number => 0,
        :shoe => 16,
        :points => 12,
        :rebounds => 4,
        :assists => 7,
        :steals => 22,
        :blocks => 15,
        :slam_dunks => 10
      },
      {
        :player_name => "DeSagna Diop",
        :number => 2,
        :shoe => 14,
        :points => 24,
        :rebounds => 12,
        :assists => 12,
        :steals => 4,
        :blocks => 5,
        :slam_dunks => 5
      },
      {
        :player_name => "Ben Gordon",
        :number => 8,
        :shoe => 15,
        :points => 33,
        :rebounds => 3,
        :assists => 2,
        :steals => 1,
        :blocks => 1,
        :slam_dunks => 0
       },
      {
        :player_name => "Kemba Walker",
        :number => 33,
        :shoe => 15,
        :points => 6,
        :rebounds => 12,
        :assists => 12,
        :steals => 7,
        :blocks => 5,
        :slam_dunks => 12
      }
    ]
    }
  }
  gh
end

# access player array of (nil) = all players, (1) = home players, (2 || other) = away players
def roster(num = nil)
  h = game_hash[:home][:players]
  a = game_hash[:away][:players]
  result = h + a if !num
  result = h if num == 1
  result = a if num == 2
  result
end

# returns a specified stat given player name and stat type
#   if no stat type given, returns entire player stat line (minus name)
def player_lookup(player, stat)
  player_loc = roster.find_index {|n| n[:player_name] == player}
  all_stat = roster[player_loc]
  all_stat.delete(:player_name)
  !stat ? all_stat : all_stat[stat]
end

# builds summary array with team names as keys, colors, and "pass" key that can drive roster method above
def game_info
  result = {}
  x = 1
  game_hash.each_key do |n|
    g = game_hash[n]
    result[g[:team_name]] = {}
    result[g[:team_name]][:colors] = g[:colors]
    result[g[:team_name]][:pass] = x
    x += 1
  end
  result
end

# given a stat type, method returns the player name with the highest value of that stat
def max_stat(stat)
  most = roster.reduce(nil) do |memo, n|
          memo = [roster[0][stat], roster[0][:player_name]] if !memo
          if n[stat] > memo[0]
            memo = [n[stat], n[:player_name]] 
          end
          memo
        end
  most[1]
end

def num_points_scored(player)
  player_lookup(player, :points)
end

def shoe_size(player)
  player_lookup(player, :shoe)
end

def team_colors(team)
  game_info[team][:colors]
end

def team_names
  result = []
  game_info.each_key {|n| result << n}
  result
end

def player_numbers(team)
  nos = []
  team_stats = roster(game_info[team][:pass])
  team_stats.each {|n| nos << n[:number]}
  nos
end

def player_stats(player)
  player_lookup(player, nil)
end

def big_shoe_rebounds
  player_lookup(max_stat(:shoe), :rebounds)
end

def most_points_scored
  max_stat(:points)
end

def winning_team
  home = roster(1).reduce(0) {|sum, n| sum + n[:points]}
  away = roster(2).reduce(0) {|sum, n| sum + n[:points]}
  home > away ? team_names[0] : team_names[1]
end

def player_with_longest_name
  mps = roster.reduce(nil) do |memo, n|
          memo = roster[0][:player_name] if !memo
          if n[:player_name].length > memo.length
            memo = n[:player_name]
          end
          memo
        end
  mps
end

def long_name_steals_a_ton?
  steals = []
  pln = player_with_longest_name
  roster.each {|n| steals << n[:steals]}
  player_lookup(pln, :steals) > steals.sort[-2] ? true : false
end
