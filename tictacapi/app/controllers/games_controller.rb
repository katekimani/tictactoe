class GamesController < ApplicationController
before_action :set_game, only:[:play]

$moves = []
$currentPlayer = 1
$winSequence = [[1,2,3],[1,4,7],[1,5,9],[2,5,8],[3,6,9],[3,5,7],[4,5,6],[7,8,9]]
$progress1 = []
$progress2 = []

def start
	@game = Game.new(status: "In Progress");
	if @game.save
		render json: { data: { attributes: { game_id: @game.id } } }
	else
		render json: { errors: [{
                                "status" => "418",
                                "title" => "Game not started",
                                "detail" => "Game not created try again"
                              }] 
                    }, :status => 422
    end
    $moves = []
    $currentPlayer = 1
    $progress1 = []
    $progress2 = []
end

def status
	@status = Game.find(params[:gameid])

	render json: { data: { attributes: { currentPlayer: $currentPlayer, gameState: @status.status, winner: @status.winner }}}
end

def play
	if (($moves.length < 1) || (!$moves.include? game_params[:move]))
	   $moves.push(game_params[:move])

	   @playmove = @game.plays.new(player: $currentPlayer, move: game_params[:move])

	   if ( @playmove.save )
		   	if ($currentPlayer == 1)
		   		$progress1.push(game_params[:move])
		   		@win = checkWin($progress1)
		   		$currentPlayer = 2
		   	else
		   		$progress2.push(game_params[:move])
		   		@win = checkWin($progress2)
	    	    $currentPlayer = 1
		   	end
		   	
		  render json: { data: { attributes: { player: @playmove.player, move: @playmove.move, isWin: @win  }}}
       else
			render json: {errors: [{"status" => "422", "title" => "move not saved"}]}, :status => 422
		end
    else
		render json: { errors: [{
                                "status" => "422",
                                "title" => "Invalid move",
                                "detail" => "Move already played"
                              }] 
                    }, :status => 422
	end
end

def checkWin(progress)
	$winSequence.each do |i,j,k|
	# print ("i=#{i},j=#{j},k=#{k}\n")
		@a = progress.include? "#{i}"
		@b = progress.include? "#{j}"
		@c = progress.include? "#{k}"

			if (@a == true && @b == true && @c == true)
				@winstate = @game.update_attributes(status: "Completed", winner: $currentPlayer)
				return 1
			end
	end
	
	if ($moves.length == 9)
		@winstate = @game.update_attributes(status: "Completed", winner: "Tie")
		puts @winstate.inspect
		return 2
	else
		return 0
	end
end


private
def game_params
	params.require(:data).permit(:gameid, :move)
end

def set_game
	@game = Game.find(game_params[:gameid])
end

end