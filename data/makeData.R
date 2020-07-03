#################################
# Make the neuronlistfh objects #
#################################

base::delayedAssign('mbons.light.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('mbons.light.dps.rds',package='lhns'))))
base::delayedAssign('pn.axons.light', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('pn.axons.light.rds',package='lhns'))))
base::delayedAssign('pn.axons.light.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('pn.axons.light.dps.rds',package='lhns'))))
base::delayedAssign('most.lhns', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('most.lhns.rds',package='lhns'))))
base::delayedAssign('most.lhns.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('most.lhns.dps.rds',package='lhns'))))
base::delayedAssign('most.lhins', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('most.lhins.rds',package='lhns'))))
base::delayedAssign('most.lhins.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('most.lhins.dps.rds',package='lhns'))))
base::delayedAssign('lh.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lh.splits.dps.rds',package='lhns'))))
base::delayedAssign('lh.mcfo', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lh.mcfo.rds',package='lhns'))))
base::delayedAssign('lh.mcfo.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lh.mcfo.dps.rds',package='lhns'))))
base::delayedAssign('jfw.lhns', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('jfw.lhns.rds',package='lhns'))))
base::delayedAssign('jfw.lhns.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('jfw.lhns.dps.rds',package='lhns'))))
base::delayedAssign('lh.fafb', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lh.fafb.rds',package='lhns'))))
base::delayedAssign('pn.fafb', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('pn.fafb.rds',package='lhns'))))

