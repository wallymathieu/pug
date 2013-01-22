require "date"
require "yaml"

$:.unshift(File.dirname(__FILE__))
require "format"
# include all models
Dir[File.dirname(__FILE__) + "/models/*.rb"].each {|file| require file }

class Repository
	attr_reader :path

	def initialize(path)
		@path = path
	end

	def get_path_and_filename(model)
		nowpart = Format::compact_datetime(DateTime.now)
		titlepart = Format::safe_for_filename(model.title)
		filename = "#{titlepart}_#{nowpart}.yml"
		File.join(@path, filename)
	end

	def add(model)
		content = model.to_yaml
		path_and_filename = get_path_and_filename(model)
		file = File.new(path_and_filename, 'w')
		file.write(content)
		file.close
		path_and_filename
	end

	def all
		files = Dir.glob(File.join(@path, '*.yml'))
		files.map { |f| yield f, get(f) }
	end

	def get(filename_with_optional_path)
		filename_with_optional_path = File.expand_path(filename_with_optional_path)
		filename = File.basename(filename_with_optional_path)
		if filename != filename_with_optional_path
			filename_with_path = File.join(@path, filename)
		else
			filename_with_path = filename_with_optional_path
		end

		file = File.open(filename_with_path)
		d = YAML::load(file)
		file.close
		d
	end

	def set(model, filename)
		content = model.to_yaml
		file = File.new(filename, 'w')
		file.write(content)
		file.close
	end
end
