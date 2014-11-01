import os
import os.path
import shutil

lineBreak = "========================================================================"

print (lineBreak)
print ("Crestron Smart Graphics Deployment Script")
print ("Beginning deployment.... ")
print ("")

cwdPath = os.getcwd() # Get the Current Working Directory
absPath = os.path.abspath(os.path.join(cwdPath, '..')) # Get the absolute path of our script
releasePath = os.path.abspath(os.path.join(cwdPath,  '..\..')) + "\\release"
projectName = cwdPath.replace(absPath + '\\', '') # Extract the folder (project) name from the path
c3cName = projectName + ".c3c"

print (releasePath)
print ("Found the current project name: " + projectName)

# Search for our C3C file in the CWD path
# This file should be named the same as your project name (e.g. "Hello World" would yield "Hello World.c3c")
print ("")
print ("Searching for c3c file named " + c3cName)

if not os.path.exists(cwdPath + "\\" + c3cName):
	print ("Fatal Error: C3C file not found!")
	exit()

# Lets deploy the file to the release folder
print ("")
print ("Copying C3C to release folder...")
shutil.copyfile(cwdPath + "\\" + c3cName, releasePath + "\\" + c3cName)

print ("")
print ("Deployment of " + projectName + " complete!")
print (lineBreak)