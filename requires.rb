require 'pp'
require 'matrix'
require 'securerandom'
require 'logger'

class Life

	attr_reader :seed, :flag_gen, :seeded_state, :logger

	def initialize(seed: 1234, dimensions: [150, 150], logfile: "life.log")
		@seed = seed
		rng = Random.new(@seed)
		@flag_gen = lambda { rng.rand(3) - 1 }
		@seeded_state = Matrix.build(*dimensions) { rng.rand(2) }
		@logger = Logger.new(logfile)
	end

	def render(state:)
		state.row_vectors
			.map { |r| r.map { |cell| cell == 1 ? 0 : ' ' } }
			.each { |r| puts r.map { |cell| cell.to_s.rjust(1, ' ')  }.to_a.join(" ") }
		""
	end

	def clear
		if RUBY_PLATFORM =~ /win32|win64|\.NET/i
		  system("cls")
		else
		  system("clear")
		end
	end

	def tick(state:)
		new_generation = []
		state.row_vectors.each_with_index do |row, row_index|
			new_generation_row = []
			row.each_with_index do |value, col_index|
				neighbors = compute_living_neighbors(matrix: state, row_index: row_index, col_index: col_index)
				generation = compute_generation(cell_state: value, neighbors: neighbors)
				# puts "(#{row_index},#{col_index}): #{neighbors.join(" ")} value: #{value} new: #{generation}"
				new_generation_row << generation
			end
			new_generation << new_generation_row
		end
		Matrix.rows(new_generation)
	end

	private

	def compute_generation(cell_state:, neighbors:)
		case cell_state
			when -1
				solve_for_dead_cell(neighbors: neighbors)
			when 1
				solve_for_live_cell(neighbors: neighbors)
			when 0
				solve_for_birth_of_cell(neighbors: neighbors)
			else
				cell_state
		end
	end

	def solve_for_birth_of_cell(neighbors:)
		sum = neighbors.sum
		case
			when sum > 3
				1
			else
				0
		end
	end

	def solve_for_live_cell(neighbors:)
		sum = neighbors.sum
		case
			when sum < 2
				-1
			when sum >= 2 && sum <= 3
				1
			when sum > 3
				-1
			else
				-1
			end
	end

	def solve_for_dead_cell(neighbors:)
		sum = neighbors.sum
		case
			when sum == 3
				1
			else
				-1
		end
	end

	def compute_living_neighbors(matrix:, row_index:, col_index:)
		# Get the value of the element of interest
		element = matrix[row_index, col_index]

		# Get the values of the neighboring elements
		neighbors = []
		if row_index > 0 && col_index > 0
		  neighbors << matrix[row_index-1, col_index-1]
		end
		if row_index > 0
		  neighbors << matrix[row_index-1, col_index]
		end
		if row_index > 0 && col_index < matrix.column_count - 1
		  neighbors << matrix[row_index-1, col_index+1]
		end
		if col_index > 0
		  neighbors << matrix[row_index, col_index-1]
		end
		if col_index < matrix.column_count - 1
		  neighbors << matrix[row_index, col_index+1]
		end
		if row_index < matrix.row_count - 1 && col_index > 0
		  neighbors << matrix[row_index+1, col_index-1]
		end
		if row_index < matrix.row_count - 1
		  neighbors << matrix[row_index+1, col_index]
		end
		if row_index < matrix.row_count - 1 && col_index < matrix.column_count - 1
		  neighbors << matrix[row_index+1, col_index+1]
		end

		neighbors.select { |num| num >= 0 }
	end
end
