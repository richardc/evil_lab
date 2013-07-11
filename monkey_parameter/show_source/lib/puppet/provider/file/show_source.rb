# Monkeypatches a show_source parameter into files
Puppet::Type.type(:file).newproperty(:show_source) do
  desc "Add an extended attribute to files showing where in puppet the resource is defined

    file { '/tmp/extattr':
      ensure      => 'present',
      content     => 'test content',
      show_source => true,
    }

  "
  ##############################################

  def should
    attrs = {}

    attrs['user.puppet.file']     = resource.file
    attrs['user.puppet.line']     = resource.line.to_s
    attrs['user.puppet.resource'] = resource.to_s
    
    #require 'pry'
    #binding.pry()
    Puppet.debug("should #{attrs.inspect}")
    attrs
  end

  def retrieve
    Puppet.debug("getting current state")
    attrs = {}

    props = `getfattr --absolute-names -d #{resource[:path]}`
    props.split("\n").grep(/^user\.puppet\./).each do | prop |
      prop.chomp!
      prop.gsub!(/"/, '')
      
      attr_name, attr_value = prop.split('=')
      attrs[attr_name] = attr_value
    end
  
    Puppet.debug "retrieve #{attrs.inspect}"

    attrs
  end

  def set(props)
    Puppet.debug "set #{props.inspect}"

    props.each do |name,value|
      if props
         `/usr/bin/setfattr -n #{name} -v #{value} #{resource[:path]}`
      end
    end
  end

  def is_to_s(it)
    it.inspect
  end

  def should_to_s(it)
    it.inspect
  end
end
