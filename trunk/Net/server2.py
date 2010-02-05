#!/usr/bin/python -O

import select, socket, sys, signal

BUFSIZ = 1024

class Server(object):
    
    def __init__(self, host = "localhost", port = 66666, backlog = 5):
        # Client map
        self.clientmap = {}
        
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server.bind((host, port))
        self.server.listen(backlog)
        # Trap keyboard interrupts
        signal.signal(signal.SIGINT, self.sighandler)
    
    def sighandler(self, signum, frame):
        # Close the server
        print 'Shutting down server...'
        # Close existing client sockets
        for c in self.clientmap.keys():
            c.close()
        self.server.close()
    
    def serve(self):
        self.clientmap = {}
        inputs = [self.server, sys.stdin]
        
        running = 1
        
        while running:
            #print self.clientmap
            #print inputs
            
            try:
                inputready, outputready, exceptready = select.select(inputs, self.clientmap.keys(), [])
            except select.error, e:
                break
            except socket.error, e:
                break
            
            for s in inputready:
                if s == self.server:
                    # handle the server socket
                    client, address = self.server.accept()
                    # Read the login name
                    data = client.recv(BUFSIZ).split("\r\n")[:-1]
                    if data:
                        m = data[0].split('|')
                        if m and 'U' == m[0]:
                            uid = m[1]
                            print 'Add Client %d from %s uid %s' % (client.fileno(), address, uid)
                            client.send("E|ok\r\n")
                            
                            inputs.append(client)
                            self.clientmap[client] = uid
                elif s == sys.stdin:
                    # handle standard input
                    junk = sys.stdin.readline()
                    running = 0
                else:
                    # handle all other sockets
                    try:
                        data = s.recv(BUFSIZ).split("\r\n")[:-1]
                        if data:
                            for m in data:
                                if m:
                                    m = m.split('|')
                                    if m and 'E' == m[0]:
                                        print self.clientmap[s] + ": " + m[1]
                                        s.send("%s\r\n" % m[1])
                        else:
                            print 'Client: %d hung up uid %s' % (s.fileno(), self.clientmap[s])
                            s.close()
                            inputs.remove(s)
                            del self.clientmap[s]
                    except socket.error, e:
                        # Remove
                        inputs.remove(s)
                        del self.clientmap[s]
        
        self.server.close()


if __name__ == "__main__":
    Server().serve()
