# Micro-Notas
Pequeno sistema para pesquisa e aprovação de notas.

### Módulos
Todas as classes do sistema estão organizadas em seus respectivos módulos(prgs), por exemplo.
```ruby
oHistorico = newObject("historico","historico.prg")
oHistorico.listarHistorico()

oSql = newObject("Sql","Sql.prg")
oSql.Executar("Select * From ....")
```
### Aparência
Todo componente visual é herdado de sua respectiva classe construída pelo Class-Designer.

### Banco de dados
Mysql 5.5 -
Foi incluído um Dump das informações, string de conexão dentro de Sql.prg
Somente um administrador pode fazer cadastros e consultar histórico
login = admin
senha = admin
