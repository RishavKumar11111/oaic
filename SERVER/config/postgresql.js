const Pool = require('pg').Pool

const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "oaic",
  password: "postgres",
  // password: "1234",
  port: 5432
});

exports.selectAllFromTable = (tableName, callback) => {
    pool.query(`SELECT * FROM ${tableName}`, (error, results) => {
        callback(error, results)        
      });  
}
exports.insertSingleRow = (insertQuery, values, callback) => {
    pool.query(insertQuery, values, (err, results) => {
      callback(err, results);
    })
}
exports.insertRow = (parameterNames, parameterValues, tableName, callback) => {
  let insertQuery = `INSERT INTO ${tableName}( ${parameterNames} ) VALUES( ${parameterValues} ) RETURNING *`;
  pool.query(insertQuery, (err, response) => {
    callback(err, response);
  })

}
exports.selectAllByCondition = (condition, tableName, callback) => {
  let selectQuqry = `SELECT * FROM ${tableName} WHERE ${condition}`;
  pool.query(selectQuqry, (err, response) => {
    callback(err, response);
  })
}
exports.updateTable = (condition, query, tableName, callback) => {
  let updateQuery = `UPDATE ${tableName} SET ${query} WHERE ${condition}`;
  pool.query(updateQuery, (err, response) => {
    callback(err, response);
  })
}
exports.selectByJoinQuery = (query, callback) => {
  pool.query(query, (err, response) => {
    callback(err, response);
  })
}
exports.getMax = (fieldName, tableName, callback) => {
  let query = `select MAX(${fieldName}) from ${tableName}`;
  pool.query(query, (err, response) => {
    callback(err, response);
  })
}
exports.selectColumnsFromTable = (fields, condition, tableName, callback) => {
  pool.query(`SELECT ${fields} FROM ${tableName} WHERE ${condition}`, (error, results) => {
    callback(error, results)        
  }); 
}
exports.executeByQuery = (query, callback) => {
  pool.query(query, (err, response) => {
    callback(err, response);
  })
}