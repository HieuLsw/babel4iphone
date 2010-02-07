import MySQLdb

class Database(object):
    
    def __init__(self, host = "localhost", user = "root", passwd = "", db = "gameDB"):
        self.conn = None
        try:
            self.conn = MySQLdb.connect(host, user, passwd, db)
        except Exception, e:
            print e
    
    def close(self):
        if self.conn:
            self.conn.close()
    
    def select(self, select, table, where = "'1'"):
        result = None
        if self.conn:
            cursor = self.conn.cursor(MySQLdb.cursors.DictCursor)
            sql = "SELECT %s FROM %s WHERE %s;" % (select, table, where)
            cursor.execute(sql)
            result = cursor.fetchall()
        return result
    
    def insert(self, table, fields):
        result = False
        if self.conn:
            try:
                cursor = self.conn.cursor()
                keys = fields.keys()
                values = fields.values()
                sql = "INSERT INTO %s(%s) VALUES(%s);" % (table, ','.join(keys), ','.join(values))
                cursor.execute(sql)
                self.conn.commit()
                result = True
            except:
                self.conn.rollback()
        return result
    
    # High Functions Database
    
    def getNameFromUid(self, uid):
        r = self.select("name", "user", "uid='%s'" % uid)
        if r:
            r = r[0]["name"]
        return r


if __name__ == "__main__":
    d = Database()
    for r in d.select("*", "user"):
        print r
    print d.getNameFromUid("6397D24E-299F-594E-BEE1-C1BBEA6C0B9E")
