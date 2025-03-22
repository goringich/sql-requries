// =======================================================
// Часть 1: Cypher‑запросы для выполнения заданий по уровням 1 и 2
// =======================================================

// Создаём узлы District с уникальным свойством name
MERGE (:District {name: "Канавинский"});
MERGE (:District {name: "Советский"});
MERGE (:District {name: "Нижегродский"});
MERGE (:District {name: "Ленинский"});
MERGE (:District {name: "Приокский"});
MERGE (:District {name: "Сормовский"});

// Создаём ограничение для District, если его ещё нет
CREATE CONSTRAINT unique_node_constraint IF NOT EXISTS FOR (n:District) REQUIRE n.name IS UNIQUE;

// Создаём узлы Policyholder и устанавливаем связь LIVED с District
MATCH (d:District {name:"Канавинский"})
MERGE (p:Policyholder {id:1})
  SET p.surname = "Гришков", p.discount = 2
CREATE (p)-[:LIVED]->(d);

MATCH (d:District {name:"Советский"})
MERGE (p:Policyholder {id:2})
  SET p.surname = "Бессонов", p.discount = 2
CREATE (p)-[:LIVED]->(d);

MATCH (d:District {name:"Нижегродский"})
MERGE (p:Policyholder {id:3})
  SET p.surname = "Чарышникова", p.discount = 0
CREATE (p)-[:LIVED]->(d);

MATCH (d:District {name:"Нижегродский"})
MERGE (p:Policyholder {id:4})
  SET p.surname = "Сотникова", p.discount = 0
CREATE (p)-[:LIVED]->(d);

MATCH (d:District {name:"Ленинский"})
MERGE (p:Policyholder {id:5})
  SET p.surname = "Мельников", p.discount = 0
CREATE (p)-[:LIVED]->(d);

// Создаём узлы InsuranceAgent и устанавливаем связь WORKED с District
MATCH (d:District {name:"Приокский"})
MERGE (ia:InsuranceAgent {id:1})
  SET ia.surname = "Лореттов", ia.commission = 5
CREATE (ia)-[:WORKED]->(d);

MATCH (d:District {name:"Советский"})
MERGE (ia:InsuranceAgent {id:2})
  SET ia.surname = "Шалин", ia.commission = 5
CREATE (ia)-[:WORKED]->(d);

MATCH (d:District {name:"Сормовский"})
MERGE (ia:InsuranceAgent {id:3})
  SET ia.surname = "Киселева", ia.commission = 5
CREATE (ia)-[:WORKED]->(d);

MATCH (d:District {name:"Советский"})
MERGE (ia:InsuranceAgent {id:4})
  SET ia.surname = "Растворов", ia.commission = 3
CREATE (ia)-[:WORKED]->(d);

MATCH (d:District {name:"Нижегродский"})
MERGE (ia:InsuranceAgent {id:5})
  SET ia.surname = "Калин", ia.commission = 4
CREATE (ia)-[:WORKED]->(d);

MATCH (d:District {name:"Нижегродский"})
MERGE (ia:InsuranceAgent {id:6})
  SET ia.surname = "Вишнякова", ia.commission = 5
CREATE (ia)-[:WORKED]->(d);

// Создаём ограничение для Policyholder, если его ещё нет
CREATE CONSTRAINT unique_policyholder_id IF NOT EXISTS FOR (p:Policyholder) REQUIRE p.id IS UNIQUE;

// Создаём ограничение для InsuranceAgent, если его ещё нет
CREATE CONSTRAINT unique_agent_id IF NOT EXISTS FOR (a:InsuranceAgent) REQUIRE a.id IS UNIQUE;

// Создаём узлы InsuranceType и устанавливаем связь PAYMENT_ADDRESS с District
MATCH (d:District {name:"Нижегродский"})
MERGE (it:InsuranceType {id:1})
  SET it.name = "Недвижимость", it.weeklyPayment = 2000, it.maxPolicyholders = 50
CREATE (it)-[:PAYMENT_ADDRESS]->(d);

MATCH (d:District {name:"Нижегродский"})
MERGE (it:InsuranceType {id:2})
  SET it.name = "Дом.Животные", it.weeklyPayment = 700, it.maxPolicyholders = 40
CREATE (it)-[:PAYMENT_ADDRESS]->(d);

MATCH (d:District {name:"Советский"})
MERGE (it:InsuranceType {id:3})
  SET it.name = "Автомобиль", it.weeklyPayment = 1500, it.maxPolicyholders = 40
CREATE (it)-[:PAYMENT_ADDRESS]->(d);

