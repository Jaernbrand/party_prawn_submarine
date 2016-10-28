
require 'rake'
require 'rdoc/task'
require 'rake/testtask'

require 'fileutils'

SRC_DIR = "party_prawn_submarine"
DOC_DIR = "doc"
TEST_DIR = "tests"

ASSET_DIR = "assets"
BUILD_DIR = "build"

PROJ_TITLE = "Party Prawn Submarine"


task :build do
	FileUtils::mkdir_p BUILD_DIR
	FileUtils::cp_r(SRC_DIR, BUILD_DIR + "/" + PROJ_TITLE)
	FileUtils::cp_r(ASSET_DIR, BUILD_DIR + "/" + PROJ_TITLE + "/")
end

task :clean do
	FileUtils::rm_rf BUILD_DIR
end

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

