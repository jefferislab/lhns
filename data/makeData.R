# ##############################
# Make the neuronlistfh objects #
###############################
base::delayedAssign('mbons.light.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('mbons.light.dps.rds'))))
base::delayedAssign('pn.axons.light', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('pn.axons.light.rds'))))
base::delayedAssign('pn.axons.light.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('pn.axons.light.dps.rds'))))
base::delayedAssign('most.lhns', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('most.lhns.rds'))))
base::delayedAssign('most.lhns.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('most.lhns.dps.rds'))))
base::delayedAssign('most.lhins', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('most.lhins.rds'))))
base::delayedAssign('most.lhins.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('most.lhins.dps.rds'))))
base::delayedAssign('lhin.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lhin.splits.dps.rds'))))
base::delayedAssign('lhln.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lhln.splits.dps.rds'))))
base::delayedAssign('lhon.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lhon.splits.dps.rds'))))
base::delayedAssign('almost.lh.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('almost.lh.splits.dps.rds'))))
base::delayedAssign('lh.mcfo', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lh.mcfo.rds'))))
base::delayedAssign('lh.mcfo.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lh.mcfo.dps.rds'))))


