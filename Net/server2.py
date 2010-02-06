#!/usr/bin/python -O

import select, socket, sys, signal, time

BUFSIZ = 1024
DELIMETER = "\r\n"

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
                    globals()[fn[2]](*fn[3])
            else:
                self.__fn.append(fn)

reactor = Reactor()

# Core Funcions

def get_s(mapper, u):
    for s, uid in mapper.items():
        if uid == u:
            return s
    return None

def next(l, e):
    return l[(l.index(e) + 1) % len(l)]


class Server(object):
    
    def __init__(self, host = "localhost", port = 66666, backlog = 5):
        # Client map
        self.__c = {}
        self.__i = []
        
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server.bind((host, port))
        self.server.listen(backlog)
        # Trap keyboard interrupts
        signal.signal(signal.SIGINT, self.sighandler)
        print "Server is up on %s:%s..." % (host, port)
        
        self.__a = {} # arene
        self.__mm = "Attack;Defende;Magics;Invocations;Items;Team;Settings"
    
    def sighandler(self, signum, frame):
        print "Shutting down server..."
        for s in self.__c.keys():
            s.close()
        self.server.close()
    
    def sendLine(self, s, msg, t = 0):
        reactor.callLater(t, s, "send", msg + DELIMETER)
    
    def start(self):
        self.__c = {}
        self.__i = [self.server, sys.stdin]
        
        running = 1
        
        while running:
            try:
                inputready, outputready, exceptready = \
                    select.select(self.__i, self.__c.keys(), [])
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
                        self.__delClient(s)
            self.__mainLoop()
            reactor.step()
        self.server.close()
    
    def __dispatch(self, s):
        data = None
        try:
            data = s.recv(BUFSIZ).split(DELIMETER)[:-1]
        except:
            pass
        if data:
            for m in data:
                if m:
                    m = m.split('|')
                    if m:
                        if 'U' == m[0]:
                            self.__addClient(s, m[1])
                        elif 'F' == m[0]:
                            s2 = get_s(self.__c, m[1])
                            if s2:
                                self.__createArena(s, s2)
                        elif 'E' == m[0]:
                            print "Echo %s: %s" % (self.__c[s] ,m[1])
                        else:
                            print "Not implemented: %s" % m
        else:
            self.__delClient(s)
    
    # Main Funcions
    
    def __addClient(self, s, uid):
        print 'Add Client %d uid %s' % (s.fileno(), uid)
        self.__i.append(s)
        self.__c[s] = uid
        self.sendLine(s, "E|Connected")
    
    def __delClient(self, s):
        try:
            print 'Del Client %d uid %s' % (s.fileno(), self.__c[s])
            s.close()
            self.__i.remove(s)
            del self.__c[s]
        except Exception, e:
            print e
    
    def __mainLoop(self):
        for k in self.__a.keys():
            t = self.__a[k]["time"]
            if time.time() - t > 15:  # change turn
                mode = 0
                other = None
                scks = [get_s(self.__c, x) for x in k.split('|')]
                
                if not self.__c.has_key(scks[0]):
                    mode += 1
                    other = scks[1]
                if not self.__c.has_key(scks[1]):
                    mode += 2
                    other = scks[0]
                
                if mode < 3:
                    if mode > 0:
                        self.sendLine(other, "T|fine")
                        self.__delArena(k)
                        return
                else:
                    self.__delArena(k)
                    return
                
                self.__a[k]["turn"] = next(scks, self.__a[k]["turn"])
                self.__a[k]["time"] = time.time()                
                for s in scks:
                    if s == self.__a[k]["turn"]:
                        #self.clients[uid].main_menu = ""
                        name = self.getData("uid=%s" % self.__c[s])
                        self.sendLine(s, "T|%s" % name)
                        self.sendLine(s, "M|%s" % self.__mm, 2)
                    else:
                        name = self.getData("uid=%s" % self.__c[self.__a[k]["turn"]])
                        self.sendLine(s, "M|chiudi")
                        self.sendLine(s, "T|%s" % name, 0.5)
        
    def __createArena(self, s1, s2):
        uid1, uid2 = self.__c[s1], self.__c[s2]
        for k in self.__a.keys():
            uids = k.split('|')
            if uid1 in uids:
                self.sendLine(s2, "E|Utente impegnato")
                return
            if uid2 in uids:
                self.sendLine(s1, "E|Utente impegnato")
                return
        k = '%s|%s' % (uid1, uid2)
        if not self.__a.has_key(k):
            print "Create Arena %s" % k
            self.__a[k] = {
                "turn": s2,
                "time": time.time()
                }
            self.sendLine(s2, "T|%s" % self.getData("uid=%s" % uid2))
            self.sendLine(s2, "M|%s" % self.__mm, 2)
    
    def __delArena(self, k):
        del self.__a[k]
        print "Delete Arena %s" % k
    
    # simula lettura da db
    def getData(self, query):
        result = ""
        args = query.split('=')
        if "uid" == args[0]:
            if len(args[1]) > 10:
                result = "IPhone"
            else:
                result = "Python"
        elif "magics" == args[0]:
            if len(args[1]) > 10:
                result = "Fire:25;Water:25"
            else:
                result = "Fire:25"
        return result


if __name__ == "__main__":
    Server().start()
