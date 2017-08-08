# frozen_string_literal: true

module GlobalRegistry #:nodoc:
  module Bindings #:nodoc:
    module Options
      class EntityInstanceOptions
        delegate :id_column,
                 :mdm_id_column,
                 :mdm_timeout,
                 :push_on,
                 :parent_association,
                 :parent_association_class,
                 :mdm_worker_class_name,
                 :ensure_entity_type?,
                 :include_all_columns?,
                 to: :@class_options

        def initialize(model)
          @model = model
          @class_options = model.class.global_registry_entity
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

        def type
          t = @class_options.type
          t.is_a?(Proc) ? t.call(@model) : t
        end

        def parent
          @model.send(parent_association) if parent_association.present?
        end

        def parent_class
          return if parent_association.blank?
          parent_association_class
        end

        def parent_type
          parent&.global_registry_entity&.type
        end

        def parent_id_value
          parent&.global_registry_entity&.id_value
        end

        def parent_required?
          parent_association.present? && !parent_is_self?
        end

        def parent_is_self?
          parent_association.present? && parent_class == @model.class
        end

        def exclude
          option = @class_options.exclude
          case option
          when Proc
            option.call(type, @model)
          when Symbol
            @model.send(option, type)
          else
            option
          end
        end

        def fields
          option = @class_options.fields
          case option
          when Proc
            option.call(type, @model)
          when Symbol
            @model.send(option, type)
          else
            option
          end
        end
      end
    end
  end
end
