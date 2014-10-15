#################################################################################
# deploy.py
# Crestron Core 3 UI Deployment Script
# 
# This script dploys a c3c package to the Core 3 UI User Controls folder
#################################################################################

import os
import os.path
import shutil
from winreg import *

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

cwdPath = os.getcwd() # Get the Current Working Directory
absPath = os.path.abspath(os.path.join(cwdPath, '..')) # Get the absolute path of our script
projectName = cwdPath.replace(absPath + '\\', '') # Extract the folder (project) name from the path
c3cName = projectName + ".c3c"

print ("Found the current project name: " + projectName)

# Search for our C3C file in the CWD path
# This file should be named the same as your project name (e.g. "Hello World" would yield "Hello World.c3c")
print ("")
print ("Searching for c3c file named " + c3cName)

if not os.path.exists(cwdPath + "\\" + c3cName):
	print ("Fatal Error: C3C file not found!")
	exit()

# Find out Core 3 UI User Controls Location from the registry
print ("")
print ("Looking up registry key for the Core 3 UI User Controls location...")

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


#if userPath == "":
#	print ("Fatal Error: User Controls path not found!")
#	exit()
#else:
#	print ("User Controls path found at: " + userPath)

CloseKey(core3Key)
CloseKey(regConn)

# Lets deploy the file to the user controls folder
print ("")
print ("Copying C3C to User Controls...")
shutil.copyfile(cwdPath + "\\" + c3cName, userPath + "\\" + c3cName)

print ("")
print ("Deployment of " + projectName + " complete!")
print (lineBreak)




