# My VCS Build and Simulation Script
# Author: Hoseung Yoon
# Last Modified: 2025.11.17

OUT=sim_out

rm -rf $OUT
mkdir -p $OUT
timestamp=$(date +%Y%m%d_%H%M%S)

vcs -full64 -sverilog \
    -ntb_opts uvm-1.2 \
    -debug_access+all -kdb \
    -timescale=1ns/1ps \
    -Mdir=$OUT/csrc \
    -o $OUT/simv \
    -l vcs_$timestamp.txt \
    -f run.f

cd $OUT
./simv +fsdbfile+wave.fsdb \
     -l ../sim_$timestamp.txt
cd ..