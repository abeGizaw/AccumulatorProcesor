## Assembler Usage

To assemble your assembly code into machine code, follow these instructions:

1. Run the assembler from the command line.
2. When prompted, enter the absolute path to your assembly file.
3. Specify the output format:
   - Enter 'E' for Excel or 'T' for text file output.
4. Choose whether you want a detailed output:
   - Enter 'Y' for a detailed output, which includes addresses, in-line comments, and spacing.
   - Enter 'N' for a strict binary/hex output without additional details.
5. Choose the value representation:
   - Enter 'H' for hexadecimal values.
   - Enter 'B' for binary values.  
     
The assembler will then process the assembly file and output the machine code in the desired format onto the same file provided.

## Example

### TXT
```
RP:
    loadsp r0 0
    set r1 2
    set r2 1
SU:
    movesp -4
    storesp r0 0
    storesp r1 2
    jal GCD
    movesp 4
    beq r2 r3 finish
    addi r1 1
    beq r1 r1 SU
finish:
    swap r1 r3
    jb 0
GCD:
    loadsp r0 0
    loadsp r1 2
    set r2 0
    bne r0 r2 continue
    swap r1 r3
    jb 0
continue:
    beq r1 r2 done
    blt r1 r0 ChangeA
    alter r1 r1 r0 -
    beq r1 r1 continue
ChangeA:
    alter r0 r0 r1 -
    beq r0 r0 continue
done:
    swap r0 r3
    jb 0
```  

### Prompt
```
Excel or txt?(E,T) T
Enter the absolute path to the assembly file: C:\Path\To\Your\File.txt
Do you want a detailed output (addresses, in-line comments, spacing)? (Y/N) Y
Do you want values in hex or Binary? (H/B) B 
```

### Output
```
RP:
    loadsp r0 0
    set r1 2
    set r2 1
SU:
    movesp -4
    storesp r0 0
    storesp r1 2
    jal GCD
    movesp 4
    beq r2 r3 finish
    addi r1 1
    beq r1 r1 SU
finish:
    swap r1 r3
    jb 0
GCD:
    loadsp r0 0
    loadsp r1 2
    set r2 0
    bne r0 r2 continue
    swap r1 r3
    jb 0
continue:
    beq r1 r2 done
    blt r1 r0 ChangeA
    alter r1 r1 r0 -
    beq r1 r1 continue
ChangeA:
    alter r0 r0 r1 -
    beq r0 r0 continue
done:
    swap r0 r3
    jb 0

Binary:
RP:                       ~  3           0x0  
000000000 00 11000        ~  16           0x0  
000000010 01 00110        ~  16           0x2  
000000001 10 00110        ~  16           0x4  
SU:                       ~  3           0x6  
11111111100 11001         ~  16           0x6  
000000000 00 10111        ~  16           0x8  
000000010 01 10111        ~  16           0xa  
00000000110 10100         ~  16           0xc  
00000000100 11001         ~  16           0xe  
0000010 11 10 10000       ~  16           0x10  
000000001 01 01011        ~  16           0x12  
1111000 01 01 10000       ~  16           0x14  
finish:                   ~  7           0x16  
0000000 11 01 11101       ~  16           0x16  
00000000000 11100         ~  16           0x18  
GCD:                      ~  4           0x1a  
000000000 00 11000        ~  16           0x1a  
000000010 01 11000        ~  16           0x1c  
000000000 10 00110        ~  16           0x1e  
0000010 10 00 10001       ~  16           0x20  
0000000 11 01 11101       ~  16           0x22  
00000000000 11100         ~  16           0x24  
continue:                 ~  9           0x26  
0000101 10 01 10000       ~  16           0x26  
0000010 00 01 10010       ~  16           0x28  
00001 01 00 01 11110      ~  16           0x2a  
1111100 01 01 10000       ~  16           0x2c  
ChangeA:                  ~  8           0x2e  
00001 00 01 00 11110      ~  16           0x2e  
1111010 00 00 10000       ~  16           0x30  
done:                     ~  5           0x32  
0000000 11 00 11101       ~  16           0x32  
00000000000 11100         ~  16           0x34
```
