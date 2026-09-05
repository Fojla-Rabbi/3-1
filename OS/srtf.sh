#!/bin/bash

# SRTF Scheduling in Bash

echo -n "Enter number of processes: "
read n

declare -a pid
declare -a at
declare -a bt
declare -a rt
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

    rt[$i]=${bt[$i]}
done

# SRTF Scheduling

current_time=0
completed=0

while (( completed < n ))
do
    shortest=-1

    # Find process with shortest remaining time
    # among the processes that have arrived
    for ((i=0; i<n; i++))
    do
         if (( at[$i] <= current_time && rt[$i] > 0 ))
         then
              if (( shortest == -1 || rt[$i] < rt[$shortest] ))
              then
                   shortest=$i
              fi
         fi
    done

    # If no process has arrived, move time forward
    if (( shortest == -1 ))
    then
         current_time=$((current_time + 1))
         continue
    fi

    # Execute selected process for 1 unit of time
    rt[$shortest]=$((rt[$shortest] - 1))
    current_time=$((current_time + 1))

   # If process is completed
   if (( rt[$shortest] == 0 ))
   then
        completed=$((completed + 1))

        # Completion Time
        ct[$shortest]=$current_time

        # Turnaround Time
        tat[$shortest]=$((ct[$shortest] - at[$shortest]))

        # Waiting Time
        wt[$shortest]=$((tat[$shortest] - bt[$shortest]))
   fi
done

# Output the Result

echo -e "\nSRTF Scheduling Table:"
echo -e "PID\tAT\tBT\tCT\tTAT\tWT"

for ((i=0; i<n; i++))
do
    echo -e "${pid[$i]}\t${at[$i]}\t${bt[$i]}\t${ct[$i]}\t${tat[$i]}\t${wt[$i]}"
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

echo -e "\nAverage Turnaround Time: $avg_tat"
echo -e "Average Waiting Time: $avg_wt"