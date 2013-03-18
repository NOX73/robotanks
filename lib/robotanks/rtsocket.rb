module Robotanks
  class RTSocket
    include Celluloid::IO

   def initialize(socket)
     @socket = socket
   end

   def readline
     line = ""
     loop{
       while char = @socket.read(1)
         return line.gsub("\r", "") if char == $/
         line << char
       end
     }
   end

   def method_missing(name, *params)
     @socket.send(name, *params)
   end
  end
end
