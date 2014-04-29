#http://itshouldbeuseful.wordpress.com/2011/11/07/passing-parameters-to-a-rake-task/

namespace :notebooks do

  desc "Generate notebooks with unique identifiers"
  task :generate, [:color, :paper, :count] => [:environment] do |t, args|
    args.with_defaults(count: 100)

    if args[:color] && args[:paper]
      nids = Notebook.generate(args[:color], args[:paper], args[:count].to_i)
      puts nids.join("\n")
    else
      puts "Need color, paper"
    end
  end


  # This task is ran as such:
  #
  # rake notebooks:import[http://somurltocodes.com/codes]
  #
  # It expects the url to return a lists of codes with each code
  # being on a new line
  # See as example: http://f.cl.ly/items/0p453Z282A2n433B3b0Q/codes.txt

  desc "Import existing notebook identifiers from STDIN"
  task :import, [:url] => [:environment] do |t, args|
    url = args[:url]
    abort("No URL given") if url.blank?

    response = HTTParty.get(url)

    abort("Bad request") if response.code != 200

    codes = response.body.split( /\r?\n/ )

    notebooks = codes.map do |code|
      begin
        Notebook.create!(notebook_identifier: code)
      rescue StandardError => e
        puts "Notebook with code #{code} could not be created. #{e.message}"
      end
    end.compact

    puts "Created #{notebooks.count} notebooks"
  end
end
