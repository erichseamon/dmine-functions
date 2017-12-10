cd /dmine/data/USDA/crop_indemnity_raster_commodity_plots
for file in *_plot; do
   sed '$ s/.$//' "$file"
done
