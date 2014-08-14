
import PyQt4.QtGui as QtGui
import PyQt4.QtCore as QtCore

from ULCommon import *

tabID = 'ID_UL'

defDesc = {}
defDesc['fun'] = 'UL_2DPlot_0_100'
defDesc['title'] = ''
defDesc['x_label'] = ''
defDesc['y_label'] = ''
defDesc['y_range'] = ''
defDesc['pos_y_label'] = ''
defDesc['neg_y_label'] = ''
defDesc['pos_y_label_x'] = ''
defDesc['pos_y_label_pcty'] = ''
defDesc['neg_y_label_x'] = ''
defDesc['neg_y_label_pcty'] = ''
defDesc['show_0_line'] = 'yes'
defDesc['view_ID'] = tabID 

#-----------------------------------------------------------------------        
    
def setCurrentTextForCombo(combo, text):
    idx = combo.findText (text, flags=QtCore.Qt.MatchExactly)
    combo.setCurrentIndex(idx)
    
#-----------------------------------------------------------------------

class ImgDataGroupBox(QtGui.QGroupBox):
    def __init__(self, ID, manager):
        QtGui.QGroupBox.__init__(self)
        
        self.ID = ID
        self.manager = manager
        
        self.setTitle('Data')
        
        self.labelDataPathMode = QtGui.QLabel('Path definition:')
        self.comboDataPathMode = QtGui.QComboBox()
        self.comboDataPathMode.addItem('Direct (Suggested)')
        self.comboDataPathMode.addItem('XPath (Experts only)')
        self.labelDataTask = QtGui.QLabel('Task:')
        self.editDataTask = QtGui.QLineEdit()
        self.labelDataContext = QtGui.QLabel('Context:')
        self.comboDataContext = QtGui.QComboBox()
        self.comboDataContext.addItem('Right') 
        self.comboDataContext.addItem('Left')
        self.comboDataContext.addItem('General')
        self.comboDataContext.addItem('*')
        self.labelDataPhase = QtGui.QLabel('Phase:')
        self.comboDataPhase = QtGui.QComboBox()
        for i in xrange(1,11):
            self.comboDataPhase.addItem('Phase%d'%i)
        self.comboDataPhase.addItem('EntireCycle')
        self.labelDataCurveType = QtGui.QLabel('Curve type:')
        self.comboDataCurveType = QtGui.QComboBox()
        self.comboDataCurveType.addItem('Time-normalized angle')
        self.labelDataCurveName = QtGui.QLabel('Curve name:')
        self.editDataCurveName = QtGui.QLineEdit()     
        self.labelDataPlotType = QtGui.QLabel('Plot type:')
        self.comboDataPlotType = QtGui.QComboBox()
        self.comboDataPlotType.addItem('All curves')
        self.comboDataPlotType.addItem('Mean curve')
        self.labelDataColor = QtGui.QLabel('Color:')
        self.buttDataColor = QtGui.QPushButton()
        self.buttDataColor.setStyleSheet('background-color:rgb(0,0,255)')
        self.labelDataXPath = QtGui.QLabel('XPath:')
        self.editDataXPath = QtGui.QLineEdit()
        self.buttDelData = QtGui.QPushButton('Delete')
        
        self.hBoxDataMng = QtGui.QHBoxLayout()
        self.hBoxDataMng.addStretch(1)
        self.hBoxDataMng.addWidget(self.buttDelData)
        self.gridDataOpts = QtGui.QGridLayout()
        self.gridDataOpts.addWidget(self.labelDataPathMode, 0, 0)
        self.gridDataOpts.addWidget(self.comboDataPathMode, 0, 1)
        self.gridDataOpts.addWidget(self.labelDataTask, 1, 0)
        self.gridDataOpts.addWidget(self.editDataTask, 1, 1)
        self.gridDataOpts.addWidget(self.labelDataContext, 2, 0)
        self.gridDataOpts.addWidget(self.comboDataContext, 2, 1)
        self.gridDataOpts.addWidget(self.labelDataPhase, 3, 0)
        self.gridDataOpts.addWidget(self.comboDataPhase, 3, 1)
        self.gridDataOpts.addWidget(self.labelDataCurveType, 4, 0)
        self.gridDataOpts.addWidget(self.comboDataCurveType, 4, 1)
        self.gridDataOpts.addWidget(self.labelDataCurveName, 5, 0)
        self.gridDataOpts.addWidget(self.editDataCurveName, 5, 1)
        self.gridDataOpts.addWidget(self.labelDataXPath, 6, 0)
        self.gridDataOpts.addWidget(self.editDataXPath, 6, 1)
        self.gridDataOpts.addWidget(self.labelDataColor, 7, 0)
        self.gridDataOpts.addWidget(self.buttDataColor, 7, 1)
        self.gridDataOpts.addWidget(self.labelDataPlotType, 8, 0)
        self.gridDataOpts.addWidget(self.comboDataPlotType, 8, 1)
        self.gridDataOpts.addLayout(self.hBoxDataMng, 9, 1)
        
        self.setLayout(self.gridDataOpts)
        
        self.buttDataColor.clicked.connect(self.changeColor)
        self.buttDelData.clicked.connect(self.delete)
        self.comboDataPathMode.activated.connect(self.uiUpdateForPath)
        
        self.editDataXPath.setEnabled(False)
        
    
    def changeColor(self):       
        color = QtGui.QColorDialog.getColor()
        if color.isValid() == False:
            return
        self.buttDataColor.setStyleSheet('background-color:'+color.name())
    
    def delete(self):
        self.deleteLater()
        self.manager.delDataWithID(self.ID)
    
    def uiUpdateForPath(self, i):
        if i == 0:
            self.editDataTask.setEnabled(True)
            self.comboDataContext.setEnabled(True)
            self.comboDataPhase.setEnabled(True)
            self.comboDataCurveType.setEnabled(True)
            self.editDataCurveName.setEnabled(True)
            self.editDataXPath.setEnabled(False)
        elif i == 1:
            self.editDataTask.setEnabled(False)
            self.comboDataContext.setEnabled(False)
            self.comboDataPhase.setEnabled(False)
            self.comboDataCurveType.setEnabled(False)
            self.editDataCurveName.setEnabled(False)
            self.editDataXPath.setEnabled(True)
    
    def getContent(self):
        data = {}
        ID = self.ID
        if self.comboDataPathMode.currentIndex() == 0:
            data['task_data_'+ID] = str(self.editDataTask.text())
            data['context_data_'+ID] = str(self.comboDataContext.currentText())
            data['phase_data_'+ID] = str(self.comboDataPhase.currentText())
            data['curve_type_data_'+ID] = str(self.comboDataCurveType.currentText())
            data['curve_name_data_'+ID] = str(self.editDataCurveName.text())
        elif self.comboDataPathMode.currentIndex() == 1:
            data['data_'+ID] = str(self.editDataXPath.text())
        color = self.buttDataColor.palette().color(1).getRgb()[:-1]
        data['color_rgb_data_'+ID] = str(color)
        plotTypeIdx = self.comboDataPlotType.currentIndex()
        if plotTypeIdx == 0:
            data['plot_type_data_'+ID] = 'all_curves'
        elif plotTypeIdx == 1:
            data['plot_type_data_'+ID] = 'mean_curve'
        return data
            
    def setContent(self, data):
        ID = self.ID
        if 'data_'+ID in data:
            self.editDataXPath.setText(data['data_'+ID])
            self.comboDataPathMode.setCurrentIndex(1)
            self.uiUpdateForPath(1)
        else:
            self.editDataTask.setText(data['task_data_'+ID])
            setCurrentTextForCombo(self.comboDataContext, data['context_data_'+ID])
            setCurrentTextForCombo(self.comboDataPhase, data['phase_data_'+ID])
            setCurrentTextForCombo(self.comboDataCurveType, data['curve_type_data_'+ID])
            self.editDataCurveName.setText(data['curve_name_data_'+ID])
            self.comboDataPathMode.setCurrentIndex(0)
            self.uiUpdateForPath(0)
        self.buttDataColor.setStyleSheet('background-color:rgb('+data['color_rgb_data_'+ID][1:-1]+')')
        if data['plot_type_data_'+ID] == 'mean_curve':
            self.comboDataPlotType.setCurrentIndex(1)
        elif data['plot_type_data_'+ID] == 'all_curves':
            self.comboDataPlotType.setCurrentIndex(0)
            
    

