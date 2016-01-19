module ApplicationHelper

	def all_content_types()
		@content_types = current_site.content_types
    end

    def embeded_items_data_to_js (type )
	    collection = []
	    
	    case type
	      when 'jules'
	        collection = Jule.all.map{ |jul| [jul.name, jul._id]}
	        options = {
	          # NE PAS CHANGER L'ORDRE DES TAKEN_IDS VALUES. JULE ID DOIT ETRE EN 2 ET ID EN 1
	          :taken_ids => @page.embeded_items.jules.empty? ? [] : @page.embeded_items.jules.map{ |item| [item.id, item.item_id, item.position] }
	        }
	    end 
	    
	    collection_to_js(collection, options)
	  end

	  def collection_to_js(collection, options = {})
	    js = collection.collect { |object| object.to_json }

	    options_to_js = ActiveSupport::JSON.encode(options).gsub(/^\{/, '').gsub(/\}$/, '')

	    "new Object({ \"collection\": [#{js.join(', ')}], #{options_to_js} })"
	  end

end
