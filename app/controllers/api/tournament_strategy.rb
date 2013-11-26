class API::TournamentStrategy

  def self.generate_matches(tournament)
    if tournament.round_robin?
      RoundRobinStrategy.new(tournament).generate_matches
    else
      raise NotImplementedError
    end
  end

  def self.resolve_ranking(tournament)
    if tournament.round_robin?
      RoundRobinStrategy.new(tournament).resolve_ranking
    else
      raise NotImplementedError
    end
  end
end

class RoundRobinStrategy < API::TournamentStrategy

  def initialize(tournament)
    @tournament = tournament
  end

  def generate_matches
    participants = get_accepted_players
    if participants.size < 4 or participants.size > 20
      raise NotImplementedError
    end
    permutations = participants.permutation(2).to_a.map { |p| [p[0].id, p[1].id] }.sort
    permutations.select! { |x| x[0] < x[1] } if @tournament.single_round_robin?
    permutations.each do |x|
      match = Match.new({
        :tournament_id => @tournament.id,
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

  # Not used, kept here only for further reference (besides the math is cool!)
  def calculate_number_of_matches(number_of_participants)
    factor = @tournament.single_round_robin? ? 1 : 2
    x = (1..number_of_participants).inject(:*)
    y = (1..number_of_participants - 2).inject(:*) * 2
    result = (x / y) * factor
    result
  end
end
