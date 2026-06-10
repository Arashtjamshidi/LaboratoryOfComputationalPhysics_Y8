#!/bin/bash

# Stop the script if an important command fails
set -e

# Exercise 3.1 — Bash student list processing

# 1.a Create students directory in home
mkdir -p "$HOME/students"

# Go to the students directory
cd "$HOME/students" || exit

# Define file name and URL
file="LCP_22-23_students.csv"
url="https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv?dl=1"

# Check whether the file is already there
if [ -f "$file" ]; then
    echo "$file already exists."
else
    echo "$file not found. Downloading..."

    # Use wget if available, otherwise use curl
    if command -v wget >/dev/null 2>&1; then
        wget -O "$file" "$url"
    elif command -v curl >/dev/null 2>&1; then
        curl -L -o "$file" "$url"
    else
        echo "Error: neither wget nor curl is available."
        exit 1
    fi
fi

# Check that the file really exists after download
if [ ! -f "$file" ]; then
    echo "Error: download failed. CSV file was not created."
    exit 1
fi

echo "CSV file is ready."

# Show first few lines to inspect the structure
echo
echo "First 5 lines of the file:"
head -n 5 "$file"

# 1.b Create two files: PoD students and Physics students
grep "PoD" "$file" > students_PoD.csv || true
grep "Physics" "$file" > students_Physics.csv || true

# 1.c Count how many surnames start with each letter
> surname_counts.txt

for letter in {A..Z}
do
    count=$(awk -F',' -v l="$letter" 'toupper($1) ~ "^"l {count++} END {print count+0}' "$file")
    echo "$letter $count" >> surname_counts.txt
done

# 1.d Find the letter with the maximum count
sort -k2 -nr surname_counts.txt | head -n 1 > most_common_letter.txt

# 1.e Group students modulo 18
rm -f group_*.txt

awk -F',' '
{
    group = ((NR - 1) % 18) + 1
    print $0 >> "group_" group ".txt"
}
' "$file"

echo
echo "Exercise 3.1 completed."
