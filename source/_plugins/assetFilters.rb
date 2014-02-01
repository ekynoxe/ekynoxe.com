module Jekyll
    module AssetFilter

        def image_path(assetName)
            # [page][name] should be set by the MetadataGenerator plugin
            pageId = @context.environments.first['page']['name']
            "content/#{pageId}/#{assetName}"
        end

        def cdn(input)
            "#{@context.registers[:site].config['cdn']}/#{input}"
        end

        def urlize(text)
            text.gsub(/(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/i,"<a href='\\1'>\\1</a>")
        end
    end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)