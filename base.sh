#!/bin/bash

# Variables
NAME="Adam"
a="My name is $NAME"
b="My name is ${NAME}-Szustak"
c=$(ls -a)                           
d=$((1 * 3))                         
NAME="Borys" echo "second cmd"
echo $NAME
 
# User inputs
read -p "Enter your name: " NAME
read -t 10 -sp "Enter password:  " PASSWD
echo $NAME $PASSWD
 
# Exit status
true
echo $?
false
echo $?
 
# Number comparison
NR1=22
NR2=44
if [[ "$NUM1" -gt "$NUM2" ]]; then
	echo "$NR1 is greater than $NR2"
else
    echo "$NR1 is less than or equal $NR2"
fi
 
# String comparison & regex
AMOUNT=15
if [[ "$AMOUNT" == 15USD ]]; then
    echo "It costs $AMOUNT"
elif [[ "$AMOUNT" =~ ^[0-9]+[A-Z]+$ ]]; then 
    echo "It costs another amount $AMOUNT"
elif ! [[ "$AMOUNT" =~ ^[0-9]+[A-Z]+$ ]]; then
    echo "perhaps $AMOUNT is not correct"
fi
 
# Logical Operators
VALUE=33
if [[ "$VALUE" -ge "$NR1" && "$VALUE" -le "$NR2" ]]; then
	echo "Value is located between"
fi
 
# File conditions
FILE=test1
if [[ -e "$FILE" ]]; then
    if [[ -d "$FILE" ]]; then
        echo "$FILE is dir"
    elif [[ -f "$FILE" ]]; then
        echo "$FILE is file"
    else
        echo "$FILE N/A" >&2
        # exit 1
    fi
else
    echo "$FILE does NOT exist" >&2
    # exit 1
fi
 
# Here doc
cat <<- _EOF_
		1 line
		2 line
		_EOF_

# Here string
read file <<< $(ls)
echo $file
 
# While
count=0
while [[ $count -le 3 ]]; do
    echo $count
    count=$((count+1))
done

ls | while read file; do
    echo $file
done 
 
# Case
case $NAME in
    q|Q)          echo "Exiting";;
    [[:alpha:]]+) echo "OK";;
    *)            echo "Invalid";;
esac
 
# Function
function sayHello() {
    echo "Hello World"
}
# **** OR ****
sayHello () {
    local foo=bar 
    echo "Hello World"
}
sayHello
 
# Validation
read -p "Input item > "
[[ -z $REPLY ]] && sayHello 

# Positional arguments
echo $0 $1 $2                       
echo "Accepted $# args"

# Function with params
greet() {
	echo "I am $1 and I am $2"
}
greet "Adam" "29"
 
# Shift
count=1
while [[ $# -gt 0 ]]; do
    echo "Arg $count = $1"
    count=$((count + 1))
    shift
done
 
# For loop
for i in {A..D}; do
	echo $i
done

# Manage empty variables
foo=
echo ${foo:-"bar"}
echo $foo

echo ${foo:="bar"}
echo $foo
echo ${foo:="fooooo"}

echo ${foo:?"is empty"}
foo=
echo ${foo:+"bar"}
foo=foooooo
echo ${foo:+"bar"}

# String operations
foo="This is something"
echo ${#foo}
echo ${foo:5:15}

foo=file.zip.txt
echo ${foo#*.}
echo ${foo##*.}
echo ${foo%.*}
echo ${foo%%.*}

foo=JPG.JGP
echo ${foo/JPG/jpg}
echo ${foo//JPG/jpg}

foo=aBcD
echo ${foo,,}
echo ${foo^^}
echo ${foo^}

# Number operations
echo $((5 - 6))
if (( $INT == 0 )); then
    echo null
fi

echo $((51))
echo $((8#51))
echo $((16#51))
echo $((2#1111))

for ((i = 0; i <= 20; i++)); do
    if (((( i % 5)) == 0 )); then
        printf "<%d> " $i
    else
        printf "%d " $i
    fi
done

# Arrays
a[1]=foo
echo ${a[1]}

days=(Mon Tue Wed Thu Fri)
echo $days
days+=(Sat)
echo ${#days[@]}
