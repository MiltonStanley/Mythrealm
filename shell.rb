class World < Array
  attr_reader :name, :height, :width
  
  def initialize(height, width, name, new_room_x, new_room_y)
    @name = name
    @height = height
    @width = width
    @map = Array.new(width)
    @map.map! { Array.new(height) }
    @map[new_room_y][new_room_x] = Room.new('null','null')
    @map
  end
    
  def add(roomID, x, y)
  end
  
  def room (y, x)
    @map[y][x]
  end
  
  #~ def [(y),(x)]
    #~ self[y][x]
  #~ end
  
end

class Room
  attr_accessor :name, :description
  def initialize(name, description)
    @name = name
    @description = description
  end
  
end

class Console
  
  def initialize(player, world, room_y, room_x)
    @player = player
    @room = [room_y, room_y]
    @room_name = world.room(room_y,room_x).name
    @room_description = world.room(room_y, room_x).description
    3.times { puts }
    puts @room_name
    puts @room_description
    puts "You are #{@player.name}"
    puts
    print '...>'
  end
  
  def whoami
    puts
    puts "Silly! You're #{@player.name}!"
  end
  
  def edit(*args)
    if @player.type != 'admin'
      puts "Editing is only available to admins. Sorry!"
      exit
    else
      args.each_index { |i| puts "#{i}: #{args[i]}" }
      if args[0] == 'room'
        if args[1] == 'name'
          $WORLD.room(@room[0],@room[1]).name = args[2].capitalize unless args[2].nil?
          puts "You must supply the room name!" if args[2].nil?
        elsif args[1] == 'description'
          puts 'changing room description'
        else
          puts 'invalid room editing target!'
        end
      else
        puts 'invalid edit target!'
      end
    end
  end
  
  def save
    begin
      save = File.new("#{$WORLD.name}.txt",'w')
      save.puts "#{$WORLD.name}"
      save.puts "Height: #{$WORLD.height}"
      save.puts "Width: #{$WORLD.width}"
    ensure
      save.close
    end
  end

  def method_missing(*args)
    puts "#{args[0].capitalize} is not a valid command!"
  end
  
end

class Player
  
  attr_reader :name, :type
  
  def initialize(name, account_type)
    @name = name
    @type= account_type
  end
  
end

milton = Player.new("Milton", 'admin')
$WORLD = World.new(2, 2, "Mythrealm", 1, 1)
#console = Console.new(mythrealm)

command = ""
while command != 'exit'
  console = Console.new(milton, $WORLD, 1, 1)
  command = gets.chomp
  command.downcase!
  command, *args = command.split("\s")
  console.send(command, *args)
end



