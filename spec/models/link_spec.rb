require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://gist.github.com/Alex-Govorov/d2ec80cade529155ce6e76').for(:url) }
  it { should_not allow_value('htpp:/dfdf.com').for(:url) }

  describe '#gist?' do
    let(:gist_url) { 'https://gist.github.com/Alex-Govorov/d2ec80cade529155ce6e76' }
    let(:not_gist_url) { 'http://somesite.com' }
    let(:link) { described_class.create(name: 'Gist link', url: gist_url) }
    let(:link2) { described_class.create(name: 'Gist link', url: not_gist_url) }

    it 'returns true if url includes: gist.github.com' do
      expect(link.gist?).to eq true
    end

    it 'returns false if url does not includes: gist.github.com' do
      expect(link2.gist?).to eq false
    end
  end
end