class ImgCtrlDataGroupBox(QtGui.QGroupBox):
    def __init__(self, ID, manager):
        QtGui.QGroupBox.__init__(self)  
        
        self.ID = ID
        self.manager = manager
        
        self.setTitle('Control data')
        
        self.labelCtrlDataPathMode = QtGui.QLabel('Path definition:')
        self.comboCtrlDataPathMode = QtGui.QComboBox()
        self.comboCtrlDataPathMode.addItem('Direct (Suggested)')
        self.comboCtrlDataPathMode.addItem('XPath (Experts only)')
        self.labelCtrlDataTask = QtGui.QLabel('Task:')
        self.editCtrlDataTask = QtGui.QLineEdit()
        self.labelCtrlDataPhase = QtGui.QLabel('Phase:')
        self.comboCtrlDataPhase = QtGui.QComboBox()
        for i in xrange(1,11):
            self.comboCtrlDataPhase.addItem('Phase%d'%i)
        self.comboCtrlDataPhase.addItem('EntireCycle')
        self.labelCtrlDataCurveType = QtGui.QLabel('Curve type:')
        self.comboCtrlDataCurveType = QtGui.QComboBox()
        self.comboCtrlDataCurveType.addItem('Angle')
        self.labelCtrlDataCurveName = QtGui.QLabel('Curve name:')
        self.editCtrlDataCurveName = QtGui.QLineEdit()   
        self.labelCtrlDataColor = QtGui.QLabel('Color:')
        self.buttCtrlDataColor = QtGui.QPushButton()
        self.buttCtrlDataColor.setStyleSheet('background-color:rgb(170,170,255)')
        self.labelCtrlDataXPath = QtGui.QLabel('XPath:')
        self.editCtrlDataXPath = QtGui.QLineEdit() 
        self.labelShowCtrlDataMean = QtGui.QLabel('Show mean curve:')
        self.bgShowCtrlDataMean = QtGui.QButtonGroup()
        self.bgShowCtrlDataMean.setExclusive(True)
        self.rbShowCtrlDataMeanYes = QtGui.QRadioButton('Yes')
        self.rbShowCtrlDataMeanNo = QtGui.QRadioButton('No')
        self.bgShowCtrlDataMean.addButton(self.rbShowCtrlDataMeanYes)
        self.bgShowCtrlDataMean.addButton(self.rbShowCtrlDataMeanNo)
        self.rbShowCtrlDataMeanYes.setChecked(True)
        self.hBoxShowCtrlDataMean = QtGui.QHBoxLayout()
        self.buttDelCtrlData = QtGui.QPushButton('Delete')

        self.hBoxCtrlDataMng = QtGui.QHBoxLayout()
        self.hBoxCtrlDataMng.addStretch(1)
        self.hBoxCtrlDataMng.addWidget(self.buttDelCtrlData)
        self.gridCtrlDataOpts = QtGui.QGridLayout()   
        self.gridCtrlDataOpts.addWidget(self.labelCtrlDataPathMode, 0, 0)
        self.gridCtrlDataOpts.addWidget(self.comboCtrlDataPathMode, 0, 1)
        self.gridCtrlDataOpts.addWidget(self.labelCtrlDataTask, 1, 0)
        self.gridCtrlDataOpts.addWidget(self.editCtrlDataTask, 1, 1)
        self.gridCtrlDataOpts.addWidget(self.labelCtrlDataPhase, 2, 0)
        self.gridCtrlDataOpts.addWidget(self.comboCtrlDataPhase, 2, 1)
        self.gridCtrlDataOpts.addWidget(self.labelCtrlDataCurveType, 3, 0)
        self.gridCtrlDataOpts.addWidget(self.comboCtrlDataCurveType, 3, 1)
        self.gridCtrlDataOpts.addWidget(self.labelCtrlDataCurveName, 4, 0)
        self.gridCtrlDataOpts.addWidget(self.editCtrlDataCurveName, 4, 1)
        self.gridCtrlDataOpts.addWidget(self.labelCtrlDataXPath, 5, 0)
        self.gridCtrlDataOpts.addWidget(self.editCtrlDataXPath, 5, 1)
        self.gridCtrlDataOpts.addWidget(self.labelCtrlDataColor, 6, 0)
        self.gridCtrlDataOpts.addWidget(self.buttCtrlDataColor, 6, 1)
        self.gridCtrlDataOpts.addWidget(self.labelShowCtrlDataMean, 7, 0)
        self.hBoxShowCtrlDataMean.addWidget(self.rbShowCtrlDataMeanYes)
        self.hBoxShowCtrlDataMean.addWidget(self.rbShowCtrlDataMeanNo)
        self.hBoxShowCtrlDataMean.addStretch(1)
        self.gridCtrlDataOpts.addLayout(self.hBoxShowCtrlDataMean, 7, 1)
        self.gridCtrlDataOpts.addLayout(self.hBoxCtrlDataMng, 8, 1)
        
        self.setLayout(self.gridCtrlDataOpts)
        
        self.buttCtrlDataColor.clicked.connect(self.changeColor)
        self.buttDelCtrlData.clicked.connect(self.delete)
        self.comboCtrlDataPathMode.activated.connect(self.uiUpdateForPath)
        
        self.editCtrlDataXPath.setEnabled(False)
        
    
    def changeColor(self):
        color = QtGui.QColorDialog.getColor()
        if color.isValid() == False:
            return
        self.buttCtrlDataColor.setStyleSheet('background-color:'+color.name())
    
    def delete(self):
        self.deleteLater()
        self.manager.delCtrlDataWithID(self.ID)
        
    def uiUpdateForPath(self, i):
        if i == 0:
            self.editCtrlDataTask.setEnabled(True)
            self.comboCtrlDataPhase.setEnabled(True)
            self.comboCtrlDataCurveType.setEnabled(True)
            self.editCtrlDataCurveName.setEnabled(True)
            self.editCtrlDataXPath.setEnabled(False)
        elif i == 1:
            self.editCtrlDataTask.setEnabled(False)
            self.comboCtrlDataPhase.setEnabled(False)
            self.comboCtrlDataCurveType.setEnabled(False)
            self.editCtrlDataCurveName.setEnabled(False)
            self.editCtrlDataXPath.setEnabled(True)
    
    def getContent(self):
        data = {}
        ID = self.ID
        if self.comboCtrlDataPathMode.currentIndex() == 0:
            data['task_ctrl_data_'+ID] = str(self.editCtrlDataTask.text())
            data['phase_ctrl_data_'+ID] = str(self.comboCtrlDataPhase.currentText())
            data['curve_type_ctrl_data_'+ID] = str(self.comboCtrlDataCurveType.currentText())
            data['curve_name_ctrl_data_'+ID] = str(self.editCtrlDataCurveName.text())
        elif self.comboCtrlDataPathMode.currentIndex() == 1:
            data['ctrl_data_'+ID] = str(self.editCtrlDataXPath.text())
        color = self.buttCtrlDataColor.palette().color(1).getRgb()[:-1]
        data['color_rgb_ctrl_data_'+ID] = str(color)
        if self.rbShowCtrlDataMeanYes.isChecked() == True:
            data['show_mean_ctrl_data_'+ID] = 'yes'
        else:
            data['show_mean_ctrl_data_'+ID] = 'no'
        return data
        
    def setContent(self, data):
        # NOTE: in this section there should be" try - except" blocks for every
        # key in the data dictionary. This to ease the update of the dictionary/view
        ID = self.ID
        if 'ctrl_data_'+ID in data:
            self.editCtrlDataXPath.setText(data['ctrl_data_'+ID])
            self.comboCtrlDataPathMode.setCurrentIndex(1)
            self.uiUpdateForPath(1)
        else:
            self.editCtrlDataTask.setText(data['task_ctrl_data_'+ID])
            setCurrentTextForCombo(self.comboCtrlDataPhase, data['phase_ctrl_data_'+ID])
            setCurrentTextForCombo(self.comboCtrlDataCurveType, data['curve_type_ctrl_data_'+ID])
            self.editCtrlDataCurveName.setText(data['curve_name_ctrl_data_'+ID])
            self.comboCtrlDataPathMode.setCurrentIndex(0)
            self.uiUpdateForPath(0)
        self.buttCtrlDataColor.setStyleSheet('background-color:rgb('+data['color_rgb_ctrl_data_'+ID][1:-1]+')')
        if data['show_mean_ctrl_data_'+ID] == 'yes':
            self.rbShowCtrlDataMeanYes.setChecked(True)
        else:
            self.rbShowCtrlDataMeanNo.setChecked(True)
        

class ImgVlinesGroupBox(QtGui.QGroupBox):
    def __init__(self, ID, manager):
        QtGui.QGroupBox.__init__(self) 
        
        self.ID = ID
        self.manager = manager
        
        self.setTitle('Vertical lines')
        
        self.labelVlinesPathMode = QtGui.QLabel('Path definition:')
        self.comboVlinesPathMode = QtGui.QComboBox()
        self.comboVlinesPathMode.addItem('Direct (Suggested)')
        self.comboVlinesPathMode.addItem('XPath (Experts only)')
        self.labelVlinesEvName = QtGui.QLabel('Event:')
        self.editVlinesEvName = QtGui.QLineEdit()
        self.labelVlinesFirstEvName = QtGui.QLabel('Event at 0 %:')
        self.editVlinesFirstEvName = QtGui.QLineEdit()
        self.labelVlinesLastEvName = QtGui.QLabel('Event at 100 %:')
        self.editVlinesLastEvName = QtGui.QLineEdit()
        self.labelVlinesTask = QtGui.QLabel('Task:')
        self.editVlinesTask = QtGui.QLineEdit()
        self.labelVlinesContext = QtGui.QLabel('Context:')
        self.comboVlinesContext = QtGui.QComboBox()
        self.comboVlinesContext.addItem('Right') 
        self.comboVlinesContext.addItem('Left')
        self.comboVlinesContext.addItem('*')
        self.labelVlinesPhase = QtGui.QLabel('Phase:')
        self.comboVlinesPhase = QtGui.QComboBox()
        for i in xrange(1,11):
            self.comboVlinesPhase.addItem('Phase%d'%i)
        self.comboVlinesPhase.addItem('EntireCycle')
        self.labelVlinesColor = QtGui.QLabel('Color:')
        self.buttVlinesColor = QtGui.QPushButton()
        self.buttVlinesColor.setStyleSheet('background-color:rgb(0,0,0)')
        self.labelVlinesXPath = QtGui.QLabel('XPath:')
        self.editVlinesXPath = QtGui.QLineEdit() 
        self.editVlinesXPath = QtGui.QLineEdit() 
        self.buttDelVlinesData = QtGui.QPushButton('Delete')

        self.hBoxVlinesMng = QtGui.QHBoxLayout()
        self.hBoxVlinesMng.addStretch(1)
        self.hBoxVlinesMng.addWidget(self.buttDelVlinesData)
        self.gridVlinesOpts = QtGui.QGridLayout()  
        self.gridVlinesOpts.addWidget(self.labelVlinesPathMode, 0, 0)
        self.gridVlinesOpts.addWidget(self.comboVlinesPathMode, 0, 1)
        self.gridVlinesOpts.addWidget(self.labelVlinesEvName, 1, 0)
        self.gridVlinesOpts.addWidget(self.editVlinesEvName, 1, 1)
        self.gridVlinesOpts.addWidget(self.labelVlinesFirstEvName, 2, 0)
        self.gridVlinesOpts.addWidget(self.editVlinesFirstEvName, 2, 1)
        self.gridVlinesOpts.addWidget(self.labelVlinesLastEvName, 3, 0)
        self.gridVlinesOpts.addWidget(self.editVlinesLastEvName, 3, 1)
        self.gridVlinesOpts.addWidget(self.labelVlinesTask, 4, 0)
        self.gridVlinesOpts.addWidget(self.editVlinesTask, 4, 1)
        self.gridVlinesOpts.addWidget(self.labelVlinesContext, 5, 0)
        self.gridVlinesOpts.addWidget(self.comboVlinesContext, 5, 1)
        self.gridVlinesOpts.addWidget(self.labelVlinesPhase, 6, 0)
        self.gridVlinesOpts.addWidget(self.comboVlinesPhase, 6, 1)
        self.gridVlinesOpts.addWidget(self.labelVlinesXPath, 7, 0)
        self.gridVlinesOpts.addWidget(self.editVlinesXPath, 7, 1)
        self.gridVlinesOpts.addWidget(self.labelVlinesColor, 8, 0)
        self.gridVlinesOpts.addWidget(self.buttVlinesColor, 8, 1)
        self.gridVlinesOpts.addLayout(self.hBoxVlinesMng, 9, 1)
        
        self.setLayout(self.gridVlinesOpts)
        
        self.buttVlinesColor.clicked.connect(self.changeColor)
        self.buttDelVlinesData.clicked.connect(self.delete)
        self.comboVlinesPathMode.activated.connect(self.uiUpdateForPath)
        
        self.editVlinesXPath.setEnabled(False)
        
    
    def changeColor(self):    
        color = QtGui.QColorDialog.getColor()
        if color.isValid() == False:
            return
        self.buttVlinesColor.setStyleSheet('background-color:'+color.name())
    
    def delete(self):
        self.deleteLater()
        self.manager.delVlinesWithID(self.ID)

    def uiUpdateForPath(self, i):
        if i == 0:
            self.editVlinesEvName.setEnabled(True)
            self.editVlinesFirstEvName.setEnabled(True)
            self.editVlinesLastEvName.setEnabled(True)
            self.editVlinesTask.setEnabled(True)
            self.comboVlinesContext.setEnabled(True)
            self.comboVlinesPhase.setEnabled(True)
            self.editVlinesXPath.setEnabled(False)
        elif i == 1:
            self.editVlinesEvName.setEnabled(False)
            self.editVlinesFirstEvName.setEnabled(False)
            self.editVlinesLastEvName.setEnabled(False)
            self.editVlinesTask.setEnabled(False)
            self.comboVlinesContext.setEnabled(False)
            self.comboVlinesPhase.setEnabled(False)
            self.editVlinesXPath.setEnabled(True)
    
    def getContent(self):
        data = {}
        ID = self.ID
        if self.comboVlinesPathMode.currentIndex() == 0:
            data['name_vline_'+ID] = str(self.editVlinesEvName.text())
            data['name_vline_first_'+ID] = str(self.editVlinesFirstEvName.text())
            data['name_vline_last_'+ID] = str(self.editVlinesLastEvName.text())
            data['task_vline_'+ID] = str(self.editVlinesTask.text())
            data['context_vline_'+ID] = str(self.comboVlinesContext.currentText())
            data['phase_vline_'+ID] = str(self.comboVlinesPhase.currentText())
        elif self.comboVlinesPathMode.currentIndex() == 1:
            data['vline_'+ID] = str(self.editVlinesXPath.text())
        color = self.buttVlinesColor.palette().color(1).getRgb()[:-1]
        data['color_rgb_vline_'+ID] = str(color)
        return data
    
    def setContent(self, data):
        ID = self.ID
        if 'vline_'+ID in data:
            self.editVlinesXPath.setText(data['vline_'+ID])
            self.comboVlinesPathMode.setCurrentIndex(1)
            self.uiUpdateForPath(1)
        else:
            self.editVlinesEvName.setText(data['name_vline_'+ID])
            self.editVlinesFirstEvName.setText(data['name_vline_first_'+ID])
            self.editVlinesLastEvName.setText(data['name_vline_last_'+ID])
            self.editVlinesTask.setText(data['task_vline_'+ID])
            setCurrentTextForCombo(self.comboVlinesContext, data['context_vline_'+ID])
            setCurrentTextForCombo(self.comboVlinesPhase, data['phase_vline_'+ID])
            self.comboVlinesPathMode.setCurrentIndex(0)
            self.uiUpdateForPath(0)
        self.buttVlinesColor.setStyleSheet('background-color:rgb('+data['color_rgb_vline_'+ID][1:-1]+')')


