def find_predicats(url)
  resource_query = %[
    SELECT ?predicat  
    WHERE 
    { 
      %SUBJECT% ?predicat ?object
    }    
  ]

  window :width => 782, :height => 544 do
    predicats = nil
    background "predicatExplorerBG.png"
    stack :top => 200, :width => 300 do
      resource = edit_line "Type resource here", :width => "100%"
      button "go" do
        rq = resource_query.dup
        rq.gsub!(/%SUBJECT%/, "<#{resource.text}>")
        sq = SparqlTransmission.new(url)
        alert(rq)
        sq.query = rq
        sq.execute_async_query do |res| 

          predicats.text =  res.collect do |r|
            r.collect { |s| s * ": " } * " | "
          end * "\n"

        end
      end
      para "Type the full URI of a resource on the above box. It will list you all the possible predicate to use on this resource."
    end

    stack :top => 200, :width => -300 do
      predicats = edit_box :height => 350, :width => "100%"
    end
  end

end