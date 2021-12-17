var postgresql = require('../config/postgresql');
const { pool } = require('../config/config');

function getCurrentFinYear() {
    return new Promise(resolve => {
        var year = new Date().getFullYear().toString();
        var month = new Date().getMonth();
        var finYear = month >= 3 ? year + "-" + (parseInt(year.slice(2, 4)) + 1).toString() : (parseInt(year) - 1).toString() + "-" + year.slice(2, 4);
        resolve(finYear);
    })
}
exports.addCluster = async (data, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        await client.query('BEGIN');
        let query1 = `INSERT INTO jn_orders(fin_year, date, dist_id, dist_name, system, cluster_id, farmer_id, farmer_name, status) values`;
        let fin_year = await getCurrentFinYear();
        data.farmers.forEach( element => {
            query1 += `('${fin_year}', 'NOW()', '${data.dist_id}', '${data.dist_name}', 'jalanidhi', '${data.cluster_id}', '${element.farmer_id}', '${element.farmer_name}', 'not_paid'), `;
        });
        await client.query(query1.substring(0, query1.length - 2));
        await client.query('COMMIT');
        callback(true);
    } catch (e) {
        await client.query('ROLLBACK');
        callback(false);
        throw e
    } finally {
        client.release();
    }
}
exports.addFarmerPaymentFromJalanidhi = async (data, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        await client.query('BEGIN');
        let max = await client.query(`select MAX(sl_no) from payment`);
        let fin_year = await getCurrentFinYear();
        let transction_id = max.rows.length == 0 ? 'YR' + fin_year + '-DS' + data.dist_id + '-1' : 'YR' + fin_year + '-DS' + data.dist_id + '-' + (max.rows[0].max + 1);
        let from = `farmer-${data.farmer_id}`;
        let to = `DS-${data.dist_id}`;
        let queryText = `INSERT INTO payment(fin_year, date, transaction_id, reference_no, system, purpose, "from", "to", ammount, payment_date, payment_type, payment_no, remark) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)`;
        let values = [fin_year, 'NOW()', transction_id, data.cluster_id, 'jalanidhi', 'farmer_advance_payment', from, to, data.ammount, data.payment_date, data.payment_type, data.payment_no, data.remark];
        let addPayment = client.query(queryText, values);

        let queryText2 = `INSERT INTO payment_desc(transaction_id, reference_no) VALUES($1, $2)`;
        let values2 = [transction_id, data.farmer_id];
        let addPDesc = client.query(queryText2, values2);

        let query3 = `update jn_orders set status = 'paid' where cluster_id = '${data.cluster_id}' and farmer_id = '${data.farmer_id}'`;
        let updateOrder = client.query(query3);

        await addPayment; await addPDesc; await updateOrder;

        await client.query('COMMIT');
        callback(true);
    } catch (e) {
        await client.query('ROLLBACK');
        callback(false);
        throw e;
    } finally {
        client.release();
    }
};


