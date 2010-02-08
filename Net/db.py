import sys, MySQLdb

class Database(object):
    
    def __init__(self, h = "localhost", u = "root", p = "", db = "gameDB"):
        self.conn = None
        try:
            self.conn = MySQLdb.connect(h, u, p, db)
        except Exception, e:
            print e
            self.close()
            sys.exit(1)
    
    def close(self):
        if self.conn:
            self.conn.close()
    
    def select(self, select, table, where = "'1'"):
        cursor = self.conn.cursor(MySQLdb.cursors.DictCursor)
        sql = "SELECT %s FROM %s WHERE %s;" % (select, table, where)
        cursor.execute(sql)
        return cursor.fetchall()
    
    def insert(self, table, fields):
        result = True
        try:
            cursor = self.conn.cursor()
            keys = fields.keys()
            values = fields.values()
            sql = "INSERT INTO %s(%s) VALUES(%s);" % \
                (table, ','.join(keys), ','.join(values))
            cursor.execute(sql)
            self.conn.commit()
        except:
            result = False
            self.conn.rollback()
        return result
    
    # High Functions Database
    
    def getNameByUid(self, uid):
        r = self.select("name", "user", "uid='%s'" % uid)
        if r:
            r = r[0]["name"]
        return r


if __name__ == "__main__":
    d = Database()
    for r in d.select("*", "user"):
        print r
    print d.getNameByUid("6397D24E-299F-594E-BEE1-C1BBEA6C0B9E")
