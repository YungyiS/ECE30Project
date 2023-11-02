////////////////////////
//                    //
// Project Submission //
//                    //
////////////////////////

// Partner1: YungYi Sun, A16310687
// Partner2: (your name here), (Student ID here)

////////////////////////
//                    //
//       main         //
//                    //
////////////////////////

    // Print Input Array
    lda x0, arr1        // x0 = &list1
    lda x1, arr1_length // x1 = &list1_length
    ldur x1, [x1, #0]   // x1 = list1_length
    bl printList

    // Test Swap Function
    bl printSwapNumbers // print the original values
    lda x0, swap_test   // x0 = &swap_test[0]
    addi x1, x0, #8     // x1 = &swap_test[1]
    bl Swap             // Swap(&swap_test[0], &swap_test[1])
    bl printSwapNumbers // print the swapped values

    // Test GetNextGap Function
    addi x0, xzr, #1    // x0 = 1
    bl GetNextGap       // x0 = GetNextGap(1) = 0
    putint x0           // print x0
    addi x1, xzr, #32   // x1 = ' '
    putchar x1          // print x1

    addi x0, xzr, #6    // x0 = 6
    bl GetNextGap       // x0 = GetNextGap(6) = 3
    putint x0           // print x0
    addi x1, xzr, #32   // x1 = ' '
    putchar x1          // print x1

    addi x0, xzr, #7    // x0 = 7
    bl GetNextGap       // x0 = GetNextGap(7) = 4
    putint x0           // print x0
    addi x1, xzr, #10   // x1 = '\n'
    putchar x1          // print x1


    // Test inPlaceMerge Function
    lda x0, merge_arr_length // x1 = &merge_arr1_length
    ldur x0, [x0, #0]        // x0 = merge_arr1_length
    bl GetNextGap            // x0 = GetNextGap(merge_arr1_length)
    addi x2, x0, #0          // x2 = x0 = gap
    lda x0, merge_arr        // x0 = &merge_arr1
    lda x3, merge_arr_length // x3 = &merge_arr1_length
    ldur x3, [x3, #0]        // x3 = merge_arr1_length
    subi x3, x3, #1          // x3 = x3 - 1     to get the last element
    lsl x3, x3, #3           // x3 = x3 * 8 <- convert length to bytes
    add x1, x3, x0           // x1 = x3 + x0 <- x1 = &merge_arr1[0] + length in bytes
    bl inPlaceMerge          // inPlaceMerge(&merge_arr1[0], &merge_arr1[0] + length in bytes, gap)
    lda x0, merge_arr
    lda x1, merge_arr_length // x1 = &merge_arr1_length
    ldur x1, [x1, #0]        // x1 = list1_length
    bl printList             // print the merged list


    // Test MergeSort Function
    lda x0, arr1            // x0 = &merge_arr1
    lda x2, arr1_length     // x2 = &merge_arr1_length
    ldur x2, [x2, #0]       // x2 = merge_arr1_length
    subi x2, x2, #1         // x2 = x2 - 1     to get the last element
    lsl x2, x2, #3          // x2 = x2 * 8 <-- convert length to bytes
    add x1, x2, x0          // x1 = x2 + x0 <-- x1 = &merge_arr1[0] + length in bytes
    bl MergeSort            // inPlaceMerge(&merge_arr1[0], &merge_arr1[0] + length in bytes, gap)
    lda x1, arr1_length     // x1 = &list1_length
    ldur x1, [x1, #0]       // x1 = list1_length
    bl printList            // print the merged list


    // [BONUS QUESTION] Binary Search Extension
    // load the sorted array's start and end indices
    lda x0, arr1            // x0 = &merge_arr1
    lda x2, arr1_length     // x2 = &merge_arr1_length
    ldur x2, [x2, #0]       // x2 = merge_arr1_length
    subi x2, x2, #1         // x2 = x2 - 1     to get the last element
    lsl x2, x2, #3          // x2 = x2 * 8 <-- convert length to bytes
    add x1, x2, x0          // x1 = x2 + x0 <-- x1 = &merge_arr1[0] + length in bytes

    // Write your code here to check if each values of binary_search_queries are in the sorted array
    // You must loop through the binary_search_queries array and print 1 if the index is found else 0
    // Hint: use binary_search_query_length and binary_search_queries pointers to loop through the queries
    //       and preserve x0 and x1 values, ie. the starting and ending address which you need to pass
    //       in every function call)

    // [BONUS QUESTION] INSERT YOUR CODE HERE

    stop

////////////////////////
//                    //
//        Swap        //
//                    //
////////////////////////
Swap:
    // input:
    //     x0: the address of the first value
    //     x1: the address of the second value

    // INSERT YOUR CODE HERE
    //Callee responsibility
    SUBI SP, SP, #32	//subtract space for stack
	STUR FP, [SP, #0]	//store frame pointer of caller
	STUR LR, [SP, #8]	//store link register
	ADDI FP, SP, #24	//move frame pointer up

    //Loading data into register
    LDUR X9, [X0, #0]  //Load the first value into a temp register X9
    LDUR X10, [X1, #0] //Load the second value into temp register X10

    //Storing valule in register and store in memory
    STUR X10, [X0, #0] //Storing second value into address of first value
    STUR X9, [X1, #0]  //Storing first value into address of second value

    LDUR LR, [SP, #8]	//restore link register
	LDUR FP, [SP, #0]	//restore caller’s frame pointer
	ADDI SP, SP, #32	//restore stack pointer down
    br lr  //Return to caller

////////////////////////
//                    //
//     GetNextGap     //
//                    //
////////////////////////
GetNextGap:
    // input:
    //     x0: The previous value for gap

    // INSERT YOUR CODE HERE
    SUBIS XZR, X0, #1   //Generating flags if gap is less than or equal to 1
    B.GT GetNextGapELSE //Going to else if it's greater than
    ADDI X0, XZR, #0    //Return value of gap = 0 if less than 1
    B.endGetNextGap
    GetNextGapELSE:    
        ANDI X9, X0, #1 //Finding gap&1 and storing into temp register X9
        LSR X10, X0, #1 //gap/2 and storing into temp register X10
        ADD X0, X9, X10 //Setting gap value to gap/2 + gap&1 
endGetNextGap:
    br lr


////////////////////////
//                    //
//    inPlaceMerge    //
//                    //
////////////////////////
inPlaceMerge:
    // input:
    //    x0: The address of the starting element of the first sub-array.
    //    x1: The address of the last element of the second sub-array.
    //    x2: The gap used in comparisons for shell sorting

    // INSERT YOUR CODE HERE
    SUBI SP, SP, #40   //Creating 5 double words for stack
    STUR LR, [SP, #0]  //Storing the link register
    STUR FP, [SP, #8]  //Storing frame pointer
    STUR X0, [SP, #16] //Store address of starting element
    SUBI FP, FP, #32   //Move frame pointer

    SUBIS XZR, X2, 1  //Compare if gap is less than 1
    B.LE end          //Branch to return if less than or equal to 1
checkif:
    LSL X9, X2, #3    //Create the gap to add to address
    ADD X10, X0, X9   //Find right = left + gap index
    SUBS XZR, X10, X1 //Check if calculate left + gap <= end 
    B.LE loop
    
    BL.GetNextGap      //Find new gap
    MOV X2, X0         //Copy new gap from GetNextGap (returned in X0) to X2
    LDUR X0, [SP, #16] //Restore address for starting element
    
    BL.inPlaceMerge


loop:
    LDUR X11, [X0, #0]  //Load arry[left] into X11
    LDUR X12, [X10, #0] //Load arry[right] into X12
    SUBS XZR, X11, X12  //Checking if arry[left] > arry[right]
    ADDI X0, X0, #8     //Implement left++
   

end:
    LDUR LR, [SP, #0]  //restore the link register
    LDUR FP, [SP, #8]  //restore frame pointer
    ADDI SP, SP, #40   //pop stack
    br lr


////////////////////////
//                    //
//      MergeSort     //
//                    //
////////////////////////
MergeSort:
    // input:
    //     x0: The starting address of the array.
    //     x1: The ending address of the array

    // INSERT YOUR CODE HERE
    
    br lr

////////////////////////
//                    //
//      [BONUS]       //
//   Binary Search    //
//                    //
////////////////////////
BinarySearch:
    // input:
    //     x0: The starting address of the sorted array.
    //     x1: The ending address of the sorted array
    //     x2: The value to search for in the sorted array
    // output:
    //     x3: 1 if value is found, 0 if not found

    // INSERT YOUR CODE HERE

    br lr

////////////////////////
//                    //
//     printList      //
//                    //
////////////////////////

printList:
    // x0: start address
    // x1: length of array
    addi x3, xzr, #32       // x3 = ' '
    addi x4, xzr, #10       // x4 = '\n'
printList_loop:
    subis xzr, x1, #0       // if (x1 == 0) break
    b.eq printList_loopEnd  // break
    subi x1, x1, #1         // x1 = x1 - 1
    ldur x2, [x0, #0]       // x2 = x0->val
    putint x2               // print x2
    addi x0, x0, #8         // x0 = x0 + 8
    putchar x3              // print x3 ' '
    b printList_loop        // continue
printList_loopEnd:
    putchar x4              // print x4 '\n'
    br lr                   // return


////////////////////////
//                    //
//  helper functions  //
//                    //
////////////////////////
printSwapNumbers:
    lda x2, swap_test   // x0 = &swap_test
    ldur x0, [x2, #0]   // x1 = swap_test[0]
    ldur x1, [x2, #8]   // x2 = swap_test[1]
    addi x3, xzr, #32   // x3 = ' '
    addi x4, xzr, #10   // x4 = '\n'
    putint x0           // print x1
    putchar x3          // print ' '
    putint x1           // print x2
    putchar x4          // print '\n'
    br lr               // return
