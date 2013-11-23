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
      tournament = Tournament.new({
        :title => tournament_params[:title],
        :kind  => tournament_params[:kind],
        :rules => tournament_params[:rules]
      })
      tournament.save!
      generate_matches(tournament)
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

    def generate_matches(tournament)
      case tournament.kind
      when 'SRR'
        generate_matches_for_single_round_robin(tournament)
      else
        raise RuntimeError, "Cannot generate matches for tournament type: #{tournament.kind}."
      end
    end

    def generate_matches_for_single_round_robin(tournament)
      puts 'Generating matches!'
    end

    def tournament_params
      params.require(:tournament)
    end

end
