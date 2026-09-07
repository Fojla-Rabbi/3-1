#!/bin/bash

# FCFS Scheduling in Bash

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

# Sort based on Arrival Time (Bubble Sort)
for ((i=0; i<n-1; i++))
do
    for ((j=0; j<n-i-1; j++))
    do
        if (( at[$j] > at[$((j+1))] ))
        then
             # Swap Arrival Time
             temp=${at[$j]}
             at[$j]=${at[$((j+1))]}
             at[$((j+1))]=$temp

              # Swap Burst Time
              temp=${bt[$j]}
              bt[$j]=${bt[$((j+1))]}
              bt[$((j+1))]=$temp

              # Swap Process ID
              temp=${pid[$j]}
              pid[$j]=${pid[$((j+1))]}
              pid[$((j+1))]=$temp
        fi
    done
done

# Calculate Completion, Turnaround, and Waiting Times

ct[0]=$((at[0] + bt[0]))
tat[0]=$((ct[0] - at[0]))
wt[0]=$((tat[0] - bt[0]))

for ((i=1; i<n; i++))
do

   # Check if CPU is idle
   if (( ct[$((i-1))] < at[$i] ))
   then
        ct[$i]=$((at[$i] + bt[$i]))
   else
        ct[$i]=$((ct[$((i-1))] + bt[$i]))
   fi

   # Turnaround Time
   tat[$i]=$((ct[$i] - at[$i]))

   # Waiting Time
   wt[$i]=$((tat[$i] - bt[$i]))
done

# Output the Result

echo -e "\nFCFS Scheduling Table:"
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