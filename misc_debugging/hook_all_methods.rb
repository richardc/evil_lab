  # Be noisy - hook all our methods so we can see what the provider interface
  # does.
  instance_methods.each do |method_name|
    next if method_name =~ /__|safe_insync\?/
    original_method = instance_method(method_name)
    define_method(method_name) do |*args,&blk|
      #Puppet.debug "extattr #{method_name}: #{args}"
      original_method.bind(self).call(*args,&blk)
    end
  end
