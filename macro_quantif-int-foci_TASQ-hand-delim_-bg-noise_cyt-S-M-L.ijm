///////////////////////////// Entry of quantification features /////////////////////////////
Dialog.create("!!!Warning!!!");
Dialog.addMessage("Please, make sure : \n- There are no spaces in the folder or file name!\n- \"Bio-formats\", \"Adjustable Watershed\" and \"3D object counter\" plugins are installed!\n- 8-bit Images are calibrated (in µm)");
Dialog.show();

Dialog.create("!!!Before using macro!!!");
Dialog.addMessage("You have to set several parameters before using the macro:\n");
Dialog.addMessage(" - DAPI threshold on AVG-z-projection (with Triangle),");//segmentation of nuclei with triangle threshold
Dialog.addMessage(" - DAPI adjustable watershed to separate nuclei,");//Adjustable watershed is able to separate badly segmented nuclei
Dialog.addMessage(" - Size of nucleus (min and max, in µm),");//size selection of nucleus
Dialog.addMessage(" - DAPI threshold on z-sliced image (with Intermodes),");//segmentation of nuclei with Otsu threshold
Dialog.addMessage(" - TASQ threshold on z-sliced image for nucleolus determination (with Yen),");//size selection of nucleus
Dialog.addMessage("- If cytoplasm analysis needed: \n* !!! MANUAL SEGMENTATION !!!");//segmentation of cytoplasm
Dialog.addMessage("- If foci determination needed: \n* TASQ threshold (with Triangle), \n* TASQ foci cut-off size (in voxel, corresponding to nucleoli staining).");//segmentation of TASQ foci with Yen threshold
Dialog.show();



///////// Selection of channel parameters
Dialog.create("Enter channels parameters");
Dialog.addNumber("DAPI channel number", 1);///value assignment for DAPI channel number
Dialog.addNumber("TASQ channel number", 2);///value assignment for TASQ channel number
Dialog.show();

Cdapi=Dialog.getNumber();///value assignment for DAPI channel number
Cgreen=Dialog.getNumber();///value assignment for TASQ channel number



///////// Define analysis to process
Dialog.create("Define which analysis to process");
Dialog.addMessage("Define which analysis to process (you can do both intensity and foci analysis):\n(Keep in mind that segmentation of cytoplasm is harder to do than one of nucleus, it has to be done manually)");
Dialog.addCheckbox("Intensity analysis within nucleus and cytoplasm ", false);
Dialog.addCheckbox("Foci analysis within nucleus and cytoplasm ", false);
Dialog.addMessage("");
Dialog.addCheckbox("Intensity analysis within nucleus ", false);
Dialog.addCheckbox("Foci analysis within nucleus ", false);
Dialog.show();

IntC=Dialog.getCheckbox();
FociC=Dialog.getCheckbox();
Int=Dialog.getCheckbox();
Foci=Dialog.getCheckbox();




///////// Entry of quantification parameters 
Dialog.create("Enter quantification parameters");
	Dialog.addMessage("Parameters common for all analyses:\n ");
	Dialog.addNumber("z-DAPI Intermodes threshold", 21);///value assignment for zts
	Dialog.addNumber("mask-z-DAPI watershed", 2);///value assignment for ws2
	Dialog.addNumber("min. size of nucleus (µm)", 60);///value assignment for nmin
	Dialog.addNumber("max. size of nucleus (µm)", 420);///value assignment for nmax
	Dialog.addNumber("Min. Voxel volume of nuclei", 5000);///value assignment for vnucleus
	Dialog.addNumber("Min. Voxel volume of nucleoli", 50);///value assignment for vnucleolus	
if(Int || Foci){
	Dialog.addMessage("Parameters for automatic segmentation of nuclei:\n ");
	Dialog.addNumber("AVG-DAPI Triangle threshold", 12);///value assignment for dts
	Dialog.addNumber("AVG-DAPI watershed", 2);///value assignment for ws
}
if(Int || IntC){
	Dialog.addMessage("Parameters for nuclear foci analysis:\n ");
	Dialog.addNumber("z-TASQ for nucleolus Yen threshold", 70);///value assignment for nts
}
if(Foci || FociC){
	if(Foci){Dialog.addMessage("Parameters for nuclear foci analysis:\n ");}
	if(FociC){Dialog.addMessage("Parameters for nuclear and cytoplasmic foci analysis:\n ");}
	Dialog.addNumber("TASQ background substraction (radius of filter mean)", 10);///value assignment for background substraction r
	Dialog.addNumber("TASQ Triangle threshold for foci", 9);///value assignment for gts
	Dialog.addNumber("TASQ foci cut-off size (to exclude nucleoli, in voxels)", 50);///value assignment for cot
}
Dialog.show();



	zts=Dialog.getNumber();///value of zDAPI threshold
	ws2=Dialog.getNumber();///value of zDAPI watershed 
	nmin=Dialog.getNumber();///value of size of nucleus (min)
	nmax=Dialog.getNumber();///value of size of nucleus (max)
	vnucleus=Dialog.getNumber();///value of minimal voxel volume of nucleus
	vnucleolus=Dialog.getNumber();///value of minimal voxel volume of nucleolus
if(Int || Foci){
	dts=Dialog.getNumber();///value of AVG-DAPI threshold
	ws=Dialog.getNumber();///value of AVG-DAPI watershed 
}
if(Int || IntC){
	nts=Dialog.getNumber();///value of zTASQ threshold for nucleoli segmentation
}
if(Foci || FociC){
	r=Dialog.getNumber();///value of radius for background substraction
	gts=Dialog.getNumber();///value of TASQ threshold
	cot=Dialog.getNumber();///value of cut-off TASQ
}




