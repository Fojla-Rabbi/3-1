#!/bin/bash

# Round Robin Scheduling

echo -n "Enter number of processes: "
read n

declare -a pid
declare -a at
declare -a bt
declare -a rt
declare -a ct
declare -a tat
declare -a wt
declare -a added

# Input Arrival Time and Burst Time
for ((i=0; i<n; i++))
do
    pid[$i]=$i

    echo -n "Enter arrival time for Process $i: "
    read at[$i]

    echo -n "Enter burst time for Process $i: "
    read bt[$i]

    rt[$i]=${bt[$i]}
    added[$i]=0
done

echo -n "Enter Time Quantum: "
read quantum


# Round Robin Scheduling

current_time=0
completed=0

queue=()
front=0
rear=0

while (( completed < n ))
do

    for ((i=0; i<n; i++))
    do
        if (( at[$i] <= current_time && added[$i] == 0 ))
        then
            queue[$rear]=$i
            rear=$((rear + 1))
            added[$i]=1
        fi
    done

    if (( front == rear ))
    then
        current_time=$((current_time + 1))
        continue
    fi

    p=${queue[$front]}
    front=$((front + 1))

    for ((t=0; t<quantum && rt[$p]>0; t++))
    do
        rt[$p]=$((rt[$p] - 1))
        current_time=$((current_time + 1))

        for ((i=0; i<n; i++))
        do
            if (( at[$i] <= current_time && added[$i] == 0 ))
            then
                queue[$rear]=$i
                rear=$((rear + 1))
                added[$i]=1
            fi
        done
    done

    # If process is completed
    if (( rt[$p] == 0 ))
    then
        completed=$((completed + 1))
        ct[$p]=$current_time
        tat[$p]=$((ct[$p] - at[$p]))
        wt[$p]=$((tat[$p] - bt[$p]))
    else
        # Process still has remaining time
        # Put it at the end of the queue
        queue[$rear]=$p
        rear=$((rear + 1))
    fi

done


# Output the Result

echo -e "\nRound Robin Scheduling Table:"
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

avg_tat=$(echo "scale=2; $total_tat / $n" | bc)
avg_wt=$(echo "scale=2; $total_wt / $n" | bc)

echo
echo "Average Turnaround Time: $avg_tat"
echo "Average Waiting Time: $avg_wt"
