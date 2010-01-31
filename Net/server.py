#!/usr/bin/python -O

from twisted.internet import reactor
from twisted.internet.protocol import Factory
from twisted.protocols.basic import LineReceiver
import threading, time

## FUNC ##

# da il successione elemento di una lista
def next(l, e):
    return l[(l.index(e) + 1) % len(l)]


# Server

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
            elif 'M' == m[0]:
                print m[1]
            else:
                print "No used: %s" % m
    
    def connectionLost(self , reason):
        self.factory.delClient(self.username)


class ServerFactory(Factory):
    protocol = ServerProtocol
    #clients_lock = threading.Lock()
    #arena_lock = threading.Lock()
    
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
    
    def sendAll(self, message):
        for username, client in self.clients.items():
            client.sendLine(message)
    
    def send(self, username, message):
        if self.clients.has_key(username):
            self.clients[username].sendLine(message)
        else:
            print "No send msg, username %s not exist." % username
    
    def mainLoop(self):
        #self.send('6397D24E-299F-594E-BEE1-C1BBEA6C0B9E', 'T|fine')
        keys = self.arena.keys()
        for k in keys:
            p =  k.split('|')
            t = self.arena[k]["time"]
            if time.time() - t > 10:
                self.arena[k]["turn"] = next(p, self.arena[k]["turn"])
                self.arena[k]["time"] = time.time()
                for uname in p:
                    if self.clients.has_key(uname):
                        self.send(uname, "T|%s" % self.arena[k]["turn"])
                    else:
                        del self.arena[k]
                        self.send(next(p, uname), "T|fine")
                        reactor.callLater(1, self.fight) # test
                        break
        reactor.callLater(1, self.mainLoop)
    
    # test
    def fight(self):
        print "wait..."
        if len(self.clients) > 1:
            key = '|'.join(self.clients.keys()[0:2])
            if not self.arena.has_key(key):
                print "create arena " + key
                self.arena[key] = {
                    "turn": self.clients.keys()[0],
                    "time": time.time()
                    }
        else:
            reactor.callLater(1, self.fight)


if __name__=="__main__":
    f = ServerFactory()
    reactor.listenTCP(66666, f)
    reactor.callLater(1, f.mainLoop)
    reactor.callLater(1, f.fight) # test
    reactor.run()