function sameParameters() { 
// allow to repeat over and over with same parameters


///////// Define directories
Dialog.create("Define directory to open images");
Dialog.addMessage("Choose directory to open images");
Dialog.show();
open_directory=getDirectory("Choose directory to open images");

Dialog.create("Define save directory for files");
Dialog.addMessage("Choose save directory for files");
Dialog.show();
save_directory=getDirectory("Choose save directory for files");

Dialog.create("Define save directory for images");
Dialog.addMessage("Choose save directory for images");
Dialog.show();
saveIMG_directory=getDirectory("Choose save directory for images");


///////// Selection of images to process
Dialog.create("Enter the name of images and the number of images to process");
Dialog.addString("Enter the name of images: ", "name");//images from the same condition should have the same name
Dialog.addMessage("type extension of file (.tif, .lif, .vsi, .(...)),");
Dialog.addString("extension: ", ".tif");//name of extension
Dialog.addMessage("the number following the name of images to process,");
Dialog.addNumber("start: ", 1);//number of images with the same name
Dialog.addNumber("stop: ", 1);//number of images with the same name

Dialog.show();

name= Dialog.getString();
ext= Dialog.getString();
Start=Dialog.getNumber();
Stop=Dialog.getNumber();


///////// Print of all parameters 
print("macro_quantif-int-foci_TASQ-hand-delim.ijm");
print("Name:", name);
print("Extension:", ext);
print("start:"+Start, "stop:"+Stop);
print("Channels of cells:", "Channel DAPI: "+Cdapi, "Channel TASQ: "+Cgreen);
//Type of analysis
if(IntC && FociC){
	print("Type of analysis: cytoplasmic and nuclear Intensity and Foci");}
else if(Int && Foci){
	print("Type of analysis: nuclear Intensity and Foci");}
else if (Int) {
	print("Type of analysis: nuclear Intensity");} 
else if(IntC){
	print("Type of analysis: cytoplasmic and nuclear Intensity");} 
else if(Foci){
	print("Type of analysis: small and large nuclear Foci");} 
else if(FociC) {
	print("Type of analysis: cytoplasmic and small and large nuclear Foci");}
if(Int || Foci){
print("AVG-projected DAPI Triangle threshold:", dts);
print("AVG-DAPI watershed #2:", ws);
}
print("Size of nucleus:", nmin+"-"+nmax);
print("z-DAPI MaxEntropy threshold:", zts);
print("z-DAPI adjustable watershed:", ws2);
print("Min. Voxel volume of nuclei:", vnucleus);
print("Min. Voxel volume of nucleoli:", vnucleolus);
if(Int || IntC){
print("z-TASQ nucleoli Intermodes threshold:", nts);
}
if(Foci || FociC){
print("radius of mean filter for TASQ backgound substraction:", r);
print("TASQ Triangle threshold for foci:", gts);
print("TASQ foci cut-off size:", cot);
}



//Closing just in case...
if (isOpen("ROI Manager")) {
     selectWindow("ROI Manager");
     run("Close");
  }//close ROI Manager if open from previous session
if (isOpen("Results")) {
     selectWindow("Results");
     run("Close");
  }//close ROI Manager if open from previous session
  



///////////////////////////// Loop generation for quantification /////////////////////////////
for (k=Start; k<=Stop; k++){
number=k;
img=name+number+ext;//image name, number and extension
path_img=open_directory+img;//path to open images

img_save=name+number+".tif";
path_img_save=saveIMG_directory+name+number+".tif";//save path for TIF image with all channels

if (Int || IntC){
	table=name+number+"_quantif-intensity";
	Table.create(table);
}

if (Foci || FociC){
	tableF=name+number+"_quantif-foci";
	Table.create(tableF);
}

roiManager("reset");

///////// Renaming and reslicing images determination
setForegroundColor(0, 0, 0);
setBackgroundColor(255, 255, 255);
run("Bio-Formats Importer", "open="+path_img+" color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
Stack.setPosition(Cdapi,11,1);
run("Channels Tool...");
run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
beep();
    title = "You can select z-stacks without blurring";
    msg = "Keep in mind lowest and highest z-values in focal plane, \nafter clicking \"OK\" a new box to enter these values will appear.\n(You can open \"Channels tool\" to see only DAPI staining)";
    waitForUser(title, msg);
//Selection of slices
s=getSliceNumber();
Dialog.create("Enter z-min and z-max for this image");
Dialog.addNumber("z min", 1);
Dialog.addNumber("z max: ", s);
Dialog.show();
zmin=Dialog.getNumber();
zmax=Dialog.getNumber();
bs=(zmin+zmax)/2;//important to estimate background with image
print("lowest z for img #"+number+":", zmin);
print("highest z for img #"+number+":", zmax);
saveAs("Tiff", path_img_save);


///////// TASQ Background estimation
Stack.setPosition(Cgreen,bs,1);
run("Duplicate...", "title=background.TIF");
setTool("rectangle");
b=3;
	for(a=0; a<b; a++) {
	makeRectangle(0, 0, 100, 100);
	beep();
    	title2 = "Selection of a zone for TASQ background detection";
    	msg2 = "Move rectangle to a zone without any cells (therefore without any TASQ staining)\nand then click on \"OK\" \n(If you have changed brightness and contrast be careful to not apply changes) \n(It is better if you keep the same slice for selection of background) \n \nYou have to do this three times";
    waitForUser(title2, msg2);
    roiManager("Add");
	run("Measure");
	selectWindow("Results");
	Background=getResult("Mean", a);
	print("TASQ-background value for img #"+number+"_zone"+a+1+":", Background);
	}
	run("Summarize");
	selectWindow("Results");
	bn=nResults();
			for(i=0; i<bn; i++) {
    			Label=getResultString("Label", i);
    			if(Label=="Mean"){
    			Bmean=getResult("Mean", i);}
    			}
	print("background value to be substracted for img #"+number+":", Bmean);
	selectWindow("background.TIF");
	run("RGB Color");
	selectWindow("background.TIF");
	close("background.TIF");
	selectWindow("background.TIF (RGB)");
	setForegroundColor(255, 255, 255);
	setBackgroundColor(0, 0, 0);
	run("Select None");
	roiManager("Show All with labels");
	roiManager("Select", newArray(0,1,2));
	roiManager("Set Color", "white");
	roiManager("Set Line Width", 4);
	roiManager("Draw");
	selectWindow("background.TIF (RGB)");
	saveAs("Tiff", saveIMG_directory+name+"background_"+number+".tif");
	close();
	roiManager("Deselect");
	roiManager("Delete");
	run("Select None");

    //Selection of background value
Dialog.create("Enter mean background value for this image");
Dialog.addNumber("background value", Bmean);
Dialog.show();
Bmeans=Dialog.getNumber();
print("selected background value for img #"+number+":", Bmeans);
setForegroundColor(0, 0, 0);
setBackgroundColor(255, 255, 255);
//end of background determination


///////// Splitting of channel in between determined slices
selectImage(img_save);
run("Duplicate...", "title=DAPI_"+number+".TIF duplicate channels="+Cdapi+" slices="+zmin+"-"+zmax);
selectImage(img_save);
run("Duplicate...", "title=TASQ_"+number+".TIF duplicate channels="+Cgreen+" slices="+zmin+"-"+zmax);
selectImage(img_save);
if (IntC || FociC) {
	run("Duplicate...", "title=cytoplasm.TIF duplicate slices="+zmin+"-"+zmax);
}
close(img_save);


///////// Manual thresholding of cytoplasm with TASQ image
if (IntC || FociC) {
///Boolean for manual segmentation or re-use of saved ROI
useroi= getBoolean("Have you already selected ROI for cytoplasm determination?\nYES: Manual segmentation should already be saved as .zip \nNO: Manual segmentation has to be done");
if (useroi==1){
	selectWindow("TASQ_"+number+".TIF");
	roiManager("Open", save_directory+name+number+"_RoiSet-cyto.zip");
	roiManager("Show All with labels");
	}//end of loop for reuse
	
else if (useroi==0) {
	selectWindow("cytoplasm.TIF");
	run("Z Project...", "projection=[Max Intensity]");
	rename("MAX-cyto_"+number+".TIF");
	close("cytoplasm.TIF");
	selectWindow("MAX-cyto_"+number+".TIF");
	run("Enhance Contrast", "saturated=0.35");
	run("Enhance Contrast", "saturated=0.35");
	run("Enhance Contrast", "saturated=0.35");
	setTool("polygon");
	for(s=0; s<50; s++) {
		sl=50-s;
	    	title3 = "Selection of 50 cells per image";
	    	msg3 = "Do manual segmentation of cells (with cytoplasm)\nand then click on \"OK\"\n(This have to be done 50 times in total, this will be long)\n \nCells to be segmented:"+sl+"";
	    selectWindow("MAX-cyto_"+number+".TIF");
	    waitForUser(title3, msg3);
	    roiManager("Add");
	    roiManager("Show All with labels");
		}
	roiManager("Select", newArray(0,1));
	run("Select All");
	roiManager("Save", save_directory+name+number+"_RoiSet-cyto.zip");
	
			// Save of ROI determination images	
			selectImage("MAX-cyto_"+number+".TIF");
			saveAs("Tiff", saveIMG_directory+name+"Cyto-zproj_"+number+".tif");
			close();
}//end of loop for manual segmentation

}//end of loop for ROI selection of cytoplasm


///////// Thresholding nuclear DAPI staining
if(Int || Foci){	
	// Z-projection of nucleus and selection of ROI
	selectWindow("DAPI_"+number+".TIF");
	run("Z Project...", "projection=[Average Intensity]");
	rename("AVG-DAPI_"+number+".TIF");
	run("Smooth");
	setAutoThreshold("Triangle dark");
	setThreshold(dts, 255);
	run("Convert to Mask");
	run("Close-");
	run("Fill Holes");
	run("Erode");
	run("Dilate");
	run("Dilate");
	run("Adjustable Watershed", "tolerance="+ws);
	run("Analyze Particles...", "size="+nmin+"-"+nmax+" show=Nothing exclude clear add");
	
roiManager("Select", newArray(0,1));
run("Select All");
roiManager("Save", save_directory+name+number+"RoiSet-nuc.zip");

		// Save of ROI determination images	
		selectImage("AVG-DAPI_"+number+".TIF");
		saveAs("Tiff", saveIMG_directory+name+"DAPI-zproj_"+number+".tif");
		close();
}//end of loop for ROI selection of nuclei only


///////// Quantification for each ROI
// Background noise removal
	selectWindow("TASQ_"+number+".TIF");	
	run("Subtract...", "value="+Bmeans+" stack");
	
	setBatchMode(true);
	
for(c=0;c<roiManager("count");c++){
	setForegroundColor(255, 255, 255);
	setBackgroundColor(0, 0, 0);
		
	// Duplicate of DAPI
		selectWindow("DAPI_"+number+".TIF");
		roiManager("Select",c);//selection from ROI manager
		run("Duplicate...", "title=raw-DAPI_"+c+1+"/"+number+".TIF duplicate range=stack");//duplication of ROI
		run("Clear Outside", "stack");//clear outside the ROI
		run("Smooth", "stack");
		run("Duplicate...", "title=DAPI_"+c+1+"/"+number+".TIF duplicate range=stack");//duplication of ROI
		setSlice(1);
		setAutoThreshold("MaxEntropy dark");
		getThreshold(lower1, upper1);
		t1=lower1;
		setSlice(5);
		setAutoThreshold("MaxEntropy dark");
		getThreshold(lower2, upper2);
		t2=lower2;
		if(t1>=t2) {
			lower=t2;
		}
		else if(t2>t1) {
			lower=t1;
		}
		
		if (lower>0.5*zts && lower<2*zts) {
		setOption("BlackBackground", false);//detection of coloured element over a dark background
		setThreshold(lower, 255);//gts is value determined to select gH2AX signal
		}
		else {
		setOption("BlackBackground", false);//detection of coloured element over a dark background
		setThreshold(zts, 255);//gts is value determined to select gH2AX signal
		}
		
		run("Convert to Mask", "method=MaxEntropy background=Dark");
		run("Dilate", "stack");
		run("Close-", "stack");
		run("Fill Holes", "stack");
		run("Erode", "stack");
		run("Adjustable Watershed", "tolerance="+ws2+" stack");
		run("Analyze Particles...", "size="+nmin+"-"+nmax+" show=Masks stack");
		selectWindow("Mask of DAPI_"+c+1+"/"+number+".TIF");
		rename("Mask-DAPI_"+c+1+"/"+number+".TIF");
		close("DAPI_"+c+1+"/"+number+".TIF");

	// Duplicate of TASQ
		selectWindow("TASQ_"+number+".TIF");
		roiManager("Select",c);//selection of nucleus from ROI manager
		run("Duplicate...", "title=TASQ_"+c+1+"/"+number+".TIF duplicate range=stack");//duplication of ROI
		run("Clear Outside", "stack");//clear outside the ROI
		
	//Thresholding of nucleoli with TASQ staining
		if(Int || IntC){
		selectWindow("TASQ_"+c+1+"/"+number+".TIF");
		run("Duplicate...", "title=Mask-nucleoli_"+c+1+"/"+number+".TIF duplicate range=stack");//creation of mask for nucleoli
		run("Smooth", "stack");
		setAutoThreshold("Intermodes dark");
		ncts=nts;
		setThreshold(ncts, 255);
		run("Convert to Mask", "method=Intermodes background=Dark");
		imageCalculator("AND stack", "Mask-nucleoli_"+c+1+"/"+number+".TIF","Mask-DAPI_"+c+1+"/"+number+".TIF");
		//creation of DAPI without nucleoli mask
		selectWindow("Mask-DAPI_"+c+1+"/"+number+".TIF");
		run("Duplicate...", "title=Mask-DAPI-wo-nucleoli_"+c+1+"/"+number+".TIF duplicate range=stack");
		imageCalculator("Subtract stack", "Mask-DAPI-wo-nucleoli_"+c+1+"/"+number+".TIF","Mask-nucleoli_"+c+1+"/"+number+".TIF");
		}//end of loop for mask creation for nucleoli and nuclei without nucleoli
		
	//Selecting cytoplasmic TASQ staining only
		if(IntC){
		selectWindow("TASQ_"+c+1+"/"+number+".TIF");
		run("Duplicate...", "title=cytoplasm_"+c+1+"/"+number+".TIF duplicate range=stack");//creation of mask for nucleoli
		imageCalculator("Subtract stack", "cytoplasm_"+c+1+"/"+number+".TIF","Mask-DAPI_"+c+1+"/"+number+".TIF");
		}
		
	///////// Background removal of TASQ staining and creation of foci masks
		if(Foci || FociC){
	// Creation of blurred TASQ image
		selectWindow("TASQ_"+c+1+"/"+number+".TIF");
		run("Duplicate...", "title=blurred-TASQ_"+c+1+"/"+number+".TIF duplicate range=stack");
		run("Mean...", "radius="+r+" stack");
		selectWindow("TASQ_"+c+1+"/"+number+".TIF");
		run("Duplicate...", "title=foci-TASQ_"+c+1+"/"+number+".TIF duplicate range=stack");
		imageCalculator("Subtract stack", "foci-TASQ_"+c+1+"/"+number+".TIF","blurred-TASQ_"+c+1+"/"+number+".TIF");
		selectWindow("blurred-TASQ_"+c+1+"/"+number+".TIF");
		close();
	// Thresholding and converting to mask
		selectWindow("foci-TASQ_"+c+1+"/"+number+".TIF");
		run("Smooth", "stack");
		setAutoThreshold("Triangle dark");
		setThreshold(gts, 255);
		run("Convert to Mask", "method=Triangle background=Dark");
	// Creation of nuclear mask for foci detectermination
		selectWindow("foci-TASQ_"+c+1+"/"+number+".TIF");
		run("Duplicate...", "title=nuclear-foci-TASQ_"+c+1+"/"+number+".TIF duplicate range=stack");
		imageCalculator("AND stack", "nuclear-foci-TASQ_"+c+1+"/"+number+".TIF","Mask-DAPI_"+c+1+"/"+number+".TIF");
	
	if(FociC){
	// Creation of nuclear mask for foci detectermination
		selectWindow("foci-TASQ_"+c+1+"/"+number+".TIF");
		run("Duplicate...", "title=cyto-foci-TASQ_"+c+1+"/"+number+".TIF duplicate range=stack");
		imageCalculator("Subtract stack", "cyto-foci-TASQ_"+c+1+"/"+number+".TIF","Mask-DAPI_"+c+1+"/"+number+".TIF");
	}//end of loop for cytoplasmic foci
	
		// Save of ROI determination images	
		selectWindow("foci-TASQ_"+c+1+"/"+number+".TIF");
		saveAs("Tiff", saveIMG_directory+name+"foci-TASQ_"+number+"_"+c+1+".tif");
		close();
	}//end of loop for foci segmentation



	
// Loop to quantify signals
	/// Quantification of DAPI intensity
	run("3D OC Options", "volume nb_of_obj._voxels integrated_density mean_gray_value std_dev_gray_value dots_size=5 font_size=10 redirect_to=raw-DAPI_"+c+1+"/"+number+".TIF");
	run("Clear Results");
		selectWindow("Mask-DAPI_"+c+1+"/"+number+".TIF");
		run("3D Objects Counter", "threshold=0 slice=1 min.="+vnucleus+" max.=2000000 objects statistics");
		selectWindow("Results");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
		dn=nResults();
			//Getting mean and sd results
			if(dn==0){
				d=dn;
				dFI="0";
				dVol="0";
				sddFI="0";
    			sddVol="0";
			}//end of loop for none result
			if(dn==1){
				d=dn;
				dFI=getResult("IntDen", 0);
				dVol=getResult("Volume (micron^3)", 0);
				sddFI="0";
    			sddVol="0";
			}//end of loop for results n=1
			if(dn>1) {
			for(j=0; j<dn; j++) {
    			Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			dFI=getResult("IntDen", j);
    			dVol=getResult("Volume (micron^3)", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sddFI=getResult("IntDen", j);
    			sddVol=getResult("Volume (micron^3)", j);
    			}//end of loop for sd results
    			}//end of loop to get results
    		d=dn-4;}//end of loop for n results
    		
    	//Update table with nucleus results
		if(Int || IntC){
			Table.set("img", c, number, table);
			Table.set("cell", c, c+1, table);
			Table.set("number of nuclei", c, d, table);
			Table.set("mean volume nuclei (um^3)", c, dVol, table);
			Table.set("sd volume nuclei (um^3)", c, sddVol, table);
			Table.set("Mean nuclear DAPI", c, dFI, table);
			Table.set("sd mean nuclear DAPI", c, sddFI, table);
			Table.update(table);
		}
		
		if(Foci || FociC){
			Table.set("img", c, number, tableF);
			Table.set("cell", c, c+1, tableF);
			Table.set("number of nuclei", c, d, tableF);
			Table.set("mean volume nuclei (um^3)", c, dVol, tableF);
			Table.set("sd volume nuclei (um^3)", c, sddVol, tableF);
			Table.set("Mean nuclear DAPI", c, dFI, tableF);
			Table.set("sd mean nuclear DAPI", c, sddFI, tableF);
			Table.update(tableF);
		}
		
			run("Clear Results");
			close("Objects map of Mask-DAPI_"+c+1+"/"+number+".TIF redirect to raw-DAPI_"+c+1+"/"+number+".TIF");

			

if(Int || IntC){
	/// Loop to quantify intensity of TASQ
		run("3D OC Options", "volume nb_of_obj._voxels mean_gray_value std_dev_gray_value dots_size=5 font_size=10 redirect_to=TASQ_"+c+1+"/"+number+".TIF");
		
		/// within nucleus
		run("Clear Results");
		selectWindow("Mask-DAPI_"+c+1+"/"+number+".TIF");
		run("3D Objects Counter", "threshold=0 slice=1 min.="+vnucleus+" max.=2000000 objects statistics");
		selectWindow("Results");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
		dnn=nResults();
			//Getting mean and sd results
			if(dnn==0){
				meandnFI="0";
				sddnFI="0";
			}//end of loop for none result
			if(dnn==1){
				meandnFI=getResult("Mean", 0);
				sddnFI="0";
			}//end of loop for results n=1
			if(dnn>1) {
			for(j=0; j<dnn; j++) {
    			Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meandnFI=getResult("Mean", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sddnFI=getResult("Mean", j);
    			}//end of loop for sd results
    			}//end of loop to get results
    		}//end of loop for n results
    		
    	//Update table with nucleus results
		Table.set("Mean nuclear TASQ", c, meandnFI, table);
		Table.set("sd mean nuclear TASQ", c, sddnFI, table);
		Table.update(table);
		
			run("Clear Results");
			close("Objects map of Mask-DAPI_"+c+1+"/"+number+".TIF redirect to TASQ_"+c+1+"/"+number+".TIF");
			///Save of mask DAPI
			selectWindow("Mask-DAPI_"+c+1+"/"+number+".TIF");
			saveAs("Tiff", saveIMG_directory+name+"mask-DAPI_"+number+"-"+c+1+".TIF");
			close(name+"mask-DAPI_"+number+"-"+c+1+".TIF");
			///End of save
		
		
		/// within nucleolus
		run("Clear Results");
		selectWindow("Mask-nucleoli_"+c+1+"/"+number+".TIF");
		run("3D Objects Counter", "threshold=0 slice=1 min.="+vnucleolus+" max.=2000000 objects statistics");
		selectWindow("Results");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
		dnl=nResults();
			//Getting mean and sd results
			if(dnl==0){
				nl=dnl;
				meandnlFI="0";
				meandnlVol="0";
				sddnlFI="0";
    			sddnlVol="0";
			}//end of loop for none result
			if(dnl==1){
				nl=dnl;
				meandnlFI=getResult("Mean", 0);
				meandnlVol=getResult("Volume (micron^3)", 0);
				sddnlFI="0";
    			sddnlVol="0";
			}//end of loop for results n=1
			if(dnl>1) {
			for(j=0; j<dnl; j++) {
    			Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meandnlFI=getResult("Mean", j);
    			meandnlVol=getResult("Volume (micron^3)", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sddnlFI=getResult("Mean", j);
    			sddnlVol=getResult("Volume (micron^3)", j);
    			}//end of loop for sd results
    			}//end of loop to get results
    		nl=dnl-4;}//end of loop for n results
    		
    	//Update table with nucleus results
		Table.set("number of nucleoli", c, nl, table);
		Table.set("mean volume nucleoli (um^3)", c, meandnlVol, table);
		Table.set("sd volume nucleoli (um^3)", c, sddnlVol, table);
		Table.set("Mean nucleolar TASQ", c, meandnlFI, table);
		Table.set("sd mean nucleolar TASQ", c, sddnlFI, table);
		Table.update(table);
		
			run("Clear Results");
			close("Objects map of Mask-nucleoli_"+c+1+"/"+number+".TIF redirect to TASQ_"+c+1+"/"+number+".TIF");
			///Save of mask nucleolus
			selectWindow("Mask-nucleoli_"+c+1+"/"+number+".TIF");
			saveAs("Tiff", saveIMG_directory+name+"mask-nucleoli_"+number+"-"+c+1+".TIF");
			close(name+"mask-nucleoli_"+number+"-"+c+1+".TIF");
			///End of save
		
		
		/// within nucleus without nucleolus staining
		run("Clear Results");
		selectWindow("Mask-DAPI-wo-nucleoli_"+c+1+"/"+number+".TIF");
		run("3D Objects Counter", "threshold=0 slice=1 min.="+vnucleus+" max.=2000000 objects statistics");
		selectWindow("Results");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
		dnp=nResults();
			//Getting mean and sd results
			if(dnp==0){
				meandnpFI="0";
				meandnpVol="0";
				sddnpFI="0";
    			sddnpVol="0";
			}//end of loop for none result
			if(dnp==1){
				meandnpFI=getResult("Mean", 0);
				meandnpVol=getResult("Volume (micron^3)", 0);
				sddnpFI="0";
    			sddnpVol="0";
			}//end of loop for results n=1
			if(dnp>1) {
			for(j=0; j<dnp; j++) {
    			Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meandnpFI=getResult("Mean", j);
    			meandnpVol=getResult("Volume (micron^3)", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sddnpFI=getResult("Mean", j);
    			sddnpVol=getResult("Volume (micron^3)", j);
    			}//end of loop for sd results
    			}//end of loop to get results
    		}//end of loop for n results
    		
    	//Update table with nucleus results
		Table.set("mean volume nucleoplasm (um^3)", c, meandnpVol, table);
		Table.set("sd volume nucleoplasm (um^3)", c, sddnpVol, table);
		Table.set("Mean nucleoplasm TASQ", c, meandnpFI, table);
		Table.set("sd mean nucleoplasm TASQ", c, sddnpFI, table);
		Table.update(table);
		
			run("Clear Results");
			close("Objects map of Mask-DAPI-wo-nucleoli_"+c+1+"/"+number+".TIF redirect to TASQ_"+c+1+"/"+number+".TIF");
			///Save of mask DAPI w/o nucleoli
			selectWindow("Mask-DAPI-wo-nucleoli_"+c+1+"/"+number+".TIF");
			saveAs("Tiff", saveIMG_directory+name+"mask-DAPI-wo-nucleoli_"+number+"-"+c+1+".TIF");
			close(name+"mask-DAPI-wo-nucleoli_"+number+"-"+c+1+".TIF");
			///End of save
			
		
		if(IntC){
		/// within cytoplasm
		run("Clear Results");
		run("3D OC Options", "volume nb_of_obj._voxels integrated_density mean_gray_value dots_size=5 font_size=10 redirect_to=none");
		selectWindow("cytoplasm_"+c+1+"/"+number+".TIF");
		run("3D Objects Counter", "threshold=1 slice=1 min.=2 max.=2000000 objects statistics");
		selectWindow("Results");
		Table.sort("Volume (micron^3)");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
		cyt=nResults();
			//Getting mean and sd results
			if(cyt==0){
				meancytFI="0";
				meancytVol="0";
				sdcytFI="0";
    			sdcytVol="0";
			}//end of loop for none result
			if(cyt==1){
				meancytFI=getResult("Mean", 0);
				meancytVol=getResult("Volume (micron^3)", 0);
				sdcytFI="0";
    			sdcytVol="0";
			}//end of loop for results n=1
			if(cyt>1) {
				for(j=0; j<cyt; j++) {
    			Label=getResultString("Label", j);
    			if(Label=="Max"){
    			meancytFI=getResult("Mean", j);
    			meancytVol=getResult("Volume (micron^3)", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sdcytFI=getResult("Mean", j);
    			sdcytVol=getResult("Volume (micron^3)", j);
    			}//end of loop for sd results
    			}//end of loop to get results
    		}//end of loop for n results
    		
    	//Update table with nucleus results
		Table.set("mean volume cytoplasm (um^3)", c, meancytVol, table);
		Table.set("sd volume cytoplasm (um^3)", c, sdcytVol, table);
		Table.set("Mean cytoplasm FI TASQ", c, meancytFI, table);
		Table.set("sd mean cytoplasm FI TASQ", c, sdcytFI, table);
		Table.update(table);
		
			run("Clear Results");
			///Save mask cytoplasm
			selectWindow("cytoplasm_"+c+1+"/"+number+".TIF");
			saveAs("Tiff", saveIMG_directory+name+"cytoplasm_"+number+"-"+c+1+".TIF");
			close(name+"cytoplasm_"+number+"-"+c+1+".TIF");
			selectWindow("Objects map of cytoplasm_"+c+1+"/"+number+".TIF");
			saveAs("Tiff", saveIMG_directory+name+"map-cytoplasm_"+number+"-"+c+1+".TIF");
			close(name+"map-cytoplasm_"+number+"-"+c+1+".TIF");
		}	
				
}//end of intensity loop

if(Foci || FociC){
	/// Loop to quantify TASQ foci
	run("3D OC Options", "volume nb_of_obj._voxels mean_gray_value std_dev_gray_value dots_size=5 font_size=10 redirect_to=TASQ_"+c+1+"/"+number+".TIF");
		
		
		/// within nucleus (small foci)
		run("Clear Results");
		selectWindow("nuclear-foci-TASQ_"+c+1+"/"+number+".TIF");
		run("3D Objects Counter", "threshold=0 slice=1 min.=3 max.="+cot-1+" objects statistics");
		selectWindow("Results");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
		fsn=nResults();
			//Getting mean and sd results
			if(fsn==0){
				fs=fsn;
				meanfsFI="0";
				meanfsVol="0";
				sdfsFI="0";
    			sdfsVol="0";
			}//end of loop for none result
			if(fsn==1){
				fs=fsn;
				meanfsFI=getResult("Mean", 0);
				meanfsVol=getResult("Volume (micron^3)", 0);
				sdfsFI="0";
    			sdfsVol="0";
			}//end of loop for results n=1
			if(fsn>1) {
			for(j=0; j<fsn; j++) {
    			Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meanfsFI=getResult("Mean", j);
    			meanfsVol=getResult("Volume (micron^3)", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sdfsFI=getResult("Mean", j);
    			sdfsVol=getResult("Volume (micron^3)", j);
    			}//end of loop for sd results
    			}//end of loop to get results
    		fs=fsn-4;}//end of loop for n results
    		
    	//Update table with nucleus results
		Table.set("number of small nuclear foci", c, fs, tableF);
		Table.set("mean volume of small nuclear foci (um^3)", c, meanfsVol, tableF);
		Table.set("sd volume of small nuclear foci (um^3)", c, sdfsVol, tableF);
		Table.set("Mean FI TASQ of small nuclear foci", c, meanfsFI, tableF);
		Table.set("sd mean FI TASQ of small nuclear foci", c, sdfsFI, tableF);
		Table.update(tableF);
		
		
			run("Clear Results");
			close("Objects map of nuclear-foci-TASQ_"+c+1+"/"+number+".TIF redirect to TASQ_"+c+1+"/"+number+".TIF");
			
		/// within nucleus (large foci)
		run("Clear Results");
		selectWindow("nuclear-foci-TASQ_"+c+1+"/"+number+".TIF");
		run("3D Objects Counter", "threshold=0 slice=1 min.="+cot+" max.=2000000 objects statistics");
		selectWindow("Results");
		if(nResults>1){
			run("Summarize");
		}
		selectWindow("Results");
				selectWindow("Results");
		fln=nResults();
			//Getting mean and sd results
			if(fln==0){
				fl=fln;
				meanflFI="0";
				meanflVol="0";
				sdflFI="0";
    			sdflVol="0";
			}//end of loop for none result
			if(fln==1){
				fl=fln;
				meanflFI=getResult("Mean", 0);
				meanflVol=getResult("Volume (micron^3)", 0);
				sdflFI="0";
    			sdflVol="0";
			}//end of loop for results n=1
			if(fln>1) {
			for(j=0; j<fln; j++) {
    			Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meanflFI=getResult("Mean", j);
    			meanflVol=getResult("Volume (micron^3)", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sdflFI=getResult("Mean", j);
    			sdflVol=getResult("Volume (micron^3)", j);
    			}//end of loop for sd results
    			}//end of loop to get results
    		fl=fln-4;}//end of loop for n results
    		
    	//Update table with nucleus results
		Table.set("number of large nuclear foci", c, fl, tableF);
		Table.set("mean volume of large nuclear foci (um^3)", c, meanflVol, tableF);
		Table.set("sd volume of large nuclear foci (um^3)", c, sdflVol, tableF);
		Table.set("Mean FI TASQ of large nuclear foci", c, meanflFI, tableF);
		Table.set("sd mean FI TASQ of large nuclear foci", c, sdflFI, tableF);
		Table.update(tableF);
		
			run("Clear Results");
			close("Objects map of nuclear-foci-TASQ_"+c+1+"/"+number+".TIF redirect to TASQ_"+c+1+"/"+number+".TIF");
			///Save of nuclear foci mask
			selectImage("nuclear-foci-TASQ_"+c+1+"/"+number+".TIF");
			saveAs("Tiff", saveIMG_directory+name+"nuclear-foci-TASQ_"+number+"-"+c+1+".TIF");
			close(name+"nuclear-foci-TASQ_"+number+"-"+c+1+".TIF");
			///End of save

			
			
		if(FociC){
			/// within cytoplasm
			run("Clear Results");
			
		/// for small foci
			selectWindow("cyto-foci-TASQ_"+c+1+"/"+number+".TIF");
			run("3D Objects Counter", "threshold=0 slice=1 min.=3 max.=20 objects statistics");
			selectWindow("Results");
			if(nResults>1){
				run("Summarize");
			}
			selectWindow("Results");
			sfcn=nResults();
			//Getting mean and sd results
			if(sfcn==0){
				sfc=sfcn;
				meansfcFI="0";
				meansfcVol="0";
				sdsfcFI="0";
    			sdsfcVol="0";
			}//end of loop for none result
			if(sfcn==1){
				sfc=sfcn;
				meansfcFI=getResult("Mean", 0);
				meansfcVol=getResult("Volume (micron^3)", 0);
				sdsfcFI="0";
    			sdsfcVol="0";
			}//end of loop for results n=1
			if(sfcn>1) {
			for(j=0; j<sfcn; j++) {
    			Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meansfcFI=getResult("Mean", j);
    			meansfcVol=getResult("Volume (micron^3)", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sdsfcFI=getResult("Mean", j);
    			sdsfcVol=getResult("Volume (micron^3)", j);
    			}//end of loop for sd results
    			}//end of loop to get results
    		sfc=sfcn-4;}//end of loop for n results
    		
		    	//Update table with cytoplasmic results (SMALL)
				Table.set("number of small cytoplasmic nuclear foci", c, sfc, tableF);
				Table.set("mean volume of S cytoplasmic foci (um^3)", c, meansfcVol, tableF);
				Table.set("sd volume of S cytoplasmic foci (um^3)", c, sdsfcVol, tableF);
				Table.set("Mean FI TASQ of S cytoplasmic foci", c, meansfcFI, tableF);
				Table.set("sd mean FI TASQ of S cytoplasmic foci", c, sdsfcFI, tableF);
				Table.update(tableF);
		
			run("Clear Results");
			close("Objects map of cyto-foci-TASQ_"+c+1+"/"+number+".TIF redirect to TASQ_"+c+1+"/"+number+".TIF");

		/// for medium foci
			selectWindow("cyto-foci-TASQ_"+c+1+"/"+number+".TIF");
			run("3D Objects Counter", "threshold=0 slice=1 min.=21 max.=100 objects statistics");
			selectWindow("Results");
			if(nResults>1){
				run("Summarize");
			}
			selectWindow("Results");
			mfcn=nResults();
			//Getting mean and sd results
			if(mfcn==0){
				mfc=mfcn;
				meanmfcFI="0";
				meanmfcVol="0";
				sdmfcFI="0";
    			sdmfcVol="0";
			}//end of loop for none result
			if(mfcn==1){
				mfc=mfcn;
				meanmfcFI=getResult("Mean", 0);
				meanmfcVol=getResult("Volume (micron^3)", 0);
				sdmfcFI="0";
    			sdmfcVol="0";
			}//end of loop for results n=1
			if(mfcn>1) {
			for(j=0; j<mfcn; j++) {
    			Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meanmfcFI=getResult("Mean", j);
    			meanmfcVol=getResult("Volume (micron^3)", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sdmfcFI=getResult("Mean", j);
    			sdmfcVol=getResult("Volume (micron^3)", j);
    			}//end of loop for sd results
    			}//end of loop to get results
    		mfc=mfcn-4;}//end of loop for n results
    		
	    	//Update table with cytoplasmic results (MEDIUM)
			Table.set("number of medium cytoplasmic nuclear foci", c, mfc, tableF);
			Table.set("mean volume of M cytoplasmic foci (um^3)", c, meanmfcVol, tableF);
			Table.set("sd volume of M cytoplasmic foci (um^3)", c, sdmfcVol, tableF);
			Table.set("Mean FI TASQ of M cytoplasmic foci", c, meanmfcFI, tableF);
			Table.set("sd mean FI TASQ of M cytoplasmic foci", c, sdmfcFI, tableF);
			Table.update(tableF);
		
			run("Clear Results");
			close("Objects map of cyto-foci-TASQ_"+c+1+"/"+number+".TIF redirect to TASQ_"+c+1+"/"+number+".TIF");
		
		/// for large foci
			selectWindow("cyto-foci-TASQ_"+c+1+"/"+number+".TIF");
			run("3D Objects Counter", "threshold=0 slice=1 min.=101 max.=2000 objects statistics");
			selectWindow("Results");
			if(nResults>1){
				run("Summarize");
			}
			selectWindow("Results");
			lfcn=nResults();
			//Getting mean and sd results
			if(lfcn==0){
				lfc=lfcn;
				meanlfcFI="0";
				meanlfcVol="0";
				sdlfcFI="0";
    			sdlfcVol="0";
			}//end of loop for none result
			if(lfcn==1){
				lfc=lfcn;
				meanlfcFI=getResult("Mean", 0);
				meanlfcVol=getResult("Volume (micron^3)", 0);
				sdlfcFI="0";
    			sdlfcVol="0";
			}//end of loop for results n=1
			if(lfcn>1) {
			for(j=0; j<lfcn; j++) {
    			Label=getResultString("Label", j);
    			if(Label=="Mean"){
    			meanlfcFI=getResult("Mean", j);
    			meanlfcVol=getResult("Volume (micron^3)", j);
    			}//end of loop for mean results
    			if(Label=="SD"){
    			sdlfcFI=getResult("Mean", j);
    			sdlfcVol=getResult("Volume (micron^3)", j);
    			}//end of loop for sd results
    			}//end of loop to get results
    		lfc=lfcn-4;}//end of loop for n results
    		
	    	//Update table with cytoplasmic results (LARGE)
			Table.set("number of large cytoplasmic nuclear foci", c, lfc, tableF);
			Table.set("mean volume of L cytoplasmic foci (um^3)", c, meanlfcVol, tableF);
			Table.set("sd volume of L cytoplasmic foci (um^3)", c, sdlfcVol, tableF);
			Table.set("Mean FI TASQ of L cytoplasmic foci", c, meanlfcFI, tableF);
			Table.set("sd mean FI TASQ of L cytoplasmic foci", c, sdlfcFI, tableF);
			Table.update(tableF);
		
			run("Clear Results");
			close("Objects map of cyto-foci-TASQ_"+c+1+"/"+number+".TIF redirect to TASQ_"+c+1+"/"+number+".TIF");
			
			///Save cytoplasmic foci mask
			selectWindow("cyto-foci-TASQ_"+c+1+"/"+number+".TIF");
			saveAs("Tiff", saveIMG_directory+name+"cyto-foci-TASQ_"+number+"-"+c+1+".TIF");
			close(name+"cyto-foci-TASQ_"+number+"-"+c+1+".TIF");
			///End of save
		}//end of loop for cytoplasmic foci quantification

}

///////// Save of images and results TASQ intensity and/or foci per ROI
	//Save of DAPI and TASQ unmodified images
selectWindow("raw-DAPI_"+c+1+"/"+number+".TIF");
saveAs("Tiff", saveIMG_directory+name+"DAPI_"+number+"-"+c+1+".TIF");
close(name+"DAPI_"+number+"-"+c+1+".TIF");
selectWindow("TASQ_"+c+1+"/"+number+".TIF");
saveAs("Tiff", saveIMG_directory+name+"TASQ_"+number+"-"+c+1+".TIF");
close(name+"TASQ_"+number+"-"+c+1+".TIF");


}//end of ROI manager loop

	//Close of all opened images, ROI and results per image
close("*");
roiManager("deselect");
roiManager("Delete");

if(Int || IntC){
	selectWindow(table);
	saveAs("results", save_directory+table+".csv");
	run("Clear Results");
	run("Close");
}

if(Foci || FociC){
	selectWindow(tableF);
	saveAs("results", save_directory+tableF+".csv");
	run("Clear Results");
	run("Close");
}

setBatchMode(false);


}//end of loop for each image to be opened




///////////////////////////// Save all quantification /////////////////////////////
selectWindow("Log");
saveAs("text",save_directory+"all-results-for-all-images-of_"+name+Start+"-"+Stop+".txt");//Save all types of quantification for all images
run("Clear Results");
run("Close");
close("*");



///////////////////////////// Message box for macro restarting /////////////////////////////
messa= getBoolean("Do you have other images to analyze?");
Dialog.addMessage("!!!Macro will work with same parameters!!!");
if (messa==1){
//run function
sameParameters();
}//end of loop for same macro
else if (messa==0) {
exit;
}//enf of loop for no use of this macro
}//end of function "sameParameters"



sameParameters();

