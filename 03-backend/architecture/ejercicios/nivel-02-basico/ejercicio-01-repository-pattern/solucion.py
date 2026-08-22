from abc import ABC, abstractmethod

# Interfaz (puerto driven)
class UserRepository(ABC):
    @abstractmethod
    def save(self, user): ...
    @abstractmethod
    def find_by_id(self, id): ...
    @abstractmethod
    def find_by_email(self, email): ...

# Implementación para tests (real, en memoria)
class InMemoryUserRepository(UserRepository):
    def __init__(self):
        self._by_id = {}
        self._by_email = {}
    def save(self, user):
        self._by_id[user["id"]] = user
        self._by_email[user["email"]] = user
        return user
    def find_by_id(self, id):
        return self._by_id.get(id)
    def find_by_email(self, email):
        return self._by_email.get(email)

# Implementación "de producción" (simulada)
class MySQLUserRepository(UserRepository):
    def save(self, user):
        print(f"[MySQL] INSERT INTO users ... {user}")
        return user
    def find_by_id(self, id):
        print(f"[MySQL] SELECT * FROM users WHERE id={id}")
        return None
    def find_by_email(self, email):
        print(f"[MySQL] SELECT * FROM users WHERE email={email}")
        return None

# Dominio: depende de la INTERFAZ, no de MySQL
class UserService:
    def __init__(self, repo: UserRepository):
        self.repo = repo
    def register(self, email):
        if self.repo.find_by_email(email):
            raise ValueError("ya existe")
        user = {"id": f"u-{email}", "email": email}
        self.repo.save(user)
        return user
