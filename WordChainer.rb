require 'set'

class WordChainer
	attr_reader :dictionary

	def initialize(dictionary_file_name = "dictionary.txt")
		@dictionary = File.open(dictionary_file_name).readlines.map(&:chomp)
		@dictionary = Set.new(@dictionary)
	end

	def adjacent_words(word)
		adjacent_words = []
		letters = word.split(//)
		dict = self.dictionary.dup

		letters.each_with_index do |letter, index|
			('a'..'z').each do |char|
				new_word = word.dup
				new_word[index] = char
				adjacent_words << new_word if dict.include?(new_word)
			end
		end

		adjacent_words.reject {|adj| adj == word}
	end
	
	def run(source = "mark", target = "temp")
		if source.length != target.length
			puts "No path possible between #{source} and #{target}"
			puts "The source and target must be the same length"
			return false
		end

		@current_words = [source]
		@all_seen_words = { source => nil }

		until @current_words.empty? || @all_seen_words.include?(target)
			explore_current_words
		end

		path = build_path(target)

		if path.count > 1
			puts "Path found from #{source} to #{target}"
			path.each {|word| puts word}
			return true
		else
			puts "No path found from #{source} to #{target}"
			return false
		end
	end

	def explore_current_words
		new_current_words = []

		@current_words.each do |current_word|
			adjacent_words(current_word).each do |adj_word|
				next if @all_seen_words.include?(adj_word)
				new_current_words << adj_word
				@all_seen_words[adj_word] = current_word
			end
		end
		
		# new_current_words.each {|word| puts "#{word} => #{@all_seen_words[word]}" }
		@current_words = new_current_words
	end

	def build_path(target)
		path = [target, @all_seen_words[target]]
		next_word = path.last


		until next_word == target || next_word == nil
			path << @all_seen_words[next_word]
			next_word = path.last
		end

		path.compact.reverse

	end
end

test_wc = WordChainer.new
test_wc.run
