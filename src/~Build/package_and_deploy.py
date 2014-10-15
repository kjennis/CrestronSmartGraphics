#################################################################################
# package_and_deploy.py
# Crestron Core 3 UI Package and Deployment Script
# 
# This script creates a c3c package that is used by the Core 3 UI design tools.
# This must be run in the root of your control (projects\CONTROL) directory.
#################################################################################

import os

lineBreak = "========================================================================"

print (lineBreak)
print ("Crestron Core 3 UI Packaging and Deployment Script")
print ("Launching Packager.... ")
print ("")

os.system("package.py")

print ("")
print ("Launching Deployer.... ")
print ("")

os.system("deploy.py")

print ("")
print (lineBreak)
input("Press return to close this window...")