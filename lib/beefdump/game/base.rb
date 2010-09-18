module Beefdump
  module Game
    class Base
      require 'beefdump/game/state'
      require 'beefdump/game/player'
    
      CLIENT_UPDATE_RATE      = 1.0 / 10 # 10 times a second
      GAME_STATE_PATH         = "#{ROOT_PATH}/game_state"
      CURRENT_GAME_STATE_FILE = "#{GAME_STATE_PATH}/current.bin"

      attr_reader :map
  
      def initialize
        load_static_data
        load_map('test')
        init_game_state
    
        load_clients

        @shutdown = false

        game_loop
      end
  
      def load_map(new_map)
        @map = Map.load(new_map)
      end
  
      def shutdown!
        Logger.info "Received shutdown command from client. Quitting game."
        save_game_state
        @shutdown = true
      end
  
      def claim_player(name, client)
        player = @state.players.select {|p| p.name == name}.first
        raise "Player not found" unless player
        player
      end
  
      def should_run?
        !@shutdown
      end
  
      protected
  
      def init_game_state
        Logger.info("Loading game state.")
      
        if File.exist?(CURRENT_GAME_STATE_FILE)
          @state = File.open(CURRENT_GAME_STATE_FILE, 'r') {|f| Marshal.load(f)}
        else
          Logger.info("No saved game state found.")
          initially_create_game_state!
        end
      end
  
      def initially_create_game_state!
        initial_state = @map.get_initial_state
        @state = Game::State.from_xml(initial_state, self)
      end
  
      def save_game_state
        Logger.info("Saving game state")
        File.open(CURRENT_GAME_STATE_FILE, 'w') {|f| Marshal.dump(@state, f)}
      end
    
      def load_static_data
        World.load
      end
  
      def load_clients
        Logger.info "Loading clients."
        @clients = []
        @clients << Client::Graphical::Client.new(self)
      end
  
      def game_loop
        Logger.info "All systems go! Starting main game loop."
      
        while self.should_run?
          start_time = Time.now.to_f
      
          @clients.each do |client|
            client.act
          end
      
          passed_time = Time.now.to_f - start_time
          sleep passed_time > CLIENT_UPDATE_RATE ? 0 : CLIENT_UPDATE_RATE - passed_time
        end
        Logger.info("fin")
      end
    end
  end
end