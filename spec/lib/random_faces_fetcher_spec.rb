require 'spec_helper'
require 'timecop'
require 'webmock'
include WebMock::API

describe RandomFacesFetcher do
  let(:pivots_url) {'http://pivots/url'}

  before(:each) do
    Timecop.travel(Time.local(2013, 5, 25))
    stub_request(:get, pivots_url).to_return(:body => File.read('spec/fixtures/pivots_new_and_old_users.json'))
  end

  describe '#[]' do
    let(:fetcher) { RandomFacesFetcher.new(pivots_url) }

    it 'returns a random Pivot from a given location' do
      first_names = []
      fetcher['San Francisco'].each {|hash| first_names << hash[:first_name] }
      expect(first_names).to match_array(%w[Aaron Aaron Elana Molly Stuff Stuff1 Stuff2 Stuff3 Stuff4 Stuff5 Stuff6 Stuff7])
    end

    it 'skips pivots with default picture' do
      first_names = []
      fetcher['Toronto'].each {|hash| first_names << hash[:first_name] }
      expect(first_names).to match_array(%w[Aaron])
    end
  end
end
