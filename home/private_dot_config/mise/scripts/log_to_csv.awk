# Convert raw timing log to CSV (file,start,end,duration_ms)
# Usage: awk -f log_to_csv.awk ~/.bash_profile_timing.log > timing.csv
BEGIN {
    # Find the most recent timestamp to filter for current session
    while ((getline line < ARGV[1]) > 0) {
        split(line, parts)
        if (parts[2] > latest_end) latest_end = parts[2]
    }
    close(ARGV[1])
}
{
    start=$1; end=$2; file=$3
    # Only process entries from the most recent session (within 10 seconds of latest end)
    if ((latest_end - end) < 10) {
        dur=(end - start) * 1000   # duration in ms
        printf "%s,%.6f,%.6f,%.3f\n", file, start, end, dur
    }
}
