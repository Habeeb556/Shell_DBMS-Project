#! /bin/bash

mkdir DBMS 
cd DBMS
clear
echo "			Welcome to our DBMS 🤗️😊️"
function mainMenu {
       
	echo "		Main Menu Choose what you want to do 🤔️"
	echo " "
        select ch in " Create Database" " List Databases" " Connect to Database" " Drop Database"  " Exit"
        do
                  case $REPLY in
                        1)  CreateDatabase;;
                        2)  ls ; echo " "; mainMenu ;;
                        3)  ConnetDatabase ;;
                        4)  DropDatabase ;;
                        5) exit ;;
                        *) echo " Wrong Choice 🤬️👊️ " ; mainMenu;
                        esac
        done
}

function CreateDatabase {
echo " "
	read -p "Enter Database Name ➡️  " dbName;

	if [ -d $dbName ]
	then
		echo "Database already exists ✋️ ";
		echo " "
        	mainMenu
	else
		mkdir $dbName
	if [[ $? == 0 ]]
        then
             echo "Your Database  $dbName Created Successfully 👍️";
             	echo " "
             mainMenu
         else
         echo "Something Wrong Please Try Again ⚠️";
         mainMenu
         fi

	fi
	
}
function ConnetDatabase {
	echo " "
        read -p "Enter Database Name you want to connect ➡️  " dbName
        
        if [ -d $dbName ]
        then
                cd $dbName
                clear;
		echo "you are now connected to $dbName ✅️"
		echo " "
		tableMenu
        else
         	 echo "Database doesn't exists 🤬️👊️";
         	 echo " "
		 mainMenu
	fi
}
function DropDatabase {
	echo " "
        read -p "Enter Database Name you want to drop ➡️  " dbName

        if [ -d $dbName ]
        then
                rm -r $dbName
                echo "Database $dbName dropped successfully ✅️"
                	echo " "
		mainMenu
        else
                 echo "Database doesn't exists 🤬️👊️";
                 	echo " "
                 mainMenu
        fi
}


function tableMenu {
	echo "		Table Menu Choose what you want to do 🤔️"
	echo " "
	select ch in " List All Exsisting Table" " Create Table" " Drop Table" " Insert into Table" " Select From Table " " Delete From Table" " Update Table" " Exit"
	do
		  case $REPLY in
   		        1)  ls ; echo " "; tableMenu ;;
   	 		2)  createTable ;;
	 		3)  Drop-Table ;;
   	 		4)  insert ;;
   	 		5)  clear; selectMenu ;;
   	 		6)  deleteFromTable;;
   	 		7)  updateTable;;
    	 		8)  cd -; clear; mainMenu ;;
    	 		*) echo " Wrong Choice 🤬️👊️" ; tableMenu;
  	 		esac
	done
}


function createTable {
read -p "Enter Table Name ➡️  " TableName

if [ -f $TableName ]
then
	echo "Table already exists 👀️";
	tableMenu
else
    read -p "Enter Number Of Column ➡️  " col
    
    counter=1
    seperator=":"
    rowSep="\n"
    pKey=""
    columns="Field"$seperator"Type"$seperator"Key"
    while [ $counter -le $col ]
    do
	    read -p "Enter Column $counter Name ➡️  " colName
 
	    echo "Enter the type of Column $counter"
	    select t in " Int" " String" 
	    do
		    case $REPLY in
			    1) colType="int"; break ;;
			    2) colType="str"; break;;
			    *) echo "wrong choice 🤬️👊️"; break;;
		    esac
	    done
	    if [[ $pKey == "" ]]
	    then
		    echo "Do You need Make Praimary Key 🔑️"
		    select p in " Yes" " No"
		    do
			    case $REPLY in
				    1) pKey="PK";columns+=$rowSep$colName$seperator$colType$seperator$pKey;
					    break;;
				    2) columns+=$rowSep$colName$seperator$colType$seperator;
					    break;;
				    *) echo "Wrong Choice 🤬️👊️"; 
					    break;;
			    esac
		    done
	    else
	    	columns+=$rowSep$colName$seperator$colType$seperator ;
	    fi
	    if [[ $counter == $col ]]
	    then
		    temp=$temp$colName
	    else
		    temp=$temp$colName$seperator
	    fi
	
	    ((counter++))

    done
    touch .$TableName
    echo -e $columns  >> .$TableName
    touch $TableName
    echo -e $temp >> $TableName


    if [[ $? == 0 ]]
    then
	echo "Your Table $TableName Created Successfully ✅️";
	tableMenu
    else
	    echo "Something Wrong Please Try Again ⚠️";
	    tableMenu
    fi
