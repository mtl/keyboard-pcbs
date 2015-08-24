
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

target=$(current_dir)

gerber_dir=gerber
export_dir=$(gerber_dir)/export
zip=zip -j

.PHONY: all clean export pristine

all: $(target).zip

clean:
	-find . -type f -name "*~" -exec rm {} \;
	-find . -type f -name ".*.sw?" -exec rm {} \;

pristine: clean
	-find . -type f -name ".bak" -exec rm {} \;
	-find . -type f -name ".kicad_pcb-bak" -exec rm {} \;

export: $(target).zip

$(gerber_dir)/$(target)-merged.drl: \
	$(gerber_dir)/$(target).drl \
	$(gerber_dir)/$(target)-NPTH.drl
	gerbv -x drill -o $@ $^

$(target).zip: \
	$(gerber_dir)/$(target)-B_Cu.gbl \
	$(gerber_dir)/$(target)-B_Mask.gbs \
	$(gerber_dir)/$(target)-B_SilkS.gbo \
	$(gerber_dir)/$(target)-Edge_Cuts.gbr \
	$(gerber_dir)/$(target)-F_Cu.gtl \
	$(gerber_dir)/$(target)-F_Mask.gts \
	$(gerber_dir)/$(target)-F_SilkS.gto \
	$(gerber_dir)/$(target)-NPTH.drl \
	$(gerber_dir)/$(target)-merged.drl
	-mkdir $(export_dir)
	cp $(gerber_dir)/$(target)-B_Cu.gbl $(export_dir)/$(target).gbl
	cp $(gerber_dir)/$(target)-B_Mask.gbs $(export_dir)/$(target).gbs
	cp $(gerber_dir)/$(target)-B_SilkS.gbo $(export_dir)/$(target).gbo
	cp $(gerber_dir)/$(target)-Edge_Cuts.gbr $(export_dir)/$(target).gbr
	cp $(gerber_dir)/$(target)-F_Cu.gtl $(export_dir)/$(target).gtl
	cp $(gerber_dir)/$(target)-F_Mask.gts $(export_dir)/$(target).gts
	cp $(gerber_dir)/$(target)-F_SilkS.gto $(export_dir)/$(target).gto
	mv $(gerber_dir)/$(target)-merged.drl $(export_dir)/$(target).drl
	-rm $@
	$(zip) $@ \
		$(export_dir)/$(target).gbl \
		$(export_dir)/$(target).gbs \
		$(export_dir)/$(target).gbo \
		$(export_dir)/$(target).gbr \
		$(export_dir)/$(target).gtl \
		$(export_dir)/$(target).gts \
		$(export_dir)/$(target).gto \
		$(export_dir)/$(target).drl
	rm -r $(export_dir)


# vi: set sts=4 sw=4 ts=4:
