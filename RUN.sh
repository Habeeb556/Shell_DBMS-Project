#!/bin/bash

mkdir DBMS 
cd DBMS
clear

## 1st-Menu
function mainMenu {
	echo "======================================================="
	echo "     Bash Shell Script - Database Management System    "
	echo "======================================================="
	echo " "
        select x in "Create Database" "List Databases" "Connect to Database" "Drop Database" "Exit"
        do
                  case $REPLY in
                        1)  CreateDatabase;;
                        2)  ls; echo " "; mainMenu;;
                        3)  ConnetDatabase;;
                        4)  DropDatabase;;
                        5)  clear; exit;;
                        *)  echo " "; mainMenu;;
                        esac
        done
}

function validate() {
	if [ -z $1 ]; then
		return 1
	else 
   		return 0
  	fi
}

function CreateDatabase {
	echo " "
	read -p "Database name: " dbName;

	if validate $dbName;
	then        	
		if [ -d $dbName ]
		then
			echo "Database name already exists";
			echo " "
			mainMenu
		else 
			 if [[ $dbName =~ [a-zA-Z] ]]
			 then
				mkdir $dbName
			 	echo "Database $dbName created successfully";
			     	echo " "
			 	mainMenu
			 else
				echo "Syntax error, it contains an illegal character"
			     	echo " "
			 	mainMenu
			 fi
		fi
	else
                echo "Syntax error, not valid input";
                echo " "
                mainMenu
        fi
}

function ConnetDatabase {
	echo " "
        read -p "Enter database name want to connect: " dbName
        
	if validate $dbName;
	then        
		if [ -d $dbName ]
		then
		        cd $dbName
		        clear;
			echo "Connected to $dbName successfully"
			echo " "
			tableMenu
		else
		 	echo "Database doesn't exists";
		 	echo " "
			mainMenu
		fi
        else
                echo "Syntax error, not valid input";
                echo " "
                mainMenu
        fi
}

function DropDatabase {
	echo " "
        read -p "Enter database name want to drop: " dbName

	if validate $dbName;
	then        
		if [ -d $dbName ]
	 	then
			rm -r $dbName
			echo "Database $dbName dropped successfully"
			echo " "
			mainMenu
		else
		        echo "Database doesn't exists";
		        echo " "
		        mainMenu
		fi	
        else
                echo "Syntax error, not valid input";
                echo " "
                mainMenu
        fi
}

## 2nd-Menu
function tableMenu {
	echo "======================================================="
	echo "     Table Menu for Database Management System             "
	echo "======================================================="
	echo " "
	select x in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select from Table " "Delete from Table" "Update Table" "Exit to Main Menu" "Query Table"
	do
		case $REPLY in
   			1)  createTable;;
   	 		2)  ls; echo " "; tableMenu;;
	 		3)  dropTable;;
   	 		4)  insertTable;;
   	 		5)  clear; selectMenu;;
   	 		6)  deleteFromTable;;
   	 		7)  updateTable;;
    	 		8)  cd -; clear; mainMenu;;
			9)  Query;;
    	 		*)  echo " "; tableMenu;
  	 	esac
	done
}

##Bouns2
function numType() {
	if [[ $1 =~ ^[0-9]+$ ]]; then
		return 0
	else 
   		return 1
  	fi
}

function varType() {
	if [[ $1 =~ [a-zA-Z] ]]; then
		return 0
	else 
   		return 1
  	fi
}

function createTable {
	read -p "Table name: " TableName
	
	if validate $TableName;
	then        
		if [ -f $TableName ]
		then
			echo "Table name already exists";
			echo " "
			tableMenu
		else
			if varType $TableName;
			then
				echo ""
			else
				echo "Syntax error, it contains an illegal character"
			     	echo " "
			 	tableMenu
			fi

			read -p "Number of columns: " col
			if numType $col;
			then
				counter=1
				seperator=":"
				rowSep="\n"
				pKey=""
			 	columns="Field"$seperator"Type"$seperator"Key"
				while [ $counter -le $col ]
			 	do
					read -p "Enter column $counter name: " colName
			 		if varType $colName;
					then
						echo "Choose the type of column $colName: "
						select t in "Number" "Varchar2"
						do
							case $REPLY in
								1) colType="Number"; break ;;
								2) colType="Varchar2"; break;;
								*) echo " "; tableMenu; break;;
							esac
						done

						if [[ $pKey == "" ]]
						then
							echo "Make it PK?"
							select p in "Yes" "No"
							do
								case $REPLY in
									1) pKey="PK";columns+=$rowSep$colName$seperator$colType$seperator$pKey;
										break;;
									2) columns+=$rowSep$colName$seperator$colType$seperator;
										break;;
									*) echo " "; 
										break;;
								esac
							done
						else
						    	columns+=$rowSep$colName$seperator$colType$seperator;
						fi
				 		 
						if [[ $counter == $col ]]
						 	then
								temp=$temp$colName
						 	else
								temp=$temp$colName$seperator
						fi
					
						((counter++))
					else
						echo "Syntax error, it contains an illegal character"
					     	echo " "
					 	tableMenu
					fi
		    		done
				touch $TableName
				#meta-data
				touch ".$TableName"
				echo -e "Table name: "$TableName >>.$TableName	
				echo -e "No of columns: "$col >>.$TableName
				echo -e $columns  >> .$TableName	
				echo -e $temp >> $TableName
				echo "Table $TableName created successfully";		 
    				echo " "
 				tableMenu
			else
				echo "Syntax error, it contains an illegal character"
			     	echo " "
			 	tableMenu
			fi
	
	
	fi
	        else
                echo "Syntax error, not valid input";
                echo " "
                tableMenu
        fi    
}

