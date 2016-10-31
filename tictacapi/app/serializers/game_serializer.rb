class GameSerializer < ActiveModel::Serializer
	attributes :id, :playedCells, :gameScore, :playerID

	has_one :player
	has_one :state (inprogress, complete)