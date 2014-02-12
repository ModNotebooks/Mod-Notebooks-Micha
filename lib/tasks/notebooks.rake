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

end
