from neo4j import GraphDatabase

class Neo4jApp:
  def __init__(self, uri, user, password):
    self.driver = GraphDatabase.driver(uri, auth=(user, password))
  
  def close(self):
    self.driver.close()
  
  def create_and_fill_table(self):
    with self.driver.session() as session:
      # Очистка таблицы (удаление всех узлов с меткой Record)
      session.run("MATCH (n:Record) DETACH DELETE n")
      
      records = [
        {"id": 1, "name": "Alice", "value": 100},
        {"id": 2, "name": "Bob", "value": 200},
        {"id": 3, "name": "Charlie", "value": 300}
      ]
      
      # Вставка 
      for rec in records:
        session.run("CREATE (n:Record {id: $id, name: $name, value: $value})", rec)
  
  # Метод вывода содержимого 
  def output_table(self):
    with self.driver.session() as session:
      result = session.run("MATCH (n:Record) RETURN n")
      for record in result:
        print(record["n"])
  
  # обновление записи (по id)
  def update_record(self, record_id, new_value):
    with self.driver.session() as session:
      session.run("MATCH (n:Record {id: $id}) SET n.value = $value", {"id": record_id, "value": new_value})
  
  # удаление записи по id
  def delete_record(self, record_id):
    with self.driver.session() as session:
      session.run("MATCH (n:Record {id: $id}) DETACH DELETE n", {"id": record_id})
  
  # удаление всех узлов с меткой Record
  def clear_table(self):
    with self.driver.session() as session:
      session.run("MATCH (n:Record) DETACH DELETE n")

# Основной блок для демонстрации работы программы
if __name__ == "__main__":
  app = Neo4jApp("bolt://localhost:7687", "Neo4j", "")
  print("Создание и заполнение таблицы")
  app.create_and_fill_table()
  print("Вывод таблицы")
  app.output_table()
  print("Обновление кортежа с id=2")
  app.update_record(2, 250)
  print("Вывод таблицы после обновления")
  app.output_table()
  print("Удаление кортежа с id=1")
  app.delete_record(1)
  print("Вывод таблицы после удаления")
  app.output_table()
  print("Очистка таблицы")
  app.clear_table()
  print("Вывод таблицы после очистки")
  app.output_table()
  app.close()