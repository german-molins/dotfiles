### ✅ **Prompt for LLM Agent**

**Task Title:**  
Implement a Bash startup profiling feature with minimal overhead, integrated into `mise` as a new task named `bash:profile`.

---

#### **Context & Motivation**
- Bash shell startup files often `source` multiple scripts (hooks, completions, activations for apps).  
- We want to **measure startup time per sourced file** to identify slow scripts.  
- Requirements:
  - **Minimal overhead during startup** (no external processes, no heavy computation).
  - Capture precise timing per sourced file.
  - Store raw logs, then post-process into human-readable summary.
  - Integration into `mise` task framework for repeatability and consistency.

---

#### **Architecture & Plan**
1. **Phase 1 (Startup Logging)**
   - Append a lightweight profiling function in the user’s main Bash RC file (or as a snippet that the user sources when profiling is enabled).
   - This function logs: `start_time end_time file_path` for every sourced file.
   - Use `EPOCHREALTIME` (Bash 5+) to avoid `date` or forks.
   - Log to `~/.bash_profile_timing.log`.

2. **Phase 2 (Post-Processing)**
   - Two separate AWK scripts for modularity:
     - **`log_to_csv.awk`**: Converts raw log → CSV (`file,duration_ms`).
     - **`csv_summary.awk`**: Reads CSV → Pretty formatted summary with:
       - Rank
       - Duration (ms)
       - Relative percentage
       - Cumulative percentage
       - Total at the bottom
   - Scripts stored at:  
     `~/.config/mise/scripts/log_to_csv.awk`  
     `~/.config/mise/scripts/csv_summary.awk`

3. **Mise Task Integration**
   - Add a new `mise` task named `bash:profile`.
   - This task:
     - Uses `sources` to reference the raw log (`~/.bash_profile_timing.log`).
     - Uses `outputs` to specify:
       - CSV file (`timing.csv`).
       - Summary report (`summary.txt`).
     - Runs AWK scripts in order:
       - `log_to_csv.awk` → `timing.csv`
       - `csv_summary.awk` → `summary.txt`
   - Follow patterns from other `mise` tasks for consistency.

---

#### **Detailed Steps**
1. **Create the two AWK scripts in `~/.config/mise/scripts/`:**

**`log_to_csv.awk`**
```awk
# Convert raw timing log to CSV (file,duration_ms)
# Usage: awk -f log_to_csv.awk ~/.bash_profile_timing.log > timing.csv
{
    start=$1; end=$2; file=$3
    dur=(end - start) * 1000   # duration in ms
    printf "%s,%.3f\n", file, dur
}
```

**`csv_summary.awk`**
```awk
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
```

---

2. **Add the new mise task definition for `bash:profile`:**
- Look at similar `mise` tasks, especially those using `sources` and `outputs`.
- The task should:
  - Take `~/.bash_profile_timing.log` as the source.
  - Produce:
    - `timing.csv` (from `log_to_csv.awk`).
    - `summary.txt` (from `csv_summary.awk`).
  - Command pipeline:
    ```bash
    awk -f ~/.config/mise/scripts/log_to_csv.awk ~/.bash_profile_timing.log > timing.csv
    awk -f ~/.config/mise/scripts/csv_summary.awk timing.csv > summary.txt
    ```

---

#### **Expected Output**
- **Raw CSV (`timing.csv`)**
```
/home/user/.bashrc.d/app1.sh,120.874
/home/user/.bashrc.d/app2.sh,150.321
/home/user/.bashrc.d/app3.sh,85.502
```

- **Summary (`summary.txt`)**
```
Rank  Sourced File                                     Time (ms)   Relative   Cumulative
----- -----------------------------------------         ---------   --------   -----------
1     /home/user/.bashrc.d/app2.sh                     150.321      42.18%       42.18%
2     /home/user/.bashrc.d/app1.sh                     120.874      33.90%       76.08%
3     /home/user/.bashrc.d/app3.sh                      85.502      23.92%      100.00%
      TOTAL                                            356.697      100%        100%
```

---

### ✅ **Deliverables**
- `~/.config/mise/scripts/log_to_csv.awk`
- `~/.config/mise/scripts/csv_summary.awk`
- A new `mise` task named `bash:profile` with proper `sources` and `outputs`.

---

**Now implement this feature end-to-end in the project.**
