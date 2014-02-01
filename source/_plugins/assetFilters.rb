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
    end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)