def find_predicats(url)
  resource_query = %[
    SELECT DISTINCT ?subject  
    WHERE 
    { 
      ?subject <http://www.w3.org/2000/01/rdf-schema#domain> %OBJECT% 
    }  
  ]

  window :width => 782, :height => 544, :resizable => false do
    predicats = nil
    background "predicatExplorerBG.png"
    stack :top => 200, :width => 300 do
      resource = edit_line "Type resource here", :width => "100%"
      flow do
        button "go" do
          @label.text = "Loading"
          rq = resource_query.dup
          rq.gsub!(/%OBJECT%/, "<#{resource.text}>")
          sq = SparqlTransmission.new(url)
          sq.query = rq
          sq.execute_async_query do |res| 
            @label.text = "Ready"
            predicats.text =  res.collect do |r|
              r.collect { |s| s * ": " } * " | "
            end * "\n"

          end
        end  
        @label = para "Ready"
      end
      
      para "Type the full URI of a resource on the above box. It will list you all the possible predicate to use on this resource."
    end

    stack :top => 200, :width => -300 do
      predicats = edit_box :height => 350, :width => "100%"
    end
  end

end