class ULImageTab(QtGui.QWidget):
    
    def __init__(self):
        QtGui.QWidget.__init__(self)
        
        # ---Create non layout widgets
        # General options
        self.labelTitle = QtGui.QLabel('Title (opt):')
        self.editTitle = QtGui.QLineEdit()
        self.labelXLabel = QtGui.QLabel('X-Label (opt):')
        self.editXLabel = QtGui.QLineEdit()
        self.labelYLabel = QtGui.QLabel('Y-Label (opt):')
        self.editYLabel = QtGui.QLineEdit()
        self.labelYRange = QtGui.QLabel('Y-Range (opt):')
        self.editYRange = QtGui.QLineEdit()
        self.labelPosYLabel = QtGui.QLabel('Positive Y-Label (opt):')
        self.editPosYLabel = QtGui.QLineEdit()
        self.labelNegYLabel = QtGui.QLabel('Negative Y-Label (opt):')
        self.editNegYLabel = QtGui.QLineEdit()
        self.labelPosYLabelX = QtGui.QLabel('Positive Y-Label X (opt):')
        self.editPosYLabelX = QtGui.QLineEdit()
        self.labelPosYLabelYpct = QtGui.QLabel('Positive Y-Label Y % (opt):')
        self.editPosYLabelYpct = QtGui.QLineEdit()
        self.labelNegYLabelX = QtGui.QLabel('Negative Y-Label X (opt):')
        self.editNegYLabelX = QtGui.QLineEdit()
        self.labelNegYLabelYpct = QtGui.QLabel('Negative Y-Label Y % (opt):')
        self.editNegYLabelYpct = QtGui.QLineEdit()
        self.labelShowYZeroLine = QtGui.QLabel('Show Y=0 line:')
        self.bgShowYZeroLine = QtGui.QButtonGroup()
        self.bgShowYZeroLine.setExclusive(True)
        self.rbShowYZeroLineYes = QtGui.QRadioButton('Yes')
        self.rbShowYZeroLineNo = QtGui.QRadioButton('No')
        self.bgShowYZeroLine.addButton(self.rbShowYZeroLineYes)
        self.bgShowYZeroLine.addButton(self.rbShowYZeroLineNo)
        self.rbShowYZeroLineYes.setChecked(True)
        
        # Data paths add buttons
        self.buttAddData = QtGui.QPushButton('Add data')
        self.buttAddCtrlData = QtGui.QPushButton('Add control data')
        self.buttAddVlinesData = QtGui.QPushButton('Add v. lines data')
        
        
        # Data paths
        self.gbDataOpts = {}
        self.gbCtrlDataOpts = {}
        self.gbVlinesOpts = {}
        
        
        # ---Create layout widgets
        self.vBox = QtGui.QVBoxLayout()
        self.gridGenOpts = QtGui.QGridLayout()
        self.hBoxDataMng = QtGui.QHBoxLayout()
        

        # ---Organize non-layout widgets
        # General options
        self.gridGenOpts.addWidget(self.labelTitle, 0, 0, 1, 2) 
        self.gridGenOpts.addWidget(self.editTitle, 0, 1, 1, 2) 
        self.gridGenOpts.addWidget(self.labelXLabel, 1, 0, 1, 2) 
        self.gridGenOpts.addWidget(self.editXLabel, 1, 1, 1, 2)  
        self.gridGenOpts.addWidget(self.labelYLabel, 2, 0, 1, 2) 
        self.gridGenOpts.addWidget(self.editYLabel, 2, 1, 1, 2)
        self.gridGenOpts.addWidget(self.labelYRange, 3, 0, 1, 2) 
        self.gridGenOpts.addWidget(self.editYRange, 3, 1, 1, 2)
        self.gridGenOpts.addWidget(self.labelPosYLabel, 4, 0, 1, 2) 
        self.gridGenOpts.addWidget(self.editPosYLabel, 4, 1, 1, 2) 
        self.gridGenOpts.addWidget(self.labelNegYLabel, 5, 0, 1, 2) 
        self.gridGenOpts.addWidget(self.editNegYLabel, 5, 1, 1, 2) 
        self.gridGenOpts.addWidget(self.labelPosYLabelX, 6, 0, 1, 2)
        self.gridGenOpts.addWidget(self.editPosYLabelX, 6, 1, 1, 2)
        self.gridGenOpts.addWidget(self.labelPosYLabelYpct, 7, 0, 1, 2)
        self.gridGenOpts.addWidget(self.editPosYLabelYpct, 7, 1, 1, 2) 
        self.gridGenOpts.addWidget(self.labelNegYLabelX, 8, 0, 1, 2)
        self.gridGenOpts.addWidget(self.editNegYLabelX, 8, 1, 1, 2)
        self.gridGenOpts.addWidget(self.labelNegYLabelYpct, 9, 0, 1, 2)
        self.gridGenOpts.addWidget(self.editNegYLabelYpct, 9, 1, 1, 2) 
        self.gridGenOpts.addWidget(self.labelShowYZeroLine, 10, 0, 1, 2)
        self.gridGenOpts.addWidget(self.rbShowYZeroLineYes, 10, 1)
        self.gridGenOpts.addWidget(self.rbShowYZeroLineNo, 10, 2)       
        
        # Data paths add buttons
        self.hBoxDataMng.addStretch(1)
        self.hBoxDataMng.addWidget(self.buttAddData)
        self.hBoxDataMng.addWidget(self.buttAddCtrlData)
        self.hBoxDataMng.addWidget(self.buttAddVlinesData)
        
        # ---Organize layout widgets
        self.vBox.addLayout(self.gridGenOpts)
        self.vBox.addLayout(self.hBoxDataMng)
        self.vBox.addStretch(1)

        
        # ---Add scroll bars
        self.cWidget = QtGui.QWidget()
        self.scroll = QtGui.QScrollArea()
        self.scroll.setWidget(self.cWidget)
        self.scroll.setWidgetResizable(True)
        self.cWidget.setLayout(self.vBox)
        self.mainLayout = QtGui.QVBoxLayout()
        self.mainLayout.addWidget(self.scroll)
        self.setLayout(self.mainLayout)
        
        # Register callbacks
        self.buttAddData.clicked.connect(lambda: self.addData(-1))
        self.buttAddCtrlData.clicked.connect(lambda: self.addCtrlData(-1))
        self.buttAddVlinesData.clicked.connect(lambda: self.addVlinesData(-1))
        
      
    def removeLastStretch(self):
        stretch = self.vBox.itemAt(self.vBox.count()-1)
        self.vBox.removeItem(stretch)         

    def addData(self, N):
        self.removeLastStretch()  
        if N < 0:
            N = str(len(self.gbDataOpts.keys()))
        groupBox = ImgDataGroupBox(N, self)
        self.gbDataOpts.update([(N,groupBox)])
        self.vBox.addWidget(groupBox)
        self.vBox.addStretch(1)
        
    def addCtrlData(self, N):
        self.removeLastStretch()  
        if N < 0:
            N = str(len(self.gbCtrlDataOpts.keys()))
        groupBox = ImgCtrlDataGroupBox(N, self)
        self.gbCtrlDataOpts.update([(N,groupBox)])
        self.vBox.addWidget(groupBox)
        self.vBox.addStretch(1)
        
    def addVlinesData(self, N):
        self.removeLastStretch()  
        if N < 0:
            N = str(len(self.gbVlinesOpts.keys()))
        groupBox = ImgVlinesGroupBox(N, self)
        self.gbVlinesOpts.update([(N,groupBox)])
        self.vBox.addWidget(groupBox)
        self.vBox.addStretch(1)
    
    def addGroupBoxes(self, ID):
        for i in ID['data']:
            self.addData(i)
        for i in ID['ctrl_data']:
            self.addCtrlData(i)  
        for i in ID['vline']:
            self.addVlinesData(i)
    
    def delDataWithID(self, ID):
        del self.gbDataOpts[ID]

    def delCtrlDataWithID(self, ID):
        del self.gbCtrlDataOpts[ID]

    def delVlinesWithID(self, ID):
        del self.gbVlinesOpts[ID]
    
    def getContent(self):
        data = {}
        # Get content from general options
        data['title'] = str(self.editTitle.text())
        data['x_label'] = str(self.editXLabel.text())
        data['y_label'] = str(self.editYLabel.text())
        data['y_range'] = str(self.editYRange.text())
        data['pos_y_label'] = str(self.editPosYLabel.text())
        data['neg_y_label'] = str(self.editNegYLabel.text())
        data['pos_y_label_x'] = str(self.editPosYLabelX.text())
        data['pos_y_label_pcty'] = str(self.editPosYLabelYpct.text())
        data['neg_y_label_x'] = str(self.editNegYLabelX.text())
        data['neg_y_label_pcty'] = str(self.editNegYLabelYpct.text())
        if self.rbShowYZeroLineYes.isChecked() == True:
            data['show_0_line'] = 'yes'
        else:
            data['show_0_line'] = 'no'
        # Get content from cascading panels
        for i in self.gbDataOpts.keys():
            newData = self.gbDataOpts[i].getContent()
            data.update(newData)
        for i in self.gbCtrlDataOpts.keys():
            newData = self.gbCtrlDataOpts[i].getContent()
            data.update(newData)
        for i in self.gbVlinesOpts.keys():
            newData = self.gbVlinesOpts[i].getContent()
            data.update(newData)
        return data
    
    def deleteAllGroupBoxes(self):
        for i in self.gbDataOpts.keys():
            self.gbDataOpts[i].delete()
        for i in self.gbCtrlDataOpts.keys():
            self.gbCtrlDataOpts[i].delete()
        for i in self.gbVlinesOpts.keys():
            self.gbVlinesOpts[i].delete()
    
    def setContentForAllGroupBoxes(self, data):
        for i in self.gbDataOpts.keys():
            self.gbDataOpts[i].setContent(data)
        for i in self.gbCtrlDataOpts.keys():
            self.gbCtrlDataOpts[i].setContent(data)
        for i in self.gbVlinesOpts.keys():
            self.gbVlinesOpts[i].setContent(data)
    
        
    def setContent(self, data):
        # Set content for general options
        self.editTitle.setText(data['title'])
        self.editXLabel.setText(data['x_label'])
        self.editYLabel.setText(data['y_label'])
        self.editYRange.setText(data['y_range'])
        self.editPosYLabel.setText(data['pos_y_label'])
        self.editNegYLabel.setText(data['neg_y_label'])
        self.editPosYLabelX.setText(data['pos_y_label_x'])
        self.editPosYLabelYpct.setText(data['pos_y_label_pcty'])
        self.editNegYLabelX.setText(data['neg_y_label_x'])
        self.editNegYLabelYpct.setText(data['neg_y_label_pcty'])
        if data['show_0_line'] == 'yes':
            self.rbShowYZeroLineYes.setChecked(True)
        else:
            self.rbShowYZeroLineNo.setChecked(True)
        # Clear all the panels
        self.deleteAllGroupBoxes()
        # Determine the number of panels for each type
        ID = getDataSourceIDsFromDesc(data, 'image')
        # Add necessary panels
        self.addGroupBoxes(ID)
        # Set content for cascading panels
        self.setContentForAllGroupBoxes(data)
        
        
