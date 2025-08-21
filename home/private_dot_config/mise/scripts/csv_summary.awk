# Generate formatted summary from CSV
# Usage: awk -f csv_summary.awk timing.csv
BEGIN {
    FS=","
}
{
    file=$1; dur=$2
    total += dur
    files[file] = dur
}
END {
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
    cum = 0
    for (i=0; i<n; i++) {
        f=arr[i]
        pct=(files[f]/total)*100
        cum += pct
        printf "%-5d %-50s %10.3f %9.2f%% %11.2f%%\n", i+1, f, files[f], pct, cum
    }
    printf "%-5s %-50s %10.3f %9s %11s\n", "", "TOTAL", total, "100%", "100%"
}
