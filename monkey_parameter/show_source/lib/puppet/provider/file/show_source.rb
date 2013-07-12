# Monkeypatches a show_source parameter into files
Puppet::Type.type(:file).newproperty(:show_source) do
  desc "Add an extended attribute to files showing where in puppet the resource is defined

    file { '/tmp/extattr':
      ensure      => 'present',
      content     => 'test content',
      show_source => true,
    }

  "

  def puppet_attributes
    attrs = {
      'user.puppet.file'     => resource.file || "from_apply",
      'user.puppet.line'     => resource.line.to_s,
      'user.puppet.resource' => resource.to_s,
      'user.puppet.path'     => resource.path,
    }

    Puppet.debug("should #{attrs.inspect}")
    attrs
  end

  def retrieve
    Puppet.debug "getting current state" 
    attrs = {}
    puppet_attributes.keys.each do |name|
      attrs[name] = `/usr/bin/getfattr --only-values -n #{name} #{resource[:path]} 2>/dev/null`.chomp
    end
    Puppet.debug "retrieved #{attrs.inspect}"

    attrs == puppet_attributes
  end

  def set(props)
  end

  def flush
    puppet_attributes.each do |name,value|
      if should
        `/usr/bin/setfattr -n #{name} -v #{value} #{resource[:path]}`
      else
        `/usr/bin/setfattr --remove #{name}`
      end
    end
  end
end
