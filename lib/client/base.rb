module Client
  # The most basic client which is kind of a client specification
  class Base
    attr_reader :player
    
    # Initialize the client on connection to the server
    def initialize(game, player = nil)
      @game = game
      @player = player
    end
    
    # Do whatever the client would like to do.
    # This is called by the server in any game loop.
    def act
    end

    # The server wants to close the connection to the client.
    # Clean up the stuff in here
    def disconnect
    end
    
    protected
    def id
      object_id
    end
    
    def log(level, message)
      Logger.send(level, "Client #{id}: #{message}")
    end
  end
end