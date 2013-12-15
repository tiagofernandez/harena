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
    if not TournamentEnum.has_key?(safe_params[:kind].to_sym)
      render :status => :bad_request, :text => "Cannot create tournament for tournament: #{safe_params[:kind]}."
    else
      tournament = Tournament.new({
        :host  => current_player,
        :title => safe_params[:title],
        :kind  => safe_params[:kind],
        :rules => safe_params[:rules]
      })
      tournament.save!
      render :json => { :id => tournament.id }
    end
  end

  def show
    tournament = get_tournament
    if tournament
      result = { :tournament => tournament }
      if tournament.started
        begin
          result[:ranking] = API::TournamentStrategy.resolve_ranking(tournament)
        rescue NotImplementedError => err
          render :status => :not_implemented, :text => err.message
        end
      else
        result[:registered] = Registration.where(tournament: tournament)
      end
      render :json => result
    else
      render :status => :not_found, :text => "Tournament not found."
    end
  end

  def update
    tournament = get_tournament
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
    tournament = get_tournament
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

  def start
    tournament = get_tournament
    if !tournament
      render :status => :not_found, :text => "Tournament not found."
    elsif tournament.started
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

  def register
    tournament = get_tournament
    if !tournament
      render :status => :not_found, :text => "Tournament not found."
    elsif tournament.started
      render :status => :bad_request, :text => "Tournament already started."
    elsif tournament.registered?(current_player)
      render :status => :conflict, :text => "Player already registered."
    else
      Registration.new({
        :tournament => tournament,
        :player     => current_player,
        :accepted   => false
      }).save!
      render :nothing => true, :status => :no_content
    end
  end

  def accept
    tournament = get_tournament
    if !tournament
      render :status => :not_found, :text => "Tournament not found."
    elsif tournament.started
      render :status => :bad_request, :text => "Tournament already started."
    elsif !tournament.registered?(current_player)
      render :status => :conflict, :text => "Player not registered."
    else
      player = Player.find(params[:player_id])
      registration = Registration.where(tournament: tournament, player: player).first
      if registration
        registration.accepted = params[:accepted]
        registration.save!
        render :nothing => true, :status => :no_content
      else
        render :status => :not_found, :text => "Registration not found."
      end
    end
  end

  private

  def get_tournament
    Tournament.find_by_id(params[:id])
  end
end
