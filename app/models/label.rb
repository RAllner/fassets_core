class Label < ActiveRecord::Base
  belongs_to :facet
  has_many :labelings, :dependent => :destroy
  has_many :classifications, :through => :labelings         
  
  scope :in,  lambda {|ids|
    {:conditions => ['labels.id IN (?)', ids], :include => :facet, :order => "facet_id"}
  }
end
