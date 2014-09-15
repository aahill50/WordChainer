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
end

# test_wc = WordChainer.new
# p test_wc.adjacent_words("cant")