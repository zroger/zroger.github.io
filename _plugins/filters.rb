module DrupalRake
  module Jekyll
    # Adds some extra filters used during the category creation process.
    module Filters

      def link_class(page_url, link_url)
        # normalize urls first
        [page_url, link_url].each do |url|
          url.sub! /\/index\.html$/, ""
          url.sub! /\/$/, ""
        end

        page_url == link_url ? "active" : ""
      end

    end
  end
end

Liquid::Template.register_filter(DrupalRake::Jekyll::Filters)