require '../SparqlTransmission/SparqlTransmission'

Shoes.app :width => 562, :height => 749 do
  background "background.png"
  stack :width => "100%", :top => 270, :margin => 10 do
    @url = edit_line "http://dbpedia.org/sparql", :width => "50%" do
      background black
    end
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

        @results.text = res.collect do |r|
                          r.collect do |s|
                            s.collect do |e| 
                              if e.match(/.*[\/|#](.*)$/)
                                e.gsub(/.*[\/|#](.*)$/, "\\1")
                              else
                                e
                              end 
                            end * ": " 
                          end * " | "
                        end * "\n"
      end
      
    end
    @results = edit_box :width => "100%", :height => 270
  end
  
end