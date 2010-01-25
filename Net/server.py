from twisted.internet import reactor
from twisted.internet.protocol import Factory
from twisted.protocols.basic import LineReceiver

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
    
    def connectionLost(self , reason):
        self.factory.delClient(self.username)


class ServerFactory(Factory):
    protocol = ServerProtocol
    
    def __init__(self):
        self.clients = {}
    
    def addClient(self, username, client):
        if not self.clients.has_key(username):
            client.username = username
            self.clients[username] = client
            print "Add user %s." % username
        else:
            print "User named %s exists."
    
    def delClient(self, username):
        if self.clients.has_key(username):
            del self.clients[username]
            print "delete %s." % username
    
    def sendAll(self, message):
        for username, client in self.clients.items():
            client.sendLine(message)
    
    def send(self, username, message):
        if self.clients.has_key(username):
            self.clients[username].sendLine(message)
        else:
            print "No user named %s." % username


def loop(f):
    #print f.clients
    f.sendAll("sono server")
    reactor.callLater(5, loop, f)

if __name__=="__main__":
    f = ServerFactory()
    reactor.listenTCP(66666, f)
    reactor.callLater(5, loop, f)
    reactor.run()
