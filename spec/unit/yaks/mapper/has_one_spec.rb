require 'spec_helper'

RSpec.describe Yaks::Mapper::HasOne do
  AuthorMapper = Class.new(Yaks::Mapper) { attributes :name }

  subject(:has_one)  { described_class.new(name: :author, mapper: mapper, rel: 'http://rel') }
  let(:name)     { 'William S. Burroughs' }
  let(:mapper)   { AuthorMapper }
  let(:author)   { double(:name => name) }
  let(:policy)   {
    double(
      Yaks::DefaultPolicy,
      derive_type_from_mapper_class: 'author',
      derive_mapper_from_association: AuthorMapper
    )
  }
  let(:context) {{policy: policy, env: {}}}

  its(:singular_name) { should eq 'author' }

  it 'should map to a single Resource' do
    expect(has_one.map_resource(author, context)).to eq Yaks::Resource.new(type: 'author', attributes: {name: name})
  end

  context 'with no mapper specified' do
    let(:mapper)   { Yaks::Undefined }

    it 'should derive one based on policy' do
      expect(has_one.add_to_resource(Yaks::Resource.new, nil, {author: author}, context)).to eql(
        Yaks::Resource.new(
          subresources: {
            'http://rel' => Yaks::Resource.new(type: 'author', attributes: {name: name})
          }
        )
      )
    end

  end
end