fi    
}

function Drop-Table {

read -p "Enter Table Name ➡️  " TableName

if [ -f $TableName ]
then
	rm -i $TableName ;
	tableMenu;
else
	echo "Sorry the table you entered doesn't exist 😥️🙌️";
	tableMenu;
fi
}


function insert {

read -p "Enter Table Name ➡️  " TableName

if [ -f $TableName ]
then
	colNum=`awk 'END{print NR}' .$TableName`
	seperator=":"
	rowSep=" "
	
	for (( i=2; i<=$colNum; i++ ))
	do
		colName=`awk 'BEGIN{FS=":"}{if(NR=='$i') print $1}' .$TableName`
		colType=`awk 'BEGIN{FS=":"}{if(NR=='$i') print $2}' .$TableName`
		colKey=`awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' .$TableName`

                read -p "$colName ($colType) = " data
	        
		if [[ $colType == "int" ]]
		then
			while  [[ $data =~ ^[a-z]*$ ]]
			do
				echo "invalid input Type 🤬️👊️";
				read -p "$colName ($colType) = " data
			done
		fi

		if [[ $colKey == "PK" ]]
		then
			while [[ true ]]
			do
				if [[ $data =~ ^[`awk 'BEGIN{FS=":" ;ORS=" "}{if(NR != 1) print $(('$i'-1))}' $TableName`]$ ]]
				then
					echo "invalid input for primary key 🔑️🤬️ "
				else
					break;
				fi
				read -p "$colName ($colType) = " data
			done
		fi

		if [[ $i == $colNum ]]
		then
			row=$row$data$rowSep
		else
			row=$row$data$seperator
		fi
	done
	echo $row >> $TableName
	if [[ $? == 0 ]]
	then
		echo "Row added Successfully ✅️"
	else
		echo "Error please try again ⚠️";
		tableMenu
	fi
	row=""
	tableMenu	         		
else
	echo "Table doesn't exist 👊️🤬️";
	tableMenu;
fi
}

function selectMenu {
echo " "
echo "		Select Menu Choose what you want to do 🤔️"
echo " "
select c in " Select All from Table" " Select Specific Column in Table" " Select from Table with condition" " back to table Menu" " back to main menu"
do
	case $REPLY in 
		1) selectAll ; break ;;
		2) selectCol ; break ;;
		3) selectCondition ; break ;;
		4) tableMenu  ;;
	        5) cd -; clear; mainMenu ;; 	
		*) echo "Wrong Choice 🤬️👊️" ;selectMenu;
	esac
done
}

function selectAll {

read -p "Enter Table Name ➡️  " TableName

if [ -f $TableName ]
then
        more $TableName ;
	selectMenu ;
        
else
	echo "Table dosn't exist 🤬️👊️";
	selectMenu;
fi

}

function selectCol {

read -p "Enter Table Name ➡️  " TableName
if [ -f $TableName ]
then
	read -p "Enter Column Name ➡️  " colName
       
	ColNum=`awk -F":"  'NR==1{

        for (i=1 ; i<=NF ;i++){
                if( $i == "'$colName'" ){
                           print i
			}
        }

        }' $TableName`

	awk -F":" '{print $'$ColNum'}' $TableName 
	selectMenu ;				   
else
	echo "Table dosn't exist 🤬️👊️";
	selectMenu;
fi

}

