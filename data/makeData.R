# ##############################
# Make the neuronlistfh objects #
###############################
base::delayedAssign('mbons.light.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('mbons.light.dps.rds', package='lhns'))))
base::delayedAssign('pn.axons.light', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('pn.axons.light.rds', package='lhns'))))
base::delayedAssign('pn.axons.light.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('pn.axons.light.dps.rds', package='lhns'))))
base::delayedAssign('most.lhns', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('most.lhns.rds', package='lhns'))))
base::delayedAssign('most.lhns.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('most.lhns.dps.rds', package='lhns'))))
base::delayedAssign('most.lhins', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('most.lhins.rds', package='lhns'))))
base::delayedAssign('most.lhins.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('most.lhins.dps.rds', package='lhns'))))
base::delayedAssign('lhln.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lhln.splits.dps.rds', package='lhns'))))
base::delayedAssign('lhin.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lhin.splits.dps.rds', package='lhns'))))
base::delayedAssign('lhon.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lhon.splits.dps.rds', package='lhns'))))
