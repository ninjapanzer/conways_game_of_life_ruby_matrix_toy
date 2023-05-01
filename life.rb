require_relative 'requires'

require 'optparse'

# Define default values for the arguments
options = { seed: nil, logfile: nil, dimensions: nil }

# Define an options parser with named arguments
OptionParser.new do |opts|
  opts.banner = "Usage: life.rb [options]"

  opts.on("-sSEED", "--seed=SEED", Integer, "Specify an integer seed") do |seed|
    options[:seed] = seed
  end

  opts.on("-lLOGFILE", "--logfile=LOGFILE", String, "logfile path") do |logfile|
    options[:logfile] = logfile
  end

  opts.on("-dDIMENSIONS", "--dimensions=DIMENSIONS", Array, "[X,Y]") do |dimensions|
    options[:dimensions] = dimensions.map(&:to_i)
  end
end.parse!

args = options.reject { |_, value| value.nil? }

life = Life.new(**args)

life.render(state: life.seeded_state)
sleep 0.1

current_state = Matrix.rows(life.seeded_state.to_a)
while true
	current_state = life.tick(state: current_state)
  life.clear
	life.render(state: current_state)
	sleep 0.1
end
