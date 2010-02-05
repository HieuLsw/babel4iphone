#!/usr/bin/python -O

import select, socket, sys, signal

BUFSIZ = 1024
DELIMETER = "\r\n"

class Server(object):
    
    def __init__(self, host = "localhost", port = 66666, backlog = 5):
        # Client map
        self.clientmap = {}
        self.inputs = []
        
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server.bind((host, port))
        self.server.listen(backlog)
        # Trap keyboard interrupts
        signal.signal(signal.SIGINT, self.sighandler)
        print "Server is up on %s:%s..." % (host, port)
    
    def sighandler(self, signum, frame):
        # Close the server
        print "Shutting down server..."
        # Close existing client sockets
        for s in self.clientmap.keys():
            s.close()
        self.server.close()
    
    def sendLine(self, s, msg):
        s.send(msg + DELIMETER)
    
    def serve(self):
        self.clientmap = {}
        self.inputs = [self.server, sys.stdin]
        
        running = 1
        
        while running:
            try:
                inputready, outputready, exceptready = select.select(self.inputs, self.clientmap.keys(), [])
            except select.error, e:
                break
            except socket.error, e:
                break
            
            for s in inputready:
                if s == self.server:
                    # handle the server socket
                    client, address = self.server.accept()
                    # Read the login name
                    self.__dispatch(client)
                elif s == sys.stdin:
                    # handle standard input
                    junk = sys.stdin.readline()
                    running = 0
                else:
                    # handle all other sockets
                    try:
                        self.__dispatch(s)
                    except socket.error, e:
                        # Remove
                        self.inputs.remove(s)
                        del self.clientmap[s]
        
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
                            uid = m[1]
                            print 'Add Client %d uid %s' % (s.fileno(), uid)
                            self.sendLine(s, "E|ok")
                            
                            self.inputs.append(s)
                            self.clientmap[s] = uid
                        elif 'E' == m[0]:
                            print "Echo " + self.clientmap[s] + ": " + m[1]
                            self.sendLine(s, m[1])
                        else:
                            pass
        else:
            print 'Del Client %d uid %s hung up' % (s.fileno(), self.clientmap[s])
            s.close()
            self.inputs.remove(s)
            del self.clientmap[s]


if __name__ == "__main__":
    Server().serve()
