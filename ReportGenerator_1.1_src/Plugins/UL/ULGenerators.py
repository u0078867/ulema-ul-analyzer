
import os
import matplotlib.pyplot as plt
import numpy as np
import re
import libxml2
from ULCommon import *

def getRgbValues(s):
    rgb = list(eval(s))
    rgb[0] = (rgb[0] + 1.0) / 256
    rgb[1] = (rgb[1] + 1.0) / 256
    rgb[2] = (rgb[2] + 1.0) / 256
    return rgb

def parseXmlCurve(nodes):
    
    curves = []
    cont = 0
    for node in nodes:
        cont += 1
        print '\nretrieving curve {0}...'.format(cont)
        try:
            strData = node.content.split(';')
            data = [float(i) for i in strData]
            print '\nvalues are separated by ";"'
        except:
            print '\nvalues are not separated by ";"'
        try:
            strData = node.content.split(' ')
            data = [float(i) for i in strData]
            print '\nvalues are separated by " "'
        except:
            print '\nvalues are not separated by " "'
        curves.append(np.array(data))
    return curves
    

def createULXPath(pathFor,dataset,task=None,context=None,phase=None,curveType=None,curveName=None,parSection=None,point=None,parName=None,evName=None):
    """
    Automatically creates XPath for some part of the .xml out of UL data.
    For non-curve data, it has been chosen to being able to retrieve only
    a FEW kinds of numeric scalars relevant for upper limb analysis. 
    This because theoretically everything in a .xml can be scalar;
    not only the content of a tag but also the name of the tag and so on.
    """
    if dataset == 'data':
        if pathFor == 'curve': # for image generator
            if curveName[0] == '*':
                str1 = '//bestCycles/'+task+'/'+context+'/'+phase+'/cycles/*/data/'+curveType+'/R'+curveName[1:]+'/text()'
                str2 = '//bestCycles/'+task+'/'+context+'/'+phase+'/cycles/*/data/'+curveType+'/L'+curveName[1:]+'/text()'
                XPath = str1 + ' | ' + str2
            else:
                XPath = '//bestCycles/'+task+'/'+context+'/'+phase+'/cycles/*/data/'+curveType+'/'+curveName+'/text()'
        elif pathFor == 'stParamPoint': # for text generator
            if point[0] == '*':
                str1 = '//bestCycles/'+task+'/'+context+'/'+phase+'/cycles/*/data/stParam/'+parSection+'/R'+point[1:]+'/'+phase+'/'+parName+'/text()'
                str2 = '//bestCycles/'+task+'/'+context+'/'+phase+'/cycles/*/data/stParam/'+parSection+'/L'+point[1:]+'/'+phase+'/'+parName+'/text()'
                XPath = str1 + ' | ' + str2
            else:
                XPath = '//bestCycles/'+task+'/'+context+'/'+phase+'/cycles/*/data/stParam/'+parSection+'/'+point+'/'+phase+'/'+parName+'/text()'
        elif pathFor == 'stParamAngle': # for text generator
            if curveName[0] == '*':
                str1 = '//bestCycles/'+task+'/'+context+'/'+phase+'/cycles/*/data/stParam/valuesInTime/R'+curveName[1:]+'/'+phase+'/'+parName+'/text()'
                str2 = '//bestCycles/'+task+'/'+context+'/'+phase+'/cycles/*/data/stParam/valuesInTime/L'+curveName[1:]+'/'+phase+'/'+parName+'/text()'
                XPath = str1 + ' | ' + str2
            else:
                XPath =  '//bestCycles/'+task+'/'+context+'/'+phase+'/cycles/*/data/stParam/valuesInTime/'+curveName+'/'+phase+'/'+parName+'/text()'
        elif pathFor == 'stParamEvent': # for image gnerator
            XPath = '//bestCycles/'+task+'/'+context+'/'+phase+'/cycles/*/data/stParam/events/'+context+'/'+evName+'/text()'
    elif dataset == 'ctrlData':
        if pathFor == 'curve': # for image generator
            if curveName[0] == '*':
                str1 = '//RefData/tasks/'+task+'/'+phase+'/'+curveType+'/*/R'+curveName[1:]+'/text()'
                str2 = '//RefData/tasks/'+task+'/'+phase+'/'+curveType+'/*/L'+curveName[1:]+'/text()'
                XPath = str1 + ' | ' + str2
            else:
                XPath = '//RefData/tasks/'+task+'/'+phase+'/'+curveType+'/*/'+curveName+'/text()'
    return XPath

