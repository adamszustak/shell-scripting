# :beetle: Shebang :beetle:

A script designed to organize the most important information about shell programming. I did it as a cheat sheet.
It was not my intention that this document be complete.
Pull requests are welcome! :airplane:

## How to write shell script?

1. Write one :)
2. Set appropriate permissions (everyone can execute 755, only owner 700)
3. Put script in a known location (defined in PATH) or start execution as `./<script_name>`

## Some knowledge

* `#!/bin/bash` is called **shebang**, this way we can tell the OS which interpreter to choose
Should be placed at the beginning of the file
* Full flags are better, like `ls --all` (not abbreviation `ls -a`)
* Use indentation and multiline commands using`\` (improve readability)
* Set in .vimrc `:syntax on`, `:set tabstop=4`, `:set number`, `:set autoindent`
* Way to enforce the immutability => `declare -r NAME="ADAM"` (the shell prevent any redefinition)
* Shell treats every variable as string by default
* If aliases limited you, you can create a function inside the file *.bashrc*
* Quoted variable - defense againt the param being empty which cause error and may lead to unexpected results
* Use `>&2` to send error messages to stderr

### Tracing

* By adding an extra argument `-x` to shebang, tracing can be set
* It's also possible by adding `set -x` before section you want to debug and `set +x` to disable it

### Variables

* Uppercase if constant
* Accepts letters, numbers, underscores
```
NAME="Adam"
a="My name is $NAME" 
b="My name is ${NAME}-Szustak"         # assigns variable and concatenate
c=$(ls -a)                             # assigns result of command
d=$((1 * 3))                           # assigns math result
NAME="Borys" echo "second"             # variable assignment is valid only in that line
echo $NAME                             # gives `Adam`
```

### User inputs

* Used to read a single line of stdin, can be used to read keyboard input, or when redirection is used, a line of data from a file
* If no variables are given, it assigns to default variable called *REPLY*
* `-t` timedout, `-s` secret, `-p` prompt
```
read -p "Enter your name: " NAME
read -t 10 -sp "Enter password -> " PASSWD
echo $NAME $PASSWD
```

### Exit status

* Each command issues a value to the system when terminate (zero -> ok, non-zero -> error)
* `echo $?` checks exit status
```
true
echo $?                                # gives `0`
false
echo $?                                # gives `1`
```

### Number comparison

| Command     | Means                                                |
|-------------|:----------------------------------------------------:|
| nr1 -eq nr2 | returns true if the values are equal                 |
| nr1 -ne nr2 | returns true if the values are not equal             |
| nr1 -lt nr2 | returns true if nr1 is less than nr2                 |
| nr1 -le nr2 | returns true if nr1 is less than or equal to nr2     |
| nr1 -gt nr2 | returns true if nr1 is greater than nr2              |
| nr1 -ge nr2 | returns true if nr1 is greater than or equal to nr2  |

```
NR1=22
NR2=44
if [[ "$NUM1" -gt "$NUM2" ]]; then
    echo "$NR1 is greater than $NR2"
else
    echo "$NR1 is less than or equal $NR2"
fi
```

### String comparison & regex

| Command            | Means                                                |
|--------------------|:----------------------------------------------------:|
| -n string          | returns true if len(string) is non-zero              |
| -z string          | returns true if len(string) is zero                  |
| string =~ regex    | returns true if string match regex                   |
| string1 == string2 | returns true if strings are equal                    |
| string1 != string2 | returns true if strings are not equal                |

```
AMOUNT=15USD
if [[ "$AMOUNT" == 15USD ]]; then
    echo "It costs $AMOUNT"
elif [[ "$AMOUNT" =~ ^[0-9]+[A-Z]+$ ]]; then 
    echo "It costs another amount $AMOUNT"
elif ! [[ "$AMOUNT" =~ ^[0-9]+[A-Z]+$ ]]; then
    echo "perhaps $AMOUNT is not correct"
