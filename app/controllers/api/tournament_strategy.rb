class API::TournamentStrategy

  def self.generate_matches(tournament)
    if tournament.round_robin?
      RoundRobinStrategy.new(tournament).generate_matches
    else
      raise NotImplementedError, "Cannot generate matches for tournament: #{tournament.kind}."
    end
  end

  def self.resolve_ranking(tournament)
    if tournament.round_robin?
      RoundRobinStrategy.new(tournament).resolve_ranking
    else
      raise NotImplementedError, "Cannot resolve ranking for tournament: #{tournament.kind}."
    end
  end
end

class RoundRobinStrategy < API::TournamentStrategy

  @@number_letter_map = {
    1  => 'A', 2  => 'B', 3  => 'C', 4  => 'D',
    5  => 'E', 6  => 'F', 7  => 'G', 8  => 'H',
    9  => 'I', 10 => 'J', 11 => 'K', 12 => 'L',
    13 => 'M', 14 => 'N', 15 => 'O', 16 => 'P',
    17 => 'Q', 18 => 'R', 19 => 'S', 20 => 'T',
    21 => 'U', 22 => 'V', 23 => 'W',
    24 => 'X', 25 => 'Y', 26 => 'Z'
  }

  def initialize(tournament)
    @tournament = tournament
  end

  def generate_matches
    participants = @tournament.get_accepted_players
    no_participants = participants.size
    if no_participants < 4 || no_participants > 20 || no_participants % 2 != 0
      raise NotImplementedError, "Number of participants must be an even number between 4 and 20."
    end
    rounds = (1...no_participants).map do |r|
      t = participants.dup
      (0...(no_participants / 2)).map do |_|
        [t.shift, t.delete_at(-(r % t.size + (r >= t.size * 2 ? 1 : 0)))]
      end
    end
    rounds.each_with_index do |round, round_idx|
      round.each_with_index do |match, match_idx|
        game = "#{round_idx + 1}:#{@@number_letter_map[match_idx + 1]}"
        match = Match.new({
          :tournament_id => @tournament.id,
          :game          => game,
          :player1_id    => match[0].id,
          :player2_id    => match[1].id
        })
        match.save!
      end
    end
  end
  
  def resolve_ranking
    participants = @tournament.get_accepted_players.inject({}) do |result, player|
      result[player.id] = {
        :id       => player.id,
        :username => player.username,
        :avatar   => player.avatar,
        :wins     => 0,
        :losses   => 0,
        :score    => 0.0
      }
      result
    end
    @tournament.get_finished_matches.each do |match|
      player1 = participants[match.player1_id]
      player2 = participants[match.player2_id]
      match_score = 1 + (1.0 / match.round).round(4)
      if match.winner_id == match.player1_id
        player1[:wins]   += 1
        player2[:losses] += 1
        player1[:score]  = _update_score(player1[:score], match_score)
      else
        player2[:wins]   += 1
        player1[:losses] += 1
        player2[:score]  = _update_score(player2[:score], match_score)
      end
    end
    ranking = participants.values.sort_by { |player| player[:score] }.reverse!
    ranking
  end

  def _update_score(current_score, match_score)
    result = (current_score + match_score).round(4)
    result
  end
  
  private

  # Not used, kept only for further reference (besides the algorithm is cool!)
  def _generate_games(no_matches)
    games, section = {}, 0
    no_letters = @@number_letter_map.size
    no_matches.times do |idx|
      number = idx + 1
      if number <= no_letters
        games[idx] = @@number_letter_map[number]
      else
        remainder = number % no_letters
        section += 1 if remainder == 1
        sub_section = (remainder != 0) ? remainder : no_letters
        games[idx] = "#{@@number_letter_map[section]}#{@@number_letter_map[sub_section]}"
      end
    end
    games
  end

  # Not used, kept only for further reference (besides the math is cool!)
  def _calculate_number_of_matches(no_participants, double=false)
    raise ArgumentError, "Number of participants must be greater than 3." if no_participants < 3
    factor = double ? 2 : 1
    x = (1..no_participants).inject(:*)
    y = (1..no_participants - 2).inject(:*) * 2
    result = (x / y) * factor
    result
  end
end
