Puppet::Type.type(:henchman).provide(:splice) do
  def exists?
    Puppet.debug "henchman going to work #{resource[:name]}"
    type = resource[:type].to_sym
    prop = resource[:property].to_sym
    victim = Puppet::Type.type(type).properties

    Puppet.debug("victim property list is #{victim.inspect}")
    i = victim.find_index { |p| p.name == prop }

    Puppet.debug "found our accomplice at #{i.inspect}"

    move = victim[i]
    victim[i] = nil
    victim << move
    victim.compact!
    Puppet.debug("post-henchman victim property list is #{victim.inspect}")
    true
  end
end
