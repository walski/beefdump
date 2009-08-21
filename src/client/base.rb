module Client
  # The most basic client which is kind of a client specification
  class Base
    attr_reader :players
    
    # Initialize the client on connection to the server
    def initialize(game, player = nil)
      @game = game
      @players = []
      @players << player if player
    end
    
    # Do whatever the client would like to do.
    # This is called by the server in any game loop.
    def act
    end

    # The server wants to close the connection to the client.
    # Clean up the stuff in here
    def disconnect
    end
  end
end