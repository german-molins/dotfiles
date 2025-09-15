# Convert raw timing log to CSV (file,start,end,duration_ms)
# Usage: awk -f log_to_csv.awk ~/.local/share/dotfiles/bash/profile_timing.log
{
    start=$1; end=$2; file=$3
    dur=(end - start) * 1000   # duration in ms
    printf "%s,%.6f,%.6f,%.3f\n", file, start, end, dur
}
