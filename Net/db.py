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
            sql = "INSERT INTO %s(%s) VALUES(%s);" % (table, ','.join(keys), ','.join(values))
            cursor.execute(sql)
            self.conn.commit()
        except Exception, e:
            print e
            result = False
            self.conn.rollback()
        return result
    
    def update(self, table, fields, where):
        result = True
        try:
            cursor = self.conn.cursor()
            values = ["%s=%s" % (k, v) for k, v in fields.items()]
            sql = "UPDATE %s SET %s WHERE %s;" % (table, ','.join(values), where)
            cursor.execute(sql)
            self.conn.commit()
        except Exception, e:
            print e
            result = False
            self.conn.rollback()
        return result
    
    def delete(self, table, where = '1'):
        result = True
        try:
            cursor = self.conn.cursor()
            sql = "DELETE FROM %s WHERE %s;" % (table, where)
            cursor.execute(sql)
            self.conn.commit()
        except Exception, e:
            print e
            result = False
            self.conn.rollback()
        return result
    
    # High Functions Database
    
    def getNameByUid(self, uid):
        r = self.select("name", "user", "id='%s'" % uid)
        if r:
            r = r[0]["name"]
        return r
    
    def getAllArena(self):
        return self.select("*", "arena")
    
    def getArena(self, uid1, uid2):
        r = self.select("turn, time", 
                        "arena", 
                        "(user_id1='%s' and user_id2='%s') or " % (uid1, uid2) + \
                            "(user_id1='%s' and user_id2='%s')" % (uid2, uid1))
        if r:
            r = r[0]
        return r
    
    def getArenaByUser(self, uid):
        r = self.select("*", 
                        "arena", 
                        "user_id1='%s' or user_id2='%s'" % (uid, uid))
        if r:
            r = r[0]
        return r
    
    def createArena(self, uid1, uid2, turn, time):
        return self.insert("arena", {"user_id1":"'%s'" % uid1, 
                                     "user_id2":"'%s'" % uid2, 
                                     "turn":"'%s'" % turn, 
                                     "time":str(time)})
    
    def updateArena(self, a):
        k, turn, time = a["id"], a["turn"], a["time"]
        return self.update("arena", {"turn":"'%s'" % turn, "time":str(time)}, "id=%s" % k)
    
    def delArena(self, a):
        k = a["id"]
        return self.delete("arena", "id=%s" % k)
    
    def getTeam(self, uid):
        r = self.select("id, char_id, level, hp, mp", 
                        "collection", 
                        "user_id='%s' and team=1" % uid)
        if r:
            r = r
        return r


if __name__ == "__main__":
    d = Database()
    #for r in d.select("*", "user"):
    #    print r
    #print d.getNameByUid("6397D24E-299F-594E-BEE1-C1BBEA6C0B9E")
    d.update("arena", {"user_id1":"'ciao'", "time": 0}, "id=4")
    d.delArena(4)
