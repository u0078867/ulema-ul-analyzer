
import PyQt4.QtGui as QtGui
import PyQt4.QtCore as QtCore

import os

windowTitle = 'Descriptors editor'

defDesc = {}
defDesc['obj'] = '' # This will be automatically filled
defDesc['obj_type'] = 'image'



class Controller():
    
    def __init__(self, model, view, app, plugins, showWin=True):     
        # Register view and application
        self.m = model
        self.v = view
        self.app = app
        self.plugins = plugins
        
        # Get the IDs of all available tabs
        self.tabIDs = self.v.getAllTabIDs()
              
        # Register callbacks
        self.v.buttNewDesc.clicked.connect(self.newDescriptor)
        self.v.buttCopyDesc.clicked.connect(self.copyDescriptor)
        self.v.buttDelDesc.clicked.connect(self.delDescriptor)
        self.v.listDesc.itemClicked.connect(self.showDescriptorContent)
        self.v.buttSaveDesc.clicked.connect(self.saveDescriptor)
        self.v.actSaveFile.triggered.connect(self.saveFile)
        self.v.actSaveFileAs.triggered.connect(self.saveFileAs)
        self.v.actLoadFile.triggered.connect(self.loadFile)
        self.v.tabAnalysis.currentChanged.connect(self.changeCurrentTab)
        
        # Show view, if necessary
        if showWin == True:
            self.v.show()
        
        # Initialize last used folders and files
        self.lastSaveDir = ''
        self.lastLoadDir = ''
        self.currDataFilePath = ''
        
        # Initialize title
        self.v.setWindowTitle(windowTitle)
        
    
    def newDescriptor(self):
        # Search for a new valid name
        allDesc = self.v.getAllDescInList()
        cont = 1
        newDesc = 'New descriptor {0:3d}'.format(cont)
        while newDesc in allDesc:
            cont += 1
            newDesc = 'New descriptor {0:3d}'.format(cont)
        # Get default descriptor for the current tab index
        descData = defDesc.copy()
        descData.update(self.v.getCurrentTab().getDefDescriptor())
        # Add the new descriptor in the list
        self.v.addDesc(newDesc) 
        # Add new descriptor in the model
        descData['obj'] = newDesc
        self.m.appendNewDescriptor(descData)
        print 'Descriptor "{0}" added'.format(newDesc)
        
    
    def copyDescriptor(self):
        # Get current descriptor
        currentDesc = self.v.getHighlightedDesc()
        if len(currentDesc) == 0:
            return
        # Get descriptor from model
        print currentDesc
        desc = self.m.getDescriptorFromId(currentDesc)
        # Search for a new valid name
        allDesc = self.v.getAllDescInList()
        cont = 0
        newDesc = 'Copy of {0}'.format(currentDesc)
        while newDesc in allDesc:
            cont += 1
            newDesc = 'Copy of {0} {1}'.format(currentDesc, cont)
        # Add the new descriptor in the list
        self.v.addDesc(newDesc) 
        # Add new descriptor in the model
        descData = desc.copy()
        descData['obj'] = newDesc
        self.m.appendNewDescriptor(descData)
        print 'Descriptor "{0}" added'.format(newDesc)        
        
       
    def delDescriptor(self):
        # Get current descriptor
        currentDesc = self.v.getHighlightedDesc()
        if len(currentDesc) == 0:
            return
        # Delete current descriptor from list
        self.v.delDesc(currentDesc)
        # Delete current descriptor from model
        self.m.delDescriptor(currentDesc)
        print 'Descriptor "{0}" deleted'.format(currentDesc)
            

    def showDescriptorContent(self): 
        # Get current descriptor
        currentDesc = self.v.getHighlightedDesc()
        if len(currentDesc) > 0:
            # Get descriptor from model
            desc = self.m.getDescriptorFromId(currentDesc)
            # Set descriptor to view
            self.v.setDescriptorContent(desc)
            print 'Descriptor "{0}" showed:\n{1}'.format(currentDesc, desc)
        
    
    def saveDescriptor(self):
        # Get current descriptor
        currentDesc = self.v.getHighlightedDesc()
        if len(currentDesc) == 0:
            return
        # Get descriptor from view
        desc = self.v.getDescriptorContent()
        # Check if name is empty
        if desc['obj'] == '':
            QtGui.QMessageBox.critical(None, "Descriptor","Name cannot be empty")
            return
        # Check if name is already in the list
        if desc['obj'] <> currentDesc and desc['obj'] in self.v.getAllDescInList():
            QtGui.QMessageBox.critical(None, "Descriptor","Name is already in the list")
            return 
        # Change descriptor name in the list
        self.v.changeDescNameInList(currentDesc, desc['obj'])
        # Set descriptor to model
        self.m.overwriteDescriptorWithId(currentDesc, desc)
        print 'Descriptor "{0}" saved:\n{1}'.format(currentDesc, desc)
        
    def saveFile(self):
        # Check if it is first time saving
        if self.currDataFilePath == '':
            self.saveFileAs()
        else:
            # Save file
            fileName = self.currDataFilePath
            self.m.saveListToFile(fileName)
            print 'file {0} saved'.format(fileName)

    def saveFileAs(self):
        # Ask for a path
        fileName = QtGui.QFileDialog.getSaveFileName( \
            caption='Save descriptors file', \
            directory=self.lastSaveDir+'/my_descriptors_file.des', \
            filter='Descriptors file (*.des)')
        fileName = str(fileName)
        # Save content to file
        if len(fileName) == 0:
            print 'No file selected'
            return
        self.lastSaveDir = os.path.dirname(fileName)        
        self.m.saveListToFile(fileName)
        # Set current file path
        self.currDataFilePath = fileName
        # Set new main window title
        self.v.setWindowTitle(windowTitle + ' ({0})'.format(fileName))
        print 'file {0} saved'.format(fileName)
        QtGui.QMessageBox.information(None, "Save file", "Descriptors file saved")
    
    def loadFile(self):
        # Ask for a path
        fileName = QtGui.QFileDialog. getOpenFileName( \
            caption='Load descriptors file', \
            directory=self.lastLoadDir, \
            filter='Descriptors file (*.des)')
        fileName = str(fileName)
        # Load content from file
        if len(fileName) == 0:
            print 'No file selected'
            return
        self.lastLoadDir = os.path.dirname(fileName)        
        notSuppDescNames = self.m.loadListFromFile(fileName, self.tabIDs)
        # Clean the user interface
        self.v.clearUI()
        # Create the list of descriptors
        descNames = self.m.getDescriptorNames()
        for descName in descNames:
            if descName in notSuppDescNames:
                enabled = False
            else:
                enabled = True
            self.v.addDesc(descName, enabled=enabled)
        # Select the first descriptor in the list
        #self.v.setHighlightedDesc(0)
        self.v.listDesc.itemClicked.emit(None)
        # Set current file path
        self.currDataFilePath = fileName
        # Set new main window title
        self.v.setWindowTitle(windowTitle + ' ({0})'.format(fileName))
        print 'file {0} loaded'.format(fileName)
    
    def changeCurrentTab(self, idx):
        self.v.changeObjType()
        
    

    
    
    
    
    
    
    
    