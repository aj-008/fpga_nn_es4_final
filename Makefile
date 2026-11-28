# THIS IS FOR A TANG NANO 20K NOT AN UPDUINO
# CHANGE THE DEVICE/FAMILY/BOARD/CST TO US
TOP     := top
DEVICE  := GW2AR-LV18QN88C8/I7
FAMILY  := GW2A-18C
BOARD   := tangnano20k
CST     := constraints/tangnano20k.cst

BUILD   := build
SRCS    := $(shell find rtl -name '*.sv')

YOSYS   ?= yosys
NEXTPNR ?= nextpnr-himbaechel

all: $(BUILD)/$(TOP).fs

$(BUILD):
	mkdir -p $@

$(BUILD)/$(TOP).json: $(SRCS) | $(BUILD)
	$(YOSYS) -q -l $(BUILD)/yosys.log \
	  -p "read_verilog -sv $(SRCS); synth_gowin -top $(TOP) -json $@"

$(BUILD)/$(TOP)_pnr.json: $(BUILD)/$(TOP).json $(CST)
	$(NEXTPNR) -q -l $(BUILD)/nextpnr.log --json $< --write $@ \
	  --device $(DEVICE) --vopt family=$(FAMILY) --vopt cst=$(CST)

$(BUILD)/$(TOP).fs: $(BUILD)/$(TOP)_pnr.json
	gowin_pack -d $(FAMILY) -o $@ $<

load: $(BUILD)/$(TOP).fs
	openFPGALoader -b $(BOARD) $<

flash: $(BUILD)/$(TOP).fs
	openFPGALoader -b $(BOARD) -f $<

clean:
	rm -rf $(BUILD)

.PHONY: all load flash clean