function getTransId(dl_id, tableName, callback) {
    postgresql.getMax('sl_no', tableName, (err, result) => {
        if (err) throw err;
        let id = 'YR' + new Date().getFullYear() + '-' + dl_id + '-' + (result.rows[0].max + 1);
        callback(id);
    })
}
exports.addBillFromDealerJN = (bill, cluster_ids, callback) => {
    getTransId(bill.dl_id, 'payment', async trans_id => {

        let from = `DL-${bill.dl_id}`;
        let to = `DS-${bill.dist_id}`;
        let parameterNames = `fin_year, date, transaction_id, reference_no, system, purpose, "from", "to", ammount, remark`;
        let parameterValues = `'${await getCurrentFinYear()}', '${new Date()}', '${trans_id}', '${bill.po_no}', 'jalanidhi', 'advance_dealer_bill', '${from}', '${to}', '${bill.ammount}', '${bill.ammount}' `;
        postgresql.insertRow(parameterNames, parameterValues, 'payment', (err, result) => {
            if (err) throw err;
        })
        let query = `insert into payment_desc (transaction_id, reference_no) values `;
        cluster_ids.forEach(cluster_id => {
            query += `('${trans_id}', '${cluster_id}'), `;
        })
        postgresql.executeByQuery(query.substring(0, query.length - 2), (err, result) => {
            if (err) throw err;
            callback(true);
        })
    })
}
exports.addPayToDelearJN = async (data, cluster_ids, callback) => {

    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        await client.query('BEGIN');
        let max = await client.query(`select MAX(sl_no) from payment`);
        let fin_year = await getCurrentFinYear();
        let transction_id = max.rows.length == 0 ? 'YR' + fin_year + '-DS' + data.dist_id + '-1' : 'YR' + fin_year + '-DS' + data.dist_id + '-' + (max.rows[0].max + 1);
        let from = `DS-${data.dist_id}`;
        let to = `DL-${data.dl_id}`;
        let queryText = `INSERT INTO payment(fin_year, date, transaction_id, reference_no, system, purpose, "from", "to", ammount, remark) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`;
        let values = [fin_year, 'NOW()', transction_id, data.po_no, 'jalanidhi', 'pay_against_bill', from, to, data.ammount, data.remark];
        let addPayment = client.query(queryText, values);

        let query1 = `insert into payment_desc (transaction_id, reference_no) values `;
        cluster_ids.forEach(cluster_id => {
            query1 += `('${transction_id}', '${cluster_id}'), `;
        })
        let addPDesc = client.query(query1.substring(0, query1.length - 2));

        await addPayment; await addPDesc;

        await client.query('COMMIT');
        callback(true);
    } catch (e) {
        await client.query('ROLLBACK');
        callback(false);
        throw e;
    } finally {
        client.release();
    }
}
exports.addReceivedOrder = async (data, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `INSERT INTO jn_stock(fin_year, dist_id, dl_id, dl_name, system, po_no, cluster_id, farmer_id, farmer_name, implement, make, model, status, receive_date) 
    VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)`;
        let values = [await getCurrentFinYear(), data.dist_id, data.dl_id, data.dl_name, "jalanidhhi", data.po_no, data.cluster_id, data.farmer_id, data.farmer_name, data.implement, data.make, data.model, "received", "NOW()"];
        await client.query(queryText, values);
        callback(true);
    } catch (e) {
        callback(false);
        throw e
    } finally {
        client.release();
    }
}
exports.orderDeliveredToCustomer = async (data, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let updateQuery = `update jn_stock set status = 'delivered_to_customer', deliver_date = 'NOW()', engine_no = '${data.engine_no}', chassic_no = '${data.chassic_no}'
                            where po_no = '${data.po_no}' and cluster_id = '${data.cluster_id}' and farmer_id = '${data.farmer_id}' and implement = '${data.implement}' and make = '${data.make}' and model = '${data.model}'`;
        await client.query(updateQuery);
        callback(true);
    } catch (e) {
        callback(false);
        throw e
    } finally {
        client.release();
    }
}
exports.addExpenditureOnHead = async (data, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        await client.query('BEGIN');
        let max = await client.query(`select MAX(sl_no) from payment`);
        let transction_id = max.rows.length == 0 ? 'YR' + await getCurrentFinYear() + '-DS' + data.dist_id + '-1' : 'YR' + await getCurrentFinYear() + '-DS' + data.dist_id + '-' + (max.rows[0].max + 1);
        let from = `DS-${data.dist_id}`;
        let to = `DL-${data.dl_id}`;
        let queryText = `INSERT INTO payment(fin_year, date, transaction_id, reference_no, system, purpose, "from", "to", ammount, remark) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`;
        let values = [await getCurrentFinYear(), "NOW()", transction_id, data.po_no, "jalanidhi", "miscellaneous", from, to, data.ammount, data.remark];
        await client.query(queryText, values);

        let queryText2 = `INSERT INTO dept_expenditure_payment_desc(transaction_id, reference_no, schem_id, head_name, subhead_name) VALUES($1, $2, $3, $4, $5)`;
        let values2 = [transction_id, data.cluster_id, '2', data.head, data.sub_head];
        await client.query(queryText2, values2);

        let query1 = `INSERT INTO jn_expenditure_desc(transaction_id, item_name, item_price, quantity) values`;
        data.items.forEach(item => {
            query1 += `('${transction_id}', '${item.item_name}', '${item.item_price}', '${item.quantity}'), `;
        });
        await client.query(query1.substring(0, query1.length - 2));
        await client.query('COMMIT');
        callback(true);
    } catch (e) {
        await client.query('ROLLBACK');
        callback(false);
        throw e;
    } finally {
        client.release();
    }
}