require 'asciidoctor'
require 'asciidoctor/extensions'

class MxgraphBlockMacro < Asciidoctor::Extensions::BlockMacroProcessor
  use_dsl

  named :mxgraph

  def process parent, target, attrs
    title_html = (attrs.has_key? 'title') ? %(<div class="title">#{attrs['title']}</div>\n) : nil
    height = (attrs.has_key? 'height') ? attrs['height']: '500px'
    width = (attrs.has_key? 'width') ? attrs['width']: '100%'
    width_height = "height: #{height}; width: #{width};"
    style = (attrs.has_key? 'style') ? attrs['style']: width_height

    html = %(
      <div class="openblock mxgraph" style="#{width_height}#{style}">
        <iframe src="#{target}" style="border: none; width: 100%; height: 100%;"></iframe>
      </div>
    )

    create_pass_block parent, html, attrs, subs: nil
  end
end

Asciidoctor::Extensions.register do
  block_macro MxgraphBlockMacro if document.basebackend? 'html'
end