fi
```

### Logical operators

* AND -> `&&`
* OR ->  `||`
* NOT -> `!` 
```
VALUE=33
if [[ "$VALUE" -ge "$NR1" && "$VALUE" -le "$NR2" ]]; then
    echo "Value is located between"
fi
```

### File conditions

| Command               | Means                                                |
|-----------------------|:----------------------------------------------------:|
| file1 -ef file2       | returns true if files have the same inode nr         |                              
| file1 (-nt|-ot) file2 | returns true if file1 is newer/older than file2      |                
| -d file               | returns true if the file is a directory              |          
| -e file               | returns true if the file exists                      |  
| -f file               | returns true if the provided string is a file        |                 
| -g file               | returns true if the group id is set on a file        |                 
| -s file               | returns true if the file has a non-zero size         |                
| -u file               | returns true if the user id is set on a file         |                
| -r file               | returns true if the file is readable                 |        
| -w file               | returns true if the file is writable                 |        
| -x file               | returns true if the file is an executable            |            
```
FILE=test.txt
if [[ -e "$FILE" ]]; then
    if [[ -d "$FILE" ]]; then
        echo "$FILE is dir"
    elif [[ -f "$FILE" ]]; then
        echo "$FILE is file"
    else
        echo "$FILE N/A" >&2
        exit 1
    fi
else
    echo "$FILE does NOT exist" >&2
    exit 1
fi
```

### Here doc

* An additional form of I/O redirection
* `cmd <<- token`
* command that accepts stdin (such as cat, ftp) and a token in a string to indicate the end of the embedded text
```
cat <<- _EOF_
        1 line
        2 line
        _EOF_
```

### Here string

* cmd <<< line
```
read user <<< $(ls)
echo $user
```

### While

* As long as exit status is 0, it executes commands inside the loop
* Break/continue, accepts stdin
```
count=0
while [[ $count -le 3 ]]; do
    echo $count
    count=$((count+1))
done
```
```
ls | while read file; do                 # piping to while
    echo $file
done
```

### Case

* Multiple-choice command (e.g. to avoid multiple IFs)
* Accepts regex like `[ABC][C-9]`, `*.txt` or `???)`
* Only matches one case, if multiple selections -> use `;;&` instead of `;;`
```
case $NAME in
    q|Q)          echo "Exiting"
                  ;;
    [[:alpha:]]+) echo "OK"
                  ;;
    *)            echo "Invalid
                  ;;
esac
```

### Function

```
function sayHello() {
  echo "Hello World"
}
# **** 2nd option ****
sayHello () {
    local foo=bar                       # local var for func
    echo "Hello World"
}
sayHello                                # call a func
```

### Validation

* Instead of using IFs, you can use 1-line checking
```
read -p "Input item > "
[[ -z $REPLY ]] && sayHello             # if var is empty then trigger function
```

### Positional arguments

* Variables from `$0` contains the given arguments, `${99}`
* `$0` always contains path to the script
* `$#` contains nr of given args
```
$ ./script.sh 1a 2b 3c
echo $0 $1 $2                           # prints `/home/me/.../script.sh 1a 2b`
echo "Accepted $# args"                 # prints `Accepted 3 args`
```

### Funtion with params

```
greet() {
    echo "I am $1 and I am $2"
}
greet "Adam" "29"
```

### Shift

* Causes all the params to move down one each time it's executed (except `$0`)
* `$(basename $0)` extracts script name from  the path stored in `$0`
```
count=1
while [[ &# -gt 0 ]]; do
    echo "Arg $count = $1"              # prints each given argument
    count=$((count + 1))
    shift
done
```

### For loop

```
for i in {A..D}; do
    echo $i
done
```

### Manage empty variables

* Substitute value if unset (only once, when expanding)
```
$ echo ${foo:-"bar"}                    # prints `bar`
$ echo $foo                             # empty value
```
* Default value if unset
```
$ echo ${foo:="bar"}                    # prints `bar`
$ echo $foo                             # prints `bar`
$ echo ${foo:="fooooo"}                 # prints `bar`
```
* If empty or unset, causes the script to exit with an error
```
$ foo=
$ echo ${foo:?"is empty"}               # bash: foo: "is empty"
```
* Substitute value if set
```
$ foo=
$ echo ${foo:+"bar"}                    # empty value
$ foo=foooooo
$ echo ${foo:+"bar"}                    # prints `bar`
```