MATCH (d:District {name:"Советский"})
MERGE (it:InsuranceType {id:4})
  SET it.name = "Жизнь", it.weeklyPayment = 2200, it.maxPolicyholders = 35
CREATE (it)-[:PAYMENT_ADDRESS]->(d);

MATCH (d:District {name:"Приокский"})
MERGE (it:InsuranceType {id:5})
  SET it.name = "С.х.животные", it.weeklyPayment = 800, it.maxPolicyholders = 40
CREATE (it)-[:PAYMENT_ADDRESS]->(d);

MATCH (d:District {name:"Приокский"})
MERGE (it:InsuranceType {id:6})
  SET it.name = "От пожара", it.weeklyPayment = 1300, it.maxPolicyholders = 50
CREATE (it)-[:PAYMENT_ADDRESS]->(d);

MATCH (d:District {name:"Нижегродский"})
MERGE (it:InsuranceType {id:7})
  SET it.name = "Компьютер", it.weeklyPayment = 1000, it.maxPolicyholders = 20
CREATE (it)-[:PAYMENT_ADDRESS]->(d);

// Создаём ограничение для InsuranceType, если его ещё нет
CREATE CONSTRAINT unique_insurance_type_id IF NOT EXISTS FOR (it:InsuranceType) REQUIRE it.id IS UNIQUE;

// Создаём узлы InsuranceContract и устанавливаем соответствующие связи
MATCH (p:Policyholder {id:1}), (ia:InsuranceAgent {id:6}), (it:InsuranceType {id:5})
MERGE (ic:InsuranceContract {contractNumber: 1})
  SET ic.date = "Январь", ic.duration = 4, ic.cost = 32000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:2}), (ia:InsuranceAgent {id:5}), (it:InsuranceType {id:2})
MERGE (ic:InsuranceContract {contractNumber: 2})
  SET ic.date = "Январь", ic.duration = 8, ic.cost = 56000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:3}), (ia:InsuranceAgent {id:1}), (it:InsuranceType {id:5})
MERGE (ic:InsuranceContract {contractNumber: 3})
  SET ic.date = "Январь", ic.duration = 2, ic.cost = 16000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:3}), (ia:InsuranceAgent {id:2}), (it:InsuranceType {id:2})
MERGE (ic:InsuranceContract {contractNumber: 4})
  SET ic.date = "Январь", ic.duration = 6, ic.cost = 78000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:1}), (ia:InsuranceAgent {id:6}), (it:InsuranceType {id:3})
MERGE (ic:InsuranceContract {contractNumber: 5})
  SET ic.date = "Февраль", ic.duration = 2, ic.cost = 30000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:2}), (ia:InsuranceAgent {id:5}), (it:InsuranceType {id:3})
MERGE (ic:InsuranceContract {contractNumber: 6})
  SET ic.date = "Февраль", ic.duration = 4, ic.cost = 60000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:2}), (ia:InsuranceAgent {id:4}), (it:InsuranceType {id:7})
MERGE (ic:InsuranceContract {contractNumber: 7})
  SET ic.date = "Февраль", ic.duration = 8, ic.cost = 80000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:4}), (ia:InsuranceAgent {id:4}), (it:InsuranceType {id:4})
MERGE (ic:InsuranceContract {contractNumber: 8})
  SET ic.date = "Февраль", ic.duration = 6, ic.cost = 132000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:1}), (ia:InsuranceAgent {id:5}), (it:InsuranceType {id:7})
MERGE (ic:InsuranceContract {contractNumber: 9})
  SET ic.date = "Март", ic.duration = 2, ic.cost = 2000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:1}), (ia:InsuranceAgent {id:2}), (it:InsuranceType {id:5})
MERGE (ic:InsuranceContract {contractNumber: 10})
  SET ic.date = "Апрель", ic.duration = 1, ic.cost = 800
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:1}), (ia:InsuranceAgent {id:3}), (it:InsuranceType {id:4})
MERGE (ic:InsuranceContract {contractNumber: 11})
  SET ic.date = "Апрель", ic.duration = 17, ic.cost = 374000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:3}), (ia:InsuranceAgent {id:2}), (it:InsuranceType {id:3})
MERGE (ic:InsuranceContract {contractNumber: 12})
  SET ic.date = "Апрель", ic.duration = 2, ic.cost = 3000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:3}), (ia:InsuranceAgent {id:3}), (it:InsuranceType {id:3})
MERGE (ic:InsuranceContract {contractNumber: 13})
  SET ic.date = "Апрель", ic.duration = 1, ic.cost = 1500
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:4}), (ia:InsuranceAgent {id:2}), (it:InsuranceType {id:3})
MERGE (ic:InsuranceContract {contractNumber: 14})
  SET ic.date = "Апрель", ic.duration = 4, ic.cost = 6000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:5}), (ia:InsuranceAgent {id:3}), (it:InsuranceType {id:1})