def UL_2DPlot_0_100(templateDoc, templateXp, dataFiles, info, tempFolder):
    
    # Get IDs for every data set
    IDs = getDataSourceIDsFromDesc(info, 'image')    
    # Create the figure
    widthInch = info['width'] / 2.54
    heightInch = info['height'] / 2.54
    print '\ncalculated image size (inches): {0}'.format((widthInch, heightInch))
    fig = plt.figure(1,dpi=300)
    fig.set_size_inches(widthInch,heightInch)
    plt.cla()
    plt.hold(True)
    # Plot control data first (so data is in the background) 
    if len(IDs['ctrl_data']) > 0:
        ctrlDataDoc = libxml2.parseFile(dataFiles[1])
        ctrlXp = ctrlDataDoc.xpathNewContext()        
    for ID in IDs['ctrl_data']:
        ctrlDataCond1 = 'ctrl_data_'+ID in info.keys()
        ctrlDataCond2 = 'task_ctrl_data_'+ID in info.keys() and 'phase_ctrl_data_'+ID in info.keys() and 'curve_type_ctrl_data_'+ID in info.keys() and 'curve_name_ctrl_data_'+ID in info.keys()
        if ctrlDataCond1 or ctrlDataCond2:
            if ctrlDataCond1:
                ctrlDataXPath = info['ctrl_data_'+ID]
            else:
                taskCtrlData = info['task_ctrl_data_'+ID]
                phaseCtrlData = info['phase_ctrl_data_'+ID]
                curveTypeCtrlData = info['curve_type_ctrl_data_'+ID]
                if curveTypeCtrlData == 'Angle':
                    curveTypeCtrlData = 'angles'
                curveNameCtrlData = info['curve_name_ctrl_data_'+ID]
                ctrlDataXPath = createULXPath('curve','ctrlData',task=taskCtrlData,phase=phaseCtrlData,curveType=curveTypeCtrlData,curveName=curveNameCtrlData)
            result = ctrlXp.xpathEval(ctrlDataXPath)
            print '\n{0} control curves for descriptor {1} for ID {2} retrievable from {3}'.format(len(result), info['obj'], ID, dataFiles[1])
            ctrlCurves = parseXmlCurve(result)
        else:
            raise Exception('impossible to retrieve data for control curves')
        if ctrlDataCond1 or ctrlDataCond2:
            ctrlMeanCurve = ctrlCurves[0]   # to adjust for future: mean and std could be swapped!
            ctrlStdCurve = ctrlCurves[1]    # to adjust for future: mean and std could be swapped!
            x = np.linspace(0,100,len(ctrlMeanCurve))
            color = getRgbValues(info['color_rgb_ctrl_data_'+ID])
            plt.fill_between(x, ctrlMeanCurve-ctrlStdCurve, ctrlMeanCurve+ctrlStdCurve, color=color)
            if 'show_mean_ctrl_data_'+ID in info.keys() and info['show_mean_ctrl_data_'+ID] == 'yes':
                plt.plot(x, ctrlMeanCurve, 'k--')
            print '\ncontrol data plotted'        
    # Plot curve(s)
    if len(IDs['data']) > 0:
        dataDoc = libxml2.parseFile(dataFiles[0])
        xp = dataDoc.xpathNewContext()
    for ID in IDs['data']:
        dataCond1 = 'data_'+ID in info.keys()
        dataCond2 = 'task_data_'+ID in info.keys() and 'context_data_'+ID in info.keys() and 'phase_data_'+ID in info.keys() and 'curve_type_data_'+ID in info.keys() and 'curve_name_data_'+ID in info.keys()
        if dataCond1:
            dataXPath = info['data_'+ID]
        elif dataCond2:
            taskData = info['task_data_'+ID]
            contextData = info['context_data_'+ID]
            phaseData = info['phase_data_'+ID]
            curveTypeData = info['curve_type_data_'+ID]
            if curveTypeData == 'Time-normalized angle':
                curveTypeData = 'anglesNorm'
            curveNameData = info['curve_name_data_'+ID]
            dataXPath = createULXPath('curve','data',task=taskData,context=contextData,phase=phaseData,curveType=curveTypeData,curveName=curveNameData)
        else:
            raise Exception('impossible to retrieve data for non-control curves') 
        result = xp.xpathEval(dataXPath)
        print '\n{0} curves for descriptor {1} for ID {2} retrievable from {3}'.format(len(result), info['obj'], ID, dataFiles[0])
        curves = parseXmlCurve(result)
        if 'plot_type_data_'+ID in info.keys():
            meanCurve = np.zeros((101,))
            if info['plot_type_data_'+ID] == 'mean_curve':
                for curve in curves:
                    meanCurve += curve
                meanCurve = meanCurve / len(curves)
                curves = [meanCurve]
        for curve in curves:
            x = np.linspace(0,100,len(curve))
            curveGraph = plt.plot(x,curve,'b')
            if 'color_rgb_data_'+ID in info.keys():
                color = getRgbValues(info['color_rgb_data_'+ID])
                curveGraph[0].set_color(color)
                print '\ncolor {0} set'.format(color) 
        print '\ndata plotted'
    # Plot horizontal y=0 line
    if 'show_0_line' in info.keys() and info['show_0_line'] == 'yes':
        zeroLine = np.zeros((len(x),))
        plt.plot(x, zeroLine, 'k', linewidth=0.5)
    # Add additional information to to the plot
    if 'title' in info.keys() and info['title'] <> '':
        title = info['title']
        plt.title(title, size=7)
        print '\ntitle "{0}" set'.format(title)
    if 'x_label' in info.keys() and info['x_label'] <> '':  
        xLabel = info['x_label']
        plt.xlabel(xLabel, size=7)
        print '\nx label "{0}" set'.format(xLabel)
    if 'y_label' in info.keys() and info['y_label'] <> '':
        yLabel = info['y_label']
        plt.ylabel(yLabel, size=7)
        print '\ny label "{0}" set'.format(yLabel)
    if 'y_range' in info.keys() and info['y_range'] <> '':
        yRange = list(info['y_range'][1:-1].split(','))
        yRange = [float(i) for i in yRange]
        plt.ylim(yRange)
        print '\ny range {0} set'.format(yRange)
    if 'pos_y_label' in info.keys() and info['pos_y_label'] <> '':
        posYLabel = info['pos_y_label']
        yMin, yMax = plt.ylim()
        startPoint = (yMax + yMin) / 2.0
        if 'pos_y_label_x' in info.keys() and info['pos_y_label_x'] <> '':
            x = float(info['pos_y_label_x'])
        else:
            x = 7.0
        if 'pos_y_label_pcty' in info.keys() and info['pos_y_label_pcty'] <> '':
            pct = float(info['pos_y_label_pcty']) / 100.0
        else:    
            pct = 0.8
        y = startPoint + pct * (yMax - yMin) / 2.0
        plt.text(x,y,posYLabel,fontsize=6)
        print '\npos y label "{0}" set'.format(posYLabel)
    if 'neg_y_label' in info.keys() and info['neg_y_label'] <> '':
        posYLabel = info['neg_y_label']
        yMin, yMax = plt.ylim()
        startPoint = (yMax + yMin) / 2.0
        if 'neg_y_label_x' in info.keys() and info['neg_y_label_x'] <> '':
            x = float(info['neg_y_label_x'])
        else:
            x = 7.0
        if 'neg_y_label_pcty' in info.keys() and info['neg_y_label_pcty'] <> '':
            pct = float(info['neg_y_label_pcty']) / 100.0
        else:    
            pct = 0.8
        y = startPoint - pct * (yMax - yMin) / 2.0
        plt.text(x,y,posYLabel,fontsize=6)
        print '\npos y label "{0}" set'.format(posYLabel)
    # Insert vertical lines
    for ID in IDs['vline']:
        vlineCond1 = 'vline_'+ID in info.keys()
        vlineCond2 = 'name_vline_'+ID in info.keys() and 'name_vline_first_'+ID in info.keys() and 'name_vline_last_'+ID in info.keys() and 'task_vline_'+ID in info.keys() and 'context_vline_'+ID in info.keys() and 'phase_vline_'+ID in info.keys()
        if vlineCond1 or vlineCond2:
            # Retrieve all vertical lines data
            if vlineCond1:
                vlineData = []
                vlineDataTemp = info['name_vline_'+ID].split(';')
                vlineData.append(info['name_vline_first_'+ID])
                vlineData += vlineDataTemp
                vlineData.append(info['name_vline_last_'+ID])
            elif vlineCond2:
                vlineData = info['vline_'+ID].split(';')
            N = len(vlineData)
            if N < 2:
                raise Exception('more than 2 vline datasets must be specified')
            vlineToShowIdx = range(1,N-1)
            vline = [None]*N
            for i in xrange(N):
                if vlineCond1:
                    vlineXPath = vlineData[i]
                elif vlineCond2:
                    taskData = info['task_data_'+ID]
                    contextData = info['context_data_'+ID]
                    phaseData = info['phase_data_'+ID]
                    vlineNameData = vlineData[i]
                    vlineXPath = createULXPath('stParamEvent','data',task=taskData,context=contextData,phase=phaseData,evName=vlineNameData)
                else:
                    raise Exception('impossible to retrieve data for vlines') 
                result = xp.xpathEval(vlineXPath)
                vline[i] = [None]*len(result)
                for k in xrange(len(result)):
                    vline[i][k] = float(result[k].content)
            print '\nvline datasets retrieved'
            # Express the position in percentage between 0 - 100
            for k in xrange(len(vline[0])):
                for i in xrange(len(vline)):
                    vline[i][k] = (vline[i][k] - vline[0][k]) / (vline[-1][k] - vline[0][k]) * 100.0
            print '\nvline positions converted in percentage in 0 - 100: {0}'.format(vline)
            # Plot the wanted vertical lines
            [ymin, ymax] = plt.gca().get_ylim()
            if 'color_rgb_vline_'+ID in info.keys():
                colors = info['color_rgb_vline_'+ID].split(';')
                col = [None]*len(colors)
                for i in xrange(len(colors)):
                    col[i] = getRgbValues(colors[i])
            else:
                col = ['b']*len(vlineToShowIdx)
            for k in xrange(len(vline[0])):
                for i in vlineToShowIdx:
                    x = (vline[i][k], vline[i][k])
                    y = (ymin, ymax)
                    plt.plot(x,y,color=col[i])
            print '\nvlines plotted'
    # Adjust more the figure and save it
    plt.xlim((0,100))
    plt.gca().tick_params(axis='x', labelsize=7)
    plt.gca().tick_params(axis='y', labelsize=7)
    fig.subplots_adjust(bottom=0.2,left=0.15,top=0.87)
    #fig.subplots_adjust(hspace=0,wspace=0)
    #plt.tight_layout(pad=1)
    figFilePath = os.path.join(tempFolder, info['image_name'])
    plt.savefig(figFilePath,dpi=300,format='jpeg')
    xp.xpathFreeContext()
    dataDoc.freeDoc()
    if ctrlDataCond1 or ctrlDataCond2:
        ctrlXp.xpathFreeContext()
        ctrlDataDoc.freeDoc()
    print '\nfigure saved'
    
    
