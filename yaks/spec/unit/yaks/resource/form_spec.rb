RSpec.describe Yaks::Resource::Form do
  let(:fields) {
    [
      Yaks::Resource::Form::Field.new(name: :foo, value: '123', type: 'text'),
      Yaks::Resource::Form::Field.new(name: :bar, value: '+32 477 123 123', type: 'tel')
    ]
  }

  subject(:form) {
    described_class.new(name: :create_foo, fields: fields)
  }

  describe '#[]' do
    it 'should find a field value by field name' do
      expect(subject[:bar])
        .to eq '+32 477 123 123'
    end
  end

  describe '#values' do
    it 'should return all field values in a hash' do
      expect(subject.values).to eql(foo: '123', bar: '+32 477 123 123')
    end
  end

  describe '#fields_flat' do
    let(:fields) do
      [
        Yaks::Resource::Form::Fieldset.new(fields: [
          Yaks::Resource::Form::Field.new(name: :foo, value: '123', type: 'text'),
          Yaks::Resource::Form::Field.new(name: :bar, value: '+32 477 123 123', type: 'tel')
        ]),
        Yaks::Resource::Form::Fieldset.new(fields: [
          Yaks::Resource::Form::Fieldset.new(fields: [
            Yaks::Resource::Form::Field.new(name: :qux, value: '777', type: 'text'),
          ]),
          Yaks::Resource::Form::Field.new(name: :quux, value: '999', type: 'tel')
        ])
      ]
    end

    it 'should flatten fieldsets' do
      expect(subject.fields_flat).to eql [
        Yaks::Resource::Form::Field.new(name: :foo, value: '123', type: 'text'),
        Yaks::Resource::Form::Field.new(name: :bar, value: '+32 477 123 123', type: 'tel'),
        Yaks::Resource::Form::Field.new(name: :qux, value: '777', type: 'text'),
        Yaks::Resource::Form::Field.new(name: :quux, value: '999', type: 'tel')
      ]
    end
  end

  describe "#method?" do
    it 'should return true if method matches' do
      form_sym = Yaks::Resource::Form.new(name: :foo, method: :get)
      form_str = Yaks::Resource::Form.new(name: :foo, method: 'GET')

      expect(form_sym.method?(:get)).to eq(true)
      expect(form_sym.method?('get')).to eq(true)
      expect(form_str.method?(:get)).to eq(true)
      expect(form_str.method?('GET')).to eq(true)
    end

    it 'should return false if method does not match' do
      form_sym = Yaks::Resource::Form.new(name: :foo, method: :get)
      form_str = Yaks::Resource::Form.new(name: :foo, method: 'GET')

      expect(form_sym.method?(:post)).to eq(false)
      expect(form_sym.method?('patch')).to eq(false)
      expect(form_str.method?(:delete)).to eq(false)
      expect(form_str.method?('PUT')).to eq(false)
    end
  end

  describe "#has_action?" do
     it 'should return true if form has an action url' do
      form = Yaks::Resource::Form.new(name: :foo, action: "/my-action")

      expect(form.has_action?).to eq(true)
    end

    it 'should return false if form has not an action url' do
      form = Yaks::Resource::Form.new(name: :foo)

      expect(form.has_action?).to eq(false)
    end
  end
end
