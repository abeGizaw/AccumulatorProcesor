# Accumulator-Based Processor
4 Person Project  
## High-Level Description

This repository contains the design and implementation details of a custom accumulator-based processor architecture. Our processor features four accumulators to optimize instruction execution by reducing the number of operations that directly access memory, thereby enhancing performance by keeping track of more variables efficiently. Our design implements 32 instructions across six types and utilizes the stack for storing return addresses, accumulator registers, and arguments. A stack pointer is also utilized to save accumulator values before transferring control to another procedure.

The architecture is designed to balance the trade-off between cost and speed. By opting for a 4-accumulator design over a load/store or single accumulator architecture, we achieve a processor that is more cost-effective than load/store systems and faster than a single accumulator setup.

## Performance Measures

Performance is measured by assessing the combination of the speed and cost of the processor. The 4-accumulator architecture strikes a balance between these two factors, providing a cost-effective solution without significantly compromising on speed.

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

## Personal Contributions

As part of the project team, I had the opportunity to make significant contributions to both the design and implementation phases of our custom processor:

- **Assembler Development**: I single-handedly developed the assembler that translates assembly code into machine code. This involved writing the entire codebase from scratch, ensuring that it correctly parses, assembles, and outputs the correct binary or hexadecimal representations of the instructions.

- **Testing and Debugging**: I played a key role in the testing and debugging process, particularly within the Verilog components. My efforts were crucial in identifying and fixing issues, which helped stabilize and improve the overall functionality of the processor components.

- **Integration without Control**: Alongside a partner, I was instrumental in connecting all the components of the processor without the control unit. This step was vital in the incremental building and testing of the processor, laying a strong foundation for the addition of the control unit.

- **Final Processor Assembly**: I was deeply involved in the final assembly of the processor with the control unit, ensuring that all parts worked in unison and performed as expected.

- **Instruction Set Design**: My contributions to the design of the instruction set were pivotal. I led the initiative to design efficient instructions and made critical decisions that shaped our architecture, such as opting for a 4-accumulator setup to achieve an optimal balance between cost and performance.

These contributions were part of a collective effort to innovate and push the boundaries of what we can achieve with accumulator architecture in processor design.


