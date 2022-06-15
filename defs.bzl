def _impl(ctx):
  i = ctx.actions.declare_file("%s.in" % ctx.label.name)
  s = ctx.actions.declare_file("%s.sym" % ctx.label.name)
  o = ctx.actions.declare_file("%s.out" % ctx.label.name)

  ctx.actions.run_shell(
    outputs = [i],
    command = "touch $1",
    arguments = [i.path],
  )

  ctx.actions.symlink(
    output = s,
    target_file = i,
  )

  ctx.actions.run_shell(
    inputs = [s],
    outputs = [o],
    command = "test -f $1 && touch $2",
    arguments = [s.path, o.path],
  )

  return DefaultInfo(files = depset([o]))

dangling_symlink = rule(
  implementation = _impl,
)
