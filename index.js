const mongodb = require("mongodb");
const oracledb = require("oracledb");

const run = async () => {
  const data = await getDataFromOracle();
  await insertDataIntoMongo(data);
};

const getDataFromOracle = async () => {
  let connection;

  try {
    connection = await oracledb.getConnection({
      user: "",
      password: "",
      connectString: "",
    });

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
  //TODO
  console.log(data);
};

run();
