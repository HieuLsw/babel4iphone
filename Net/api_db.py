from twisted.internet import reactor
from twisted.enterprise import adbapi

class ApiDB(object):
    
    def __init__(self):
        self.conn = None
        try:
            self.conn = adbapi.ConnectionPool("MySQLdb", user = "root", db = "gameDB")
        except Exception, e:
            print e
    
    def __getData(self, txn, select, table, where):
        sql = "SELECT %s FROM %s WHERE %s" % (select, table, where)
        txn.execute(sql)
        result = txn.fetchall()
        if result:
            print result[0]
    
    def getData(self, select, table, where = "'1'"):
        if self.conn:
            self.conn.runInteraction(self.__getData, select, table, where)
    
    def setData(self, table, fields):
        if self.conn:
            keys = fields.keys()
            values = fields.values()
            sql = "INSERT INTO %s(%s) VALUES(%s)" % (table, ','.join(keys), ','.join(values))
            self.conn.runQuery(sql)
    
    # High Func
    
    def __goc_user(self, txn, uid, name):
        sql = "SELECT * FROM user WHERE uid=%s" % (uid)
        txn.execute(sql)
        result = txn.fetchall()
        if result:
            print result[0]
        else:
            self.setData("user", {'uid': uid, "name": name})
            reactor.callLater(0.5, self.get_or_create_user, uid, name)
    
    def get_or_create_user(self, uid, name):
        if self.conn:
            self.conn.runInteraction(self.__goc_user, uid, name)


if __name__=="__main__":
    conn = ApiDB()
    conn.get_or_create_user("'U41242'", "'vito'")
    #for i in xrange(100):
    #    conn.getData("*", "user")
    reactor.run()
