$:.unshift(File.expand_path('../../', __FILE__))

require "tracker"
require "deltatracker"

module Commands

	class ListCommand
		def initialize(tracker)
			@tracker = tracker
		end

		def run(commandcontext)
			type = commandcontext.pop_argument! if commandcontext.number_of_arguments > 0
			status = commandcontext.pop_argument! if commandcontext.number_of_arguments > 0

			@tracker.all {|x|
				if (x.type == type || type == nil) && (x.status == status || status == nil)
					commandcontext.output(x)
				end
			}
		end

		def help(commandcontext)
			commandcontext.output 'Use pug list [type [status]]'
		end
	end
end