MERGE (ic:InsuranceContract {contractNumber: 15})
  SET ic.date = "Май", ic.duration = 8, ic.cost = 16000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:3}), (ia:InsuranceAgent {id:5}), (it:InsuranceType {id:4})
MERGE (ic:InsuranceContract {contractNumber: 16})
  SET ic.date = "Июнь", ic.duration = 8, ic.cost = 176000
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);

MATCH (p:Policyholder {id:1}), (ia:InsuranceAgent {id:5}), (it:InsuranceType {id:6})
MERGE (ic:InsuranceContract {contractNumber: 17})
  SET ic.date = "Июнь", ic.duration = 2, ic.cost = 2600
CREATE (p)-[:HAS_CONTRACT]->(ic),
       (ia)-[:HAS_CONTRACT]->(ic),
       (ic)-[:HAS_TYPE]->(it);


// ----- Уровень 1 -----
// Задание 4.c)
MATCH (it:InsuranceType)
RETURN DISTINCT it.name AS insuranceType;

// ----- Задание 5 -----

// 5.c)
MATCH (ia:InsuranceAgent)-[:WORKED]->(d:District)
WHERE d.name = "Приокский"
RETURN ia.surname AS surname;

// ----- Задание 6 -----

// 6.b)
MATCH (ia:InsuranceAgent)-[:HAS_CONTRACT]->(ic:InsuranceContract),
      (ic)-[:HAS_TYPE]->(it:InsuranceType)
RETURN ic.date AS date, ia.surname AS agent, it.name AS insuranceType, ic.duration AS duration;

// ----- Задание 7 -----

// 7.d)
MATCH (ia:InsuranceAgent)-[:HAS_CONTRACT]->(ic:InsuranceContract)
WHERE ic.cost > 100000 AND ic.date IN ["Февраль", "Март", "Апрель", "Май", "Июнь"]
RETURN DISTINCT ia.surname AS agent;

// ----- Уровень 2 -----


// 10.b)
MATCH (ia:InsuranceAgent)
WHERE NOT EXISTS {
  MATCH (ia)-[:HAS_CONTRACT]->(ic:InsuranceContract)<-[:HAS_CONTRACT]-(p:Policyholder)-[:LIVED]->(d:District)
  WHERE d.name = "Нижегродский"
}
RETURN ia.surname AS agent;

// 10.c)
MATCH (it:InsuranceType)-[:PAYMENT_ADDRESS]->(d:District)
WHERE NOT d.name IN ["Советский"]
RETURN it.name AS insuranceType, d.name AS district;

// 11.d)
MATCH (p:Policyholder)-[:HAS_CONTRACT]->(ic:InsuranceContract)-[:HAS_TYPE]->(it:InsuranceType)-[:PAYMENT_ADDRESS]->(d:District),
      (p)-[:LIVED]->(d2:District)
WHERE ALL(x IN [d.name] WHERE x = d2.name)
RETURN DISTINCT it.name AS insuranceType, d.name AS district;

// 12)
MATCH (ia:InsuranceAgent)-[:WORKED]->(d:District)
RETURN d.name AS district
UNION
MATCH (it:InsuranceType)-[:PAYMENT_ADDRESS]->(d:District)
RETURN d.name AS district;

// 13.d)
MATCH (p:Policyholder)-[:LIVED]->(d:District)
WHERE NOT EXISTS {
  MATCH (p)-[:HAS_CONTRACT]->(ic:InsuranceContract)
  WHERE ic.date IN ["Январь", "Февраль"] 
    AND EXISTS {
      MATCH (ic)-[:HAS_TYPE]->(it:InsuranceType)-[:PAYMENT_ADDRESS]->(dp:District)
      WHERE dp.name <> d.name
    }
}
RETURN p.surname AS policyholder;


// 14.d)
MATCH (ia:InsuranceAgent)-[:WORKED]->(d1:District {name:"Нижегродский"})
MATCH (p:Policyholder)-[:LIVED]->(d2:District {name:"Сормовский"})
MATCH (ia)-[:HAS_CONTRACT]->(ic:InsuranceContract)<-[:HAS_CONTRACT]-(p)
RETURN sum(ic.cost) AS totalCost;


// 15.d)
MATCH (p:Policyholder)-[:HAS_CONTRACT]->(ic:InsuranceContract)<-[:HAS_CONTRACT]-(ia:InsuranceAgent)
WHERE ic.cost > 50000
RETURN p.surname AS policyholder, count(DISTINCT ia) AS agentCount;
