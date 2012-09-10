require "acts_as_asset"

class Url < ActiveRecord::Base
  validates_presence_of :url
  validates_format_of :url, :with => /^(#{URI::regexp(%w(http https))})$/, :message => "is invalid"

  acts_as_asset

  def to_jq_upload
    {
      "edit_box_url" => "/edit_box/"+id.to_s,
      "content_type" => "Url"
    }
  end
end

