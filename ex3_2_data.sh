#!/bin/bash

set -e

# Exercise 3.2 — Final clean Bash solution

# n is the input parameter
n="$1"

# Check input parameter
if [ -z "$n" ]; then
    echo "Usage: bash ex3_2_data.sh n"
    exit 1
fi

# Input and output files
input="data.csv"
output="data.txt"

# Check that data.csv exists
if [ ! -f "$input" ]; then
    echo "Error: data.csv not found."
    exit 1
fi

# 2.a Remove metadata and commas; create data.txt
# Keep only rows where the first three fields are numbers
awk -F',' '
$1 ~ /^-?[0-9]+(\.[0-9]+)?$/ &&
$2 ~ /^-?[0-9]+(\.[0-9]+)?$/ &&
$3 ~ /^-?[0-9]+(\.[0-9]+)?$/ {
    print $1, $2, $3
}
' "$input" > "$output"

# 2.b Count even numbers in data.txt
awk '
{
    for (i = 1; i <= NF; i++) {
        if ($i == int($i) && $i % 2 == 0) {
            count++
        }
    }
}
END {
    print count
}
' "$output" > even_count.txt

# 2.c Split rows according to distance from origin
awk '
BEGIN {
    threshold = 100 * sqrt(3) / 2
}
{
    x = $1
    y = $2
    z = $3

    distance = sqrt(x*x + y*y + z*z)

    if (distance > threshold) {
        print $0 > "data_greater.txt"
        greater++
    } else {
        print $0 > "data_smaller.txt"
        smaller++
    }
}
END {
    print "greater", greater + 0 > "distance_counts.txt"
    print "smaller_or_equal", smaller + 0 >> "distance_counts.txt"
}
' "$output"

# 2.d Make n copies of data.txt
# In the i-th copy, all numbers are divided by i
for ((i = 1; i <= n; i++))
do
    awk -v divisor="$i" '
    {
        for (j = 1; j <= NF; j++) {
            printf "%g", $j / divisor

            if (j < NF) {
                printf " "
            } else {
                printf "\n"
            }
        }
    }
    ' "$output" > "data_divided_by_${i}.txt"
done

echo "Exercise 3.2 completed."
