# frozen_string_literal: true

module GlobalRegistry #:nodoc:
  module Bindings #:nodoc:
    module Options
      class InstanceOptions
        delegate :id_column,
                 :mdm_id_column,
                 :mdm_timeout,
                 :type,
                 :push_on,
                 :parent_association,
                 :parent_association_class,
                 :related_association,
                 :related_association_class,
                 :exclude_fields,
                 :extra_fields,
                 :parent_class,
                 :related_class,
                 :parent_type,
                 :related_type,
                 :parent_relationship_name,
                 :related_relationship_name,
                 :parent_is_self?,
                 :mdm_worker_class_name,
                 to: :@class_options

        def initialize(model)
          @model = model
          @class_options = model.class.global_registry
        end

        def id_value
          @model.send id_column
        end

        def id_value=(value)
          @model.send "#{id_column}=", value
        end

        def id_value?
          @model.send "#{id_column}?"
        end

        def parent
          @model.send(parent_association) if parent_association.present?
        end

        def related
          @model.send(related_association) if related_association.present?
        end

        def parent_id_value
          parent&.global_registry&.id_value
        end

        def related_id_value
          related&.global_registry&.id_value
        end
      end
    end
  end
end
