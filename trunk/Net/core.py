from db import Database
from utils import *
import time

class Core(object):
    
    def __init__(self, server):
        self.__server = server
        self.__db = Database()
        
        self.__c = {}
        self.__i = []
        self.__a = {}
        self.__mmenu = "Attack;Defende;Magics;Invocations;Items;Team;Settings"
    
    def setInputs(self, inputs = []):
        self.__i = inputs
    
    def getInputs(self):
        return self.__i
    
    def clearSockets(self):
        self.__c = {}
    
    def getSockets(self):
        return self.__c.keys()
    
    def getSocket(self, u):
        for s, uid in self.__c.items():
            if uid == u:
                return s
        return None
    
    def getSocketsMap(self):
        return self.__c.items()
    
    def getUids(self):
        return self.__c.values()
    
    def getUid(self, s):
        result = None
        if self.__c.has_key(s):
            result = self.__c[s]
        return result
    
    def setUid(self, s, u):
        self.__c[s] = u
    
    # Main Function Server
    
    def addClient(self, s, uid):
        print 'Add Client %d uid %s' % (s.fileno(), uid)
        self.__i.append(s)
        self.__c[s] = uid
        self.__server.sendLine(s, "E|Connected")
    
    def delClient(self, s):
        try:
            print 'Del Client %d uid %s' % (s.fileno(), self.__c[s])
            s.close()
            self.__i.remove(s)
            del self.__c[s]
        except Exception, e:
            print e
    
    def mainLoop(self):
        for k in self.__a.keys():
            t = self.__a[k]["time"]
            if time.time() - t > 15: # change turn
                mode = 0
                uids = k.split('|')
                s0 = self.getSocket(uids[0])
                s1 = self.getSocket(uids[1])
                
                if not s0:
                    mode += 1
                    s0 = s1
                if not s1:
                    mode += 2
                
                if mode < 3:
                    if mode > 0:
                        self.__server.sendLine(s0, "T|fine")
                        self.delArena(k)
                        return
                else:
                    self.delArena(k)
                    return
                
                mapp = {uids[0]:s0, uids[1]:s1}
                self.__a[k]["turn"] = next(uids, self.__a[k]["turn"])
                self.__a[k]["time"] = time.time()
                
                for u in uids:
                    s = mapp[u]
                    if u == self.__a[k]["turn"]:
                        #self.clients[uid].main_menu = ""
                        name = self.__db.getNameFromUid(u)
                        self.__server.sendLine(s, "T|%s" % name)
                        self.__server.sendLine(s, "M|%s" % self.__mmenu, 2)
                    else:
                        name = self.__db.getNameFromUid(self.__a[k]["turn"])
                        self.__server.sendLine(s, "M|chiudi")
                        self.__server.sendLine(s, "T|%s" % name, 0.5)
        
    def createArena(self, s1, s2):
        uid1, uid2 = self.__c[s1], self.__c[s2]
        for k in self.__a.keys():
            uids = k.split('|')
            if uid1 in uids and uid2 not in uids:
                self.__server.sendLine(s2, "E|Utente impegnato")
                return
            if uid2 in uids and uid1 not in uids:
                self.__server.sendLine(s1, "E|Utente impegnato")
                return
        
        k = '%s|%s' % (uid1, uid2)
        if not self.__a.has_key(k):
            print "Create Arena %s" % k
            self.__a[k] = {
                "turn": uid2,
                "time": time.time()
                }
            name = self.__db.getNameFromUid(uid2)
            self.__server.sendLine(s2, "T|%s" % name)
            self.__server.sendLine(s2, "M|%s" % self.__mmenu, 2)
        else:
            print "Client rientrato in Arena %s" % k
    
    def delArena(self, k):
        del self.__a[k]
        print "Delete Arena %s" % k
