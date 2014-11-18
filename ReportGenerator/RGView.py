
import PyQt4.QtGui as QtGui
import PyQt4.QtCore as QtCore

import os
import sys

from LogTools import LogViewer


class ComboCell(QtGui.QWidget):
    def __init__(self, l=None):
        QtGui.QWidget.__init__(self)
        self.label = QtGui.QLabel()
        self.combo = QtGui.QComboBox()
        self.grid = QtGui.QGridLayout()
        self.grid.addWidget(self.label,0,0)
        self.grid.addWidget(self.combo,1,0)
        self.mainWidget = QtGui.QWidget()
        self.mainWidget.setLayout(self.grid)
        self.mainLayout = QtGui.QHBoxLayout()
        self.mainLayout.addWidget(self.mainWidget)
        self.mainLayout.setMargin(0)
        self.setLayout(self.mainLayout)
        if l != None:
            self.label.setText(l[0])
            self.setPossibleChoices(l)
        self.setBackground('transparent')
        
    def setPossibleChoices(self, l):
        self.combo.clear()
        self.combo.addItems(l)
    
    def getChoice(self):
        idx = self.combo.currentIndex()
        return str(self.combo.itemText(idx))
    
    def setLabel(self, text):
        self.label.setText(text)
        
    def getLabel(self):
        return str(self.label.text())
    
    def setBackgroundColor(self, col):
        self.mainWidget.setStyleSheet('background-color: %s' % col)
        
    def setBackground(self, background):
        self.mainWidget.setStyleSheet('background: %s' % background)   
        self.combo.setStyleSheet('background-color: %s' % 'white')
        

class CheckboxCell(QtGui.QWidget):
    def __init__(self, checked=False):
        QtGui.QWidget.__init__(self)
        self.checkProc = QtGui.QCheckBox()
        self.vBox = QtGui.QVBoxLayout()
        self.vBox.addWidget(self.checkProc,0)
        self.mainWidget = QtGui.QWidget()
        self.mainWidget.setLayout(self.vBox)
        self.mainLayout = QtGui.QHBoxLayout()
        self.mainLayout.addWidget(self.mainWidget)
        self.mainLayout.setMargin(0)
        self.setLayout(self.mainLayout)
        self.checkProc.setChecked(checked)
        self.setBackground('transparent')

    def setBackgroundColor(self, col):
        self.mainWidget.setStyleSheet('background-color: %s' % col)
        
    def setBackground(self, background):
        self.mainWidget.setStyleSheet('background: %s' % background) 
        
    def isChecked(self):
        return self.checkProc.isChecked()
        

