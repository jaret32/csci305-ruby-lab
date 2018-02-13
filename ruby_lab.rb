
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Jaret Boyer
# jaret.c.boyer@gmail.com
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "Jaret Boyer" # My Name

# Takes a line from the input file and extracts the song title, then filtering out other patterns
def cleanup_title(line)
  # removes everything except whats after the last <SEP>
  title = line.gsub(/^.*<SEP>/, "")
  # removes everything after and including the following symbols
  title.gsub!(/[\(\[\{\/\\\_\-\:\"\`\+\=\*].*/, "")
  title.gsub!(/feat\..*/, "")
  # removes punctuation
  title.gsub!(/[\?\¿\!\¡\.\;\&\@\%\#\|]/, "")
  # sets to lowercase
  title.downcase!()
  # removes common stop words
  title.gsub!(/a\b|an\b|and\b|by\b|for\b|from\b|in\b|of\b|on\b|or\b|out\b|the\b|to\b|with\b/, "")
  # if title has non english characters, return nothing
  if title =~ /[^\w\s\']/
    return nil
  else
    return title
  end
end

# builds the word bigram
def build_bigrams(song_titles)
  song_titles.each do |title|
    # splits titles into words and adds them to the nested hash
    words = title.split(" ")
    for i in 0..words.length-2
      if $bigrams[words[i]].nil?
        $bigrams[words[i]] = {words[i+1] => 1}
      else
        if $bigrams[words[i]][words[i+1]].nil?
          $bigrams[words[i]][words[i+1]] = 1
        else
          $bigrams[words[i]][words[i+1]] += 1
        end
      end
    end
  end
end

def mcw(word)
  count = 0
  follower = nil
  # if there is no word occuring after
  if $bigrams[word].nil?
    return nil
  else
    # check each occuring word to see which one occurs most
    $bigrams[word].each do |key, value|
      if value > count
        count = value
        follower = key
      end
    end
    return follower
  end
end

def create_title(start)
  title = [start]
  current = start
  while title.length < 20 do
    next_word = mcw(current)
    if next_word.nil?
      break
    end
    current = next_word
    if title.include?(current)
      break
    end
    title.push(current)
  end
  return title.join(" ")
end

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "
  # array to hold all song titles, used to build bigram
  song_titles = Array.new

	begin
		if RUBY_PLATFORM.downcase.include? 'mswin'
			file = File.open(file_name)
			unless file.eof?
				file.each_line do |line|
          title = cleanup_title(line)
          if title != nil
            song_titles.push(title)
          end
				end
			end
			file.close
		else
			IO.foreach(file_name, encoding: "utf-8") do |line|
				title = cleanup_title(line)
        if title != nil
          song_titles.push(title)
        end
			end
		end

    puts "#{song_titles.length} valid song titles found"

    build_bigrams(song_titles)

		puts "Finished. Bigram model built.\n"

	rescue => exception
    # added exception stuff to debug code better
    puts exception
    puts exception.backtrace
		STDERR.puts "Could not open file"
		exit 4
	end
end

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])

	# Get user input
  print ("Enter a word [Enter 'q' to quit]: ")
  # had to change to $stdin becuase it was getting input from file
  input = $stdin.gets.chomp
  while input != "q" do
    puts create_title(input)
    print ("Enter a word [Enter 'q' to quit]: ")
    input = $stdin.gets.chomp
  end
end

if __FILE__==$0
	main_loop()
end
