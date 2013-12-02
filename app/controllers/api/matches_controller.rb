class API::MatchesController < ApplicationController

  def show
    match = Match.find_by_id(params[:id])
    if match
      render :json => match
    else
      render :status => :not_found, :text => "Match not found."
    end
  end

  def update
    match = Match.find_by_id(params[:id])
    if match
      if match.can_be_managed_by?(current_player)
        safe_params = params.require(:match).permit(
          :player1_team,
          :player2_team,
          :winner_id,
          :victory,
          :map,
          :round
        )
        match.attributes = safe_params
        match.save!
        render :nothing => true, :status => :no_content
      else
        render :status => :unauthorized, :text => "No permission to update match."
      end
    else
      render :status => :not_found, :text => "Match not found."
    end
  end
end
