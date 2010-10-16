require '../SparqlTransmission/lib/SparqlTransmission'
require 'FindPredicats'

Shoes.app :title => "ShoesPARQL", :width => 954, :height => 611 do

  background "background.png"

  para link("Open Predicat Explorer") {find_predicats(@url.text)}, :top => 205, :left => 430

  stack :width => 400, :top => 270, :margin => 30 do
    @url = edit_line "http://dbpedia.org/sparql", :width => "100%"
    @query = edit_box %[
      SELECT ?subject ?predicat ?object 
      WHERE 
      { 
        ?subject ?predicat ?object
      }
      ], :width => "100%", :height => 200

    flow do
      button "Execute" do
        @status.text = "Loading"
        @st = SparqlTransmission.new @url.text
        @st.query = @query.text
        @st.execute_async_query do |res|

          @status.text = "Ready"
          # Shows the results with the full URI
          @results.text = res.collect do |r|
            r.collect { |s| s * ": " } * " | "
          end * "\n"
        end
      end
      @status = para "Ready"
    end
  end

  stack :width => -400, :top => 270, :margin => 30 do
    @results = edit_box :width => "100%", :height => 200
  end

end