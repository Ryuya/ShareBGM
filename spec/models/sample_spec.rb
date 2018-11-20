require 'rails_helper'

RSpec.describe Sample, type: :model do
  example 'nameとemailが設定されていれば有効' do
    sample = Sample.new(
      name: 'test',
      email: 'test@test.com',
    )
    expect(sample).to be_valid
  end
  
  example 'nameが無ければ無効' do
    sample = Sample.new(
      email: 'test@test.com'  
    )
    expect(sample).not_to be_valid
  end
  
  example 'emailが無ければ無効'do
    sample = Sample.new(
        name: "test"
    )
    expect(sample).not_to be_valid
  end
end
