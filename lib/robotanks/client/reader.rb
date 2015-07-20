module Robotanks
  class Client::Reader
    include Celluloid

    attr_reader :socket, :recipient

    def initialize(socket, recipient)
      @socket = socket
      @recipient = recipient
    end


    def read_messages
      loop{
        break if socket.closed?

        socket.wait_readable

        json = socket.readline
        next if json == ""
        hash = ActiveSupport::JSON.decode json

        hash.each do |name, params|
          message = Message.new name, params
          recipient.mailbox << message
        end

      }
    end



  end
end