function dropTable {
	read -p "Table name: " TableName

	if validate $TableName;
	then        
		if [ -f $TableName ]
		then
			rm -f $TableName;
			rm -f .$TableName;
			echo "tables removed successfully"
			echo " "
			tableMenu;
		else
			echo "Table doesn't exist";
			echo " "
			tableMenu;
		fi
	else
                echo "Syntax error, not valid input";
                echo " "
                tableMenu
        fi    
}

function insertTable {
	read -p "Table name: " TableName

	if validate $TableName;
	then        
		if [ -f $TableName ]
		then
			TcolNum=`awk 'END{print NR}' .$TableName`
			seperator=":"
			rowSep=" "
			
			for (( i=4; i<=$TcolNum; i++ ))
			do
				colName=`awk -F":" '{if(NR=='$i') print $1}' .$TableName`
				colType=`awk -F":" '{if(NR=='$i') print $2}' .$TableName`
				colKey=`awk -F":" '{if(NR=='$i') print $3}' .$TableName`
				
				ColNum=` awk -F":" '{for(i=1;i<=NF;i++)
				{
					if( $i == "'$colName'" )
					print i
				} 
				}' $TableName`

				read -p "$colName ($colType): " data
				
				if [[ $colType == "Number" ]]
				then
					while  [[ true ]]					
					do
						if numType $data;
						then break;
						else
							echo "Syntax error, invalid input type";
							read -p "$colName ($colType): " data
						fi						
						done
				else
					while [[ $data =~ ^[0-9]+$ ]]
					do
						echo "Syntax error, invalid input type";
						read -p "$colName ($colType): " data
					done
				fi

				if [[ $colKey == "PK" ]]
				then
					while [[ true ]]
					do
					if validate $TableName
					then
						if [[ $data =~ ^[`awk -F":" '{if(NR != 1) print $(('$ColNum'))}' $TableName`]$ ]]
						then
							echo "Duplicate entry for key (PRIMARY)"
						else
							break;
						fi
						read -p "$colName ($colType) = " data
					fi
					done
				fi

				if [[ $i == $TcolNum ]]
				then
					row=$row$data$rowSep
				else
					row=$row$data$seperator
				fi
			done
			echo $row >> $TableName
			row=""
			echo "Row add successfully";
			echo " "
			tableMenu	         		
		else
			echo "Table doesn't exist";
			echo " "
			tableMenu;
		fi
	else
                echo "Syntax error, not valid input";
                echo " "
                tableMenu
        fi   
}

function deleteFromTable {
	read -p "Table name: " TableName 
	read -p "Row number: " rowNum
	
	if validate $TableName && validate $rowNum;
	then        
		if [ -f $TableName ]
		then
			while [[ true ]]
			do
				if numType $rowNum;
				then
					break;
				else 
					echo "Syntax error, invalid input type";
					read -p "Row number: " rowNum;
				fi
			done
			let "rowNum += 1"
			TcolNum=`awk 'END{print NR}' $TableName`
			if [[ $rowNum < $TcolNum ]]
			then	
				sed  -i ''$rowNum'd' $TableName
				echo "Row deleted successfully"	 		
				echo " "
				tableMenu
			else
				echo "Row doesn't exist";
				echo " "
				tableMenu ;
	  		fi
		else
			echo "Table doesn't exist";
			echo " "
			tableMenu ;
	  	fi
	else
                echo "Syntax error, not valid input";
                echo " "
                tableMenu
        fi   
}

