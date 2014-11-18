
import PyQt4.QtGui as QtGui
import PyQt4.QtCore as QtCore

import shutil, os

from ReportTools import *

import traceback

from DescriptorsEditor import Application as DE



class Controller():
    
    def __init__(self, view, app, plugins):
        
        # Register view and application
        self.v = view
        self.app = app
        self.plugins = plugins
        
        # Set log viewer
        #self.v.connectLogViewerToStdout()
        
        # Register callbacks
        self.v.buttFillCellsChoice.clicked.connect(self.fillCellsFromTree)
        self.v.buttFillCellsRepDir.clicked.connect(self.fillCellsRepDir) 
        self.v.buttFillTemplates.clicked.connect(self.fillTemplates)
        self.v.actShowHideLogViewer.triggered.connect(self.showHideLogViewer)
        self.v.actShowDescriptorsEditor.triggered.connect(self.showDescriptorsEditor)
        
        # Set quit function for view
        self.v.setQuitFun(self.quitApp)
        
        # Show view
        self.v.show()
        
        # Set last opened folders
        self.templateLastDir = ''
        self.dataSourceLastDir = ''
        self.reportFolderLastDir = ''
        
        # Create all the tools (that have a MVC pattern)
        self.descriptorsEditor = DE(self.plugins)
        
    
    def quitApp(self):
        # Ask to the user the confirmation
        reply = QtGui.QMessageBox.question(self.v, 'Quit',
            "Are you sure to quit?", QtGui.QMessageBox.Yes | 
            QtGui.QMessageBox.No, QtGui.QMessageBox.No)
        if reply == QtGui.QMessageBox.Yes:
            toQuit = True
        else:
            toQuit = False
        # Perform quitting actions
        if toQuit == True:
            QtCore.QCoreApplication.instance().quit()
            print 'exit...'
        return toQuit
        
        
    def fillCellsFromTree(self):
        # Check if at least one cell is selected
        if self.v.getHlCellsCount() == 0:
            QtGui.QMessageBox.critical(None, "Cell selection","Select at least one cell first")
            return  
        # Get highligthed columns
        columnIdxs = self.v.getHlCellsColumns()
        # Check if the user mistakenly selected a cell relative to report
        reportDirColumnIdx = 4
        reportNameColumnIdx = 5
        procColumnIdx = 0
        if reportDirColumnIdx in columnIdxs or reportNameColumnIdx in columnIdxs or procColumnIdx in columnIdxs:
            QtGui.QMessageBox.critical(None, "Cell selection","Select either template cells, data source cells or descriptors file cells first")
            return   
        # Check if I mistakenly selected a mix of template cells, data source cells or decriptors cells
        if 1 in columnIdxs and not (2 in columnIdxs or 3 in columnIdxs or 6 in columnIdxs):
        # if columnIdxs == [1]
            modality = 'template'
            lastDir = self.templateLastDir
        elif (2 in columnIdxs or 3 in columnIdxs) and not 1 in columnIdxs and not 6 in columnIdxs:
            modality = 'data_source'
            lastDir = self.dataSourceLastDir
        elif 6 in columnIdxs and not (2 in columnIdxs or 3 in columnIdxs or 1 in columnIdxs):
            modality = 'descriptors_file'
            lastDir = self.dataSourceLastDir            
        else:
            QtGui.QMessageBox.critical(None, "Cell selection","Select either only template cells, data source cells or descriptors file cells, not a mix")
            return             
        # Ask for a folder
        treePath = QtGui.QFileDialog.getExistingDirectory( \
            caption='Select directory tree', \
            options=QtGui.QFileDialog.ShowDirsOnly, \
            directory=lastDir)
        treePath = str(treePath)
        if treePath == '':
            print 'No tree selected'
            return
        if modality == 'template':
            self.templateLastDir = treePath
        elif modality == 'data_source':
            self.dataSourceLastDir = treePath
        print 'Selected tree: {0}'.format(treePath)
        # Define the extension to be searched
        if modality == 'template':
            wantedExts = ['.odt']
        elif modality == 'data_source':
            wantedExts = ['.xml','.h5']
        elif modality == 'descriptors_file':
            wantedExts = ['.des']
        # Search all the files with wanted extension in the selected tree
        filesList = []
        for root,folder,files in os.walk(treePath):
            cont = 0.
            for fn in files:
                cont += 1
                pct =  cont / len(files) * 100.
                self.v.setProgGenOpPct(pct)
                fileAbsPath = os.path.join(root,fn)
                fileRelPath = fileAbsPath[len(treePath)+len(os.sep):] #XXX: relative path
                name, ext = os.path.splitext(fn)
                if ext in wantedExts:
                    filesList.append(fileRelPath)
                    msg = fileRelPath
                    self.v.setLabGenOp(msg)
        msg = '{0} file(s) found'.format(len(filesList))
        self.v.setLabGenOp(msg)
        print msg
        # Update the choices for the selected cells
        self.v.setPossibleChoicesForHlCells(filesList)
        self.v.setLabelsForHlCells(treePath)
        print 'cells content updated'
        
    
    def fillCellsRepDir(self):
        # Check if at least one cell is selected
        if self.v.getHlCellsCount() == 0:
            QtGui.QMessageBox.critical(None, "Cell selection","Select at least one cell first")
            return    
        # Check if the user mistakenly selected a cell not in the last column
        columnIdxs = self.v.getHlCellsColumns()
        reportDirColumnIdx = self.v.getColumnCount()-3
        if columnIdxs != [reportDirColumnIdx]:
            QtGui.QMessageBox.critical(None, "Cell selection","Select report folder cells first")
            return            
        # Ask for a folder
        folder = QtGui.QFileDialog.getExistingDirectory( \
            caption='Select directory tree', \
            options=QtGui.QFileDialog.ShowDirsOnly, \
            directory=self.reportFolderLastDir)
        folder = str(folder)
        if folder == '':
            print 'No folder selected'
            return
        self.reportFolderLastDir = folder
        print 'Selected folder: {0}'.format(folder) 
        # Update the report path for selected cells
        self.v.setLabelsForHlCells(folder)
    
    def fillTemplates(self):
        # Get highligthed rows
        checkedRows = self.v.getCheckedRows()
        if len(checkedRows) == 0:
            QtGui.QMessageBox.critical(None, "Row selection","No rows checked")
            return 
        # Reset background color for all the cells of the table
        for r in xrange(self.v.getRowCount()):
            for c in xrange(self.v.getColumnCount()):
                self.v.setCellBackgroundColor(r, c, 'white')
                self.v.setCellBackground(r, c, 'transparent')
        print 'Cell color reset'
        # Get the generators dictionary
        genDict = self.plugins['generators']
        # Fill template for selected rows
        cont = 0.
        for r in checkedRows:
            print '\n\n***Row {0}\n\n'.format(r+1)
            # Set background color to yellow ("in progress")
            self.v.setRowBackgroundColor(r, '#FFFF00')
            # Read data from the current row
            rowData = self.v.getRowData(r)
            # Update message
            self.v.setLabFillTemplates('Creating {0} ...'.format(rowData['reportName']))
            # Process all pending events (needed to refresh the UI)
            self.app.processEvents()
            # Create the report
            tempFolder = os.path.join(rowData['reportFolder'],'temp_report')
            reportPath = os.path.join(rowData['reportFolder'], rowData['reportName'])
            sourceFiles = []
            sourceFiles.append(rowData['dataSource1File'])
            sourceFiles.append(rowData['dataSource2File'])
            descriptorsFile = rowData['descriptorsFile']
            try:
                fillTemplate(rowData['templateFile'], tempFolder, reportPath, sourceFiles, 3, genDict, ldFilePath=descriptorsFile)
                # Set the row color to green
                rowCol = '#00FF00'
                print '{0} succesfully created'.format(rowData['reportName'])
            except:
                # Set the row color to red
                rowCol = '#FF0000'
                msg = traceback.format_exc()
                self.v.writeToLogViewer(msg)
                print '{0} skipped'.format(rowData['reportName'])
                # Delete the folder 'temp_report'
                shutil.rmtree(tempFolder)
            # Color the row
            self.v.setRowBackgroundColor(r, rowCol)
            # Update progress bar
            cont += 1
            pct = cont / len(checkedRows) * 100.
            self.v.setProgFillTemplatesPct(pct)
            # Process all pending events (needed to refresh the UI)
            self.app.processEvents()
        # Update message
        self.v.setLabFillTemplates('Finished!')
    
    def showHideLogViewer(self):
        if self.v.isLogViewerHidden():
            self.v.showLogViewer()
        else:
            self.v.hideLogViewer()  
    
    def showDescriptorsEditor(self):
        self.descriptorsEditor.show()
    
    
    
    
    
    