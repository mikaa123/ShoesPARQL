require 'SparqlTransmission'
require 'FindPredicats'
require 'examples'

Shoes.app :title => "ShoesPARQL", :width => 954, :height => 611, :resizable => false do

  background "background.png"

  para link("Open Predicat Explorer") {find_predicats(@url.text)}, " ",
  link("Examples") {examples}, :top => 205, :left => 430

  stack :width => 400, :top => 270, :margin => 30 do
    @url = edit_line "http://dbpedia.org/sparql", :width => "100%"
    @query = edit_box %[
SELECT ?subject 
WHERE 
{
   
 ?subject <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://dbpedia.org/ontology/Person>

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
      button "Generate Ruby Code" do
        
        ruby_code = "require 'SparqlTransmission'\n
st = SparqlTransmission.new '#{@url.text}'
st.query = %[#{@query.text.chomp}
]
st.execute_async_query do |res|
  #The results are right here
end"
                    
        @results.text = ruby_code
      end
    end
  end

  stack :width => -400, :top => 270, :margin => 30, :height => 350, :scroll => true do
    @results = para "Your results will go here. That's when you ", strong("execute the query"), " of course.\n\n",
                    "if you want to check a little tutorial on the semantic web, check my guide ",
                    link("Rubyist's instant grasp on semantic web",
                    :click => "http://s139459221.onlinehome.fr/Semantic_web_guide/"),
                    "\n\n", strong("Long live Ruby and Shoes!"), "\nMichael"
  end

end