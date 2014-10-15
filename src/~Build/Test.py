import os
import os.path
import shutil

cwdPath = os.getcwd()
absPath = os.path.abspath(os.path.join(cwdPath, '..'))
binPath = cwdPath + "\\" + "bin\\"
projectName = cwdPath.replace(absPath + '\\', '')

print ("Found the current project name: " + projectName)

swfName = projectName.replace(" ", "") + ".swf"
print ("Searching for " + swfName + " in " + binPath)

if not os.path.isfile(binPath + swfName):
	print ("")
	print (swfName + ".swf was not found... looking for other SWF files")
	
	swfName = ""

	for file in os.listdir(binPath):
		fileName, fileExt = os.path.splitext(file)
		if fileExt == ".swf":
			swfName = file
			
	if swfName == "":
		print ("")
		print ("Fatal Error: No SWF file found at " + binPath)
		exit()
		
print ("Found SWF (" + projectName + ".swf)")

print ("")
print ("Copying files to test folder")
shutil.copyfile(binPath + "\\" + swfName, "C:\\Crestron\\Smart Graphics\\TEST\\Test\\swf\\controls\\" + swfName)

print ("")
print ("Deployment of " + projectName + " complete!")

print ("")