#-----------------------------------------------------------------------

class TxtPntDataGroupBox(QtGui.QGroupBox):
    def __init__(self, ID, manager):
        QtGui.QGroupBox.__init__(self)
        
        self.ID = ID
        self.manager = manager
        
        self.setTitle('Point data')
        
        self.labelDataPathMode = QtGui.QLabel('Path definition:')
        self.comboDataPathMode = QtGui.QComboBox()
        self.comboDataPathMode.addItem('Direct (Suggested)')
        self.comboDataPathMode.addItem('XPath (Experts only)')
        self.labelDataTask = QtGui.QLabel('Task:')
        self.editDataTask = QtGui.QLineEdit()
        self.labelDataContext = QtGui.QLabel('Context:')
        self.comboDataContext = QtGui.QComboBox()
        self.comboDataContext.addItem('Right') 
        self.comboDataContext.addItem('Left')
        self.comboDataContext.addItem('General')
        self.comboDataContext.addItem('*')
        self.labelDataPhase = QtGui.QLabel('Phase:')
        self.comboDataPhase = QtGui.QComboBox()
        for i in xrange(1,11):
            self.comboDataPhase.addItem('Phase%d'%i)
        self.comboDataPhase.addItem('EntireCycle')
        self.labelDataParSection = QtGui.QLabel('Parameter type:')
        self.comboDataParSection = QtGui.QComboBox()
        self.comboDataParSection.addItem('timing')
        self.comboDataParSection.addItem('speed')
        self.comboDataParSection.addItem('trajectory')
        self.labelDataPoint = QtGui.QLabel('Point:')
        self.editDataPoint = QtGui.QLineEdit() 
        self.labelDataParName = QtGui.QLabel('Parameter name:')
        self.comboDataParName = QtGui.QComboBox()
        self.comboDataParName.addItem('duration')
        self.comboDataParName.addItem('percentage timing')
        self.comboDataParName.addItem('time of max velocity')
        self.labelDataTextType = QtGui.QLabel('Text type:')
        self.comboDataTextType = QtGui.QComboBox()
        self.comboDataTextType.addItem('Mean value')
        self.comboDataTextType.addItem('Std dev value')
        self.labelDataXPath = QtGui.QLabel('XPath:')
        self.editDataXPath = QtGui.QLineEdit()
        self.buttDelData = QtGui.QPushButton('Delete')
        
        self.hBoxDataMng = QtGui.QHBoxLayout()
        self.hBoxDataMng.addStretch(1)
        self.hBoxDataMng.addWidget(self.buttDelData)
        self.gridDataOpts = QtGui.QGridLayout()
        self.gridDataOpts.addWidget(self.labelDataPathMode, 0, 0)
        self.gridDataOpts.addWidget(self.comboDataPathMode, 0, 1)
        self.gridDataOpts.addWidget(self.labelDataTask, 1, 0)
        self.gridDataOpts.addWidget(self.editDataTask, 1, 1)
        self.gridDataOpts.addWidget(self.labelDataContext, 2, 0)
        self.gridDataOpts.addWidget(self.comboDataContext, 2, 1)
        self.gridDataOpts.addWidget(self.labelDataPhase, 3, 0)
        self.gridDataOpts.addWidget(self.comboDataPhase, 3, 1)
        self.gridDataOpts.addWidget(self.labelDataParSection, 4, 0)
        self.gridDataOpts.addWidget(self.comboDataParSection, 4, 1)
        self.gridDataOpts.addWidget(self.labelDataPoint, 5, 0)
        self.gridDataOpts.addWidget(self.editDataPoint, 5, 1)
        self.gridDataOpts.addWidget(self.labelDataParName, 6, 0)
        self.gridDataOpts.addWidget(self.comboDataParName, 6, 1)
        self.gridDataOpts.addWidget(self.labelDataXPath, 7, 0)
        self.gridDataOpts.addWidget(self.editDataXPath, 7, 1)
        self.gridDataOpts.addWidget(self.labelDataTextType, 8, 0)
        self.gridDataOpts.addWidget(self.comboDataTextType, 8, 1)
        self.gridDataOpts.addLayout(self.hBoxDataMng, 9, 1)
        
        self.setLayout(self.gridDataOpts)
        
        self.buttDelData.clicked.connect(self.delete)
        self.comboDataPathMode.activated.connect(self.uiUpdateForPath)
        self.comboDataParSection.activated.connect(self.changeParNames)
        
        self.editDataXPath.setEnabled(False)
        
    
    def delete(self):
        self.deleteLater()
        self.manager.delPntDataWithID(self.ID)
    
    def uiUpdateForPath(self, i):
        if i == 0:
            self.editDataTask.setEnabled(True)
            self.comboDataContext.setEnabled(True)
            self.comboDataPhase.setEnabled(True)
            self.comboDataParSection.setEnabled(True)
            self.editDataPoint.setEnabled(True)
            self.comboDataParName.setEnabled(True)
            self.editDataXPath.setEnabled(False)
        elif i == 1:
            self.editDataTask.setEnabled(False)
            self.comboDataContext.setEnabled(False)
            self.comboDataPhase.setEnabled(False)
            self.comboDataParSection.setEnabled(False)
            self.editDataPoint.setEnabled(False)
            self.comboDataParName.setEnabled(False)
            self.editDataXPath.setEnabled(True)
    
    def changeParNames(self, i):
        parSectionIdx = self.comboDataParSection.currentIndex()
        self.comboDataParName.clear()
        if parSectionIdx == 0: # timing
            self.comboDataParName.addItem('duration')
            self.comboDataParName.addItem('percentage timing')
            self.comboDataParName.addItem('time of max velocity')
        elif parSectionIdx == 1: # speed
            self.comboDataParName.addItem('max velocity')
        elif parSectionIdx == 2: # trajectory
            self.comboDataParName.addItem('trajectory')
        
    
    def getContent(self):
        data = {}
        ID = self.ID
        if self.comboDataPathMode.currentIndex() == 0:
            data['task_data_'+ID] = str(self.editDataTask.text())
            data['context_data_'+ID] = str(self.comboDataContext.currentText())
            data['phase_data_'+ID] = str(self.comboDataPhase.currentText())
            data['par_section_data_'+ID] = str(self.comboDataParSection.currentText())
            parSecIdx = self.comboDataParSection.currentIndex()
            if parSecIdx == 0:
                data['par_section_data_'+ID] = 'timing'
            elif parSecIdx == 1:
                data['par_section_data_'+ID] = 'speed' 
            elif parSecIdx == 2:
                data['par_section_data_'+ID] = 'trajectory' 
            data['point_data_'+ID] = str(self.editDataPoint.text())
            parNameIdx = self.comboDataParName.currentIndex()
            if parNameIdx == 0: 
                if parSecIdx == 0:
                    data['par_name_data_'+ID] = 'duration'
                elif parSecIdx == 1:
                    data['par_name_data_'+ID] = 'Vmax'
                elif parSecIdx == 2:
                    data['par_name_data_'+ID] = 'trajectory'
            elif parNameIdx == 1:
                if parSecIdx == 0:
                    data['par_name_data_'+ID] = 'percentageTiming' 
            elif parNameIdx == 2:
                if parSecIdx == 0:
                    data['par_name_data_'+ID] = 'timeVmax' 
        elif self.comboDataPathMode.currentIndex() == 1:
            data['data_'+ID] = str(self.editDataXPath.text())
        textTypeIdx = self.comboDataTextType.currentIndex()
        if textTypeIdx == 0:
            data['text_type_data_'+ID] = 'values_mean'
        elif textTypeIdx == 1:
            data['text_type_data_'+ID] = 'values_std'
        data['type_data_'+ID] = 'point'
        return data
            
    def setContent(self, data):
        ID = self.ID
        if 'data_'+ID in data:
            self.editDataXPath.setText(data['data_'+ID])
            self.comboDataPathMode.setCurrentIndex(1)
            self.uiUpdateForPath(1)
        else:
            self.editDataTask.setText(data['task_data_'+ID])
            setCurrentTextForCombo(self.comboDataContext, data['context_data_'+ID])
            setCurrentTextForCombo(self.comboDataPhase, data['phase_data_'+ID])
            if data['par_section_data_'+ID] == 'timing':
                self.comboDataParSection.setCurrentIndex(0)
                idx = 0
            elif data['par_section_data_'+ID] == 'speed':
                self.comboDataParSection.setCurrentIndex(1)
                idx = 1
            elif data['par_section_data_'+ID] == 'trajectory':
                self.comboDataParSection.setCurrentIndex(2)
                idx = 2
            self.comboDataParSection.activated.emit(idx)
            self.editDataPoint.setText(data['point_data_'+ID])
            if data['par_name_data_'+ID] == 'duration':
                self.comboDataParName.setCurrentIndex(0)
            elif data['par_name_data_'+ID] == 'percentageTiming':
                self.comboDataParName.setCurrentIndex(1)
            elif data['par_name_data_'+ID] == 'timeVmax':
                self.comboDataParName.setCurrentIndex(2)
            elif data['par_name_data_'+ID] == 'Vmax':
                self.comboDataParName.setCurrentIndex(0)  
            elif data['par_name_data_'+ID] == 'trajectory':
                self.comboDataParName.setCurrentIndex(0)                                
            self.comboDataPathMode.setCurrentIndex(0)
            self.uiUpdateForPath(0)
        if data['text_type_data_'+ID] == 'values_mean':
            self.comboDataTextType.setCurrentIndex(0)
        elif data['text_type_data_'+ID] == 'values_std':
            self.comboDataTextType.setCurrentIndex(1)

