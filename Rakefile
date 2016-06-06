
require 'rake'
require 'rdoc/task'
require 'rake/testtask'

SRC_DIR = "party_prawn_submarine"
DOC_DIR = "doc"
TEST_DIR = "tests"

PROJ_TITLE = "Party Prawn Submarine"


RDoc::Task.new do |rdoc|
	rdoc.title = PROJ_TITLE
	rdoc.rdoc_dir = DOC_DIR
	rdoc.rdoc_files.add(SRC_DIR + "/**/*.rb")

	rdoc.options << "--force-update"
end

Rake::TestTask.new do |tests|
	tests.libs << SRC_DIR

	tests.test_files = FileList[TEST_DIR + "/**/test*.rb"]

	tests.verbose = true
end