class MainWindow(QtGui.QMainWindow):
    def __init__(self, plugins):
        
        QtGui.QMainWindow.__init__(self)
        
        self.logViewer = LogViewer(otherStdout=sys.stdout,otherStderr=sys.stderr)
        #self.logViewer.connectToStdout()
        #self.logViewer.connectToStderr()
        
        self.plugin = plugins
        self.resize(1000, 600)
        self.setWindowTitle('Report generator (v1.1)')

        # ---Create non layout widgets
        self.tabDataSource = QtGui.QTableWidget(20,7)
        self.tabDataSource.setHorizontalHeaderLabels([' ','ODT template','Data source 1','Data dource 2','ODT report folder','ODT report name','DES file'])
        self.buttFillCellsChoice = QtGui.QPushButton('Fill from tree...') 
        self.buttFillCellsRepDir = QtGui.QPushButton('Choose report folder...') 
        self.buttFillTemplates = QtGui.QPushButton('Fill template for checked rows') 
        self.progGenOp = QtGui.QProgressBar()
        self.progGenOp.setMinimum(0)
        self.progGenOp.setMaximum(100)
        self.labGenOp = QtGui.QLabel('')
        self.progFillTemplates = QtGui.QProgressBar()
        self.progFillTemplates.setMinimum(0)
        self.progFillTemplates.setMaximum(100)       
        self.labFillTemplates = QtGui.QLabel('')
        
        self.menuBar = self.menuBar()
        
        self.menuView = self.menuBar.addMenu('&View')
        self.actShowHideLogViewer = QtGui.QAction("Log console", self)
        self.actShowHideLogViewer.setShortcut("Ctrl+L")
        self.menuView.addAction(self.actShowHideLogViewer)
        
        self.menuTools = self.menuBar.addMenu('&Tools')
        self.actShowDescriptorsEditor = QtGui.QAction("Descriptors Editor...", self)
        self.actShowDescriptorsEditor.setShortcut("Ctrl+D")
        self.menuTools.addAction(self.actShowDescriptorsEditor)

        # ---Create layout widgets
        self.hBox = QtGui.QHBoxLayout()
        self.vBox = QtGui.QVBoxLayout()
        self.vBoxControl1 = QtGui.QVBoxLayout()
        self.gridControl = QtGui.QGridLayout()
        self.gridControl.setColumnMinimumWidth(0, 160)
        self.gridRun = QtGui.QGridLayout()
        self.cWidget = QtGui.QWidget(self)  
        
        # ---Organize non-layout widgets
        self.hBox.addLayout(self.gridControl, 0)
        self.hBox.addLayout(self.vBox, 1)
        self.vBox.addLayout(self.gridRun, 0)
        self.vBox.addWidget(self.tabDataSource, 1)
        self.vBoxControl1.addStretch(1)
        self.vBoxControl1.addWidget(self.buttFillCellsChoice, 0)
        self.vBoxControl1.addWidget(self.buttFillCellsRepDir, 1)
        self.vBoxControl1.addWidget(self.buttFillTemplates, 2)
        self.vBoxControl1.addStretch(1)
        self.gridControl.addLayout(self.vBoxControl1, 0, 0)            
        self.gridRun.addWidget(self.labGenOp, 0, 0)
        self.gridRun.addWidget(self.progGenOp, 2, 0)
        self.gridRun.addWidget(self.labFillTemplates, 3, 0)
        self.gridRun.addWidget(self.progFillTemplates, 4, 0)
        self.cWidget.setLayout(self.hBox)
        self.setCentralWidget(self.cWidget)
    
        # ---Initialize data source table
        for r in xrange(self.tabDataSource.rowCount()):
            # Set processing column
            self.tabDataSource.setCellWidget(r, 0, CheckboxCell(checked=False))
            if r == 0:
                self.tabDataSource.horizontalHeader().setResizeMode(0, QtGui.QHeaderView.Fixed)
                self.tabDataSource.setColumnWidth(0, 32)
            # Set data source column
            for c in [1,2,3,6]:
                self.tabDataSource.setCellWidget(r, c, ComboCell([' ']))
                if r == 0:
                    self.tabDataSource.setColumnWidth(c, 160)
            # Set report folder column
            cell = QtGui.QTableWidgetItem('')
            self.tabDataSource.setItem(r, 4, cell)
            self.tabDataSource.setColumnWidth(4, 160)
            # Set report name column
            cell = QtGui.QTableWidgetItem('')
            self.tabDataSource.setItem(r, 5, cell)
            self.tabDataSource.setColumnWidth(5, 160)
        self.tabDataSource.resizeRowsToContents()
        #self.show()
    
    def show(self):
        super(MainWindow, self).show()
        
    
    def setQuitFun(self, quitFun):
        self.quitFun = quitFun
        
    
    def closeEvent(self, event):
        r = self.quitFun()
        if r:
            event.accept()
        else:
            event.ignore()
            
    def setProgGenOpPct(self, pct):
        self.progGenOp.setValue(pct)
            
    def setLabGenOp(self, text):
        self.labGenOp.setText(text)
    
    def setProgFillTemplatesPct(self, pct):
        self.progFillTemplates.setValue(pct)
    
    def setLabFillTemplates(self, text):
        self.labFillTemplates.setText(text)
    
    def getHlCellsCount(self):
        return len(self.tabDataSource.selectedIndexes())
    
    def getColumnCount(self):
        return self.tabDataSource.columnCount()

    def getRowCount(self):
        return self.tabDataSource.rowCount()
    
    def getHlCellsColumns(self):
        columnIdxs = []
        hlIndexes = self.tabDataSource.selectedIndexes()
        for index in hlIndexes:
            c = index.column()
            if c not in columnIdxs:
                columnIdxs.append(c)
        return columnIdxs
    
    def getHlCellsRows(self):
        rowIdxs = []
        hlIndexes = self.tabDataSource.selectedIndexes()
        for index in hlIndexes:
            r = index.row()
            if r not in rowIdxs:
                rowIdxs.append(r)
        return rowIdxs
    
    def getCheckedRows(self):
        rowIdxs = []
        for r in xrange(self.getRowCount()):
            cell = self.tabDataSource.cellWidget(r, 0)
            if cell.isChecked():
                rowIdxs.append(r)
        return rowIdxs
        
    
    def setPossibleChoicesForHlCells(self, l):
        hlIndexes = self.tabDataSource.selectedIndexes()
        for index in hlIndexes:
            cell = self.tabDataSource.cellWidget(index.row(), index.column())
            cell.setPossibleChoices(l)
        
    def setLabelsForHlCells(self, text):
        hlIndexes = self.tabDataSource.selectedIndexes()
        for index in hlIndexes:
            if index.column() < 4 or index.column() == 6:
                cell = self.tabDataSource.cellWidget(index.row(), index.column())
                cell.setLabel(text)
            else:
                cell = QtGui.QTableWidgetItem(text)
                self.tabDataSource.setItem(index.row(), index.column(), cell)
    
    def setCellBackgroundColor(self, r, c, col):
        if c < 4 or c == 6:
            cell = self.tabDataSource.cellWidget(r, c)
            cell.setBackgroundColor(col)
        else:
            item = self.tabDataSource.item(r, c)
            item.setBackgroundColor(QtGui.QColor(col))
    
    def setCellBackground(self, r, c, background):
        if c < 4 or c == 6:
            cell = self.tabDataSource.cellWidget(r, c)
            cell.setBackground(background)
    
    def setRowBackgroundColor(self, r, col):
        for c in xrange(self.getColumnCount()):
            self.setCellBackgroundColor(r, c, col)
    
    def getRowData(self, r):
        data = {'templateFile':None,
                'dataSource1File':None,
                'dataSource2File':None,
                'reportFolder':None,
                'reportName':None,
                'descriptorsFile':None}
        templateFileFolder = self.tabDataSource.cellWidget(r, 1).getLabel()
        templateFileName = self.tabDataSource.cellWidget(r, 1).getChoice()
        data['templateFile'] = os.path.join(templateFileFolder, templateFileName)
        dataSource1FileFolder = self.tabDataSource.cellWidget(r, 2).getLabel()
        dataSource1FileName = self.tabDataSource.cellWidget(r, 2).getChoice()
        data['dataSource1File'] = os.path.join(dataSource1FileFolder, dataSource1FileName)
        dataSource2FileFolder = self.tabDataSource.cellWidget(r, 3).getLabel()
        dataSource2FileName = self.tabDataSource.cellWidget(r, 3).getChoice()
        data['dataSource2File'] = os.path.join(dataSource2FileFolder, dataSource2FileName)
        data['reportFolder'] = str(self.tabDataSource.item(r, 4).text())
        data['reportName'] = str(self.tabDataSource.item(r, 5).text())+'.odt'
        descriptorsFileFolder = self.tabDataSource.cellWidget(r, 6).getLabel()
        descriptorsFileName = self.tabDataSource.cellWidget(r, 6).getChoice()
        data['descriptorsFile'] = os.path.join(descriptorsFileFolder, descriptorsFileName)        
        print data
        return data
    
    def showLogViewer(self):
        self.logViewer.show()
            
    def hideLogViewer(self):
        self.logViewer.hide()
    
    def isLogViewerHidden(self):
        return self.logViewer.isHidden()
        
    def connectLogViewerToStdout(self):
        self.logViewer.connectToStdout()

    def connectLogViewerToStderr(self):
        self.logViewer.connectToStderr()
    
    def writeToLogViewer(self, msg):
        self.logViewer.write(msg)
    
    
    
    