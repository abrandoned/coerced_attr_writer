class Class
  def coerced_attr_writer(*attributes)
    setter_methods = _coerced_attr_writer_setters

    attributes.each do |attribute|
      java_setter_name = _coerced_setter_name(attribute)
      camel_writer_name = _coerced_camel_writer_name(attribute)
      coercion_type = "#{setter_methods[java_setter_name]}"      

      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{attribute}=(val)                      # def user_id=(val)
          unless val.is_a?(#{coercion_type})        #   unless val.is_a?(java.math.BigDecimal)
            val = val.to_java(#{coercion_type})     #     val = val.to_java(java.math.BigDecimal)
          end                                       #   end
                                                    #
          set_#{attribute}(val)                     #   set_user_id(val)
        end                                         # end
      RUBY

      # Do not want to overwrite the first with the second
      # if this is a simple setter
      unless "#{attribute}" == camel_writer_name
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{camel_writer_name}=(val)            # def userId=(val)
            unless val.is_a?(#{coercion_type})      #   unless val.is_a?(java.math.BigDecimal)
              val = val.to_java(#{coercion_type})   #     val = val.to_java(java.math.BigDecimal)
            end                                     #   end
                                                    #
            set_#{attribute}(val)                   #   set_user_id(val)
          end                                       # end
        RUBY
      end
    end
  end

  alias_method :attr_writer_with_coercion, :coerced_attr_writer
  alias_method :coercible_attr_writer, :coerced_attr_writer
  alias_method :coercable_attr_writer, :coerced_attr_writer
  alias_method :attr_writer_coerced, :coerced_attr_writer
  alias_method :coerced_setters, :coerced_attr_writer
  alias_method :coerce_setters, :coerced_attr_writer

  private 

  def _coerced_attr_writer_setters
    @_coerced_attr_writer_setters ||= java_class.java_instance_methods.inject({}) do |method_hash, method|
      if method.arity == 1 && method.name =~ /\Aset.*\Z/
        method_hash[method.name] = method.parameter_types.first 
      end

      method_hash
    end
  end

  def _coerced_setter_name(attribute)
    string = _coerced_camelize(attribute.to_s)

    return "set#{string}"
  end

  def _coerced_camel_writer_name(attribute)
    string = _coerced_camelize(attribute.to_s)
    string[0] = string[0].downcase

    return string
  end

  def _coerced_camelize(string)
    local_string = string.to_s.dup
    local_string = local_string.split(/[^a-z0-9]/i).map { |word| word.capitalize }.join

    return local_string
  end

end
