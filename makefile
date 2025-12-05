TARGET	 = SurfBreak.nes
SOURCES  = src
INCLUDES = src
AS	 = wla-6502
ASFLAGS	 = -x
LD	 = wlalink
LDFLAGS	 = -S
LINKFILE = linkfile

SFILES	= $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
OFILES 	= $(patsubst %.s, %.o, $(wildcard $(SOURCES)/*.s))

.PHONY: default all clean
.PRECIOUS: $(TARGET) $(OFILES)


default: $(TARGET)
all: default

$(TARGET): $(OFILES)
	$(LD) $(LDFLAGS) $(LINKFILE) $@
	python sym2mlb.py SurfBreak.sym

%.o: %.s
	$(AS) $(ASFLAGS) -I $(INCLUDES) -o $@ $<

clean:
	-rm -f $(TARGET)
	-rm -f $(SOURCES)/*.o
	-rm -f *.sym
	-rm -f *.mlb