class TxtAngDataGroupBox(QtGui.QGroupBox):
    def __init__(self, ID, manager):
        QtGui.QGroupBox.__init__(self)
        
        self.ID = ID
        self.manager = manager
        
        self.setTitle('Angle data')
        
        self.labelDataPathMode = QtGui.QLabel('Path definition:')
        self.comboDataPathMode = QtGui.QComboBox()
        self.comboDataPathMode.addItem('Direct (Suggested)')
        self.comboDataPathMode.addItem('XPath (Experts only)')
        self.labelDataTask = QtGui.QLabel('Task:')
        self.editDataTask = QtGui.QLineEdit()
        self.labelDataContext = QtGui.QLabel('Context:')
        self.comboDataContext = QtGui.QComboBox()
        self.comboDataContext.addItem('Right') 
        self.comboDataContext.addItem('Left')
        self.comboDataContext.addItem('General')
        self.comboDataContext.addItem('*')
        self.labelDataPhase = QtGui.QLabel('Phase:')
        self.comboDataPhase = QtGui.QComboBox()
        for i in xrange(1,11):
            self.comboDataPhase.addItem('Phase%d'%i)
        self.comboDataPhase.addItem('EntireCycle')
        self.labelDataCurveName = QtGui.QLabel('Curve name:')
        self.editDataCurveName = QtGui.QLineEdit() 
        self.labelDataParName = QtGui.QLabel('Parameter name:')
        self.comboDataParName = QtGui.QComboBox()
        self.comboDataParName.addItem('min value')
        self.comboDataParName.addItem('max value')
        self.comboDataParName.addItem('initial value')
        self.comboDataParName.addItem('final value')
        self.labelDataTextType = QtGui.QLabel('Text type:')
        self.comboDataTextType = QtGui.QComboBox()
        self.comboDataTextType.addItem('Mean value')
        self.comboDataTextType.addItem('Std dev value')
        self.labelDataXPath = QtGui.QLabel('XPath:')
        self.editDataXPath = QtGui.QLineEdit()
        self.buttDelData = QtGui.QPushButton('Delete')
        
        self.hBoxDataMng = QtGui.QHBoxLayout()
        self.hBoxDataMng.addStretch(1)
        self.hBoxDataMng.addWidget(self.buttDelData)
        self.gridDataOpts = QtGui.QGridLayout()
        self.gridDataOpts.addWidget(self.labelDataPathMode, 0, 0)
        self.gridDataOpts.addWidget(self.comboDataPathMode, 0, 1)
        self.gridDataOpts.addWidget(self.labelDataTask, 1, 0)
        self.gridDataOpts.addWidget(self.editDataTask, 1, 1)
        self.gridDataOpts.addWidget(self.labelDataContext, 2, 0)
        self.gridDataOpts.addWidget(self.comboDataContext, 2, 1)
        self.gridDataOpts.addWidget(self.labelDataPhase, 3, 0)
        self.gridDataOpts.addWidget(self.comboDataPhase, 3, 1)
        self.gridDataOpts.addWidget(self.labelDataCurveName, 4, 0)
        self.gridDataOpts.addWidget(self.editDataCurveName, 4, 1)
        self.gridDataOpts.addWidget(self.labelDataParName, 5, 0)
        self.gridDataOpts.addWidget(self.comboDataParName, 5, 1)
        self.gridDataOpts.addWidget(self.labelDataXPath, 6, 0)
        self.gridDataOpts.addWidget(self.editDataXPath, 6, 1)
        self.gridDataOpts.addWidget(self.labelDataTextType, 7, 0)
        self.gridDataOpts.addWidget(self.comboDataTextType, 7, 1)
        self.gridDataOpts.addLayout(self.hBoxDataMng, 8, 1)
        
        self.setLayout(self.gridDataOpts)
        
        self.buttDelData.clicked.connect(self.delete)
        self.comboDataPathMode.activated.connect(self.uiUpdateForPath)
        
        self.editDataXPath.setEnabled(False)
        
    
    def delete(self):
        self.deleteLater()
        self.manager.delAngDataWithID(self.ID)
    
    def uiUpdateForPath(self, i):
        if i == 0:
            self.editDataTask.setEnabled(True)
            self.comboDataContext.setEnabled(True)
            self.comboDataPhase.setEnabled(True)
            self.editDataCurveName.setEnabled(True)
            self.comboDataParName.setEnabled(True)
            self.editDataXPath.setEnabled(False)
        elif i == 1:
            self.editDataTask.setEnabled(False)
            self.comboDataContext.setEnabled(False)
            self.comboDataPhase.setEnabled(False)
            self.editDataCurveName.setEnabled(False)
            self.comboDataParName.setEnabled(False)
            self.editDataXPath.setEnabled(True)
        
    
    def getContent(self):
        data = {}
        ID = self.ID
        if self.comboDataPathMode.currentIndex() == 0:
            data['task_data_'+ID] = str(self.editDataTask.text())
            data['context_data_'+ID] = str(self.comboDataContext.currentText())
            data['phase_data_'+ID] = str(self.comboDataPhase.currentText())
            data['curve_name_data_'+ID] = str(self.editDataCurveName.text())
            parNameIdx = self.comboDataParName.currentIndex()
            if parNameIdx == 0: 
                data['par_name_data_'+ID] = 'minValue'
            if parNameIdx == 1: 
                data['par_name_data_'+ID] = 'maxValue'
            if parNameIdx == 2: 
                data['par_name_data_'+ID] = 'startValue'
            if parNameIdx == 3: 
                data['par_name_data_'+ID] = 'endValue'
        elif self.comboDataPathMode.currentIndex() == 1:
            data['data_'+ID] = str(self.editDataXPath.text())
        textTypeIdx = self.comboDataTextType.currentIndex()
        if textTypeIdx == 0:
            data['text_type_data_'+ID] = 'values_mean'
        elif textTypeIdx == 1:
            data['text_type_data_'+ID] = 'values_std'
        data['type_data_'+ID] = 'angle'
        return data
            
    def setContent(self, data):
        ID = self.ID
        if 'data_'+ID in data:
            self.editDataXPath.setText(data['data_'+ID])
            self.comboDataPathMode.setCurrentIndex(1)
            self.uiUpdateForPath(1)
        else:
            self.editDataTask.setText(data['task_data_'+ID])
            setCurrentTextForCombo(self.comboDataContext, data['context_data_'+ID])
            setCurrentTextForCombo(self.comboDataPhase, data['phase_data_'+ID])
            self.editDataCurveName.setText(data['curve_name_data_'+ID])
            if data['par_name_data_'+ID] == 'minValue':
                self.comboDataParName.setCurrentIndex(0)
            elif data['par_name_data_'+ID] == 'maxValue':
                self.comboDataParName.setCurrentIndex(1)
            elif data['par_name_data_'+ID] == 'startValue':
                self.comboDataParName.setCurrentIndex(2)
            elif data['par_name_data_'+ID] == 'endValue':
                self.comboDataParName.setCurrentIndex(3)                                
            self.comboDataPathMode.setCurrentIndex(0)
            self.uiUpdateForPath(0)
        if data['text_type_data_'+ID] == 'values_mean':
            self.comboDataTextType.setCurrentIndex(0)
        elif data['text_type_data_'+ID] == 'values_std':
            self.comboDataTextType.setCurrentIndex(1)
    
