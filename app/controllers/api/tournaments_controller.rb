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
      tournament = Tournament.new({
        :title => params[:title],
        :kind  => params[:kind],
        :rules => params[:rules]
      })
      tournament.save!
      begin
        # TODO: generate matches only when the tournament gets started
        API::TournamentStrategy.generate_matches(tournament, number_of_participants)
      rescue NotImplementedError
        render :status => :not_implemented, :text => "Unsupported tournament type."
      end
      render :json => { :id => tournament.id }
    end
  end

  def start
    render :json => {}
  end

  def show
    tournament = Tournament.find_by_id(params[:id])
    if tournament
      begin
        render :json => API::TournamentStrategy.resolve_ranking(tournament)
      rescue NotImplementedError
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
end
