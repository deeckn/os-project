#! /usr/bin/bash

<<com
Criteria:
- 0 for no file
- 1 for compilation error
- 2 for wrong output
- 3 for correct ouput
com

LAB_FOLDER_PATH="Labs/"

# Input
LAB_FILE_NAME="$1"
EXPECTED_OUTPUT="$2"
LENGTH=${#LAB_FILE_NAME}
LAB_NUMBER="${LAB_FILE_NAME::LENGTH-1}" #LABFILE_NAME[-1]

<<com
    Beam Part: Check input format
    Be sure to use variables that is easily understandable and use comments if needed
com

# Result location
RESULTS_DIR="LabResults"
RESULT_FILE_NAME="result$LAB_FILE_NAME.txt"

<<com
    TODO: Check if lab directory exists
    Eg. ./autochecker.sh Lab31 20
        -> Lab3 doesn't exist, give feedback and terminate program (or loop to receive input until correct, or allow them to quit)
com

# Change to lab directory
if [ -d "$LAB_FOLDER_PATH/$LAB_NUMBER" ]
then 
    cd "$LAB_FOLDER_PATH/$LAB_NUMBER"
else 
    echo "directory is not exist"
    exit "-1"
fi

# param: studentDir
function checkScore {
    local FILE_EXIST=false
    local COMPILED=false
    local SCORE=0

    # check if file exist
    if [ -e "$1/$LAB_FILE_NAME.c" ]
    then FILE_EXIST=true
    fi

    # complie c code
    if $FILE_EXIST
    then
        if gcc "$1/$LAB_FILE_NAME.c" -o "$1/$LAB_FILE_NAME"
        then
            COMPILED=true
            SCORE=$((SCORE+1))
        else SCORE=1
        fi
    fi

    # run c code
    if $COMPILED
    then
        ./"$1/$LAB_FILE_NAME"
        local OUTPUT=$?
        
        # Check if output is correct
        if [[ $OUTPUT == $EXPECTED_OUTPUT ]]
        then SCORE=$((SCORE+2))
        else SCORE=$((SCORE+1))
        fi
    fi

    # delete executable file
    if $COMPILED
    then rm "$1/$LAB_FILE_NAME"
    fi

    # return score
    echo $SCORE
}

# Check if result file exist
if [ -e "../$RESULTS_DIR/$RESULT_FILE_NAME" ]
# Delete existing file
then rm "../$RESULTS_DIR/$RESULT_FILE_NAME"
fi

# Loop through each student
for STUDENT_DIR in *
do
    SCORE=$(checkScore $STUDENT_DIR)
    
    # Write to text file
    touch "../$RESULTS_DIR/$RESULT_FILE_NAME"
    printf "$STUDENT_DIR;$SCORE\n" >> "../$RESULTS_DIR/$RESULT_FILE_NAME"
done

# User Feedback
printf "\nResult file created at $LAB_FOLDER_PATH$RESULTS_DIR/$RESULT_FILE_NAME"