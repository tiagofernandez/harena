class API::TournamentsController < ApplicationController

  def index
    render :json => Tournament.all
  end

  def create
    tournament_param = params.require(:tournament)
    params = tournament_param.permit(:title, :kind, :rules, :number_of_participants)
    number_of_participants = params[:number_of_participants].to_i or -1

    if number_of_participants < 4 or number_of_participants > 20
      render :status => :bad_request, :text => "Invalid number of participants."
    elsif not TournamentType.has_key?(params[:kind].to_sym)
      render :status => :bad_request, :text => "Invalid tournament type."
    else
      tournament = create_tournament(params)
      generate_matches(tournament, number_of_participants)
      render :json => { :id => tournament.id }
    end
  end

  def show
    tournament = Tournament.find_by_id(params[:id])
    if tournament
      if ['SRR', 'DRR'].include?(tournament.kind)
        render :json => resolve_round_robin_ranking(tournament.id)
      else
        render :status => :not_implemented, :text => "Unsupported tournament type."
      end
    else
      render :status => :not_found, :text => "Tournament not found."
    end
  end

  def update
    render :json => {}
  end

  def destroy
    render :json => {}
  end

  private

  def create_tournament(params)
    tournament = Tournament.new({
      :title => params[:title],
      :kind  => params[:kind],
      :rules => params[:rules]
    })
    tournament.save!
    tournament
  end

  def generate_matches(tournament, number_of_participants)
    case tournament.kind
    when 'SRR'
      generate_round_robin_matches(tournament, number_of_participants, single=true)
    when 'DRR'
      generate_round_robin_matches(tournament, number_of_participants, single=false)
    else
      raise RuntimeError, "Cannot generate matches for tournament type: #{tournament.kind}."
    end
  end

  def generate_round_robin_matches(tournament, number_of_participants, single=true)
    calculate_round_robin_matches(number_of_participants, single).times do
      match = Match.new({ :tournament_id => tournament.id })
      match.save!
    end
  end

  def calculate_round_robin_matches(number_of_participants, single=true)
    factor = single ? 1 : 2
    x = (1..number_of_participants).inject(:*)
    y = (1..number_of_participants - 2).inject(:*) * 2
    ((x / y) * factor) + factor # take finals into account
  end

  def resolve_round_robin_ranking(tournament_id)
    participants = get_accepted_players(tournament_id).inject({}) do |result, player|
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
    get_finished_matches(tournament_id).each do |match|
      player1 = participants[match.player1_id]
      player2 = participants[match.player2_id]
      score   = 1 + (1.0 / match.round).round(4)

      if match.winner_id == match.player1_id
        player1[:wins]   += 1
        player2[:losses] += 1
        player1[:score]  = (player1[:score] + score).round(4)
      else
        player2[:wins]   += 1
        player1[:losses] += 1
        player2[:score]  = (player2[:score] + score).round(4)
      end
    end
    ranking = participants.values.sort_by { |player| player[:score] }.reverse!
    ranking
  end

  def get_accepted_players(tournament_id)
    players = Player.joins(:tournaments).where(
      "tournament_id = :tournament_id AND accepted = :accepted",
      { tournament_id: tournament_id, accepted: true })
    players
  end

  def get_finished_matches(tournament_id)
    matches = Match.where(
      "tournament_id = :tournament_id AND winner_id IS NOT NULL",
      { tournament_id: tournament_id })
    matches
  end

end
