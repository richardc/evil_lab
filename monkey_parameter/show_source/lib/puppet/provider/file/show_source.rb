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

  def puppet_attrs
    attrs = {}

    attrs['user.puppet.file']     = resource.file
    attrs['user.puppet.line']     = resource.line.to_i
    attrs['user.puppet.resource'] = resource.to_s

    attrs
  end

  def retrieve
    attrs = {}
    attrs['user.puppet.file']     = nil
    attrs['user.puppet.line']     = nil
    attrs['user.puppet.resource'] = nil

    props = `getfattr --absolute-names -d #{resource[:path]}`
    props.to_a.grep(/^user\.puppet\./).each do | prop |
      prop.chomp!
      prop.gsub!(/"/, '')
      
      attr_name, attr_value = prop.split('=')
      attrs[attr_name] = attr_value
    end
  
    attrs['user.puppet.line'] = attrs['user.puppet.line'].to_i

    attrs == puppet_attrs
  end

  def set(props)
    puppet_attrs.each do |name,value|
      if props
         `/usr/bin/setfattr -n #{name} -v #{value} #{resource[:path]}`
      end
    end
  end

#  def should_to_s(should_value)
#    puts "=========================== In should_to_s"
#    require 'pp'
#    pp should_value
#  end

end
