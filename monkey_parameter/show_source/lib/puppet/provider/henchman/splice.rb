Puppet::Type.type(:henchman).provide(:splice) do
  def exists?
    Puppet.debug "henchman going to work #{resource[:name]}"
    victim = Puppet::Type.type(:file).properties
    Puppet.debug("victim is #{victim.inspect}")
    i = victim.find_index { |p| p.name == resource[:name] }
    Puppet.debug "ooo #{victim[1]} #{victim[1].class}"
    Puppet.debug "found our accomplice at #{i.inspect}"

    i = 1
    move = victim[i]
    victim[i] = nil
    victim << move
    victim.compact!

    victim = Puppet::Type.type(:file).properties
    Puppet.debug("victim is #{victim.inspect}")
    true
  end
end
