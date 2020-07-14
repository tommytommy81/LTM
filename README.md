# LTM

Main scripts for Sep's project (and Alicia, with some modifications) on the associative memory task in sEEG.

In main there are 3 files:
- info....m : setup folders, libraries and paths. This must be modified by end user and not download anymore.
- build...m : read files extracted from BS and tranform then to ft_struct to run stats. Ideally must be run only once if everything is setup correctly.
- CLUSTER_stat: compute pairwise cluster statistics in the time-freq domain

In the folder "subroutine" there are lower level batch and functions.

This is only work in progress, so bugs are expected to come, and comments to blossom...
