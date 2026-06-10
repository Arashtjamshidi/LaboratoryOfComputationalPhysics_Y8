#!/bin/bash

set -e

# Exercise 3.1 — Final clean exam-style solution

# 1.a Create students directory in home
mkdir -p "$HOME/students"

# Define file and URL
file="$HOME/students/LCP_22-23_students.csv"
url="https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv?dl=1"

# Download file only if it is not already there
if [ -f "$file" ]; then
    echo "CSV file already exists."
else
    echo "CSV file not found. Downloading..."

    if command -v wget >/dev/null 2>&1; then
        wget -O "$file" "$url"
    else
        curl -L -o "$file" "$url"
    fi
fi

# 1.b Create files for PoD and Physics students
awk -F',' 'NR > 1 && $4 == "PoD" {print $0}' "$file" > "$HOME/students/students_PoD.csv"
awk -F',' 'NR > 1 && $4 == "Physics" {print $0}' "$file" > "$HOME/students/students_Physics.csv"

# 1.c Count students whose surname starts with each letter
> "$HOME/students/surname_counts.txt"

for letter in {A..Z}
do
    awk -F',' -v letter="$letter" '
    NR > 1 {
        first_letter = toupper(substr($1, 1, 1))
        if (first_letter == letter) {
            count++
        }
    }
    END {
        print letter, count + 0
    }
    ' "$file" >> "$HOME/students/surname_counts.txt"
done

# 1.d Find the most common surname starting letter
sort -k2,2nr "$HOME/students/surname_counts.txt" | head -n 1 > "$HOME/students/most_common_letter.txt"

# 1.e Split students into 18 groups using modulo 18
awk -F',' '
NR > 1 {
    group = ((NR - 2) % 18) + 1
    print $0 > ENVIRON["HOME"] "/students/group_" group ".txt"
}
' "$file"

echo "Exercise 3.1 completed."
