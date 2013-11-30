class API::TournamentsController < ApplicationController

  def index
    render :json =>
      Tournament
        .where(:started => true)
        .order(updated_at: :desc)
        .limit(20)
  end

  def create
    tournament_param = params.require(:tournament)
    params = tournament_param.permit(:title, :kind, :rules)
    
    if not TournamentType.has_key?(params[:kind].to_sym)
      render :status => :bad_request, :text => "Invalid tournament type."
    else
      tournament = Tournament.new({
        :title => params[:title],
        :kind  => params[:kind],
        :rules => params[:rules]
      })
      tournament.save!
      render :json => { :id => tournament.id }
    end
  end

  def start
    tournament = Tournament.find_by_id(params[:id])
    if tournament.started
      render :status => :bad_request, :text => "Tournament already started."
    else
      begin
        API::TournamentStrategy.generate_matches(tournament)
        tournament.started = true
        tournament.save!
        render :json => { :started => tournament.started }
      rescue NotImplementedError
        render :status => :not_implemented, :text => "Unsupported number of participants."
      end
    end
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
