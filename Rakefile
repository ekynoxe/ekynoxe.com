# encoding: utf-8

require "rubygems"
require "bundler/setup"
require "stringex"
require 'highline/import'

domain          = "ekynoxe.com"

public_dir      = "public"  # compiled site directory
source_dir      = "source"  # source file directory
posts_dir       = "_posts"  # directory for blog files
drafts_dir      = "_drafts" # directory for draft posts
server_port     = "4000"    # port for preview server eg. localhost:4000
deploy_to_local = "/Users/matt/Sites/ekynoxe/ekynoxial.github.io/"
# remote_server   = "pegasus" # remote server for deployment
# remote_path     = "sites/kitchen/public"    # remote path for deployment

# use like this:   rake new_post["post title goes here"]
desc "Begin a new post in #{source_dir}/#{drafts_dir}"
task :new_post, :title do |t, args|
    mkdir_p "#{source_dir}/#{drafts_dir}"
    args.with_defaults(:title => 'new-post')
    title = args.title
    filename = "#{source_dir}/#{drafts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.md"
    if File.exist?(filename)
        abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
    end
    print "Creating new post: #{filename}…\t"
    open(filename, 'w') do |post|
        post.puts "---"
        post.puts "draft: true"
        post.puts "layout: post"
        post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
        post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
        post.puts "categories: "
        post.puts "---"
    end
    puts "[DONE!]\n"
end

# use like this:   rake generate
desc "Generate jekyll site"
task :generate do
    print "Generating Site with Jekyll…\t"
    system "compass compile --css-dir #{source_dir}/assets/css"
    system "jekyll build --source ./#{source_dir} --destination ./#{public_dir}"
    system "cp -R public/* #{deploy_to_local}"
    puts "[DONE!]\n"
end

# use like this:   rake preview
desc "Preview the site in a web browser"
task :preview do
    jekyll_pid = Process.spawn("jekyll serve --watch --trace --drafts --source ./#{source_dir} --destination ./#{public_dir} --port #{server_port}")
    compass_pid = Process.spawn("compass watch --css-dir #{source_dir}/assets/css")

    puts "Starting to watch source with Jekyll (PID: #{jekyll_pid}) and Compass (PID: #{compass_pid})."
    puts "Visit your site in a browser at http://localhost:#{server_port}. Press Ctrl-C to stop…\n\n"

    trap("SIGINT") do
        print "\nKilling dem processes…\t"
        [jekyll_pid, compass_pid].each { |pid| Process.kill(9, pid) rescue Errno::ESRCH }
        puts "[DONE!]\n"
        exit 0
    end

    [jekyll_pid, compass_pid].each { |pid| Process.wait(pid) }
end
