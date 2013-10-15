

import string

def getDataSourceIDsFromDesc(data, dest):
    if dest == 'image':
        patterns = ['color_rgb_data','color_rgb_ctrl_data','color_rgb_vline']
        ID = {}
        for p in patterns:
            ID[p] = []
            for key in data.keys():
                if string.find(key, p) == 0:
                    ID[p].append(key.split('_')[-1])
        ID2 = {}
        ID2['data'] = ID['color_rgb_data']
        ID2['ctrl_data'] = ID['color_rgb_ctrl_data']
        ID2['vline'] = ID['color_rgb_vline']
        return ID2
    elif dest == 'text':
        ID2 = {'pnt_data':[], 'ang_data':[]}
        for key in data.keys():
            if string.find(key, 'type_data') == 0:
                ID = key.split('_')[-1]
                if data[key] == 'point':
                    ID2['pnt_data'].append(ID)
                elif data[key] == 'angle':
                    ID2['ang_data'].append(ID)
        return ID2

