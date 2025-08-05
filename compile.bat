wla-6502 -x -I src/ src/main.s
wla-6502 -x -I src/ src/graphics.s
wla-6502 -x -I src/ src/interrupts.s
wlalink -S -A linkfile SurfBreak.nes

pause