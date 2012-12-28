require 'gserver'

class ChatServer < GServer
  def initialize(*args)
    super(*args)

    @@client_id = 0   # Keeps track of # of users who have logged in
    @@chat = []       # Array housing speaker & comments
  end
  
  def serve(io)
    @@client_id += 1            # Increment ID list
    my_client_id = @@client_id  # Assign it to current user
    my_position = @@chat.size   # Same as client_id

    io.puts("Welcome to the chat, client #{@@client_id}!")
    io.puts("There are currently #{self.connections} connections.")

    @@chat << [my_client_id, "I've joined the chat!"]

    loop do
      if IO.select([io], nil, nil, 0) # We have a new line!!
        line = io.readline      
        
        if line =~ /quit/     # Disconnect user
          @@chat << [my_client_id, "I've left the chat!"]
          break
        end

        if line =~ /report/   # Debugging - outputs the chat log
          @@chat.each { |line| io.puts line }
        end

        self.stop if line =~ /shutdown/ # Shut down the server

        @@chat << [my_client_id, line]      

      else  # No new line
        # No data, so print any new lines from the chat stream
        @@chat[my_position..-1].each_with_index do |line, index|
          io.puts("#{line[0]} says: #{line[1]}")
        end
        
        # Move the position to one past the end of the array
        my_position = @@chat.size
      end
    end
    
  end
end

server = ChatServer.new(1234)
server.start
server.join

puts "Server has been terminated"