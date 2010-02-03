from twisted.internet import reactor
from twisted.enterprise import adbapi

class ApiDB(object):
    
    def __init__(self):
        self.conn = None
        try:
            self.conn = adbapi.ConnectionPool("MySQLdb", user = "root", db = "gameDB")
        except Exception, e:
            print e
    
    def _getData2(self, txn, select, table, where):
        sql = "SELECT %s FROM %s WHERE %s" % (select, table, where)
        txn.execute(sql)
        result = txn.fetchall()
        if result:
            print result[0]
            return result[0][0]
        else:
            return None
    
    def getData2(self, select, table, where = "'1'"):
        return self.conn.runInteraction(self._getData2, select, table, where)
    
    def getData(self, select, table, where = "'1'"):
        sql = "SELECT %s FROM %s WHERE %s" % (select, table, where)
        self.conn.runQuery(sql).addCallbacks(self.printResult)
    
    def setData(self, table, fields):
        keys = fields.keys()
        values = fields.values()
        sql = "INSERT INTO %s(%s) VALUES(%s)" % (table, ','.join(keys), ','.join(values))
        self.conn.runQuery(sql).addCallbacks(self.printResult)
    
    def printResult(self, results):
        for item in results:
            print item


if __name__=="__main__":
    conn = ApiDB()
    #conn.setData("user", {"uid": "'U41242'", "name": "'vito'"})
    conn.getData2("*", "user")
    #conn.getData("*", "user")
    reactor.run()
    
