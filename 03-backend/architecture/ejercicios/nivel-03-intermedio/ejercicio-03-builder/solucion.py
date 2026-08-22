class QueryBuilder:
    def __init__(self):
        self._select = "*"
        self._from = ""
        self._where = []
        self._limit = None
        self._order = ""

    def select(self, cols):
        self._select = cols
        return self

    def from_(self, tabla):
        self._from = tabla
        return self

    def where(self, cond):
        self._where.append(cond)
        return self

    def order_by(self, col):
        self._order = col
        return self

    def limit(self, n):
        self._limit = n
        return self

    def build(self):
        sql = f"SELECT {self._select} FROM {self._from}"
        if self._where:
            sql += " WHERE " + " AND ".join(self._where)
        if self._order:
            sql += f" ORDER BY {self._order}"
        if self._limit is not None:
            sql += f" LIMIT {self._limit}"
        return sql
