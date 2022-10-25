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
RESULT_FILE_NAME="result$LAB_FILE_NAME.txt"

# Change to lab directory
cd "$LAB_FOLDER_PATH/$LAB_NUMBER"

# Control variables
SCORE=0
FILE_EXIST=false
COMPILED=false

# Check if result file exist
if [ -e "../$RESULTS_DIR/$RESULT_FILE_NAME" ]
# Delete existing file
then rm "../$RESULTS_DIR/$RESULT_FILE_NAME"
fi

# Loop through each student
for STUDENT_DIR in *
do
    # Check if file exist
    if [ -e "$STUDENT_DIR/$LAB_FILE_NAME.c" ]
    then FILE_EXIST=true
    fi
    
    # Compile student code
    if $FILE_EXIST
    then
        if gcc "$STUDENT_DIR/$LAB_FILE_NAME.c" -o "$STUDENT_DIR/$LAB_FILE_NAME"
        then
            COMPILED=true
            SCORE=$((SCORE+1))
        else
            SCORE=1
        fi
    fi
    
    # Run student code
    if $COMPILED
    then
        ./"$STUDENT_DIR/$LAB_FILE_NAME"
        OUTPUT=$?
        
        # Check if output is correct
        if [[ $OUTPUT == $EXPECTED_OUTPUT ]]
        then SCORE=$((SCORE+2))
        else SCORE=$((SCORE+1))
        fi
    fi
    
    # Delete executable file
    if $COMPILED
    then rm "$STUDENT_DIR/$LAB_FILE_NAME"
    fi

    # Write to text file
    touch "../$RESULTS_DIR/$RESULT_FILE_NAME"
    printf "$STUDENT_DIR;$SCORE\n" >> "../$RESULTS_DIR/$RESULT_FILE_NAME"
    
    # Reset control variables
    SCORE=0
    FILE_EXIST=false
    COMPILED=false
done
