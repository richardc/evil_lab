file { '/tmp/setattr':
  content => "setattr",
  extattr => 'user.puppet.shiny=1',
}
