require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:image) }
  it { should validate_content_type_of(:image).allowing('image/png', 'image/jpg', 'image/jpeg') }
  it { should validate_size_of(:image).less_than(100.kilobytes) }

  it 'have one attached image' do
    expect(described_class.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
