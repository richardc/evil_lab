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
    # Flush will do the work
  end

  def flush
    attr_name, attr_value = value.split('=')
    Puppet.debug "flushing #{attr_name} #{attr_value}"
    `/usr/bin/setfattr -n #{attr_name} -v #{attr_value} #{resource[:path]}`
  end

end
