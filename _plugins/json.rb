# Convert liquid objects to json.  Very useful for display in a javascript console.
#  <script type="text/javascript">
#    console.log("site: %O", {{ site | json }});
#  </script>

require 'json'

module Jekyll
  module JsonFilter
    def json(obj)
      obj.to_json.gsub /\/script/, '\/script'
    end
  end
end

Liquid::Template.register_filter(Jekyll::JsonFilter)