##Bouns3
function updateTable {
	read -p "Table name: " TableName 
	read -p "Row number: " rowNum
	read -p "Column name: " colName
	
	if validate $TableName && validate $rowNum && validate $colName;
	then        
		if [ -f $TableName ]
		then
			while [[ true ]]
			do
				if numType $rowNum;
				then
					break;
				else 
					echo "Syntax error, invalid input type";
					read -p "Row number: " rowNum;
				fi
			done
			while [[ true ]]
			do
				if varType $colName;
				then
					break;
				else 
					echo "Syntax error, invalid input type";
					read -p "Column name: " colName;
				fi
			done
			let "rowNum += 1"
			ColNum=`awk -F":" '{for(i=1;i<=NF;i++){if( $i == "'$colName'" )print i}}' $TableName`
			Val=`awk -F":" 'NR=='$rowNum' {print $'$ColNum'}' $TableName 2>/dev/null`
			if [[ $? == 0 ]]
			then
				if [[ $Val == " " ]]; 
				then 
					echo "There is no data to update";
					echo " "
					tableMenu
				fi	
				colRow=`awk -F: '{if ($1=="'$colName'") print NR}' .$TableName`
				colKey=`awk -F":" '{if(NR=='$colRow') print $3}' .$TableName`
				if [[ $colKey == 'PK' ]]
				then
					echo "Cannot update Primary Key Field"
					echo " "
					tableMenu
				fi
				colType=`awk -F":" '{if(NR=='$rowNum+2') print $2}' .$TableName`
				read -p "New value: " newValue;
				
				if [[ $colType == "Number" ]]
				then
					while  [[ true ]]					
					do
						if numType $newValue;
						then break;
						else
							echo "Syntax error, invalid input type";
							read -p "New value instead of['$Val']: " newValue;
						fi						
					done
				else
					while [[ $newValue =~ ^[0-9]+$ ]]
					do
						echo "Syntax error, invalid input type";
						read -p "New value instead of['$Val']: " newValue;
					done
				fi
				sed -i -r 's/'$Val'/'$newValue'/g' $TableName
				echo "Row updated successfully from $Val to $newValue"	 		
				echo " "
				tableMenu
			else
				echo "Something wrong, try again";
				echo " "
				tableMenu
			fi
		else
			echo "Table doesn't exist";
			echo " "
			tableMenu ;
	  	fi
	else
                echo "Syntax error, not valid input";
                echo " "
                tableMenu
        fi   
}

## 3rd-Menu
function selectMenu {
	echo "======================================================="
	echo "     Select Menu for Database Management System        "
	echo "======================================================="
	echo " "
	select x in "Select all" "Select column" "Back to Table Menu" "Back to Main Menu"
	do
		case $REPLY in 
			1) selectAll; break;;
			2) selectCol; break;;
			3) tableMenu;;
			4) cd -; clear; mainMenu;; 	
			*) echo " "; selectMenu;
		esac
	done
}

function selectAll {
	read -p "Table name: " TableName

	if validate $TableName;
	then        	
		if [ -f $TableName ]
		then
			if [[ `wc -l < "$TableName"` = 1 ]]
			then
				echo "No data yet";
				echo " "
				selectMenu;
			else
				cat $TableName;
				echo " "
				selectMenu;
			fi
		else
			echo "Table doesn't exist";
			echo " "
			selectMenu;
		fi
	else
                echo "Syntax error, not valid input";
                echo " "
                selectMenu
        fi   
}

function selectCol {
	read -p "Table name: " TableName
	
	if validate $TableName;
	then        	
		if [ -f $TableName ]
		then
			read -p "Column name: " colName
			while [[ true ]]
			do
				if varType $colName;
				then
					break;
				else 
					echo "Syntax error, invalid input type";
					read -p "Column name: " colName;
				fi
			done
			ColNum=` awk -F":" '{for(i=1;i<=NF;i++)
			{
				if( $i == "'$colName'" )
				print i
			} 
			}' $TableName`
			awk -F":" '{if( NR!=1 )print $'$ColNum'}' $TableName 2> /dev/null;
			if [[ $? == 0 ]];
			then	
				echo " "
				selectMenu;
			else
				echo "Something wrong, try again";
				echo " "
				selectMenu
			fi				   
		else
			echo "Table doesn't exist";
			echo " "
			selectMenu;
		fi
	else
                echo "Syntax error, not valid input";
                echo " "
                selectMenu
        fi   
}

##Bouns1
function Query {
	c=0
	echo "enter Query : "
	read r
	CheckOnQuery $r
	Dml=`echo $r | cut -d' ' -f1`
	colN=`echo $r | cut -d' ' -f2`
	syntax=`echo $r | cut -d' ' -f3`
	tabN=`echo $r | cut -d' ' -f4`
	((tabL=`wc -l $tabN | cut -d' ' -f1`-1)) 2> /dev/null
	if [ $Dml = 'select'  ] && [ $syntax = 'from' ]
	then
		if [ -f $tabN ]
		then #table exists	
			if [ $colN = 'all' ]	
		 	then
			tail -$tabL $tabN
			Query;
			else
				ColNum=`awk -F":"  '{
		for (i=1 ; i<=NF ;i++){
		        if( $i == "'$colN'" ){
		                   print i
			}
		}
		}' $tabN`

		awk -F":" '{if( NR!=1 )print $'$ColNum'}' $tabN 2> /dev/null
			if [ $? != 0 ]
			then
			echo "enter a valid column name";
			fi
			Query
			fi	
		else
		echo "table doesn't exist "
		Query;
		fi
	elif [ `echo $r | cut -d: -f1` = 'exit' 2> /dev/null ]
	then
		tableMenu
	else 
		echo "invalid Query"
		Query;
	fi
}

function CheckOnQuery {
	chk=$*
	num=$#
	if [ -z `echo $chk | cut -d' ' -f4` ] || [ $num -gt 4 ]
	then
		echo enter a valid Query 
		Query;
	fi
}

mainMenu
