class Class
  def coerced_attr_writer(*attributes)
    setter_methods = _coerced_attr_writer_setters

    attributes.each do |attribute|
      java_setter_name = _coerced_setter_name(attribute)
      coercion_type = "#{setter_methods[java_setter_name]}"      

      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{attribute}=(val)
          unless val.is_a?(#{coercion_type})
            val = val.to_java(#{coercion_type})
          end

          set_#{attribute}(val)
        end
      RUBY
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
    string = attribute.to_s.dup
    string = string.split(/[^a-z0-9]/i).map { |word| word.capitalize }.join
    return "set#{string}"
  end

end