const oracledb = require("oracledb");
const mongodb = require("mongodb").MongoClient;

const ORACLE_CONNECTION = {
  user: "andres",
  password: "2907",
  connectString: "localhost:1521/xe",
};
const MONGO_URL = "mongodb://localhost:27017";
const DB_MONGO = "test";

const run = async () => {
  let data = await getDataFromOracle();
  console.log(data)
  await insertDataIntoMongo(data);
};

const getDataFromOracle = async () => {
  let connection;

  try {
    connection = await oracledb.getConnection(ORACLE_CONNECTION);
    const result = await connection.execute(
      `SELECT v.numeroDeSerie, a.modelo
       FROM Producto p, Venta v, Automovil a
       WHERE p.id = a.id
       AND v.idProducto = p.id`
    ); 

    return result.rows;
  } catch (err) {
    console.error(err);
  } finally {
    if (connection) {
      try {
        await connection.close();
      } catch (err) {
        console.error(err);
      }
    }
  }
};

const insertDataIntoMongo = async (data) => {
  mongodb.connect(MONGO_URL, (err, db) => {
    try {
      if (err) throw err;

      const dbo = db.db(DB_MONGO);

      console.log(data);
      const rows = []; //See how data is being passed and make an object accordingly

      
      dbo.collection("telemetria").insertMany(rows, (err, res) => {
        if (err) throw err;
        db.close();
      });
    } catch (err) {
      console.log(err);
    }
  });
};

run();
