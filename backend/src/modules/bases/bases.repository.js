const db = require('../../config/database');

class BasesRepository {
  async findAll(filters = {}) {
    const { limit, offset } = filters;
    let sql = 'SELECT * FROM Bases';
    const params = [];
    if (limit !== undefined && offset !== undefined) {
      sql += ' LIMIT ? OFFSET ?';
      params.push(limit, offset);
    }
    const [rows] = await db.query(sql, params);
    return rows;
  }

  async count(filters = {}) {
    const [rows] = await db.query('SELECT COUNT(*) AS total FROM Bases');
    return rows[0].total;
  }

  async findById(id, connection = null) {
    const dbConn = connection || db;
    const [rows] = await dbConn.query('SELECT * FROM Bases WHERE Base_id = ?', [id]);
    return rows[0] || null;
  }

  async create(data, connection = null) {
    const dbConn = connection || db;
    const [result] = await dbConn.query('INSERT INTO Bases SET ?', data);
    return result.insertId;
  }

  async update(id, data, connection = null) {
    const dbConn = connection || db;
    const [result] = await dbConn.query('UPDATE Bases SET ? WHERE Base_id = ?', [data, id]);
    return result.affectedRows > 0;
  }

  async delete(id, connection = null) {
    const dbConn = connection || db;
    const [result] = await dbConn.query('DELETE FROM Bases WHERE Base_id = ?', [id]);
    return result.affectedRows > 0;
  }
}

module.exports = new BasesRepository();