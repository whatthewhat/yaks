RSpec.describe Yaks::Resource::HasFields do
  let(:class_with_fields) do
    Class.new do
      include Yaks::Resource::HasFields
      include Yaks::Attributes.new(:fields)
    end
  end

  let(:fields) do
    [
      Yaks::Resource::Form::Fieldset.new(fields: [
        Yaks::Resource::Form::Field.new(name: :foo, value: '123', type: 'text'),
        Yaks::Resource::Form::Field.new(name: :bar, value: '+32 477 123 123', type: 'tel')
      ]),
      Yaks::Resource::Form::Fieldset.new(fields: [
        Yaks::Resource::Form::Fieldset.new(fields: [
          Yaks::Resource::Form::Field.new(name: :quux, value: '999', type: 'tel')
        ]),
        Yaks::Resource::Form::Field.new(name: :qux, value: '777', type: 'text')
      ])
    ]
  end

  subject(:with_fields) { class_with_fields.new(fields: fields) }

  describe '#map_fields' do

    let(:update_fields) do
      ->(field) do
        field.with({ value: "updated" })
      end
    end

    it 'will map over nested fieldsets' do
      expect(subject.map_fields(&update_fields)).to eql class_with_fields.new(fields: [
        Yaks::Resource::Form::Fieldset.new(fields: [
          Yaks::Resource::Form::Field.new(name: :foo, value: 'updated', type: 'text'),
          Yaks::Resource::Form::Field.new(name: :bar, value: 'updated', type: 'tel')
        ]),
        Yaks::Resource::Form::Fieldset.new(fields: [
          Yaks::Resource::Form::Fieldset.new(fields: [
            Yaks::Resource::Form::Field.new(name: :quux, value: 'updated', type: 'tel')
          ]),
          Yaks::Resource::Form::Field.new(name: :qux, value: 'updated', type: 'text')
        ])
      ])
    end
  end

end
