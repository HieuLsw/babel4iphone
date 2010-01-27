from twisted.internet import reactor
from twisted.internet.protocol import Factory
from twisted.protocols.basic import LineReceiver
import threading

# il socket riceve solo gli eventi e li indirizza al factory x attivare i comandi
class ServerProtocol(LineReceiver):
    
    def __init__(self):
        self.username = None
    
    def connectionMade(self):
        print "Connection..."
        self.factory.addClient("test", self)
        #pass
    
    def lineReceived(self, data):
        data = data.split("\r\n")
        for msg in data:
            m = msg.split('|')
            if 'U' == m[0]:
                self.factory.addClient(m[1], self)
            elif 'M' == m[0]:
                print m[1]
            else:
                print "no used: %s" % m
    
    def connectionLost(self , reason):
        self.factory.delClient(self.username)


# tutte le operazioni devono essere fatte nel factory e gestite con i lock
class ServerFactory(Factory):
    protocol = ServerProtocol
    clients_lock = threading.Lock()
    
    def __init__(self):
        self.clients_lock.acquire()
        self.clients = {}
        self.clients_lock.release()
    
    def addClient(self, username, client):
        self.clients_lock.acquire()
        if not self.clients.has_key(username):
            client.username = username
            self.clients[username] = client
            print "Add user %s." % username
        else:
            print "User named %s exists."
        self.clients_lock.release()
    
    def delClient(self, username):
        self.clients_lock.acquire()
        if self.clients.has_key(username):
            del self.clients[username]
            print "delete %s." % username
        self.clients_lock.release()
    
    def sendAll(self, message):
        self.clients_lock.acquire()
        for username, client in self.clients.items():
            client.sendLine(message)
        self.clients_lock.release()
    
    def send(self, username, message):
        self.clients_lock.acquire()
        if self.clients.has_key(username):
            self.clients[username].sendLine(message)
        else:
            print "No send msg, username %s not exist." % username
        self.clients_lock.release()


def loop(f):
    #print f.clients
    f.sendAll("sono server")
    reactor.callLater(5, loop, f)

if __name__=="__main__":
    f = ServerFactory()
    reactor.listenTCP(66666, f)
    reactor.callLater(5, loop, f)
    reactor.run()
