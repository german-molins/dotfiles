# Generate formatted summary from CSV
# Usage: awk -f csv_summary.awk timing.csv
BEGIN {
    FS=","
}
{
    file=$1; start=$2; end=$3; dur=$4
    total_sourced += dur
    files[file] = dur

    # Track earliest start and latest end for total elapsed time
    if (start < min_start || min_start == 0) min_start = start
    if (end > max_end) max_end = end
}
END {
    # Calculate actual total elapsed time
    total_elapsed = (max_end - min_start) * 1000

    n=0
    for (f in files) arr[n++] = f
    for (i=0; i<n; i++) {
        for (j=i+1; j<n; j++) {
            if (files[arr[j]] > files[arr[i]]) {
                tmp=arr[i]; arr[i]=arr[j]; arr[j]=tmp
            }
        }
    }
    printf "%-5s %-50s %10s %10s %12s\n", "Rank", "Sourced File", "Time (ms)", "Relative", "Cumulative"
    printf "%-5s %-50s %10s %10s %12s\n", "-----", "-----------------------------------------", "---------", "--------", "-----------"
    cum_dur = 0
    for (i=0; i<n; i++) {
        f=arr[i]
        pct=(files[f]/total_elapsed)*100
        cum_dur += files[f]
        cum_pct=(cum_dur/total_elapsed)*100
        printf "%-5d %-50s %10.3f %9.2f%% %11.2f%%\n", i+1, f, files[f], pct, cum_pct
    }
    printf "%-5s %-50s %10.3f %10s %12s\n", "", "TOTAL SOURCED", total_sourced, sprintf("%.2f%%", (total_sourced/total_elapsed)*100), sprintf("%.2f%%", (total_sourced/total_elapsed)*100)
    printf "%-5s %-50s %10.3f %10s %12s\n", "", "TOTAL", total_elapsed, "100%", "100%"
}
