import os
import os.path
import shutil
from winreg import *

cwdPath = os.getcwd()
absPath = os.path.abspath(os.path.join(cwdPath, '..'))
binPath = cwdPath + "\\" + "bin\\"
dataPath = cwdPath + "\\" + "data\\"
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

def is_window64():
	try:
		aReg = OpenKey(HKEY_LOCAL_MACHINE,"SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run")
		if aReg:
			print("Yes")
			return True
	except WindowsError:
		print("No")
		return False
	return False

lineBreak = "========================================================================"

print (lineBreak)
print ("Crestron Core 3 UI Deployment Script")
print ("Beginning deployment.... ")
print ("")

regConn = ConnectRegistry(None, HKEY_LOCAL_MACHINE)

if is_window64():
	core3Key = OpenKey(regConn, "SOFTWARE\Wow6432Node\Crestron Electronics Inc.\Crestron Core 3 UI Controls")
else:
	core3Key = OpenKey(regConn, "SOFTWARE\Crestron Electronics Inc.\Crestron Core 3 UI Controls")


userPath = QueryValueEx(core3Key, "UserCtrls Path")[0] + "\controls"

if os.path.isdir(userPath):
	print("Found: " + userPath)
else:
	try:
		os.mkdir(userPath)
	except:
		print("could not create missing control directory")
		exit()
		
CloseKey(core3Key)
CloseKey(regConn)

print ("")
print ("Copying files to User Controls...")
shutil.copyfile(binPath + "\\" + swfName, userPath + "\\" + swfName)
shutil.copyfile(dataPath + "\\" + xsdFile, userPath + "\\" + xsdFile)
shutil.copyfile(dataPath + "\\" + xmlFile, userPath + "\\" + xmlFile)

print ("")
print ("Deployment of " + projectName + " complete!")
print (lineBreak)

print ("")
print (lineBreak)