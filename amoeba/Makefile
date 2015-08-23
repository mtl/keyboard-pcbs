
project=amoeba

gerber_dir=gerber
export_dir=$(gerber_dir)/export

.PHONY: all clean export pristine

all: export

clean:
	-find . -type f -name "*~" -exec rm {} \;
	-find . -type f -name ".*.sw?" -exec rm {} \;

pristine: clean
	-find . -type f -name ".bak" -exec rm {} \;
	-find . -type f -name ".kicad_pcb-bak" -exec rm {} \;

export: \
	$(gerber_dir)/$(project)-B_Cu.gbl \
	$(gerber_dir)/$(project)-B_Mask.gbs \
	$(gerber_dir)/$(project)-B_SilkS.gbo \
	$(gerber_dir)/$(project)-Edge_Cuts.gbr \
	$(gerber_dir)/$(project)-F_Cu.gtl \
	$(gerber_dir)/$(project)-F_Mask.gts \
	$(gerber_dir)/$(project)-F_SilkS.gto \
	$(gerber_dir)/$(project)-NPTH.drl \
	$(gerber_dir)/$(project)-merged.drl
	-mkdir $(export_dir)
	cp $(gerber_dir)/$(project)-B_Cu.gbl $(export_dir)/$(project).gbl
	cp $(gerber_dir)/$(project)-B_Mask.gbs $(export_dir)/$(project).gbs
	cp $(gerber_dir)/$(project)-B_SilkS.gbo $(export_dir)/$(project).gbo
	cp $(gerber_dir)/$(project)-Edge_Cuts.gbr $(export_dir)/$(project).gbr
	cp $(gerber_dir)/$(project)-F_Cu.gtl $(export_dir)/$(project).gtl
	cp $(gerber_dir)/$(project)-F_Mask.gts $(export_dir)/$(project).gts
	cp $(gerber_dir)/$(project)-F_SilkS.gto $(export_dir)/$(project).gto
	cp $(gerber_dir)/$(project)-merged.drl $(export_dir)/$(project).drl
	zip -j $(project).zip \
		$(export_dir)/$(project).gbl \
		$(export_dir)/$(project).gbs \
		$(export_dir)/$(project).gbo \
		$(export_dir)/$(project).gbr \
		$(export_dir)/$(project).gtl \
		$(export_dir)/$(project).gts \
		$(export_dir)/$(project).gto \
		$(export_dir)/$(project).drl
	rm -r $(export_dir)

$(gerber_dir)/$(project)-merged.drl: \
	$(gerber_dir)/$(project).drl \
	$(gerber_dir)/$(project)-NPTH.drl
	gerbv -x drill -o $@ $^


# vi: set sts=4 sw=4 ts=4:
