#!/usr/bin/ruby
class Game
  attr_accessor :board, :player1, :player2, :player1_turn

  def initialize(player1, player2)
    @board = Board.new

    # first player is always X
    @player1 = Player.new(player1, 'X')
    @player2 = Player.new(player2, 'O')

    @player1_turn = true
  end

  # method to switch turns
  def pick_turn
    player = (@player1_turn) ? @player1 : @player2
    @player1_turn = !@player1_turn

    player
  end

  # if a player wins, his score is incremented
  def player_has_won(player)
    player.score += 1

    puts player.name + ' has won!'
    puts "Current score: "
    puts "#{@player1.name} - #{@player1.score} : #{@player2.name} - #{@player2.score}"
  end

  def start
    @board.display

    # while nobody won the game or it's not draw
    while win == "no"
      player = pick_turn

      puts "#{player.name}'s turn"

      choices = player.pick

      if choices.nil?
        puts "Invalid input, you're supposed to pick 2 numbers between 1 and 9"
        pick_turn
      elsif @board.map[choices[0]][choices[1]] != '-'
        puts "This place is already occupied, pick another"
        pick_turn
      else
        puts @board.map[choices[0]][choices[1]] = player.symbol
      end

      puts '#' * 25

      @board.display
    end
  end

  def win
    # prepare the winning player if it is the case
    player = (@player1_turn) ? @player2 : @player1

    # check diagonals
    if @board.map[0][0] != '-' &&
       @board.map[0][0] == @board.map[1][1] &&
       @board.map[1][1] == @board.map[2][2]

       player_has_won(player)

      return @board.map[0][0]
    end

    if @board.map[0][2] != '-' &&
       @board.map[0][2] == @board.map[1][1] &&
       @board.map[1][1] == @board.map[2][1]

       player_has_won(player)

      return @board.map[0][2]
    end

    # check horizontal
    if @board.map[0][0] != '-' &&
       @board.map[0][0] == @board.map[0][1] &&
       @board.map[0][1] == @board.map[0][2]

      player_has_won(player)

      return @board.map[0][0]
    end

    if @board.map[1][0] != '-' &&
       @board.map[1][0] == @board.map[1][1] &&
       @board.map[1][1] == @board.map[1][2]

      player_has_won(player)

      return @board.map[1][0]
    end

    if @board.map[2][0] != '-' &&
       @board.map[2][0] == @board.map[2][1] &&
       @board.map[2][1] == @board.map[2][2]

      player_has_won(player)

      return @board.map[2][0]
    end

    # check vertical
    if @board.map[0][0] != '-' &&
       @board.map[0][0] == @board.map[1][0] &&
       @board.map[1][0] == @board.map[2][0]

      player_has_won(player)

      return @board.map[0][0]
    end

    if @board.map[0][1] != '-' &&
       @board.map[0][1] == @board.map[1][1] &&
       @board.map[1][1] == @board.map[2][1]

      player_has_won(player)

      return @board.map[0][1]
    end

    if @board.map[0][2] != '-' &&
       @board.map[0][2] == @board.map[1][2] &&
       @board.map[1][2] == @board.map[2][2]

      player_has_won(player)

      return @board.map[0][2]
    end

    # check whether the board contains '-', otherwise return draw
    if @board.map.any? { |line| line.include? '-' }
      return "no"
    else
      puts "Draw"
      puts "Current score: "
      puts "#{@player1.name} - #{@player1.score} : #{@player2.name} - #{@player2.score}"

      return "draw"
    end

    "no"
  end

  class Player
    attr_accessor :name, :score, :symbol

    def initialize(name, symbol)
      @name = name
      @symbol = symbol
      @score = 0
    end

    def pick
      puts 'Pick X and Y coordinates: '

      # since we're using arguments, the default gets method is
      # the Kernel.gets one, so we have to explicitly specify the module
      coords = STDIN.gets.chomp.split.map { |e| e.to_i - 1 }

      if coords.length != 2
        puts "Wrong input: You're supposed to enter 2 numbers"
        return nil
      elsif coords[0] < 0 || coords[1] < 0 ||
            coords[0] > 8 || coords[1] > 8

        puts "Wrong input: You're supposed to enter 2 numbers between 1 and 9"
        return nil
      end

      coords
    end
  end

  class Board
    attr_accessor :map

    def initialize
      # the board is a 3x3 matrix
      @map = Array.new(3) { Array.new(3) { |val| '-' } }
    end

    def display
      @map.each do |line|
        line.each do |value|
          print value + ' '
        end

        puts ''
      end

      puts ''
    end
  end
end

# get the player names as arguments 
name1, name2 = ARGV

game = Game.new(name1, name2)

game.start
