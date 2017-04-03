require 'spec_helper'

describe Gbm do



  xit 'loads correct number of trees' do
    gbm_file = 'spec/fixtures/gbm_sample.pmml'
    xml = RandomForester.xml_from_file_path(gbm_file)
    @gbm = Gbm.new(xml)
    expect(@gbm.tree_count).to eq 30
  end

end
