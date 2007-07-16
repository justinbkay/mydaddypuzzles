module PuzzleHelper
  def images_links_builder(puzzle)
    linkages = [] 
    puzzle.default_configurations.each do |c|
      linkages.<<(link_to_remote(c.name, 
							                   :url => {:action => "display_picture", :id => c}, 
							                   :loading => "Element.show('status');",
			     			                 :complete => "Element.hide('status');"))
		end
		linkages.join(' | ')
  end

end
