import time

# Class for callLater, step need called in main loop

class Reactor(object):
    
    def __init__(self):
        self.__fn = []
    
    def callLater(self, t, obj, fname, *args):
        self.__fn.append((time.time() + t, obj, fname, list(args)))
    
    def step(self):
        if self.__fn:
            fn = self.__fn.pop(0)
            if time.time() >= fn[0]:
                try:
                    getattr(fn[1], fn[2])(*fn[3])
                except Exception, e:
                    print "No callable method %s in object %s" % (fn[1], fn[2])
            else:
                self.__fn.append(fn)

reactor = Reactor()
