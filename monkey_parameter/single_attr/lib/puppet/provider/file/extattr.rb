Puppet::Type.type(:file).newproperty(:extattr) do
  desc "Add an extended attribute to a file

    file { '/tmp/extattr':
      ensure => 'present',
      content => 'testy',
      mode    => '0644',
      extattr => 'myattr=myattrvalue',
    }
  
  "

  def retrieve
    attr_name, attr_value = value.split('=')
    command = '/usr/bin/getfattr --only-values --absolute-names 2>/dev/null'
    current_value = `#{command} #{resource[:path]} -n #{attr_name}`.chomp
    got = "#{attr_name}=#{current_value}"
    Puppet.debug "retrieve #{got}" 
    got
  end

  def set(value)
    Puppet.debug "setting #{value}"
    attr_name, attr_value = value.split('=')
    `/usr/bin/setfattr -n #{attr_name} -v #{attr_value} #{resource[:path]}`
  end

  def flush
    Puppet.debug "flushing"
    attr_name, attr_value = resource[:extattr].split('=')
    `/usr/bin/setfattr -n #{attr_name} -v #{attr_value} #{resource[:path]}`
  end

end
