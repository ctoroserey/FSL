#!/bin/bash
# Claudio 6/20/15
# Add this file to the folder with the ROI files (in NIFTI), and change the directory to this folder. Remember to chmod a+x
# to run type "bash centroid_calc.sh"

printf "%s\t" ROI Cluster Voxels MAX MAX_X_mm MAX_Y_mm MAX_Z_mm COG_X_mm COG_Y_mm COG_Z_mm | awk '{print $0}' >> roi_centroids_${PWD##*/}.xls	# printf is for formatted printing, with t doing tabular separation into Excel, creating cells for each item. The '$0' awk function prints all items.

for filename in *.nii ; do  	# grabs all files with a nifti extension
	fname=`$FSLDIR/bin/remove_ext ${filename}`	# removes file extension
	echo $fname >> ROI_list.xls			# creates an Excel file with the roi list
	echo CLUSTER --in=${fname}.nii --thresh=0.00001 --mm
	CLUSTER --in=${fname}.nii --thresh=0.00001 --mm | awk '{ if (NR == 2) { print } }' >> results.xls	# FSL input based on fname. FSL outputs 2 rows onto Excel, so 'NR>1' filters out the first one, giving you just the numbers corresponding to the ROI. Since some ROI files contain 2 clusters, n==2 limits the row output to just the larger one.

done

paste ROI_list.xls results.xls >> roi_centroids_${PWD##*/}.xls	# combine tthe roi list and results into one spreadsheet

rm ROI_list.xls
rm results.xls
