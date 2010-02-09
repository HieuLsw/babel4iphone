from client import Client
from db import Database
from utils import *
import time

class Core(object):
    
    def __init__(self, server):
        self.__server = server
        self.__db = Database()
        
        self.__c = {}
        self.__a = {}
        self.__mmenu = "Attack;Defende;Magics;Invocations;Items;Team;Settings"
    
    def getSockets(self):
        return [c.socket for c in self.__c.values()]
    
    def setClientMap(self, u, c):
        self.__c[u] = c
    
    def getClient(self, u):
        if self.__c.has_key(u):
            return self.__c[u]
        return None
    
    def getClientBySocket(self, s):
        for c in self.__c.values():
            if c.socket == s:
                return c
        return None
    
    def delClientMap(self, u):
        if self.__c.has_key(u):
            del self.__c[u]
    
    def clearClientsMap(self):
        self.__c = {}
    
    # Main Function Server
    
    def addClient(self, uid, s):
        c = None
        try:
            name = self.__db.getNameByUid(uid)
            if name:
                c = Client(s, uid, name)
        except Exception, e:
            print e
        if c:
            print 'Add Client uid %s' % uid
            self.setClientMap(uid, c)
            self.__server.sendLine(s, "E|Connesso")
        else:
            self.__server.sendLine(s, "E|Non sei registrato")
    
    def delClientBySocket(self, s):
        #try:
        c = self.getClientBySocket(s)
        print 'Del Client uid %s' % c.uid
        c.socket.close()
        self.delClientMap(c.uid)
        #except Exception, e:
        #    print e
    
    def mainLoop(self):
        for k in self.__a.keys():
            t = self.__a[k]["time"]
            if time.time() - t > 15: # change turn
                mode = 0
                uids = k.split('|')
                clients = [self.getClient(u) for u in uids]
                other = clients[0]
                
                if not clients[0]:
                    mode += 1
                    other = clients[1]
                if not clients[1]:
                    mode += 2
                
                if mode < 3:
                    if mode > 0:
                        self.__server.sendLine(other.socket, "T|fine")
                        self.delArena(k)
                        return
                else:
                    self.delArena(k)
                    return
                
                self.__a[k]["turn"] = next(uids, self.__a[k]["turn"])
                self.__a[k]["time"] = time.time()
                
                for c in clients:
                    if c.uid == self.__a[k]["turn"]:
                        #self.clients[uid].main_menu = ""
                        self.__server.sendLine(c.socket, 
                                               ["T|%s" % c.name, 
                                                "M|%s" % self.__mmenu])
                    else:
                        self.__server.sendLine(c.socket, 
                                               ["T|%s" % self.getClient(self.__a[k]["turn"]).name,
                                                "M|chiudi"])
    
    def createArena(self, c1, c2):
        for k in self.__a.keys():
            uids = k.split('|')
            if c1.uid in uids and c2.uid not in uids:
                self.__server.sendLine(c2.socket, "E|Utente impegnato")
                return
            if c2.uid in uids and c1.uid not in uids:
                self.__server.sendLine(c1.socket, "E|Utente impegnato")
                return
        
        k = '%s|%s' % (c1.uid, c2.uid)
        if not self.__a.has_key(k):
            print "Create Arena %s" % k
            self.__a[k] = {
                "turn": c2.uid,
                "time": time.time()
                }
            self.__server.sendLine(c2.socket, ["T|%s" % c2.name, "M|%s" % self.__mmenu])
            self.__server.sendLine(c1.socket, ["T|%s" % c2.name, "M|chiudi"])
        else:
            print "Client rientrato in Arena %s" % k
    
    def delArena(self, k):
        del self.__a[k]
        print "Delete Arena %s" % k
