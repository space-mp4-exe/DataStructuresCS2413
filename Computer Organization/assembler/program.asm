                ORG 10
                //get input of 2 digit octal number
FSA,            SKI 		        //look for input
	        BUN	FSA		//No input
	        CLA			//Clear AC
	        INP			//input character to AC
	        ADD	NEG30	        //convert to octal
	        STA	INPUT1	        //Store first character in INPUT1
FSB,            SKI 		        //look for input
	        BUN	FSB		//No input
	        CLA			//Clear AC
	        INP 		        //Second INP for second character
	        ADD	NEG30	        //convert to octal
	        STA	INPUT2 	        //store input in INPUT2
        
                //convert input to decimal
                LDA	INPUT1          //dont have to do a loop becuase input will always be 2 digits
                CIL
                ADD     MIN1
                CIL
                ADD     MIN1
                CIL                 
                ADD     MIN1            //INPUT1 * pow(8,1)
                STA     INPUT1
                ADD	INPUT2
                STA	DECIMAL         //DECIMAL = INPUT1 * pow(8,0) + INPUT2 * pow(8,1)

                //find if divisible by 3 or 5
                CLA
                LDA     DECIMAL
                STA     DIVIDEND
                LDA     THREE
                STA     DIVISOR
                BSA     DIVIDE
                CLA
                LDA     DIVIDEND
                STA     MOD3            //mod3 = decimal % 3

                LDA     DECIMAL
                STA     DIVIDEND
                LDA     FIVE
                STA     DIVISOR
                BSA     DIVIDE
                CLA
                LDA     DIVIDEND
                STA     MOD5            //mod5 = decimal % 5

                //check for decimal % 5
   		LDA     MOD5   	        //load result of decimal % 5
   		SZA   			//MOD5 should be 0 if divisible by 5
   		BUN     FALSE1   	//jump to the FALSE label
                BUN     TRUE            //jump to the TRUE label
   	 
   	        //check for decimal % 3
FALSE1,   	LDA	MOD3		//load result of decimal % 3
   		SZA   	                //MOD3 should be 0 if divisible by 3
   		BUN     FALSE2   	//jump to the FALSE2 label
                BUN     TRUE            //jump to the TRUE label

FALSE2,   	LDA    ZERO    	        //input is not divisible by 3 or 5
   	 	OUT   			//print out 0
   	 	HLT

TRUE,           BSA     SPLITDEC        //splits DECIMAL into OUTPUT1 and OUTPUT2
                CLA
                LDA     OUTPUT1
                ADD     MIN1            
                SPA                     //checks if OUTPUT1 is a 0
                BUN     SKIP            //won't print leading 0
                LDA     OUTPUT1
                ADD     ZERO
                OUT                
SKIP,           LDA     OUTPUT2
                ADD     ZERO
                OUT
                HLT

                //DIVIDE subroutine
DIVIDE,	        CLA 
                LDA 	DIVIDEND	//To use, set values for DIVIDEND and DIVISOR. After completion, quotient is in QUO and remainder is in DIVIDEND.
DIVIDEL,        STA 	DIVIDEND	//store value of last loop
                LDA 	QUO     	//load quotient into AC
                INC            	 
       	        STA 	QUO     	//QUO++
                LDA 	DIVISOR 	//move divisor into AC
                CMA             	//complement divisor
                INC             	//Divisor is now negative
                ADD 	DIVIDEND	//Subtract Dividend from Divisor
                SNA             	//If Dividend is larger than Divisor, this number will be positive
                BUN 	DIVIDEL 	//internal label for looping, end of loop. while(Dividend>=Divisor){Dividend-=Divisor; QUO++;};
                LDA 	QUO     	//quotient is 1 more than actual value
                ADD 	MIN1    	//subtract1
                STA 	QUO		//QUO--
                BSA	DIVIDE  I

                //SPLITDEC subroutine
                //split hex variable into two decmial variables. ex: if demcimal = 3F then OUTPUT1 = 6, OUTPUT2 = 3.
SPLITDEC,       CLA 
                LDA     DECIMAL         //input1 - input1 % 16. removes lowest digit. in hex.
                CIR
                CIR
                CIR
                CIR                     //shift over 4 digits to the left
                AND     1PLACE          //changes 00x0 to 000x. moves 16s place into 1s place  
                CMA                     //I made it negative so I can just add one using INC to count. 
                INC                     //complement of 16s place
                INC                     //add one extra because it loops an extra time. eg lessthana loops 3 times if count is -2.
                STA     COUNT           //counts how many times to add 16 to output2
                LDA     DECIMAL
                AND     1PLACE
                STA     OUTPUT2         //converts digit into decimal. ex: if, dividend = F. then, OUTPUT1 = 1, OUTPUT2 = 5. 
                ADD     NEG10           
                SPA                     //checks if first digit is greater than A
                BUN     CHECKLOOP       //we must check if we should loop at all first
                STA     OUTPUT2         //OUTPUT2's value is 10 less than it started off as
                LDA     OUTPUT1         //since we subtracted 10, we add it back in by incrementing OUTPUT1. 
                INC          
                STA     OUTPUT1
CHECKLOOP,      CLA
                LDA     COUNT           
                ADD     MIN1            //subtract 1 so that an original count of 0 will still loop
                SNA                     //an original count value of 1 will not loop
                BUN     SPLITDEC I      //check if we have to loop
LESSTHANA,      CLA                     //OUTPUT2 is less than A, so it fits in one variable.
                LDA     OUTPUT1
                INC     
                STA     OUTPUT1
                LDA     OUTPUT2
                ADD     SIX
                STA     OUTPUT2
                ADD     NEG10           //number is positive if digit is greater than A
                SPA     
                BUN     LESSTHANA
                STA     OUTPUT2
                LDA     OUTPUT1
                INC 
                STA     OUTPUT1
                LDA     COUNT           //counts from negative number to 0. break when 0
                INC
                STA     COUNT
                SPA
                BUN     LESSTHANA 
                BSA     SPLITDEC I
        
                ORG     100             
INPUT1,	        DEC 	0               //first digit of input
INPUT2,	        DEC	0               //second digit of input
OUTPUT1,        DEC     0               //first digit of OUTPUT
OUTPUT2,        DEC     0               //second digit of OUTPUT
NEG30,	        HEX	-30             //for converting into octal
DECIMAL,        DEC	0               //input in decimal form
NEG10,          DEC     -10             //for checking if output digits have a max value of 9
MOD3,           DEC     0               //decimal % 3
MOD5,           DEC     0               //decimal % 5
THREE,          DEC     3               //for MOD3
FIVE,           DEC     5               //for MOD5
SIX,            DEC     6               //for converting hex into dec
SIXTEEN,        DEC     16              //for MOD16
DIVIDEND,   	DEC	0 		//the number that is being divided. Stores remainder after running.
DIVISOR,	DEC 	0		//the number you are dividing by
QUO,    	DEC 	0		//result of division
MIN1,   	DEC 	-1		//for decrementing
ZERO,           HEX     30              //0 in ascii
COUNT,          DEC     0               //for counting in SPLITDEC
1PLACE,         HEX     000F            //used for isolating the first digit
                END