
<<com
Criteria:
- 0 for no file
- 1 for compilation error
- 2 for wrong output
- 3 for correct ouput
com

folder="Labs/"

# Input
filename="$1"
EXPECTED_OUTPUT="$2"
LENGTH=${#filename}
lab_number="${filename::LENGTH-1}" #LABFILE_NAME[-1]

standard_length=5
standard_lab_name="Lab"
temp="${filename:0:3}"

while [ $temp != $standard_lab_name ] || [ $LENGTH -lt $standard_length ]
do 
    echo "Please enter in this format LabXY Z"
    echo "where X Y Z is positive interger"
    echo "ex. Lab11 20"

    read INPUT
    FILENAME=$(echo $INPUT| cut -d' ' -f 1)
    LENGTH=${#FILENAME}
    filename=$FILENAME
    lab_number="${FILENAME::LENGTH-1}"
    EXPECTED_OUTPUT=$(echo $INPUT| cut -d' ' -f 2)
    temp="${filename:0:3}"

done


# Result location
result_dir="LabResults"
result_filename="result$filename.txt"

# Change to lab directory
cd "$folder/$lab_number"

# Control variables
SCORE=0
FILE_EXIST=false
COMPILED=false

# Check if result file exist
if [ -e "../$result_dir/$result_filename" ]
# Delete existing file
then rm "../$result_dir/$result_filename"
fi

# Loop through each student
for STUDENT_DIR in *
do
    # Check if file exist
    if [ -e "$STUDENT_DIR/$filename.c" ]
    then FILE_EXIST=true
    fi
    
    # Compile student code
    if $FILE_EXIST
    then
        if gcc "$STUDENT_DIR/$filename.c" -o "$STUDENT_DIR/$filename"
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
        ./"$STUDENT_DIR/$filename"
        OUTPUT=$?
        
        # Check if output is correct
        if [[ $OUTPUT == $EXPECTED_OUTPUT ]]
        then SCORE=$((SCORE+2))
        else SCORE=$((SCORE+1))
        fi
    fi
    
    # Delete executable file
    if $COMPILED
    then rm "$STUDENT_DIR/$filename"
    fi

    # Write to text file
    touch "../$result_dir/$result_filename"
    printf "$STUDENT_DIR;$SCORE\n" >> "../$result_dir/$result_filename"
    
    # Reset control variables
    SCORE=0
    FILE_EXIST=false
    COMPILED=false
done
