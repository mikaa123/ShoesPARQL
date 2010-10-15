require '../SparqlTransmission/SparqlTransmission'
require 'FindPredicats'

Shoes.app :width => 562, :height => 749 do

  background "background.png"
  stack :width => "100%", :top => 270, :margin => 10 do
    
    para link("Open Predicat Explorer") {find_predicats(@url.text)}
    
    @url = edit_line "http://dbpedia.org/sparql", :width => "50%"
    @query = edit_box %[
      SELECT ?subject ?predicat ?object 
      WHERE 
      { 
        ?subject ?predicat ?object
      }
      ], :width => "100%"
      button "Execute" do
        @st = SparqlTransmission.new @url.text
        @st.query = @query.text
        @st.execute_async_query do |res|

          # Shows the results with the full URI
          @results.text = res.collect do |r|
            r.collect { |s| s * ": " } * " | "
          end * "\n"
      end
      
    end
    @results = edit_box :width => "100%", :height => 200
  end
  
end