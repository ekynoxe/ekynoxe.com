module Jekyll

    class MetadataGenerator < Generator
        safe true

        def generate(site)

            posts_comments = {}

            filepath = File.join(site.source, '_includes', 'posts_comments.json')

            file = File.open(filepath) if File::exists?( filepath )
            if file
                posts_comments = JSON.parse(file.read)
                file.close
            end

            site.posts.each do |post|
                name = post.name.gsub!(/\.md$/, "")
                post.data['name'] = name
                comments_source = posts_comments[name]

                post.data['comments'] = comments_source["comments"] unless comments_source.nil?

            end

            site.pages.each do |page|
                if page.data['section']
                    page.data['name'] = page.data['section']
                end
            end
        end
    end
end
