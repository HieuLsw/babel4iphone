#!/usr/bin/python -O

from twisted.internet import reactor
from twisted.internet.protocol import Factory
from twisted.protocols.basic import LineReceiver
import threading, time

## FUNC ##

# da il successione elemento di una lista
def next(l, e):
    return l[(l.index(e) + 1) % len(l)]


## SERVER ##

# il socket riceve solo gli event e li indirizza al factory x attivare i comandi
class ServerProtocol(LineReceiver):
    
    def __init__(self):
        self.username = None
    
    def connectionMade(self):
        pass
    
    def lineReceived(self, data):
        data = data.split("\r\n")
        for msg in data:
            m = msg.split('|')
            if 'U' == m[0]:
                self.factory.addClient(m[1], self)
            elif 'F' == m[0]:
                self.factory.fight(self.username, m[1])
            elif 'E' == m[0]:
                print m[1]
            else:
                print "No used: %s" % m
    
    def connectionLost(self , reason):
        self.factory.delClient(self.username)


class ServerFactory(Factory):
    protocol = ServerProtocol
    
    def __init__(self):
        self.playerSel = -1
        self.clients = {}
        self.arena = {}
    
    def addClient(self, username, client):
        if not self.clients.has_key(username):
            client.username = username
            self.clients[username] = client
            print "Add user %s." % username
        else:
            print "User %s exists."
    
    def delClient(self, username):
        if self.clients.has_key(username):
            del self.clients[username]
            print "Delete %s." % username
    
    def sendAll(self, message, time = 0):
        for username, client in self.clients.items():
            reactor.callLater(time, client.sendLine, message)
    
    def send(self, username, message, time = 0):
        if self.clients.has_key(username):
            reactor.callLater(time, self.clients[username].sendLine, message)
        else:
            print "No send msg, username %s not exist." % username
    
    def mainLoop(self):
        arena_keys = self.arena.keys()
        for k in arena_keys:
            players =  k.split('|')
            t = self.arena[k]["time"]
            if time.time() - t > 10:
                self.arena[k]["turn"] = next(players, self.arena[k]["turn"])
                self.arena[k]["time"] = time.time()
                for uname in players:
                    if self.clients.has_key(uname):
                        self.send(uname, "T|%s" % self.arena[k]["user"][self.arena[k]["turn"]]["name"])
                        if uname == self.arena[k]["turn"]:
                            self.send(uname, "M|%s" % self.arena[k]["main_menu"], 2)
                        else:
                            self.send(uname, "M|chiudi")
                    else:
                        del self.arena[k]
                        print "Delete arena %s" % k
                        self.send(next(players, uname), "T|fine")
                        break
        reactor.callLater(1, self.mainLoop)
    
    def fight(self, u1, u2):
        key = '%s|%s' % (u1, u2)
        if not self.arena.has_key(key):
            print "Create arena " + key
            self.arena[key] = {
                "turn": u2,
                "main_menu": "Attack;Defende;Magics;Invocations;Items;Team;Settings",
                "user": {u1:{"name": "Python", "magic_memu":""},  
                         u2:{"name":"IPhone", "magic_menu":""}},
                "time": time.time()
                }
            self.send(u2, "T|%s" % self.arena[key]["user"][u2]["name"])
            self.send(u2, "M|%s" % self.arena[key]["main_menu"], 2.5)            


if __name__=="__main__":
    f = ServerFactory()
    reactor.listenTCP(66666, f)
    reactor.callLater(1, f.mainLoop)
    reactor.run()
