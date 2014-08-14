
import PyQt4.QtGui as QtGui
import PyQt4.QtCore as QtCore

  

class MainWindow(QtGui.QMainWindow):
    
    def __init__(self, plugins): 
        QtGui.QMainWindow.__init__(self)
        
        self.plugins = plugins
        self.resize(1000, 650)
        #self.setMaximumHeight(600)

        # ---Create non layout widgets
        self.labelName = QtGui.QLabel('Name:')
        self.editName = QtGui.QLineEdit()
        self.labelType = QtGui.QLabel('Type:')
        self.comboType = QtGui.QComboBox()
        self.comboType.addItem('image')
        self.comboType.addItem('text')
        self.tabAnalysis = QtGui.QTabWidget()
        
        self.tab = {}
        for tabName in self.plugins['views']:
            self.tab[tabName] = self.plugins['views'][tabName]()
            self.tabAnalysis.addTab(self.tab[tabName], self.tab[tabName].title)
        print 'plugin tabs added in Descriptors Editor'
        
        self.buttSaveDesc = QtGui.QPushButton('Save')
        
        self.labDescList = QtGui.QLabel('Descriptors:')
        self.listDesc = QtGui.QListWidget()
        self.listDesc.setSortingEnabled(True)
        self.buttNewDesc = QtGui.QPushButton('New')
        self.buttCopyDesc = QtGui.QPushButton('Copy')
        self.buttDelDesc = QtGui.QPushButton('Delete')
        
        self.menuBar = self.menuBar()
        self.menuFile = self.menuBar.addMenu('&File')
        self.actSaveFile = QtGui.QAction("Save", self)
        self.menuFile.addAction(self.actSaveFile)
        self.actSaveFileAs = QtGui.QAction("Save as...", self)
        self.menuFile.addAction(self.actSaveFileAs)
        self.actLoadFile = QtGui.QAction("Load...", self)
        self.menuFile.addAction(self.actLoadFile)

        # ---Create layout widgets
        self.gridCommonOpts = QtGui.QGridLayout()
        self.vBoxDescEdit = QtGui.QVBoxLayout()
        self.vBoxDescMan = QtGui.QVBoxLayout()
        self.gridDescManButts = QtGui.QGridLayout()
        self.hBox = QtGui.QHBoxLayout()

        
        # ---Organize non-layout widgets
        self.gridCommonOpts.addWidget(self.labelName, 0, 0)
        self.gridCommonOpts.addWidget(self.editName, 0, 1)
        self.gridCommonOpts.addWidget(self.labelType, 1, 0)
        self.gridCommonOpts.addWidget(self.comboType, 1, 1)
        self.vBoxDescEdit.addLayout(self.gridCommonOpts)
        self.vBoxDescEdit.addWidget(self.tabAnalysis)
        self.vBoxDescEdit.addWidget(self.buttSaveDesc)
        self.vBoxDescMan.addWidget(self.labDescList)
        self.vBoxDescMan.addWidget(self.listDesc)
        self.gridDescManButts.addWidget(self.buttNewDesc, 0, 0)
        self.gridDescManButts.addWidget(self.buttCopyDesc, 0, 1)
        self.gridDescManButts.addWidget(self.buttDelDesc, 0, 2)
        self.vBoxDescMan.addLayout(self.gridDescManButts)
        self.hBox.addLayout(self.vBoxDescEdit)
        self.hBox.addLayout(self.vBoxDescMan)
        self.cWidget = QtGui.QWidget()
        self.cWidget.setLayout(self.hBox)
        self.setCentralWidget(self.cWidget)
        
        # ---Register callbacks
        self.comboType.currentIndexChanged.connect(self.changeObjType)
          
          
    def addDesc(self, desc, enabled=True):
        self.listDesc.addItem(desc)
        if enabled == False:
            item = self.listDesc.findItems(desc, QtCore.Qt.MatchExactly)[0]
            item.setBackgroundColor(QtGui.QColor('#FF0000'))
            item.setFlags(QtCore.Qt.NoItemFlags)
            
    def delDesc(self, desc):
        item = self.listDesc.findItems(desc, QtCore.Qt.MatchExactly)[0]
        self.listDesc.takeItem(self.listDesc.indexFromItem(item).row())
    
    def changeDescNameInList(self, oldDesc, newDesc):
        item = self.listDesc.findItems(oldDesc, QtCore.Qt.MatchExactly)[0]
        item.setText(newDesc)

    def getHighlightedDesc(self):
        currentDesc = self.listDesc.selectedItems()
        if len(currentDesc) > 0:
            return str(currentDesc[0].text())
        else:
            return [] 
    
    def setHighlightedDesc(self, idx):
        self.listDesc.setCurrentRow(idx)
    
    def getAllDescInList(self):
        allDesc = []
        for i in xrange(self.listDesc.count()):
            allDesc.append(str(self.listDesc.item(i).text()))
        return allDesc
    
    def getDescriptorContent(self):
        data = {}
        data['obj'] = str(self.editName.text())
        data['obj_type'] = str(self.comboType.currentText())
        currentTab = self.tabAnalysis.currentWidget()
        data['view_ID'] = currentTab.getID()
        data.update(currentTab.getContent())
        return data
        
    def setDescriptorContent(self, data):
        self.editName.setText(data['obj'])
        if data['obj_type'] == 'image':
            self.comboType.setCurrentIndex(0)
        elif data['obj_type'] == 'text':
            self.comboType.setCurrentIndex(1)
        for i in xrange(self.tabAnalysis.count()):
            tab = self.tabAnalysis.widget(i)
            if tab.getID() == data['view_ID']:
                self.tabAnalysis.setCurrentIndex(i)
                tab.setContent(data)
    
    def clearUI(self):
        for i in xrange(self.tabAnalysis.count()):
            tab = self.tabAnalysis.widget(i)
            defDesc = tab.getDefDescriptor()
            defDesc.update({'obj':'','obj_type':'image'})
            self.setDescriptorContent(defDesc)
        self.listDesc.clear()
    
    def changeObjType(self):
        objType = str(self.comboType.currentText())
        currentTab = self.tabAnalysis.currentWidget()
        currentTab.showOptsForObjType(objType)
    
    def getCurrentTab(self):
        return self.tabAnalysis.currentWidget()
    
    def getAllTabIDs(self):
        IDs = []
        for i in xrange(self.tabAnalysis.count()):
            IDs.append(self.tabAnalysis.widget(i).getID())   
        return IDs

       
        
        
        
        
        

    
    
    
    