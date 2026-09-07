#!/bin/bash

# SJF Scheduling in Bash

echo -n "Enter number of processes: "
read n

declare -a pid
declare -a at
declare -a bt
declare -a ct
declare -a tat
declare -a wt

# Input Arrival Time and Burst Time
for ((i=0; i<n; i++))
do
    pid[$i]=$i

    echo -n "Enter arrival time for Process $i: "
    read at[$i]

    echo -n "Enter burst time for Process $i: "
    read bt[$i]
done

# SJF Scheduling
current_time=0
completed=0

while (( completed < n ))
do
    shortest=-1

    # Find the process with the shortest burst time
    # among the processes that have already arrived
    for ((i=0; i<n; i++))
    do
        if (( at[$i] <= current_time && ct[$i] == 0 ))
        then
            if (( shortest == -1 || bt[$i] < bt[$shortest] ))
            then
                shortest=$i
            fi
        fi
    done

    # If no process has arrived, move current time forward
    if (( shortest == -1 ))
    then
        current_time=$((current_time + 1))
        continue
    fi

    # Execute selected process completely
    current_time=$((current_time + bt[$shortest]))

    ct[$shortest]=$current_time
    tat[$shortest]=$((ct[$shortest] - at[$shortest]))
    wt[$shortest]=$((tat[$shortest] - bt[$shortest]))

    completed=$((completed + 1))
done

# Output the Result

echo -e "\\nSJF Scheduling Table:"
echo -e "PID\\tAT\\tBT\\tCT\\tTAT\\tWT"

for ((i=0; i<n; i++))
do
    echo -e "${pid[$i]}\\t${at[$i]}\\t${bt[$i]}\\t${ct[$i]}\\t${tat[$i]}\\t${wt[$i]}"
done

# Calculate Average Turnaround Time and Waiting Time

total_tat=0
total_wt=0

for ((i=0; i<n; i++))
do
    total_tat=$((total_tat + tat[$i]))
    total_wt=$((total_wt + wt[$i]))
done

# Calculate averages using bc

avg_tat=$(echo "scale=2; $total_tat / $n" | bc)
avg_wt=$(echo "scale=2; $total_wt / $n" | bc)

echo -e "\\nAverage Turnaround Time: $avg_tat"
echo -e "Average Waiting Time: $avg_wt"