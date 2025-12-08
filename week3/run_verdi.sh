OUT=sim_out
cd $OUT

# FSDB list
fs=( *.fsdb )

# NO FSDB files found
if [ "${fs[0]}" = "*.fsdb" ]; then
    echo "No .fsdb files found."
    exit 1
fi

# Verdi RUN
cmd="verdi -dbdir simv.daidir -f ../run.f"
for f in "${fs[@]}"; do
    cmd="$cmd -ssf $f"; 
done
eval $cmd &