function selectCondition {
  echo "Select specific column from TABLE Where FIELD(OPERATOR)VALUE ⬇️"
  read -p "Enter Table Name ➡️  " TableName
  if [ -f $TableName ]
  then
	  read -p "Enter required FIELD name ➡️  " field

	  fid=`awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $TableName`
	  if [[ $fid == "" ]]
	  then
	    echo "Not Found 🤬️👊️"
	    selectMenu 
	  else
	    read -p "Supported Operators: [==, !=, >, <, >=, <=] Select OPERATOR ➡️   " op
	    
	    if [[ $op == "==" ]] || [[ $op == "!=" ]] || [[ $op == ">" ]] || [[ $op == "<" ]] || [[ $op == ">=" ]] || [[ $op == "<=" ]]
	    then
	      read -p "Enter required VALUE ➡️  " val
	    
	      res=`awk 'BEGIN{FS=":"}{if ($'$fid$op$val') print $'$fid'}' $TableName`
	      if [[ $res == "" ]]
	      then
		echo "Value Not Found 🤬️👊️ "
		selectMenu
		
	      else
		awk 'BEGIN{FS=":"}{if ($'$fid$op$val') print $'$fid'}' $TableName
		
	      fi
	    else
	      echo "Unsupported Operator😥️"
	      selectMenu
	      
	    fi
	  fi
  else
  	echo "Table Not Found 😥️"
	selectMenu
  fi
    
}


function deleteFromTable {
  read -p"Enter Table Name ➡️  " TableName
  
  if [ -f $TableName ]
  then
	  read -p "Enter Column Name ➡️  " colName
	   ColNum=$(awk -F":"  'NR==1{

        for (i=1 ; i<=NF ;i++){
                if( $i == "'$colName'" ){
                           print i
                        }
        }

	}' $TableName)
	#echo $ColNum
	if [[ $ColNum == "" ]]
	then
		echo "Column not found 😥️";
		tableMenu;
	else
		#set -x
		read -p "Enter Condition Value ➡️ "  val
		Res=`awk -F":" '{
                
			if( $'$ColNum' == "'$val'" )
				print $'$ColNum'

		}' $TableName`
	fi
	#echo $Res
	if [[ $Res == "" ]]
	then
		echo "value not found 😥️";
		tableMenu;
	else
		 NUMR=`awk -F":" 'BEGIN{NumR=0}{ 
			if( $'$ColNum' == "'$val'"){
				print NR
			}		      
	 	} ' $TableName`
	 	count=0
	 	for i in $NUMR
	 	do
	 		sed -i ''$(($i-$count))'d' $TableName
	 		echo "Row Deleted Successfully 👍️";
	 		((count++)) 
	 		
	 	done
		tableMenu
	fi
  else
	  echo "Table Not Exist 🤬️👊️";
          tableMenu ;
  fi
}

function updateTable {
  read -p "Enter Table Name ➡️  " TableName
 
  read -p "Enter Column Name ➡️  " colName

  ColNum=` awk -F":" 'NR==1 {for(i=1;i<=NF;i++)
  {
	  if( $i == "'$colName'" )
		  print i
	  } 
	}' $TableName`

  if [[ $ColNum == "" ]]
  then
    echo "Column Not Found 😥️"
    echo " "
    tableMenu
  else
    read -p "Enter value you want to change it ➡️  " Val
    Res=`awk -F":" '{if( $'$ColNum' == "'$Val'" ) print $'$ColNum'}' $TableName`

    if [[ $Res == "" ]]
    then
      echo "Value Not Found 😥️"
      echo " "
      tableMenu
    else
    #set -x
        read -p "Enter New Value ➡️  " newValue
        NUM=$(awk 'BEGIN{FS=":"}{if ($'$ColNum' == "'$Val'") print NR}' $TableName)
        index=0
	 	for i in $NUM
	 	do
	 		sed -i 's/'$Val'/'$newValue'/g' $TableName
	 		echo "Row Updated Successfully from $oldValue to $newValue 👍️"
	 		((index++)) 		
	 	done
      #set +x        
	echo " "
        tableMenu
      fi
    fi
}

mainMenu

