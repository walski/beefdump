module Beefdump
  module Game
    class State
      require 'ostruct'
      attr_reader :players, :game
    
      def initialize(players)
        @players = players
      end
    
      def self.from_xml(xml, game)
        players = []
        xml['players'].first['player'].each do |player|
          position = player['position'].first
          players << Game::Player.new(player['name'], OpenStruct.new({:x => position['x'].to_i, :y => position['y'].to_i}))
        end
      
        self.new(players)
      end
    end
  end
end