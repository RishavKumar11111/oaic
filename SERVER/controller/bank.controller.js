const { pool, db } = require('../config/config');
const createError = require('http-errors');

function getCurrentFinYear() {
    return new Promise(resolve => {
        var year = new Date().getFullYear().toString();
        var month = new Date().getMonth();
        var finYear = month >= 3 ? year + "-" + (parseInt(year.slice(2, 4)) + 1).toString() : (parseInt(year) - 1).toString() + "-" + year.slice(2, 4);
        resolve(finYear);
    })
}
// exports.getUserDetailsByUserId = async (user_id, callback) => {
//     const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
//     try {
//         let response = await client.query(`select * from "DMMaster" where dm_id = '${user_id}'`);
//         callback(response.rows);
//     } catch (e) {
//         callback([]);
//         throw e
//     } finally {
//         client.release();
//     }
// }
// exports.getAllPaymentApprovals = async (fin_year, callback) => {
//     const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
//     try {
//         let queryText = `select * from approval where fin_year = '${fin_year}' and status = 'pending_at_bank'`;
//         let response = await client.query(queryText);
//         callback(response.rows);
//     } catch (e) {
//         callback([]);
//         throw e
//     } finally {
//         client.release();
//     }
// }
// exports.getApprovalDetails = async (approval_id, callback) => {
//     const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
//     try {
//         let queryText1 = `select e.permit_no, f.implement, f.make, f.model, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, f.p_invoice_value, f.p_cgst_1, f.p_sgst_1, g.mrr_id
//         from approval a
//         left join approval_desc d on d.approval_id = a.approval_id
//         left join orders e on e.permit_no = d.permit_no
//         left join "ItemMaster" f on f.implement = e.implement and f.make = e.make and f.model = e.model
//         left join mrr_desc g on g.permit_no = d.permit_no
//         where a.approval_id = '${approval_id}'
//         group by e.permit_no, f.implement, f.make, f.model, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, f.p_invoice_value, f.p_cgst_1, f.p_sgst_1, g.mrr_id`;
//         let response1 = client.query(queryText1);

//         let queryText2 = `select a.invoice_no, a.indent_no, indt.indent_date, b.invoice_date, indt.indent_ammount, b.invoice_ammount from approval a
//         inner join indent indt on indt.indent_no = a.indent_no
//         inner join invoice b on b.invoice_no = a.invoice_no
//         where a.approval_id = '${approval_id}'`;
//         let response2 = await client.query(queryText2);

//         let queryText3 = `select c.* from approval a
//         inner join dl_master c on c.dl_id = a.dl_id
//         where a.approval_id = '${approval_id}'`;
//         let response3 = await client.query(queryText3);

//         let response11 = await response1;
//         let response22 = await response2;
//         callback({ invoice: response22.rows[0], dl: response3.rows[0], data: response11.rows });
//     } catch (e) {
//         callback([]);
//         throw e
//     } finally {
//         client.release();
//     }
// }
// exports.confirmPayments = async (approval_list) => {
//     return new Promise(async (resolve, reject) => {
//         const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
//         try {
//             await client.query('BEGIN');
//             let fin_year = await getCurrentFinYear();
//             for(let i = 0; i < approval_list.length; i++) {
//                 let max = await client.query(`SELECT MAX(sl_no) FROM payment`);
//                 let transction_id = fin_year + '-' + approval_list[i].dist_id + '-' + (max.rows[0].max + 1);
//                 let from = `DS-${approval_list[i].dist_id}`;
//                 let to = `DL-${approval_list[i].dl_id}`;    
//                 let queryText1 = `INSERT INTO payment(reference_no, ammount, "from", "to", transaction_id, date, purpose, system, fin_year) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9)`;
//                 let values1 = [approval_list[i].approval_id, approval_list[i].pay_now_amount, from, to, transction_id, 'NOW()', 'pay_against_bill', 'farm_mechanisation', fin_year];
//                 await client.query(queryText1, values1);
//                 let queryText2 = `UPDATE approval SET status = 'paid', transaction_id = '${transction_id}', bank_approved_on = 'NOW()' WHERE approval_id = '${approval_list[i].approval_id}' AND pp_id = '${approval_list[i].pp_id}'`;
//                 await client.query(queryText2);
//             }
//             await client.query('COMMIT');
//             resolve(true);
//         } catch (e) {
//             await client.query('ROLLBACK');
//             reject("Server error");
//             throw e
//         } finally {
//             client.release();
//         }
//     });
// }
// exports.getApprovedPayments = async (fin_year, callback) => {
//     const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
//     try {
//         let response = await client.query(`select * from approval where fin_year = '${fin_year}' and status = 'paid'`);
//         callback(response.rows);
//     } catch (e) {
//         callback([]);
//         throw e;
//     } finally {
//         client.release();
//     }
// }






















