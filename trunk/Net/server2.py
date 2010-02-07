#!/usr/bin/python -O

from core import Core
from reactor import *
import select, socket, sys, signal

BUFSIZ = 1024
DELIMETER = "\r\n"

class Server(object):
    
    def __init__(self, host = "localhost", port = 66666, backlog = 5):
        self.__core = Core(self)
        
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server.bind((host, port))
        self.server.listen(backlog)
        signal.signal(signal.SIGINT, self.sighandler) # ctrl-c
        print "Server is up on %s:%s..." % (host, port)
        self.__start()
    
    def sighandler(self, signum, frame):
        print "Shutting down server..."
        for s in self.__core.getSockets():
            s.close()
        self.server.close()
    
    def sendLine(self, s, msg, t = 0):
        msg = msg.replace("\r", "")
        msg = msg.replace("\n", "")
        reactor.callLater(t, s, "send", msg + DELIMETER)
    
    def __start(self):
        self.__core.clearSockets()
        self.__core.setInputs([self.server, sys.stdin])
        
        running = 1
        
        while running:
            try:
                inputready, outputready, exceptready = \
                    select.select(self.__core.getInputs(), self.__core.getSockets(), [])
            except select.error, e:
                break
            except socket.error, e:
                break
            
            for s in inputready:
                if s == self.server:
                    client, address = self.server.accept()
                    self.__dispatch(client)
                elif s == sys.stdin:
                    junk = sys.stdin.readline()
                    running = 0
                else:
                    try:
                        self.__dispatch(s)
                    except socket.error, e:
                        self.__core.delClient(s)
            self.__core.mainLoop()
            reactor.step()
        self.server.close()
    
    def __dispatch(self, s):
        data = None
        try:
            data = s.recv(BUFSIZ).split(DELIMETER)[:-1]
        except:
            pass
        if not data:
            self.__core.delClient(s)
        else:
            for msg in data:
                if msg:
                    m = msg.split('|')
                    if m:
                        if 'U' == m[0]:
                            self.__core.addClient(s, m[1])
                        elif 'F' == m[0]:
                            s2 = self.__core.getSocket(m[1])
                            if s2:
                                self.__core.createArena(s, s2)
                            else:
                                self.sendLine(s, "E|Utente non connesso")
                        elif 'E' == m[0]:
                            print "Echo %s: %s" % (self.__core.getUid(s), m[1])
                        else:
                            print "Not implemented: %s" % m


if __name__ == "__main__":
    #Server("192.168.1.1")
    Server()