class ULTextTab(QtGui.QWidget):
    
    def __init__(self):
        QtGui.QWidget.__init__(self)
        
        # ---Create non layout widgets
        
        # Data paths add buttons
        self.buttAddAngData = QtGui.QPushButton('Add angle data')
        self.buttAddPntData = QtGui.QPushButton('Add point data')
        
        
        # Data paths
        self.gbAngDataOpts = {}
        self.gbPntDataOpts = {}
        
        
        # ---Create layout widgets
        self.vBox = QtGui.QVBoxLayout()
        self.gridGenOpts = QtGui.QGridLayout()
        self.hBoxDataMng = QtGui.QHBoxLayout()
        

        # ---Organize non-layout widgets  
        
        # Data paths add buttons
        self.hBoxDataMng.addStretch(1)
        self.hBoxDataMng.addWidget(self.buttAddAngData)
        self.hBoxDataMng.addWidget(self.buttAddPntData)
        
        
        # ---Organize layout widgets
        self.vBox.addLayout(self.gridGenOpts)
        self.vBox.addLayout(self.hBoxDataMng)
        self.vBox.addStretch(1)

        
        # ---Add scroll bars
        self.cWidget = QtGui.QWidget()
        self.scroll = QtGui.QScrollArea()
        self.scroll.setWidget(self.cWidget)
        self.scroll.setWidgetResizable(True)
        self.cWidget.setLayout(self.vBox)
        self.mainLayout = QtGui.QVBoxLayout()
        self.mainLayout.addWidget(self.scroll)
        self.setLayout(self.mainLayout)
        
        # Register callbacks
        self.buttAddAngData.clicked.connect(lambda: self.addAngData(-1))
        self.buttAddPntData.clicked.connect(lambda: self.addPntData(-1))
        
      
    def removeLastStretch(self):
        stretch = self.vBox.itemAt(self.vBox.count()-1)
        self.vBox.removeItem(stretch)         

    def addAngData(self, N):
        self.removeLastStretch()  
        if N < 0:
            N = str(len(self.gbAngDataOpts.keys()))
        groupBox = TxtAngDataGroupBox(N, self)
        self.gbAngDataOpts.update([(N,groupBox)])
        self.vBox.addWidget(groupBox)
        self.vBox.addStretch(1)
        # Disable add buttons
        self.buttAddAngData.setEnabled(False)
        self.buttAddPntData.setEnabled(False)
        
    def addPntData(self, N):
        self.removeLastStretch()  
        if N < 0:
            N = str(len(self.gbPntDataOpts.keys()))
        groupBox = TxtPntDataGroupBox(N, self)
        self.gbPntDataOpts.update([(N,groupBox)])
        self.vBox.addWidget(groupBox)
        self.vBox.addStretch(1)
        # Disable add buttons
        self.buttAddAngData.setEnabled(False)
        self.buttAddPntData.setEnabled(False)
    
    def addGroupBoxes(self, ID):
        for i in ID['ang_data']:
            self.addAngData(i)
        for i in ID['pnt_data']:
            self.addPntData(i)  
    
    def delAngDataWithID(self, ID):
        del self.gbAngDataOpts[ID]
        # Disable add buttons
        self.buttAddAngData.setEnabled(True)
        self.buttAddPntData.setEnabled(True)

    def delPntDataWithID(self, ID):
        del self.gbPntDataOpts[ID]
        # Disable add buttons
        self.buttAddAngData.setEnabled(True)
        self.buttAddPntData.setEnabled(True)
    
    def getContent(self):
        data = {}
        # Get content from cascading panels
        for i in self.gbAngDataOpts.keys():
            newData = self.gbAngDataOpts[i].getContent()
            data.update(newData)
        for i in self.gbPntDataOpts.keys():
            newData = self.gbPntDataOpts[i].getContent()
            data.update(newData)
        return data
    
    def deleteAllGroupBoxes(self):
        for i in self.gbAngDataOpts.keys():
            self.gbAngDataOpts[i].delete()
        for i in self.gbPntDataOpts.keys():
            self.gbPntDataOpts[i].delete()
    
    def setContentForAllGroupBoxes(self, data):
        for i in self.gbAngDataOpts.keys():
            self.gbAngDataOpts[i].setContent(data)
        for i in self.gbPntDataOpts.keys():
            self.gbPntDataOpts[i].setContent(data)
    
        
    def setContent(self, data):
        # Clear all the panels
        self.deleteAllGroupBoxes()
        # Determine the number of panels for each type
        ID = getDataSourceIDsFromDesc(data, 'text')
        # Add necessary panels
        self.addGroupBoxes(ID)
        # Set content for cascading panels
        self.setContentForAllGroupBoxes(data)
            

