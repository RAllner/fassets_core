require 'spec_helper'

describe Url do
  let(:asset) { Url.create!(:url => "http://example.com") }

  it_should_behave_like "ActsAsAsset"
end
