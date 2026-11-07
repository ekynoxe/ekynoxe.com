module Jekyll
    module AssetFilter

        def image_path(assetName)
            # Posts get [page][name] from the MetadataGenerator plugin; pages use their section.
            # Pages are no longer renamed to their section: that stopped news/index.html
            # from being used as the pagination template.
            page = @context.environments.first['page']
            pageId = page['section'] || page['name']
            "content/#{pageId}/#{assetName}"
        end

        def cdn(input)
            "#{@context.registers[:site].config['cdn']}/#{input}"
        end

        def local(input)
            "/assets/drafts/#{input}"
        end

        def urlize(text)
            text.gsub(/(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/i,"<a href='\\1'>\\1</a>")
        end
    end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)