#-----------------------------------------------------------------------


class ULTab(QtGui.QWidget):
    
    
    def __init__(self): 
        QtGui.QWidget.__init__(self)
        
        self.title = 'Upper Limb'    # Title that will bew shown in the Descriptors Editor
        self.ID = tabID 
        
        # Attention! ID will be saved in every descriptor.
        # Any further modification of this ID will need a modification of
        # the associated descriptors as well
        
        # ---Create non layout widgets
        self.labelFun = QtGui.QLabel('Function:')
        self.comboFun = QtGui.QComboBox()
        self.comboFun.addItem('UL_2DPlot_0_100')     
        self.tabType = QtGui.QTabWidget()
        self.ULImageTab = ULImageTab()
        self.ULTextTab = ULTextTab()
        self.tabType.addTab(self.ULImageTab, 'image')
        self.tabType.addTab(self.ULTextTab, 'text')
        
        # ---Create layout widgets
        self.gridOpts = QtGui.QGridLayout()
        
        # ---Organize non-layout widgets
        self.gridOpts.addWidget(self.labelFun, 0, 0)
        self.gridOpts.addWidget(self.comboFun, 0, 1)
        self.gridOpts.addWidget(self.tabType, 1, 0, 1, 2)
        self.setLayout(self.gridOpts)
        
        # ---Register callbacks
        self.comboFun.currentIndexChanged.connect(self.showOptsForFun)
        self.showOptsForFun()
    
    def showOptsForObjType(self, objType):
        if objType == 'image':
            self.comboFun.clear()
            self.comboFun.addItem('UL_2DPlot_0_100')
        elif objType == 'text':
            self.comboFun.clear()
            self.comboFun.addItem('UL_Text')
        self.showOptsForFun()            
    
    def showOptsForFun(self):
        funName = str(self.comboFun.currentText())
        if funName == 'UL_2DPlot_0_100':
            self.tabType.setTabEnabled(0, True)
            self.tabType.setTabEnabled(1, False)
        elif funName == 'UL_Text':
            self.tabType.setTabEnabled(0, False)
            self.tabType.setTabEnabled(1, True)            
    
    def getContent(self):
        data = {}
        funName = str(self.comboFun.currentText())
        data['fun'] = funName
        if funName == 'UL_2DPlot_0_100':
            newData = self.ULImageTab.getContent()
        elif funName == 'UL_Text':
            newData = self.ULTextTab.getContent()
        #print funName
        data.update(newData)
        return data
    
    def setContent(self, data):
        if data['fun'] == 'UL_2DPlot_0_100':
            self.comboFun.setCurrentIndex(0)
            self.ULImageTab.setContent(data)
        elif data['fun'] == 'UL_Text':
            self.comboFun.setCurrentIndex(0)
            self.ULTextTab.setContent(data)
    
    def getID(self):
        return self.ID
    
    def getDefDescriptor(self):
        return defDesc.copy()
            
        
    
    
    
    
    
        
        
        