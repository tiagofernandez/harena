class API::TournamentsController < ApplicationController

  def index
    render :json =>
      Tournament
        .where(:started => true)
        .order(updated_at: :desc)
        .limit(20)
  end

  def create
    safe_params = params.require(:tournament).permit(:title, :kind, :rules)
    if not TournamentType.has_key?(safe_params[:kind].to_sym)
      render :status => :bad_request, :text => "Cannot create tournament for tournament type: #{params[:kind]}."
    else
      tournament = Tournament.new({
        :host  => current_player,
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
    elsif tournament.can_be_managed_by?(current_player)
      begin
        API::TournamentStrategy.generate_matches(tournament)
        tournament.started = true
        tournament.save!
        render :json => { :started => tournament.started }
      rescue NotImplementedError => err
        render :status => :not_implemented, :text => err.message
      end
    else
      render :status => :unauthorized, :text => "Only the host can start this tournament."
    end
  end

  def show
    tournament = Tournament.find_by_id(params[:id])
    if tournament
      begin
        render :json => API::TournamentStrategy.resolve_ranking(tournament)
      rescue NotImplementedError => err
        render :status => :not_implemented, :text => err.message
      end
    else
      render :status => :not_found, :text => "Tournament not found."
    end
  end

  def update
    tournament = Tournament.find_by_id(params[:id])
    if tournament
      if tournament.can_be_managed_by?(current_player)
        safe_params = params.require(:tournament).permit(:rules)
        tournament.attributes = safe_params
        tournament.save!
        render :nothing => true, :status => :no_content
      else
        render :status => :unauthorized, :text => "No permission to update tournament."
      end
    else
      render :status => :not_found, :text => "Tournament not found."
    end
  end

  def destroy
    tournament = Tournament.find_by_id(params[:id])
    if tournament
      if tournament.can_be_managed_by?(current_player) && !tournament.started
        tournament.destroy
        render :nothing => true, :status => :no_content
      else
        render :status => :unauthorized, :text => "No permission to delete tournament."
      end
    else
      render :status => :not_found, :text => "Tournament not found."
    end
  end
end
