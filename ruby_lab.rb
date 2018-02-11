
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# <firstname> <lastname>
# <email-address>
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "<firstname> <lastname>"

def cleanup_title(line)
  title = line.gsub(/^.*<SEP>/, "")
  title.gsub!(/[\(\[\{\/\\\_\-\:\"\`\+\=\*].*/, "")
  title.gsub!(/feat\..*/, "")
  title.gsub!(/[\?\¿\!\¡\.\;\&\@\%\#\|]/, "")
  title.gsub!(//, "")
  title.downcase!()
  if title =~ /[^\w\s\']/
    return nil
  else
    return title
  end
end

def build_bigrams(song_titles)
  song_titles.each do |title|
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
  if $bigrams[word].nil?
    return nil
  else
    $bigrams[word].each do |key, value|
      if value > count
        count = value
        follower = key
      end
    end
    return follower
  end
end

def create_title()

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "
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
end

if __FILE__==$0
	main_loop()
end
