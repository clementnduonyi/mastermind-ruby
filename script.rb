class MasterMind
    def initialize
        @board =  Board.new
        @player = Game.new(breaker_picker)
        @code = @player.code_filter
        start
       
        
    end

    def breaker_picker
        puts 'Select who to be the breaker'
        puts '[H] ' + 'Human breaker'

        puts '[C] ' + 'Computer breaker'
            
        puts '[Q] ' + 'To Exit'
        gets.chomp
       
    end

    def start
        #puts "secrete number is: #{@code}"
        while !game_over?
            @guesses = @player.get_code(@guesses, @game_analysis)
            exit if %w[Q q].include?(@guesses)
            @game_analysis = interprete_guesses
            @board.update(@guesses, @game_analysis)
            sleep(1)
            break if game_over? || win?
        end
    end

    def interprete_guesses
        @correct_guess = @code.scan(/[#{Regexp.quote(@guesses)}]/).size
        @correct_position = @code.chars.select.with_index {|character, idx| character == @guesses[idx]}.size
        '!' * @correct_position + '?' * (@correct_guess - @correct_position) + '-' * (4 - @correct_guess)
        
    end

    def game_over?
        if @board.rounds == 12
            puts "Game over! The secret code was #{@code}"

            exit
        end
    end

    def win?
        return until @code == @guesses
        
        puts "Congratulations! You crack the code at Round #{@board.rounds}"
        exit
    end

end

class Board
    attr_accessor :rounds

    def initialize
        @board = ''
        @game_analysis = ''
        @rounds = 0
    end

    def update(guesses, game_analysis)
        @board += guesses
        @game_analysis += game_analysis
        @rounds += 1
        display_unit
    end

    def display_unit
        rounds.times do |i|
            puts "#{@board[0 + i]} #{@board[1 + i ]} #{@board[2 + i]} #{@board[3 + i ]}\t\t"
            puts "#{@game_analysis[0 + i * 4]} #{@game_analysis[1 + i * 4]} #{@game_analysis[2 + i *4]} #{@game_analysis[3 + i * 4]}"
        end
    end

end

class Game
    #attr_writer :breaker

    def initialize(breaker)
        @breaker = breaker
        
    end

    def code_filter
        if %w[H h].include?(@breaker)
            4.times.map{rand(1 .. 6)}.join

        elsif %w[C c].include?(@breaker) 
            puts 'Creat your secret 4 digits code here. E.g: 1234'
            gets.chomp
        elsif %w[Q q].include?(@breaker)
            exit
       
        end
    end

    def get_code(guesses, game_analysis)
        if %w[H h].include?(@breaker)
            puts "PS: Your guess must be a 4 digits number \n...formed with integers from 1...6 \n...and you have 12 rounds to guess right."
            puts 'Goodluck!'
            puts 'Make a guess. ' 
            gets.chomp
        elsif %w[C c].include?(@breaker)
            calculate_guess(@guesses, @game_analysis)

        else
            puts 'Invalid Input. Try again'
        end
    end

    def calculate_guess(guesses, game_analysis)
        if @game_analysis.nil?
            @all_codes = (1111 .. 6666).map(&:to_s).reject{|x| x.include?('0')}
            '1122'

        else
            @all_codes.delete(guesses)
            @all_codes.select!{|x| 4 - (x.chars - guesses.chars)}.size == game_analysis.count('?') + game_analysis.count('!')
            @all_codes.select! do |c|
                c.chars.select.with_index {|c, idx| c == guesses.chars[idx]}.size == game_analysis.count('!')
            end
            @all_codes[0]
        end
    end
end




MasterMind.new