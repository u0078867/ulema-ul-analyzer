
import sys

import pkgutil
import string
from inspect import getmembers, isfunction, isclass


import Plugins.Importer # necessary for PyInstaller
pluginsToLoad = dir(Plugins.Importer)


def parsePlugins(packageName):
    # Searching generators and views
    print 'searching for generators and views...'
    packageName = 'Plugins'
    package = __import__(packageName)
    print dir(package)
    pluginsDict = {'generators':{},'views':{}}
    for importer, modname, ispkg in pkgutil.walk_packages(package.__path__):
        if modname[0] <> '_':
            if ispkg == True and modname in pluginsToLoad:
                print "Found submodule %s (is a package: %s)" % (modname, ispkg)
                package2 = eval('package.'+modname)
                print 'package content: {0}'.format(dir(package2))
                for importer2, modname2, ispkg2 in pkgutil.walk_packages(package2.__path__):
                    # Searching for generators
                    if ispkg2 == False and string.find(modname2, 'Generators') >= 0:
                        genModule = eval('package2.'+modname2)
                        print "{0} contains generators".format(genModule.__name__)
                        genList = [o for o in getmembers(genModule) if isfunction(o[1])]
                        pluginsDict['generators'].update(genList)
                    # Searching for for view
                    if ispkg2 == False and string.find(modname2, 'View') >= 0:
                        viewModule = eval('package2.'+modname2)
                        print "{0} contains view".format(viewModule.__name__)
                        viewList = [o for o in getmembers(viewModule) if isclass(o[1]) and o[0] == modname+'Tab']
                        pluginsDict['views'].update(viewList)
    print 'search finished'
    print 'found generators: {0}'.format(pluginsDict['generators'])
    print 'found views: {0}'.format(pluginsDict['views'])
    return pluginsDict


import PyQt4.QtGui as QtGui


import RGView
import RGController


        
if __name__ == "__main__":  
    # Redirect stdout and stderr to a file
    f1 = open('console.log','w')
    f2 = open('console.log','w')
    #sys.stdout = f1
    #sys.stderr = f2
    # Search for plugins
    print 'Importer content:\n{0}'.format(pluginsToLoad)
    print 'loading plugins...'
    plugins = parsePlugins('Plugins')
    print 'plugins loaded'
    # Create application
    app = QtGui.QApplication(sys.argv)
    print 'check "View - Log Console" in main window for communications'
    # Create View and Controller
    view = RGView.MainWindow(plugins)
    controller = RGController.Controller(view, app, plugins)
    # Run the main loop
    print 'application started'
    sys.exit(app.exec_())
    f1.close()
    f2.close()    
    
    
    
    
    