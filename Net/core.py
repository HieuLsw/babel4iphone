from client import Client
from db import Database
from utils import *
import time

class Core(object):
    
    def __init__(self, server):
        self.__server = server
        self.__db = Database()
        self.__c = {}
        
        self.__mmenu = gettext("Attack;Defende;Magics;Invocations;Items;Team;Settings")
    
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
        
        if self.getClient(uid): # lo sleep potrebbe aspettare a ripulire il vecchio socket in caso di rilogin
            self.__server.sendLine(s, "E|%s" % gettext("Aspetta 2 secondi per riloggare"))
        elif c:
            self.setClientMap(uid, c)
            print gettext("Aggiunto client uid %s") % uid
            self.__server.sendLine(s, "N|%s" % name)
        else:
            self.__server.sendLine(s, "E|%s" % gettext("Non sei registrato"))
    
    def delClientBySocket(self, s):
        c = self.getClientBySocket(s)
        if c:
            c.socket.close()
            self.delClientMap(c.uid)
            print gettext("Cancellato client uid %s") % c.uid
        else:
            s.close()
    
    def mainLoop(self):
        arena = self.__db.getAllArena()
        for a in arena:
            t = a["time"]
            if time.time() - t > 15: # change turn
                mode = 0
                uids = [a["user_id1"], a["user_id2"]]
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
                        self.delArena(a)
                        return
                else:
                    self.delArena(a)
                    return
                
                a["turn"] = next(uids, a["turn"])
                a["time"] = time.time()
                self.__db.updateArena(a)
                
                for c in clients:
                    if c.uid == a["turn"]:
                        self.__server.sendLine(c.socket, 
                                               ["T|%s" % c.name, 
                                                "M|%s" % self.__mmenu])
                    else:
                        self.__server.sendLine(c.socket, 
                                               "T|%s" % self.getClient(a["turn"]).name)
    
    def createArena(self, c1, c2):
        if not c2:
            self.__server.sendLine(c1.socket, gettext("E|Utente non connesso"))
            return
        
        mode = 0
        tmp = self.__db.getArenaByUser(c1.uid)
        if tmp and c2.uid != tmp["user_id1"] and c2.uid != tmp["user_id2"]:
            self.__server.sendLine(c1.socket, "E|%s" % gettext("Sei impegnato con un altro utente"))
            return
        else:
            mode += 1
        tmp = self.__db.getArenaByUser(c2.uid)
        if tmp and c1.uid != tmp["user_id1"] and c1.uid != tmp["user_id2"]:
            self.__server.sendLine(c1.socket, "E|%s" % gettext("Utente impegnato"))
            return
        else:
            mode += 2
        
        arena = self.__db.getArena(c1.uid, c2.uid)
        if not arena:
            if self.__db.createArena(c1.uid, c2.uid, c2.uid, time.time()):
                print gettext("Creata arena %s|%s") % (c1.uid, c2.uid)
                self.__server.sendLine(c2.socket, ["T|%s" % c2.name, "M|%s" % self.__mmenu])
                self.__server.sendLine(c1.socket, "T|%s" % c2.name)
                # inviare ai 2 anche tutti i dati del combattimento
        elif mode >= 3:
            msgs = ["T|%s" % self.getClient(arena["turn"]).name]
            if c1.uid == arena["turn"]:
                msgs.append("M|%s" % self.__mmenu)
            self.__server.sendLine(c1.socket, msgs)
            print gettext("Client rientrato nell'arena %s|%s") % (c1.uid, c2.uid)
            # mandargli i dati e il turno di ora a quello rientrato da arena
    
    def delArena(self, a):
        if self.__db.delArena(a):
            print gettext("Cancellata arena id %s|%s") % (a["user_id1"], a["user_id2"])
