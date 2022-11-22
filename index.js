const oracledb = require("oracledb");
const mongodb = require("mongodb").MongoClient;

const ORACLE_CONNECTION = {
  user: "",
  password: "",
  connectString: "",
};
const MONGO_URL = "";

const run = async () => {
  const data = await getDataFromOracle();
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
       AND f.idProducto = p.id;`
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

      const dbo = db.db("admin");

      console.log(data);
      const rows = []; //See how data is being passed and make an object accordingly

      rows.forEach((row) => {
        dbo.collection("telemetria").insertOne(myobj, (err, res) => {
          if (err) throw err;
          db.close();
        });
      });
    } catch (err) {
      console.log(err);
    }
  });
};

run();
