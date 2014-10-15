#################################################################################
# package.py
# Crestron Core 3 UI Package Script
# 
# This script creates a c3c package that is used by the Core 3 UI design tools.
# This must be run in the root of your control (projects\CONTROL) directory.
#################################################################################

import os
import os.path
import zipfile

lineBreak = "========================================================================"

print (lineBreak)
print ("Crestron Core 3 UI Packaging Script")
print ("Beginning packaging.... ")
print ("")

cwdPath = os.getcwd() # Get the Current Working Directory
absPath = os.path.abspath(os.path.join(cwdPath, '..')) # Get the absolute path of our script
binPath = cwdPath + "\\" + "bin\\" # Store the bin path
dataPath = cwdPath + "\\" + "data\\" # Store the data path
projectName = cwdPath.replace(absPath + '\\', '') # Extract the folder (project) name from the path

print ("Found the current project name: " + projectName)

# Search for our SWF file in the bin path
# This file should be named the same as your project name, but without spaces (e.g. "Hello World" would yield "HelloWorld.swf")

swfName = projectName.replace(" ", "") + ".swf"
print ("Searching for " + swfName + " in " + binPath)

if not os.path.isfile(binPath + swfName):
	print ("")
	print (swfName + ".swf was not found... looking for other SWF files")
	
	swfName = ""
	
	#for subdir, dirs, files in os.walk(binPath):
	#	for file in files:
	#		fileName, fileExt = os.path.splitext(file)
	#		if fileExt == ".swf":
	#			swfName = file
	for file in os.listdir(binPath):
		fileName, fileExt = os.path.splitext(file)
		if fileExt == ".swf":
			swfName = file
			
	if swfName == "":
		print ("")
		print ("Fatal Error: No SWF file found at " + binPath)
		exit()

print ("Found SWF (" + projectName + ".swf)")

# If we made it this far, there was a SWF file to package
# Now we need to find our XSD, XML and Thumbnail image
# These files should be located in our data folder
xsdFile = ""
xmlFile = ""
thumbFile = ""

for file in os.listdir(dataPath):
	fileName, fileExt = os.path.splitext(file)
	if fileExt == ".xsd":
		xsdFile = file
		print ("Found XSD (" + xsdFile + ")")
	elif fileExt == ".xml":
		xmlFile = file
		print ("Found XML (" + xmlFile + ")")
	elif fileExt == ".png" or fileExt == ".jpg" or fileExt == ".bmp":
		thumbFile = file
		print ("Found Thumbnail (" + thumbFile + ")")
			
if xsdFile != "" and xmlFile != "":
	
	print ("")
	print ("Creating Crestron Core 3 Control package...")
	
	zipFile = zipfile.ZipFile(projectName + '.c3c', 'w')
	
	print ("Adding SWF file to package...")
	zipFile.write(binPath + swfName, swfName)
	
	print ("Adding XSD file to package...")
	zipFile.write(dataPath + xsdFile, xsdFile)
	
	print ("Adding XML file to package...")
	zipFile.write(dataPath + xmlFile, xmlFile)
			
	if thumbFile != "":
		print ("Adding Thumbnail file to package...")
		zipFile.write(dataPath + thumbFile, thumbFile)
	else:
		print ("Thumbnail not found, skipping...")	
		
elif xsdFile == "" and xmlFile == "":
	print ("Fatal Error: Missing XML and XSD files!")
	exit()
elif xsdFile == "":
	print ("Fatal Error: Missing XSD files!")
	exit()
elif xmlFile == "":
	print ("Fatal Error: Missing XML files!")
	exit()
			
print ("")
print ("Packaging of " + projectName + " complete!")
print (lineBreak)