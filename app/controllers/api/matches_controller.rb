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
      if match.locked_for?(current_player)
        render :status => :unauthorized, :text => "Only the host can modify finished matches."
      elsif match.can_be_managed_by?(current_player)
        safe_params = params.require(:match).permit(
          :player1_team,
          :player2_team,
          :winner_id,
          :victory,
          :map,
          :round
        )
        if safe_params.include?(:winner_id) && (safe_params.exclude?(:victory) || safe_params.exclude?(:map) || safe_params.exclude?(:round))
          render :status => :bad_request, :text => "Victory, map, and round are required when reporting a match."
        elsif safe_params.include?(:winner_id) && [match.player1.id, match.player2.id].exclude?(safe_params[:winner_id].to_i)
          render :status => :conflict, :text => "The winner must be one of the two players of that match."
        else
          match.attributes = safe_params
          match.save!
          render :nothing => true, :status => :no_content
        end
      else
        render :status => :unauthorized, :text => "No permission to update match."
      end
    else
      render :status => :not_found, :text => "Match not found."
    end
  end
end
