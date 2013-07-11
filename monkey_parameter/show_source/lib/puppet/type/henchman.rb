Puppet::Type.newtype(:henchman) do
  ensurable
  newparam(:name, :namevar => true)
  newparam(:type)
  newparam(:property)
end
