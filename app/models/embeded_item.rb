module Locomotive
  class EmbededItem

    include Locomotive::Mongoid::Document
    
    ## fields ##
    field :position
    field :type
    field :item_id
    
    ## associations ##
    #referenced_in :jule, :validate => false
    embedded_in :page, :inverse_of => :embeded_items
    
    scope :jules, -> { where(type: 'jules')}
    scope :alpha, -> { order("embeded_items.position ASC") }
    scope :for_content_type, lambda { |ct| where(:type => ct) }
    
    def self.get_jules( p_page )
      res = []
      
      jul = p_page.embeded_items.jules.alpha
      cur_p = p_page
      
      #récupére les jules, et s'il n'y en a pas, remonte au parent, remonte au parent....
      while jul.size == 0 && cur_p != nil
        jul = cur_p.embeded_items.jules
        cur_p = cur_p.parent
      end
      
      jul.each { |j| res << Jule.find(j.item_id) }
      
      res
    end
    
    def self.get_actus
      res = []
      actus.each { |j| res << Actu.find(j.item_id) }
      res
    end
    
    def self.get_jules_for_json( p_page )
      json = get_jules(p_page).map do |j|
        { :name => j.name, :block => j.block, :picto => j.picto.url, :url => j.url }
      end
    end
    
    def self.get_actus_for_json
      act = get_actus.map do |a| 
        { :name => a.title, :block => a.block, :picto => a.picto.url }
      end  
    end
    
    def self.get_of_type( p_type )
      #ids = for_content_type(p_type).map{ |t| t.item_id} 
      #items = ContentType.where(:slug => p_type).first.contents.find(ids)
      #items_sorted = items.sort_by {|a| a["_position_in_list"]}
      liste_item_ordered = []
    
      for_content_type(p_type).sort_by {|a| a["position"]}.each do |ei|      
        liste_item_ordered << ContentType.where(:slug => p_type).first.contents.find(ei.item_id)
      end
      
      liste_item_ordered
      
    end
     
    def to_liquid
      Locomotive::Liquid::Drops::Embeded.new(self)
    end
  end
end