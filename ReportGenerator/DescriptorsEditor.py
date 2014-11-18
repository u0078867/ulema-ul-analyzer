

import sys

import PyQt4.QtGui as QtGui

import DEView
import DEController
import DEModel




class Application():
    
    def __init__(self, plugins):
        # Create Model, View and Controller
        self.plugins = plugins
        self.view = DEView.MainWindow(self.plugins)
        self.model = DEModel.DescriptorsList(self.plugins)
        self.controller = DEController.Controller(self.model, self.view, None, self.plugins, showWin=False)

    def show(self): 
        self.view.show()
    
    def hide(self):
        self.view.hide()

        
if __name__ == "__main__": # Only for testing (without plugins)!
    app = QtGui.QApplication(sys.argv)
    # Create Model, View and Controller
    view = DEView.MainWindow()
    model = DEModel.DescriptorsList()
    controller = DEController.Controller(model, view, app)
    # Run the main loop
    sys.exit(app.exec_())