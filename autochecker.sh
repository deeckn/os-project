#! /usr/bin/bash

<<com
63011119 Chakrin Deesit
63011199 Natcha Teekayu
63011278 Prima Sirinapapant
63011290 Ratchwalee Wongritdechakit
63011335 Tawan Lekngam
com

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

# Program called without receiving any arguments
if [ -z "$LAB_FILE_NAME" ] && [ -z "$EXPECTED_OUTPUT" ]
then
    read -p "Lab Number: " LAB_NO
    read -p "Question Number: " QUESTION_NO
    read -p "Expected output: " EXPECTED_OUTPUT
    LAB_FILE_NAME="Lab$LAB_NO$QUESTION_NO"
fi

LENGTH=${#LAB_FILE_NAME}
LAB_NUMBER="${LAB_FILE_NAME::LENGTH-1}"

# Validate user arguments
STD_LEN=5
STD_LAB_NAME="Lab"
TEMP="${LAB_FILE_NAME:0:3}"
REGEX='^[0-9]+$'
LAB_NO_CHECK="${LAB_FILE_NAME:3:$LENGTH}"

# Check if the string after Lab is an integer
until [[ $LAB_NO_CHECK =~ $REGEX ]];
do
    echo "Please enter in the format: LabXY Z"
    echo "X = Lab number"
    echo "Y = Question number"
    echo "Z = Expected result"
    echo "Eg. Lab11 20"
    
    read INPUT
    FILE_NAME=$(echo $INPUT| cut -d' ' -f 1)
    LENGTH=${#FILE_NAME}
    LAB_FILE_NAME=$FILE_NAME
    LAB_NUMBER="${FILE_NAME::LENGTH-1}"
    EXPECTED_OUTPUT=$(echo $INPUT| cut -d' ' -f 2)
    TEMP="${LAB_FILE_NAME:0:3}"
    LAB_NO_CHECK="${LAB_FILE_NAME:3:$LENGTH}"
done

# Check if the Lab is spelled correctly and provided both lab no. and question no.
until [ $TEMP == $STD_LAB_NAME ] && [ $LENGTH -ge $STD_LEN ]
do
    echo "Please enter in the format: LabXY Z"
    echo "X = Lab number"
    echo "Y = Question number"
    echo "Z = Expected result"
    echo "Eg. Lab11 20"
    
    read INPUT
    FILE_NAME=$(echo $INPUT| cut -d' ' -f 1)
    LENGTH=${#FILE_NAME}
    LAB_FILE_NAME=$FILE_NAME
    LAB_NUMBER="${FILE_NAME::LENGTH-1}"
    EXPECTED_OUTPUT=$(echo $INPUT| cut -d' ' -f 2)
    TEMP="${LAB_FILE_NAME:0:3}"
    LAB_NO_CHECK="${LAB_FILE_NAME:3:$LENGTH}"
done

# Result location
RESULTS_DIR="LabResults"
RESULT_FILE_NAME="result$LAB_FILE_NAME.csv"

# Change to lab directory
if [ -d "$LAB_FOLDER_PATH/$LAB_NUMBER" ]
then cd "$LAB_FOLDER_PATH/$LAB_NUMBER"
else
    echo "$LAB_NUMBER does not exist, please create one or choose a different lab number"
    exit "-1"
fi

# param: studentDir
function checkScore {
    local FILE_EXIST=false
    local COMPILED=false
    local SCORE=0
    
    # Check file existence
    if [ -e "$1/$LAB_FILE_NAME.c" ]
    then FILE_EXIST=true
    fi
    
    # Complie C code
    if $FILE_EXIST
    then
        if gcc "$1/$LAB_FILE_NAME.c" -o "$1/$LAB_FILE_NAME"
        then
            COMPILED=true
            SCORE=$((SCORE+1))
        else SCORE=1
        fi
    fi
    
    # Execute compiled C code
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
    
    # Delete executable file
    if $COMPILED
    then rm "$1/$LAB_FILE_NAME"
    fi
    
    # Return score
    echo $SCORE
}

# Clear file content if exist or create new one
echo "StudentId,Score" > "../$RESULTS_DIR/$RESULT_FILE_NAME"

# Loop through each student
for STUDENT_DIR in *
do
    # Score from checkScore function
    SCORE=$(checkScore $STUDENT_DIR)
    echo "$STUDENT_DIR,$SCORE" >> "../$RESULTS_DIR/$RESULT_FILE_NAME"
done

# User Feedback
echo "Result file created at $LAB_FOLDER_PATH$RESULTS_DIR/$RESULT_FILE_NAME"