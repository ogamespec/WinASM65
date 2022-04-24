del engine\*.o
del engine\*.o_Symbol.txt
del generated_Nes_Rom\*.nes
WinASM65 -l -m game.json -c rom_gen.json
pause