### String operations

* Get the given string lentgh `${#parameter}`
```
$ foo="This is something"
$ echo ${#foo}
```
* Get part of the string `${parameter:offset:length}`
```
$ foo="This is something"
$ echo ${foo:5:15}                      # prints `is something`
```
* Get portion of the string `${parameter##pattern}`/`${parameter#pattern}` from THE END
```
$ foo=file.zip.txt
$ echo ${foo#*.}                        # prints `zip.txt`
$ echo ${foo##*.}                       # prints `txt`
```
* Get portion of the string `${parameter%%pattern}`/`${parameter%pattern}` from THE BEGINNING
```
$ foo=file.zip.txt
$ echo ${foo%.*}                        # prints `file.zip`
$ echo ${foo%%.*}                       # prints `file`
```
* Replace part of the string `${parameter/pattern/string}`/`${parameter//pattern/string}`
```
$ foo=JPG.JGP
$ echo ${foo/JPG/jpg}                   # prints `jpg.JPG`
$ echo ${foo//JPG/jpg}                  # prints `jpg.jpg`
```
* Change to upper/lowercase `${paramener,,}`/`${paramener^^}`/`${paramener^}`
```
$ foo=aBcD
$ echo ${foo,,}                         # prints `abcd`
$ echo ${foo^^}                         # prints `ABCD`
$ echo ${foo^}                          # prints `Abcd`
```

### Number operations

* Base arithtmetic operations `$(( ))`
```
$ echo $((5 - 6))
```
* Condition like `[[ $INT –eq 0 ]]` is the same as `((INT == 0))`
```
if (( $INT == 0 )); then
    echo null
fi
```
* Change number bases
```
$ echo $((51))                          # base 10
$ echo $((8#51))                        # octal
$ echo $((16#51))                       # hexadecimal
$ echo $((2#1111))                      # binary
```
* `if ((foo=5))` gives true (makes foo equal 5 and evaluates true beacuse foo was assigned non-zero value)
* Available operators:
`parameter=value`,
`parameter+=value`,
`parameter-=value`,
`parameter/=value`,
`parameter*=value`,
`parameter%=value`,
`parameter++`,
`parameter--`,
`++parameter`,
`--parameter`,
Difference between `++parameter` and `parameter++` - both increment by one, if at the front, the param is incremented before the param is returned.
```
for ((i = 0; i <= 20; i++)); do
    if (((( i % 5)) == 0 )); then
        printf "<%d> " $i
    else
        printf "%d " $i
    fi
done
```
* If needed to perform higher math or just use floating point numbers `bc` or `awk` programs can be used

### Arrays

* Limited in bash to a single dimension
* Created automatically when they are accessed
```
$ a[1]=foo                              # assignment
$ echo ${a[1]}                          # access
```
* Assigning many values
```
$ days=(Mon Tue Wed Thu Fri)
$ echo $days                            # prints `Mon Tue Wed Thu Fri`
```
* Append new values and return len(array)
```
$ days+=(Sat)                           
$ echo ${#days[@]}                      # prints `6`
```

### Grouping commands
* Allows to combine the results of several cmds into a single stream

```
{ ls -l; echo "Listing; cat foo.txt } > output.txt
```

### Traps

* When an event like logout or shutdown occurs, define what script will do
```
exit_on_signal_SIGINT () {
    echo "Script interrupted" 2>&1
    exit 0
}
trap exit_on_signal_SIGINT SIGINT
```

### Asynchronous Execution

* Launch one or more child scripts that perform an additional task while the parent continues to run
```
async-child $                           # to run script `async-child` in background
pid=$!                                  # to get the process id of async-child
wait $pid                               # to stop execution of parent process till child is finished
```