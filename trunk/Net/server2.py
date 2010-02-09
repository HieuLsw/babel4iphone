#!/usr/bin/python -O

from core import Core
from reactor import *
from types import StringType, ListType
import select, socket, sys, signal

SHOST = "localhost"
SPORT = 66666
BUFSIZ = 1024
DELIMETER = "\r\n"

class Server(object):
    
    def __init__(self, host = SHOST, port = SPORT, backlog = 5):        
        try:
            self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self.server.bind((host, port))
            self.server.listen(backlog)
            print "Server up %s:%s" % (host, port)
        except socket.error, (value, message):
            if self.server:
                self.server.close()
            print "Could not open socket: %s" % message
            sys.exit(1)
        
        signal.signal(signal.SIGINT, self.sighandler) # ctrl-c
        self.__core = Core(self)
        self.__start()
    
    def sighandler(self, signum, frame):
        print "Shutting down server..."
        for s in self.__core.getSockets():
            s.close()
        self.server.close()
    
    def sendLine(self, s, msg, t = 0):
        if type(msg) is StringType:
            msg = [msg]
        clean_msg = []
        for m in msg:
            m = str(m)
            m = m.replace("\r", "")
            m = m.replace("\n", "")
            clean_msg.append(m)
        msg = DELIMETER.join(clean_msg)        
        reactor.callLater(t, s.send, msg + DELIMETER)
    
    def __start(self):
        self.__core.clearClientsMap()
        
        running = 1
        
        while running:
            try:
                inputs = [self.server, sys.stdin]
                scks = self.__core.getSockets()
                inputs.extend(scks)
                inputready, outputready, exceptready = select.select(inputs, scks, [])
            except select.error, e:
                break
            except socket.error, e:
                break
            
            for s in inputready:
                if s == self.server:
                    c_sck, address = self.server.accept()
                    self.__dispatch(c_sck)
                elif s == sys.stdin:
                    junk = sys.stdin.readline()
                    running = 0
                else:
                    try:
                        self.__dispatch(s)
                    except socket.error, e:
                        self.__core.delClientBySocket(s)
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
            self.__core.delClientBySocket(s)
        else:
            for msg in data:
                if msg:
                    m = msg.split('|')
                    if m:
                        if 'U' == m[0]:
                            self.__core.addClient(m[1], s)
                        elif 'F' == m[0]:
                            c2 = self.__core.getClient(m[1])
                            if c2:
                                c1 = self.__core.getClientBySocket(s)
                                self.__core.createArena(c1, c2)
                            else:
                                self.sendLine(s, "E|Utente non connesso")
                        elif 'E' == m[0]:
                            c1 = self.__core.getClientBySocket(s)
                            print "Echo %s: %s" % (c1.uid, m[1])
                        else:
                            print "Not implemented: %s" % m


if __name__ == "__main__":
    Server()