def UL_Text(templateDoc, templateXp, dataFiles, info, tempFolder):

    # Get IDs for every data set
    IDs = getDataSourceIDsFromDesc(info, 'text')
    # Retrieve the data from .xml
    if len(IDs['ang_data']) > 0 or len(IDs['pnt_data']) > 0:
        dataDoc = libxml2.parseFile(dataFiles[0])
        xp = dataDoc.xpathNewContext()
    IDs2 = []
    if len(IDs['ang_data']) > 0:
        IDs2 += IDs['ang_data']
    if len(IDs['pnt_data']) > 0:
        IDs2 += IDs['pnt_data']          
    for ID in IDs2: 
        cond1 = 'data_'+ID in info.keys()
        cond2 = 'task_data_'+ID in info.keys() and 'context_data_'+ID in info.keys() and 'phase_data_'+ID in info.keys() and 'par_section_data_'+ID in info.keys() and 'point_data_'+ID in info.keys() and 'par_name_data_'+ID in info.keys()
        cond3 = 'task_data_'+ID in info.keys() and 'context_data_'+ID in info.keys() and 'phase_data_'+ID in info.keys() and 'par_name_data_'+ID in info.keys() and 'curve_name_data_'+ID in info.keys()
        if cond1:
            XPath = info['data_'+ID]    
        elif cond2:
            task = info['task_data_'+ID]
            context = info['context_data_'+ID]
            phase = info['phase_data_'+ID]
            parSection = info['par_section_data_'+ID]
            point = info['point_data_'+ID]
            parName = info['par_name_data_'+ID]
            XPath = createULXPath('stParamPoint','data',task=task,context=context,phase=phase,parSection=parSection,point=point,parName=parName)
        elif cond3:
            task = info['task_data_'+ID]
            context = info['context_data_'+ID]
            phase = info['phase_data_'+ID]
            curveName = info['curve_name_data_'+ID]
            parName = info['par_name_data_'+ID]
            XPath = createULXPath('stParamAngle','data',task=task,context=context,phase=phase,curveName=curveName,parName=parName)
        else:
            raise Exception('impossible to retrieve data for parameter') 
        result = xp.xpathEval(XPath)
        print '\n{0} strings for descriptor {1} for ID {2} retrievable from {3}'.format(len(result), info['obj'], ID, dataFiles[0])
        textType = info['text_type_data_'+ID]
        if textType == 'values_mean':
            values = [float(value.content) for value in result]
            # Calculate the mean value
            newText = '%.2f' % np.mean(values)
        elif textType == 'values_std':
            values = [float(value.content) for value in result]
            # Calculate the mean value
            newText = '%.2f' % np.std(values)  
        elif textType == 'raw_text':
            s = ''
            for value in result:
                s = s + value.content + ' '
            newText = s
        else:
            raise Exception('specify a valid text_type attribute')
    # Search all the << ... >> special strings in the .xml template
    result = templateXp.xpathEval("//text:p/descendant-or-self::*/text()")
    for node in result:
        s = node.content
        for m in re.finditer( '<<\S+>>', s):
            content = s[m.start()+2:m.end()-2]
            if content == info['obj']:
                toReplace = s[m.start():m.end()]
                s = s.replace(toReplace,newText)
        node.setContent(s)
    xp.xpathFreeContext()
    dataDoc.freeDoc()








    