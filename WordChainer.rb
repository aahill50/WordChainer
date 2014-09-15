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
	
	def run(source = "purses", target = "fairly")
		@current_words = [source]
		@all_seen_words = [source]

		until @current_words.empty?
			new_current_words = []

			@current_words.each do |word|
				adjacent_words(word).each do |adj_word|
					next if @all_seen_words.include?(adj_word)
					new_current_words << adj_word
					@all_seen_words << adj_word
				end
			end
			
			new_current_words.each {|word| puts word }
			@current_words = new_current_words

		end
	end
end

test_wc = WordChainer.new
p test_wc.run