exports.getUserDetailsByUserId = async (user_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let response = await client.query(`select * from "DMMaster" where dm_id = '${user_id}'`);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e
    } finally {
        client.release();
    }
}
exports.getAllPaymentApprovals = async (req, res, next) => {
    try {
        let queryText = `select * from approval where fin_year = '${req.query.fin_year}' and status = 'pending_at_bank'`;
        let response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getApprovalDetails = async (req, res, next) => {
    try {
        const approval_id = req.query.approval_id;
        let queryText1 = `select e.permit_no, f.implement, f.make, f.model, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, f.p_invoice_value, f.p_cgst_1, f.p_sgst_1, g.mrr_id
        from approval a
        left join approval_desc d on d.approval_id = a.approval_id
        left join orders e on e.permit_no = d.permit_no
        left join "ItemMaster" f on f.implement = e.implement and f.make = e.make and f.model = e.model
        left join mrr_desc g on g.permit_no = d.permit_no
        where a.approval_id = '${approval_id}'
        group by e.permit_no, f.implement, f.make, f.model, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, f.p_invoice_value, f.p_cgst_1, f.p_sgst_1, g.mrr_id`;
        let response1 = db.sequelize.query(queryText1);

        let queryText2 = `select a.invoice_no, a.indent_no, indt.indent_date, b.invoice_date, indt.indent_ammount, b.invoice_ammount from approval a
        inner join indent indt on indt.indent_no = a.indent_no
        inner join invoice b on b.invoice_no = a.invoice_no
        where a.approval_id = '${approval_id}'`;
        let response2 = db.sequelize.query(queryText2);

        let queryText3 = `select c.* from approval a
        inner join "VendorMaster" c on c."VendorID" = a.dl_id
        where a.approval_id = '${approval_id}'`;
        let response3 = await db.sequelize.query(queryText3);

        let response11 = await response1;
        let response22 = await response2;
        res.send({ invoice: response22[0][0], dl: response3[0][0], data: response11[0] });
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.confirmPayments = async (approval_list) => {
    return new Promise(async (resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            await client.query('BEGIN');
            let fin_year = await getCurrentFinYear();
            for(let i = 0; i < approval_list.length; i++) {
                let max = await client.query(`SELECT MAX(sl_no) FROM payment`);
                let transction_id = fin_year + '-' + approval_list[i].dist_id + '-' + (max.rows[0].max + 1);
                let from = `DS-${approval_list[i].dist_id}`;
                let to = `DL-${approval_list[i].dl_id}`;    
                let queryText1 = `INSERT INTO payment(reference_no, ammount, "from", "to", transaction_id, date, purpose, system, fin_year) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9)`;
                let values1 = [approval_list[i].approval_id, approval_list[i].pay_now_amount, from, to, transction_id, 'NOW()', 'pay_against_bill', 'farm_mechanisation', fin_year];
                await client.query(queryText1, values1);
                let queryText2 = `UPDATE approval SET status = 'paid', transaction_id = '${transction_id}', bank_approved_on = 'NOW()' WHERE approval_id = '${approval_list[i].approval_id}' AND pp_id = '${approval_list[i].pp_id}'`;
                await client.query(queryText2);
            }
            await client.query('COMMIT');
            resolve(true);
        } catch (e) {
            await client.query('ROLLBACK');
            reject("Server error");
            throw e
        } finally {
            client.release();
        }
    });
}
exports.getApprovedPayments = async (req, res, next) => {
    try {
        let response = await db.sequelize.query(`select * from approval where fin_year = '${req.query.fin_year}' and status = 'paid'`);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}