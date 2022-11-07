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

# Result location
RESULTS_DIR="LabResults"
RESULT_FILE_NAME="result$LAB_FILE_NAME.csv"

# user input validation
if [ ! $LENGTH -eq 5 ] || [ -z "$EXPECTED_OUTPUT" ]
then 
    echo "try again: ./autochecker.sh Lab[1 - 9][1 - 9] [expected output]"
    exit "-1"
fi

# change to lab directory
if [ -d "$LAB_FOLDER_PATH/$LAB_NUMBER" ]
then cd "$LAB_FOLDER_PATH/$LAB_NUMBER"
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

# clear file content if exist or create new one
echo "StudentId,Score" > "../$RESULTS_DIR/$RESULT_FILE_NAME"

# Loop through each student
for STUDENT_DIR in *
do
    # score from function
    SCORE=$(checkScore $STUDENT_DIR)
    echo "$STUDENT_DIR,$SCORE" >> "../$RESULTS_DIR/$RESULT_FILE_NAME"
done

# User Feedback
printf "Result file created at $LAB_FOLDER_PATH$RESULTS_DIR/$RESULT_FILE_NAME"