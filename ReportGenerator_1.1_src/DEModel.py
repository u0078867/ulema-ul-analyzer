
import pickle


class DescriptorsList():
    
    def __init__(self, plugins, ld=[]):
        self.plugins = plugins
        self.ld = ld
    
    def getListSize(self):
        return len(self.ld)
    
    def getDescriptorFromId(self, obj):
        res = [self.ld[i] for i in xrange(self.getListSize()) if self.ld[i]['obj']==obj]
        return res[0]
    
    def getDescriptorIdxFromId(self, obj):
        idx = [i for i in xrange(self.getListSize()) if self.ld[i]['obj']==obj]
        if len(idx) == 1:
            return idx[0]
        else:
            return -1
    
    def getDescriptorNames(self):
        return [self.ld[i]['obj'] for i in xrange(self.getListSize())]
        
    def overwriteDescriptorWithId(self, obj, d):
        idx = self.getDescriptorIdxFromId(obj)
        if idx >= 0:
            self.ld[idx] = d
    
    def appendNewDescriptor(self, d):
        self.ld.append(d)
    
    def delDescriptor(self, obj):
        idx = self.getDescriptorIdxFromId(obj)
        if idx > 0:
            del self.ld[idx]       
    
    def saveListToFile(self, filePath):
        f = open(filePath, "wb")
        pickle.dump(self.ld, f, protocol=2)
        f.close() 
        
    def loadListFromFile(self, filePath, IDs):
        # load descriptors
        f = open(filePath, "rb")
        self.ld = pickle.load(f)
        f.close()
        # Check if some descriptors are not not supported
        notSupported = []
        for d in self.ld:
            if d['view_ID'] not in IDs:
                notSupported.append(d['obj'])
        return notSupported
        
        
        
        