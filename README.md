# WinASM65

  Assembler for 6502 based systems
by CodewinBzn (Abdelghani BOUZIANE).


------------------------------
## Command line 

### Usage 

		WinASM65 [-option] sourcefile
		
### Options
		-m 			Assemble one or several segments
		-c 			Combine assembled segments/binary files
		
		
## Assemble segments

### JSON File format 
```
[
	{
		FileName: "path_to_main_file_seg1",
		Dependencies: ["path_to_main_file_seg2"]
	},
	{
		FileName: "path_to_main_file_seg2",
		Dependencies: ["path_to_main_file_seg1"]			
	},
	{
		FileName: "path_to_main_file_seg3",
		Dependencies: []			
	},
	......
]

```

### Dependencies
If a segment refers to labels, variables ... or to routines declared in other segments 
then it must mention them in this array as ["path_to_main_file_seg1", .....].


## Combine assembled segments / Binary files
### JSON File format:
```
{
	
	ObjectFile: "final_object_file",
	Files: 
	[
		{
			FileName: "path_to_seg1_object_file",
			Size: "$hex"
		},
		{
			FileName: "path_to_seg2_object_file",
			Size: "$hex"
		},
		{
			FileName: "path_to_seg3_object_file",			
		},
		....
	]
}
```

The Segments are declared in the order of their insertion in the final object file.

### Size
The size of the segment object file.
If the size of the assembled segment is less then the declared size then the assembler will 
fill the rest of bytes with the value $00 .


## Syntax

- Comments begin with a semicolon (;).
```
lda #$00 	; this is a comment
```

- Labels are declared in two ways. 

- before an instruction 
```
			ldx #$00
	label 	        lda $4000, x
			cpx #$10
			bne label
```			
- Alone in a line, A colon (:) following a label is mandatory
```
		ldx #$00
label:
	 	lda $4000, x
		cpx #$10
		bne label
```		

### Numbers
- Hexadecimal numbers begin with '$'.
- Binary numbers begin with '%'.

### Assembler directives

#### .ORG / .org

- Set the starting address of a segment.
- To use only once in each segment.
- To use only with hex numbers.
```
	.org $c000
lda #$00	
```

#### .MEMAREA / .memarea  .

- Set the starting address of a memory area for 
memory reservation (accepts expressions).

#### .RES / .res 
Reserve a number of bytes (accepts expressions).

```
	.memarea $00  ; zero page
player_posx  .res 1
player_pos_y .res 1

ram = $0400
	.memarea ram
nbr_ennemies = 15	
ennemies_pos_x .res nbr_ennemies  ; to store posx of ennemies  
ennemies_pos_y .res nbr_ennemies  ; to store posy of ennemies 
```

#### .INCBIN / .incbin
- Add the content of a binary file to the assembly output.
```
.incbin "path_to_binary_file"
```
#### .INCLUDE / .include
- Assemble another source file as if it were part of the current source.
```
.include "path_to_source_file"
```

#### .BYTE/.byte, .WORD/.word
- Emit byte(s) or word(s).
- Multiple arguments are separated by commas.
- Accept expressions.
```
RED = $06
palette:
.byte $00, $10, RED + 4, $5d
```

#### Strings
```
.byte "A", "B"
.byte "NES"
myString: 
	.byte "Hello World"
```
#### .IFDEF/.ifdef,  .IFNDEF/.ifndef
- Process a block of code if a symbol has been defined / not defined.
```
.ifdef _debug_
	.
	.
	.
.else 
	.
	.
	.
.endif

```
#### .MACRO/.macro
-  Define a macro.  Macro arguments are comma separated.
- .macro name args...
```
.macro add @a, @b
	clc 
	lda @a
	adc @b
.endmacro

red_color = $85
add #red_color, #$00	
```

### Expressions
```
 - <        Returns the low byte of a value (ex: <label).
 - >        Returns the high byte of a value (ex: >label).
 - #   	    Immidate addressing (ex: #label).
 - ()+-*/%  Arithmetic 
```
 
 ### Local lexical level
 ```
 .macro vblank label, register
	label: 
		BIT register
		BPL label
.endmacro
.
.
.
 { ; All new symbols from now on are in the local lexical level and are not accessible from outside.
   ; Symbols defined outside this local level may be accessed as long as their names are not used for new symbols inside the level.
   ; Macro names are always in the global level.
   
   vblank vblankwait, $2002
 }
 .
 .
 .
 {   
	vblank vblankwait, $2002   ; Second wait for vblank, PPU is ready after this
 }
 ```
 

 	


	
	






	






