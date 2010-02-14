#import sys, MySQLdb
import sys, sqlite3

class Database(object):
    
    #def __init__(self, h = "localhost", u = "root", p = "", db = "gameDB"):
    def __init__(self):
        self.conn = None
        try:
            #self.conn = MySQLdb.connect(h, u, p, db)
            self.conn = sqlite3.connect("gameDB.sqlite")
            self.conn.row_factory = sqlite3.Row
        except Exception, e:
            print e
            self.close()
            sys.exit(1)
    
    def close(self):
        if self.conn:
            self.conn.close()
    
    def select(self, select, table, where = "'1'"):
        #cursor = self.conn.cursor(MySQLdb.cursors.DictCursor)
        cursor = self.conn.cursor()
        sql = "SELECT %s FROM %s WHERE %s;" % (select, table, where)
        c = cursor.execute(sql)
        tmp = cursor.fetchall()
        
        # x sqlite return dict
        result = []
        for r in tmp:
            i = 0
            row = {}
            for k in r.keys():
                row.update({k: str(r[i])})
                i += 1
            result.append(row)
        return result
    
    def insert(self, table, fields):
        result = True
        try:
            cursor = self.conn.cursor()
            keys = fields.keys()
            values = fields.values()
            sql = "INSERT INTO %s (%s) VALUES (%s);" % (table, ','.join(keys), ','.join(values))
            print sql
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
    
    def getParty(self, uid):
        r = self.select("id, char_id, level, hp, mp", 
                        "collection", 
                        "user_id='%s' and party=1" % uid)
        if r:
            r = r
        return r


if __name__ == "__main__":
    d = Database()
    for r in d.select("*", "user"):
        print r
    #print d.insert("user", {"id":"'xxx'", "name":"'cazzo'"})
    #print d.update("user", {"name":"'ver'"}, "id='xxx'")
    #print d.delete("user", "id='xxx'")
    #print d.getNameByUid("U55555")
