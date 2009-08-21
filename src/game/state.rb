module Game
  class State
    attr_reader :players, :game
    
    def initialize(game, players)
      @game = game
      @players = players
      
      @players.each do |player|
        player.game_state = self
      end
    end
    
    def self.from_xml(xml, game)
      players = []
      xml['players'].first['player'].each do |player|
        position = player['position'].first
        players << Game::Player.new(player['name'], [position['x'].to_i, position['y'].to_i])
      end
      
      self.new(game, players)
    end
  end
end