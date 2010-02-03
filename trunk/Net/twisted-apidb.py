from twisted.internet import reactor
from twisted.enterprise import adbapi

def getData():
    return dbpool.runQuery("select * from auth_user")

def printResult(results):
    for item in results:
        print item

def close():
    dbpool.close()
    reactor.stop()

if __name__=='__main__':
    dbpool = adbapi.ConnectionPool("MySQLdb", user="root", db="CmDB")
    getData().addCallback(printResult)
    #getData().addCallback(printResult)
    reactor.callLater(0.5, close)
    reactor.run()
