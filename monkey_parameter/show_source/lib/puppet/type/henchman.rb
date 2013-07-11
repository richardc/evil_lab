Puppet::Type.newtype(:henchman) do
  ensurable
  newparam(:name, :namevar => true)
end
