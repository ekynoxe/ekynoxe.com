# encoding: utf-8

require "rubygems"
require "bundler/setup"
require "stringex"
require "highline/import"
require "fileutils"

domain            = "ekynoxe.com"

public_dir        = "public"  # compiled site directory
source_dir        = "source"  # source file directory
posts_dir         = "_posts"  # directory for blog files
drafts_dir        = "_drafts" # directory for draft posts
drafts_assets_dir = "assets/drafts/content" # directory for drafts assets
server_port       = "4000"    # port for preview server eg. localhost:4000
local_target      = "/Users/matt/Sites/ekynoxe/ekynoxial.github.io/"
s3_bucket         = "s3://com.ekynoxe.www/content/"

# usage:   rake new_post["post title goes here"]
desc "Begin a new post in #{source_dir}/#{drafts_dir}"
task :new_post, :title do |t, args|
    mkdir_p "#{source_dir}/#{drafts_dir}"
    args.with_defaults(:title => 'new-post')
    title = args.title
    filename = "#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}"
    filepath = "#{source_dir}/#{drafts_dir}/#{filename}.md"
    if File.exist?(filepath)
        abort("rake aborted!") if ask("#{filepath} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
    end
    print "Creating new post: #{filepath}...\n"
    open(filepath, 'w') do |post|
        post.puts "---"
        post.puts "draft: true"
        post.puts "layout: post"
        post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
        post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
        post.puts "categories: "
        post.puts "---"
    end

    print "Creating new post draft asset folder for: #{filename}\n"
    mkdir_p "#{source_dir}/#{drafts_assets_dir}/#{filename}"
    puts "[DONE!]\n"
end

# usage:   rake generate
desc "Generate jekyll site"
task :generate do
    print "Generating Site with Jekyll…\t"
    system "compass compile --css-dir #{source_dir}/assets/css"
    system "jekyll build --source ./#{source_dir} --destination ./#{public_dir}"
    system "rsync -av --exclude 'assets/drafts' public/ #{local_target}"
    puts "[DONE!]\n"
end

# usage:   rake preview
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


# usage:   rake publish
#   and follow the prompts
desc "Publish posts currently written as drafts"
task :publish do
    # * read all posts file names in the _drafts directory
    # * present them as options to chose from on the command prom[t with a digit to enter
    # * error control to prevent wrogn input
    # * remove "draft: true" line from post
    # * change date to publication (now) date/time
    # * check if a post already exist with same target name
    # * move post to _posts/new-date-[post_title]

    drafts = []
    Dir.foreach("#{source_dir}/#{drafts_dir}").each do |file|
        next if file == '.' or file == '..' or file =~ /\.DS.*/
        drafts << file
    end

    if drafts.size == 0
        puts "There are no drafts to publish, stopping here"
        exit
    end

    print_drafts(drafts)

    input = ""

    loop do
        input = STDIN.gets.strip

        if (input == "q")
            abort("publication aborted")
        end

        valid = !!(input =~ /^[-+]?[0-9]+$/)
        if !valid
            puts ""
            puts "Please enter a valid number"
            print_drafts(drafts)
        end

        if valid && drafts[input.to_i].nil?
            valid = false

            puts ""
            puts "Please chose one the the posts in the list"
            print_drafts(drafts)
        end

        break if valid
    end

    index = input.to_i
    puts "Publishing " + drafts[index]

    draft = drafts[index]

    temp_file = File.join(source_dir, drafts_dir, "temp_file.md")
    input_file = File.join(source_dir, drafts_dir, draft)

    title = ""

    File.open(temp_file, "w") do |out_file|
      File.foreach(input_file) do |line|
        next if line.chomp == "draft: true"

        if line.chomp =~ /title: .+/
            title = line.chomp.gsub("title: ", "").to_url
        end

        if line.chomp =~ /date: .+/
            out_file.puts "written_on: " + line.chomp.match(/date: (.+)/)[1]
            out_file.puts "date: " + Time.now.strftime('%Y-%m-%d %H:%M')
        else
            out_file.puts line.gsub("| local", "| cdn") # Replacing file urls for CDN urls. Images are uploaded by the s3cmd call below.
        end


      end
    end

    output_file_name = Time.now.strftime('%Y-%m-%d') + "-#{title}"
    output_file = File.join(source_dir, posts_dir, output_file_name+".md")

    if File.exist?(output_file)
        abort("publication aborted") if ask("/!\\/!\\ \"#{output_file}\" already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
    end

    puts "Writting #{output_file}"

    FileUtils.mv(temp_file, output_file)

    puts "Uploading images to amazon S3"

    draft_assets_dir = File.join(source_dir, drafts_assets_dir, draft.gsub(".md","/"))

    system "s3cmd put --acl-public --guess-mime-type #{draft_assets_dir}* #{s3_bucket}#{output_file_name}/"

    puts "Publication complete!"
end

def print_drafts drafts
    puts ""
    puts "Select a post to publish:"
    puts ""

    i = 0
    drafts.each do |draft|
        puts i.to_s + " - " + draft
        i += 1
    end

    puts "q - exit"
    puts ""
end


# usage:   rake deploy
desc "Deploy the current generated website to its target"
task :deploy do
    puts "First, let's make sure we have the correct website version generated"
    Rake::Task["generate"].invoke

    # Switch in to the tmp dir.
    Dir.chdir local_target

    system "git add . && git commit -m 'Site updated at #{Time.now.utc}'"
    system "git push origin master"
end