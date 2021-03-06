module Guileless
  module TagLibrary
    def closing(tags)
      tags.map{|t| "/#{t}" }
    end

    def html_tags
      %w{
        a abbr address area article aside audio b base bdi bdo blockquote
        body br button canvas caption cite code col colgroup data datalist
        dd del details dfn div dl dt em embed fieldset figcaption figure
        footer form h1 h2 h3 h4 h5 h6 head header hr html i iframe img
        input ins kbd keygen label legend li link main map mark math menu
        menuitem meta meter nav noscript object ol optgroup option output
        p param pre progress q rp rt ruby s samp section select small source
        span strong style sub summary svg table tbody td textarea tfoot th
        thead time title tr track u ul var video wbr
      }
    end

    def block_level_tags
      %w{
        address article aside audio blockquote canvas dd div dl fieldset
        figcaption figure footer form h1 h2 h3 h4 h5 h6 header hgroup hr
        noscript ol output p pre section table tfoot ul video
      }
    end

    def paragraph_container_tags
      %w{article aside blockquote div footer header}
    end
  end
end