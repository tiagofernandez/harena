class API::TournamentStrategy

  def self.generate_matches(tournament)
    if tournament.round_robin?
      RoundRobinStrategy.new(tournament).generate_matches
    else
      raise NotImplementedError, "Cannot generate matches for tournament type: #{tournament.kind}."
    end
  end

  def self.resolve_ranking(tournament)
    if tournament.round_robin?
      RoundRobinStrategy.new(tournament).resolve_ranking
    else
      raise NotImplementedError, "Cannot resolve ranking for tournament type: #{tournament.kind}."
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
    participants = get_accepted_players
    no_participants = participants.size
    if no_participants < 4 || no_participants > 20 || no_participants % 2 != 0
      raise NotImplementedError, "Number of participants must be an even number between 4 and 20."
    end
    permutations = participants.permutation(2).to_a.map { |p| [p[0].id, p[1].id] }.sort
    permutations.select! { |x| x[0] < x[1] } if @tournament.round_robin?
    pools = generate_pools(permutations.size)
    permutations.each_with_index do |x, idx|
      match = Match.new({
        :tournament_id => @tournament.id,
        :pool          => pools[idx],
        :player1_id    => x[0],
        :player2_id    => x[1]
      })
      match.save!
    end
  end
  
  def resolve_ranking
    participants = get_accepted_players.inject({}) do |result, player|
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
    get_finished_matches.each do |match|
      player1 = participants[match.player1_id]
      player2 = participants[match.player2_id]
      match_score = 1 + (1.0 / match.round).round(4)
      if match.winner_id == match.player1_id
        player1[:wins]   += 1
        player2[:losses] += 1
        player1[:score]  = update_score(player1[:score], match_score)
      else
        player2[:wins]   += 1
        player1[:losses] += 1
        player2[:score]  = update_score(player2[:score], match_score)
      end
    end
    ranking = participants.values.sort_by { |player| player[:score] }.reverse!
    ranking
  end
  
  private

  def get_accepted_players
    players = Player.joins(:tournaments).where(
      "tournament_id = :tournament_id AND accepted = :accepted",
      { tournament_id: @tournament.id, accepted: true })
    players
  end

  def get_finished_matches
    matches = Match.where(
      "tournament_id = :tournament_id AND winner_id IS NOT NULL",
      { tournament_id: @tournament.id })
    matches
  end

  def update_score(current_score, match_score)
    result = (current_score + match_score).round(4)
    result
  end

  def generate_pools(no_matches)
    pools, section = {}, 0
    no_letters = @@number_letter_map.size
    no_matches.times do |idx|
      number = idx + 1
      if number <= no_letters
        pools[idx] = @@number_letter_map[number]
      else
        remainder = number % no_letters
        section += 1 if remainder == 1
        sub_section = (remainder != 0) ? remainder : no_letters
        pools[idx] = "#{@@number_letter_map[section]}#{@@number_letter_map[sub_section]}"
      end
    end
    pools
  end

  # Not used, kept here only for further reference (besides the math is cool!)
  def calculate_number_of_matches(no_participants, double=false)
    factor = double ? 2 : 1
    x = (1..no_participants).inject(:*)
    y = (1..no_participants - 2).inject(:*) * 2
    result = (x / y) * factor
    result
  end
end
