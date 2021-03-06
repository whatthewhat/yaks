module Yaks
  class Resource
    module HasFields
      def map_fields(&block)
        with(
          fields: fields.map do |field|
            if field.type.equal? :fieldset
              field.map_fields(&block)
            else
              block.call(field)
            end
          end
        )
      end
    end
  end
end
