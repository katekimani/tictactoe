class GamesController < ApplicationController
	# skip_before_action :ensure_authorization_token_exists, :authenticate_user
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
                                "status" => "401",
                                "title" => "Game not started",
                                "detail" => "Game not created try again"
                              }] 
                    }, :status => 401
    end
    $moves = []
    $currentPlayer = 1
    $progress1 = []
    $progress2 = []
end

def status
	@status = Game.find(params[:gameid])
	# puts @status.status
	render json: { data: { attributes: { currentPlayer: $currentPlayer, gameState: @status.status, winner: @status.winner }}}
end

def play
		
	if (($moves.length < 1) || (!$moves.include? game_params[:move]))
	   $moves.push(game_params[:move])

	   @playmove = @game.plays.new(player: game_params[:player], move: game_params[:move])

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
			render json: {errors: [{"status" => "643", "title" => "move not saved"}]}
		end
    else
		render json: { errors: [{
                                "status" => "404",
                                "title" => "Invalid move",
                                "detail" => "Move already played"
                              }] 
                    }
	end
end

def checkWin(progress)
	puts "The moves array",$moves.inspect
	puts "The progress passed array",progress.inspect
	# puts "The progress2 array",$progress2.inspect
	if ($moves.length == 9)
		@winstate = @game.update_attributes(status: "Completed", winner: "Tie")
		puts @winstate.inspect
		return 2
		# render json: { data: { attributes: { gameState: 'Completed', winner: 'Tie'}}}
	else
		$winSequence.each do |i,j,k|
			print ("i=#{i},j=#{j},k=#{k}\n")
			# puts "#{i}".inspect
			@a = progress.include? "#{i}"
			# puts @a.inspect
			@b = progress.include? "#{j}"
			# puts @b.inspect
			@c = progress.include? "#{k}"
			# puts @c.inspect
			if (@a == true && @b == true && @c == true)
				puts "You win"
				@winstate = @game.update_attributes(status: "Completed", winner: $currentPlayer)
				return 1
			else
				return 0 
			end
		end
		
	end

	# @wins = @game.plays.group(:player, :move).count
	# 	  puts @wins.inspect
end


private
def game_params
	params.require(:data).permit(:gameid, :player, :move)
end

def set_game
	@game = Game.find(game_params[:gameid])
end

end

