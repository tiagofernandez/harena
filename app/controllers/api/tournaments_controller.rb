class API::TournamentsController < ApplicationController

  def index
    render :json => Tournament.all
  end

  def create
    params = tournament_params.permit(:title, :kind, :rules, :number_of_participants)
    number_of_participants = params[:number_of_participants].to_i or -1
    kind = params[:kind]

    if number_of_participants < 4 or number_of_participants > 20
      render :status => :bad_request, :text => "Invalid number of participants."
    elsif not TournamentType.has_key?(kind.to_sym)
      render :status => :bad_request, :text => "Invalid tournament type: #{kind}."
    else
      tournament = create_tournament(tournament_params)
      generate_matches(tournament, number_of_participants)
      render :json => { :id => tournament.id }
    end
  end

  def show
    render :json => {}
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

  def tournament_params
    params.require(:tournament)
  end

end
