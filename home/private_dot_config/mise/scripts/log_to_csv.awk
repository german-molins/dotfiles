# Convert raw timing log to CSV (file,duration_ms)
# Usage: awk -f log_to_csv.awk ~/.bash_profile_timing.log > timing.csv
{
    start=$1; end=$2; file=$3
    dur=(end - start) * 1000   # duration in ms
    printf "%s,%.3f\n", file, dur
}
