const { pool, db } = require('../config/config');
const createError = require('http-errors');





function getCurrentFinYear() {
        var year = new Date().getFullYear().toString();
        var month = new Date().getMonth();
        var finYear = month >= 3 ? year + "-" + (parseInt(year.slice(2, 4)) + 1).toString() : (parseInt(year) - 1).toString() + "-" + year.slice(2, 4);
        return finYear;
}






// ========================================= DEALER GLOBAL LEDGER PART STARTS =========================================

exports.getAllDistList = async (req, res, next) => {
        try {
            let response = await db.DistrictMaster.findAll({
                raw: true
            });
            res.send(response);
        } catch (e) {
            console.error(e);
            next(createError.InternalServerError());
        }
}
exports.getAllDelears = async (req, res, next) => {
        try {
            let response = await db.VendorMaster.findAll({
                raw: true,
                attributes: [
                    "VendorID", 
                    "LegalBussinessName",
                    "TradeName",
                    "PAN",
                    "ContactNumber",
                    "EmailID"],
                order: [["LegalBussinessName", "ASC"]]
            });
            res.send(response);
        } catch (e) {
            console.error(e);
            next(createError.InternalServerError());
        }
}
exports.getDistWiseDealerLedger = async (req, res, next) => {
        try {
            const { dl_id } = req.query;
            let queryText = `select a.*, CONCAT(c.dl_name, d.dist_name) as from_name, CONCAT(e.dl_name, f.dist_name) as to_name from payment a
            left join dl_master c on c.dl_id = substring(a.from, 4, length(a.from))
            left join "DistrictMaster" d on d.dist_id = substring(a.from, 4, length(a.from))
            left join dl_master e on e.dl_id = substring(a.to, 4, length(a.to))
            left join "DistrictMaster" f on f.dist_id = substring(a.to, 4, length(a.to))
            where a.to = 'DL-${dl_id}' or a.from = 'DL-${dl_id}' order by a.date desc`;
            let response = await db.sequelize.query(queryText);
            res.send(response[0]);
        } catch (e) {
            console.error(e);
            next(createError.InternalServerError());
        }
}
exports.getAdvanceDlBillDetail = async (req, res, next) => {
        try {
            const { trans_id } = req.query;
            let queryText = `SELECT b.mrr_id, b.date as mrr_date, b.items as mrr_items, b.mrr_amount, c.invoice_no, c.invoice_date, c.invoice_path, c.items as invoice_items, c.invoice_ammount, d.indent_no, d.indent_date, d.items as indent_items, d.indent_ammount FROM payment a
                            INNER JOIN mrr b ON b.mrr_id=a.reference_no
                            INNER JOIN invoice c ON c.invoice_no = b.invoice_no
                            INNER JOIN indent d ON d.indent_no = c.indent_no
                            WHERE a.transaction_id='${trans_id}'`;
            let response = await db.sequelize.query(queryText);
            res.send(response[0][0]);
        } catch (e) {
            console.error(e);
            next(createError.InternalServerError());
        }
}
exports.getPayAgainstBillDetail = ({ trans_id }) => {
    return new Promise(async(resolve, reject) => {
        try {
            let queryText = `SELECT a.approval_id, a.approval_date, a.items as approval_items, a.pay_now_amount as approval_amount, a.dm_approved_on, a.bank_approved_on,
                            b.invoice_no, b.invoice_date, b.invoice_path, b.items as invoice_items, b.invoice_ammount, 
                            c.indent_no, c.indent_date, c.items as indent_items, c.indent_ammount
                            FROM approval a, invoice b, indent c
                            WHERE a.transaction_id = '${trans_id}' and b.invoice_no = a.invoice_no and c.indent_no = a.indent_no`;
            let response = db.sequelize.query(queryText);
            let queryText2 = `SELECT c.mrr_id, c.date as mrr_date, c.items as mrr_items, c.mrr_amount FROM approval a 
                            INNER JOIN approval_desc b ON b.approval_id = a.approval_id
                            INNER JOIN mrr c ON c.mrr_id = b.mrr_id
                            WHERE a.transaction_id = '${trans_id}'
                            GROUP BY c.mrr_id, mrr_date, mrr_items, c.mrr_amount`
            let response2 = await db.sequelize.query(queryText2);
            let response11 = await response;
            resolve({ td: response11[0][0], mrrList: response2[0] });
        } catch (e) {
            reject('Server error.');
            throw e;
        }
    })
}
exports.getIndentDetailsByIndentNo = ({ indent_no }) => {
    return new Promise(async(resolve, reject) => {
        try {
            let queryText = `SELECT a.indent_no, a.indent_date, b.*, c.acc_name, d.permit_no, e.*, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, f.p_invoice_value
            FROM indent a LEFT JOIN dl_master b on a.dl_id = b.dl_id 
            left join "AccountantMaster" c on a.dist_id = c.dist_id 
            left join indent_desc d on a.indent_no = d.indent_no
            left join orders e on d.permit_no = e.permit_no
            left join "ItemMaster" f on e.implement = f.implement and e.make = f.make and e.model = f.model
            where a.indent_no = '${indent_no}'`;
            let response = await db.sequelize.query(queryText);
            resolve(response[0]);
        } catch (e) {
            reject('Server error.');
            throw e;
        }
    });
}
exports.getMRRDetails = ({ mrr_id, dl_id }) => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject('Database Connection Failed') })
        try {
            let queryText = `SELECT d.*, e.p_taxable_value, e.p_cgst_6, e.p_sgst_6, e.p_invoice_value FROM mrr_desc b  
                            LEFT JOIN orders d ON b.permit_no = d.permit_no
                            LEFT JOIN "ItemMaster" e ON d.implement = e.implement and d.make = e.make and d.model = e.model
                            WHERE b.mrr_id = '${mrr_id}'`;
            let response1 = client.query(queryText);
            let queryText2 = `SELECT * FROM dl_master WHERE dl_id = '${dl_id}'`;
            let response2 = client.query(queryText2);
            let queryText3 = `SELECT a.date as receive_date, c.* FROM mrr a 
                            INNER JOIN invoice c ON a.invoice_no = c.invoice_no 
                            WHERE a.mrr_id = '${mrr_id}'`;
            let response3 = client.query(queryText3);
            let response11 = await response1;
            let response22 = await response2;
            let response33 = await response3;
            resolve({ invoice: response33.rows[0], dl: response22.rows[0], data: response11.rows });
        } catch (e) {
            reject("Server error.");
            throw e;
        } finally {
            client.release();
        }
    });
}
exports.getApprovalDetail = async({ approval_id }) => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            let queryText1 = `SELECT e.permit_no, f.implement, f.make, f.model, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, f.p_invoice_value, f.p_cgst_1, f.p_sgst_1, g.mrr_id
                            FROM approval a
                            INNER JOIN approval_desc d ON d.approval_id = a.approval_id
                            INNER JOIN orders e ON e.permit_no = d.permit_no
                            INNER JOIN "ItemMaster" f ON f.implement = e.implement and f.make = e.make and f.model = e.model
                            INNER JOIN mrr_desc g ON g.permit_no = d.permit_no
                            WHERE a.approval_id = '${approval_id}'
                            GROUP BY e.permit_no, f.implement, f.make, f.model, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, f.p_invoice_value, f.p_cgst_1, f.p_sgst_1, g.mrr_id`;
            let response1 = await client.query(queryText1);

            let queryText2 = `SELECT a.approval_date, a.ammount as full_amount, a.deduction_amount, a.pay_now_amount, a.paid_amount, a.remark, 
                            b.dl_name, b.dl_address, b.bank_name, b.dl_ac_no, b.dl_ifsc_code, b.dl_mobile_no, b.dl_email, 
                            c.invoice_no, c.invoice_date, c.invoice_ammount, c.invoice_path, d.indent_no, d.indent_date, d.indent_ammount
                            FROM approval a 
                            INNER JOIN dl_master b ON b.dl_id = a.dl_id
                            INNER JOIN invoice c ON c.invoice_no = a.invoice_no
                            INNER JOIN indent d ON d.indent_no = a.indent_no
                            WHERE a.approval_id = '${approval_id}'`;
            let response2 = await client.query(queryText2);
            resolve({ apprItems: response1.rows, aprDetail: response2.rows[0] });
            resolve(true);
        } catch (e) {
            reject('Server error.');
            throw e;
        } finally {
            client.release();
        }
    });
}

// ========================================= DEALER GLOBAL LEDGER PART ENDS =========================================

// ========================================= ALL DISTRICT LEDGER PART STARTS =========================================

exports.getAllDistrictLedgerData = ({ fin_year }) => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            let queryText = `SELECT a.dist_id, a.dist_name,
                            SUM(CASE WHEN substr(b.from, 4, length(b.from)) = a.dist_id THEN b.ammount ELSE 0 END) as debit, 
                            SUM(CASE WHEN substr(b.to, 4, length(b.to)) = a.dist_id THEN b.ammount ELSE 0 END) as credit 
                            FROM "DistrictMaster" a
                            INNER JOIN payment b on substr(b.from, 4, length(b.from)) = a.dist_id or substr(b.to, 4, length(b.to)) = a.dist_id
                            WHERE b.fin_year = '${fin_year}'
                            GROUP BY a.dist_id, a.dist_name ORDER BY a.dist_name`;
            let response = await client.query(queryText);
            resolve(response.rows);
        } catch (e) {
            reject([]);
            throw e
        } finally {
            client.release();
        }
    });
}
exports.getAllLedgers = ({ fin_year, dist_id }) => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            let queryText = `SELECT a.*, i.desc as purpose, j.desc as system, case when left(a.from,2)='DS' then d.dist_name when left(a.from,2)='DL' 
            then c.dl_name when left(a.from,6)='farmer' then b.farmer_name when left(a.from, 4)='dept' then e.schem_name end as from_name, 
            a.to, case when left(a.to, 2)='DL' then f.dl_name when left(a.to, 2)='DS' then g.dist_name
            when a.purpose='pay_against_expenditure' then a.to end as to_name 
            from payment a
            inner join payment_purpose_desc i on i.purpose_id = a.purpose
            inner join system_desc j on j.system_id = a.system
            left join orders b on b.permit_no = a.reference_no
            left join dl_master c on c.dl_id = substr(a.from, 4, length(a.from))
            left join "DistrictMaster" d on d.dist_id = substr(a.from, 4, length(a.from))
            left join schem_master e on e.schem_id = substr(a.from, 6, length(a.from))
            
            left join dl_master f on f.dl_id = substr(a.to, 4, length(a.to))
            left join "DistrictMaster" g on g.dist_id = substr(a.to, 4, length(a.to))
            where a.fin_year = '${fin_year}' and a.from = 'DS-${dist_id}' or a.fin_year = '${fin_year}' and a.to = 'DS-${dist_id}' order by a.date desc`
            let response = await client.query(queryText);

            let queryText2 = `SELECT a.*, a.payment_date as date, b.desc as purpose, c.desc as system,
            case when left(a.from, 2)='DS' then d.dist_name 
            when a.purpose='receive_opening_balance' then a.from end as from_name,
            case when left(a.to, 2)='DS' then e.dist_name 
            when a.purpose='paid_opening_balance' then a.to end as to_name
            from opening_balance a 
            inner join payment_purpose_desc b on b.purpose_id = a.purpose
            inner join system_desc c on a.system = c.system_id
            left join "DistrictMaster" d on d.dist_id = substr(a.from, 4, length(a.from))
    
            left join "DistrictMaster" e on e.dist_id = substr(a.to, 4, length(a.to))
            where a.fin_year = '${fin_year}' and a.dist_id='${dist_id}' order by a.date desc`;
            let response2 = await client.query(queryText2);
            resolve(response2.rows.concat(response.rows));
        } catch (e) {
            reject([]);
            throw e;
        } finally {
            client.release();
        }
    });
}

// ========================================= ALL DISTRICT LEDGER PART ENDS =========================================
















































































exports.getItemSellingPrices = async(callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let order_detail = await client.query(`select * from "ItemMaster"`);
        callback(order_detail.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
};
exports.getAllAvailableOrders = async(dist_id, fin_year, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select * from orders where system = 'farm_mechanisation' and dist_id = '${dist_id}' and fin_year = '${fin_year}'`;
        let order_detail = await client.query(queryText);
        callback(order_detail.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.addPaymentOrderReceipt = (payment_data, order, receipt) => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            await client.query('BEGIN');
            let max = await client.query(`select MAX(sl_no) from payment`);
            let fin_year = getCurrentFinYear();
            let transction_id = max.rows.length == 0 ? 'YR' + fin_year + '-DS' + payment_data.dist_id + '-1' : 'YR' + fin_year + '-DS' + payment_data.dist_id + '-' + (max.rows[0].max + 1);
            let from = `farmer-${payment_data.farmer_id}`;
            let to = `DS-${payment_data.dist_id}`;

            let farmer_receipt_max = await client.query(`select MAX(sl_no) from farmer_receipt`);
            let receipt_no = farmer_receipt_max.length == 0 ? `MR/${fin_year}/1` : `MR/${fin_year}/${farmer_receipt_max.rows[0].max + 1}`;
            if (payment_data.payment_type == 'Cash') {
                payment_data.payment_no = receipt_no;
                receipt.payment_no = receipt_no;
            }

            let queryText = `INSERT INTO payment(fin_year, date, transaction_id, reference_no, system, purpose, "from", "to", ammount, payment_type, payment_no, payment_date, remark) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)`;
            let values = [fin_year, 'NOW()', transction_id, payment_data.permit_no, 'farm_mechanisation', 'farmerAdvancePayment', from, to, payment_data.amount, payment_data.payment_type, payment_data.payment_no, payment_data.payment_date, payment_data.remark];
            let addFarmerPayment = client.query(queryText, values);

            let order_status = payment_data.amount == order.sale_price ? 'paid' : 'pending';
            let queryText2 = `INSERT INTO orders(c_fin_year, date, system, permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, ammount, paid_amount, status, dist_id, fin_year, order_type) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22)`;
            let values2 = [fin_year, 'NOW()', 'farm_mechanisation', order.PERMIT_ORDER, order.DT_PERMIT, order.DT_P_VALIDITY, order.FARMER_ID, order.VCHFARMERNAME, order.VCHFATHERNAME, order.Dist_Name, order.block_name, order.vch_GPName, order.vch_VillageName, order.Implement, order.Make, order.Model, order.SUB_AMNT, order.paid_amount, order_status, order.dist_id, order.fin_year, "API"];
            let addOrder = client.query(queryText2, values2);

            let queryText3 = `INSERT INTO farmer_receipt(receipt_no, office, farmer_name, farmer_id,  implement, permit_no, full_ammount, payment_mode, source_bank, payment_no, dist_id, fin_year, date, payment_date)VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)`;
            let values3 = [receipt_no, receipt.office, receipt.farmer_name, receipt.farmer_id, receipt.implement, receipt.permit_no, receipt.full_ammount, receipt.payment_mode, receipt.source_bank, receipt.payment_no, receipt.dist_id, fin_year, 'NOW()', new Date(receipt.payment_date)];
            await client.query(queryText3, values3);
            await addFarmerPayment;
            await addOrder;
            await client.query('COMMIT');
            resolve(receipt_no);
        } catch (e) {
            await client.query('ROLLBACK');
            reject('SERVER ERROR.');
            throw e;
        } finally {
            client.release();
        }
    });
}
exports.getAllImplements = () => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
        try {
            let queryText = `select implement from "ItemMaster" group by implement order by implement`;
            let response = await client.query(queryText);
            resolve(response.rows);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    });
}
exports.getAllMakesByImplment = (implement) => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
        try {
            let queryText = `select make from "ItemMaster" where implement= '${implement}' group by make order by make`;
            let response = await client.query(queryText);
            resolve(response.rows);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    })
}
exports.getAllModelsByImplmentAndMake = (implement, make) => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
        try {
            let queryText = `select model from "ItemMaster" where implement= '${implement}' and make = '${make}' group by model order by model`;
            let response = await client.query(queryText);
            resolve(response.rows);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    })
}
exports.getSaleInvoiceValueOfItem = (implement, make, model) => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
        try {
            let queryText = `select s_invoice_value from "ItemMaster" where implement= '${implement}' and make = '${make}' and model = '${model}'`;
            let response = await client.query(queryText);
            resolve(response.rows[0]);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    })
}
exports.addDirectSaleToFarmerDetail = async(payment_data, order, receipt) => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            await client.query('BEGIN');
            let farmer_id;
            if (order.farmer_id == undefined) {
                let max_f_id = await client.query(`select max(cast(substr(farmer_id, 6, length(farmer_id)) as int )) 
                                                from orders where order_type='DIRECT_SALE'`);
                farmer_id = max_f_id.rows[0].max == null ? `FRMR/1` : `FRMR/${(parseInt(max_f_id.rows[0].max) + 1)}`;
            } else {
                farmer_id = order.farmer_id;
            }
            let max = await client.query(`select MAX(sl_no) from payment`);
            let fin_year = getCurrentFinYear();
            let transction_id = max.rows.length == 0 ? 'YR' + fin_year + '-DS' + payment_data.dist_id + '-1' : 'YR' + fin_year + '-DS' + payment_data.dist_id + '-' + (max.rows[0].max + 1);
            let from = `farmer-${farmer_id}`;
            let to = `DS-${payment_data.dist_id}`;

            let max_p_no = await client.query(`select max(cast(substr(permit_no, 16, length(permit_no)) as int )) 
                                                from orders where substr(permit_no, 13, 2) = '${order.dist_id}' and order_type='DIRECT_SALE'`);
            let permit_no = max_p_no.rows[0].max == null ? `DSF/${fin_year}/${order.dist_id}-1` : `DSF/${fin_year}/${order.dist_id}-${(parseInt(max_p_no.rows[0].max) + 1)}`;

            let farmer_receipt_max = await client.query(`select MAX(sl_no) from farmer_receipt`);
            let receipt_no = farmer_receipt_max.length == 0 ? `MR/${fin_year}/1` : `MR/${fin_year}/${farmer_receipt_max.rows[0].max + 1}`;
            if (payment_data.payment_type == 'Cash') {
                payment_data.payment_no = receipt_no;
                receipt.payment_no = receipt_no;
            }
            let queryText = `INSERT INTO payment(fin_year, date, transaction_id, reference_no, system, purpose, "from", "to", ammount, payment_type, payment_no, payment_date, remark) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)`;
            let values = [fin_year, 'NOW()', transction_id, permit_no, 'farm_mechanisation', 'farmerAdvancePayment', from, to, payment_data.amount, payment_data.payment_type, payment_data.payment_no, payment_data.payment_date, payment_data.remark];
            let addFarmerPayment = client.query(queryText, values);

            let order_status = payment_data.amount == order.sale_price ? 'paid' : 'pending';
            let permit_validity = new Date(new Date().setFullYear(new Date().getFullYear() + 1));
            let queryText2 = `INSERT INTO orders(c_fin_year, date, system, permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, ammount, paid_amount, status, dist_id, fin_year, order_type) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22)`;
            let values2 = [fin_year, 'NOW()', 'farm_mechanisation', permit_no, 'NOW()', permit_validity, farmer_id, order.farmer_name, order.farmer_father_name, order.dist_name, order.block_name, order.gp_name, order.village_name, order.implement, order.make, order.model, 0, order.paid_amount, order_status, order.dist_id, fin_year, "DIRECT_SALE"];
            let addOrder = client.query(queryText2, values2);

            let queryText3 = `INSERT INTO farmer_receipt(receipt_no, office, farmer_name, farmer_id,  implement, permit_no, full_ammount, payment_mode, source_bank, payment_no, dist_id, fin_year, date, payment_date)VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)`;
            let values3 = [receipt_no, receipt.office, receipt.farmer_name, farmer_id, receipt.implement, permit_no, receipt.full_ammount, receipt.payment_mode, receipt.source_bank, receipt.payment_no, receipt.dist_id, fin_year, 'NOW()', new Date(receipt.payment_date)];
            await client.query(queryText3, values3);
            await addFarmerPayment;
            await addOrder;
            await client.query('COMMIT');
            resolve({ receipt_no: receipt_no, permit_no: permit_no });
        } catch (e) {
            await client.query('ROLLBACK');
            reject('Some problem occurs to add these detail.');
            throw e;
        } finally {
            client.release();
        }
    });
}
exports.getDistList = () => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
        try {
            let response = await client.query(`select * from lgd_"DistrictMaster"`);
            resolve(response.rows);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    })
}
exports.getBlockList = (dist_code) => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
        try {
            let response = await client.query(`select * from lgd_block_master where dist_code = '${dist_code}'`);
            resolve(response.rows);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    })
}
exports.getGpList = (dist_code, block_code) => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
        try {
            let response = await client.query(`select * from lgd_gp_master where dist_code= '${dist_code}' and block_code = '${block_code}'`);
            resolve(response.rows);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    })
}







exports.getPendingPaymentOrders = async(dist_id, fin_year, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.*, b.s_invoice_value from orders a inner join "ItemMaster" b on b.implement=a.implement and a.make = b.make and a.model = b.model
        where a.system = 'farm_mechanisation' and a.dist_id = '${dist_id}' and a.c_fin_year = '${fin_year}' and a.status = 'pending'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.updateFarmerPendingPayment = async(payment_data, order, receipt) => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            await client.query('BEGIN');
            let max = await client.query(`select MAX(sl_no) from payment`);
            let fin_year = getCurrentFinYear();
            let transction_id = max.rows.length == 0 ? 'YR' + fin_year + '-DS' + payment_data.dist_id + '-1' : 'YR' + fin_year + '-DS' + payment_data.dist_id + '-' + (max.rows[0].max + 1);
            let from = `farmer-${payment_data.farmer_id}`;
            let to = `DS-${payment_data.dist_id}`;

            let queryText = `INSERT INTO payment(fin_year, date, transaction_id, reference_no, system, purpose, "from", "to", ammount, payment_type, payment_no, payment_date, remark) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)`;
            let values = [fin_year, 'NOW()', transction_id, payment_data.permit_no, 'farm_mechanisation', 'farmerAdvancePayment', from, to, payment_data.amount, payment_data.payment_type, payment_data.payment_no, payment_data.payment_date, payment_data.remark];
            let addFarmerPayment = client.query(queryText, values);

            let order_status = (order.amount_pay_now + order.paid_amount) == order.selling_price ? 'paid' : 'pending';
            let queryText2 = `UPDATE orders set status = '${order_status}', paid_amount='${order.paid_amount + order.amount_pay_now}' where permit_no='${receipt.permit_no}'`;
            let updateOrder = client.query(queryText2);

            let farmer_receipt_max = await client.query(`select MAX(sl_no) from farmer_receipt`);
            let receipt_no = farmer_receipt_max.length == 0 ? `MR/${fin_year}/1` : `MR/${fin_year}/${farmer_receipt_max.rows[0].max + 1}`;
            let queryText3 = `INSERT INTO farmer_receipt(receipt_no, office, farmer_name, farmer_id,  implement, permit_no, full_ammount, payment_mode, source_bank, payment_no, dist_id, fin_year, date, payment_date)VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)`;
            let values3 = [receipt_no, receipt.office, receipt.farmer_name, receipt.farmer_id, receipt.implement, receipt.permit_no, receipt.full_ammount, receipt.payment_mode, receipt.source_bank, receipt.payment_no, receipt.dist_id, fin_year, 'NOW()', new Date(receipt.payment_date)];
            await client.query(queryText3, values3);
            await addFarmerPayment;
            await updateOrder;
            await client.query('COMMIT');
            resolve(receipt_no);
        } catch (e) {
            await client.query('ROLLBACK');
            reject('Server error.');
            throw e;
        } finally {
            client.release();
        }
    });
}
exports.getFarmerReceiptsByFinYear = async(fin_year, dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
    try {
        let queryText = `select receipt_no, farmer_name, farmer_id, permit_no, date, implement from farmer_receipt where fin_year = '${fin_year}' and dist_id = '${dist_id}' order by date desc`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getReceiptDetails = async(receipt_no, callback) => {
    const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
    try {
        let queryText = `select a.*, b.acc_name from farmer_receipt a
        inner join "AccountantMaster" b on b.dist_id = a.dist_id where a.receipt_no = '${receipt_no}'`;
        let response = await client.query(queryText);
        callback(response.rows[0]);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllOrdersForGI = async(dist_id, fin_year, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.*, c.p_taxable_value, c.p_cgst_6, c.p_sgst_6, c.p_invoice_value from orders a inner join "ItemMaster" c on a.make = c.make and a.model = c.model and a.implement = c.implement
        where a.system='farm_mechanisation' and a.dist_id = '${dist_id}' and a.status = 'paid' and a.c_fin_year = '${fin_year}'`;
        let result = await client.query(queryText);
        callback(result.rows);
    } catch (e) {
        callback([]);
        throw e
    } finally {
        client.release();
    }
}
exports.getDlDetailOfEachOrder = (fin_year, dist_id, implement, make, model) => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
        try {
            // let queryText = `select a.dl_id, c.dl_name from dl_item_map a inner join dist_dealer_mapping b on a.dl_id = b.dl_id inner join dl_master c on c.dl_id = b.dl_id
            // where a.fin_year='${fin_year}' and a.implement='${implement.toUpperCase()}' and a.make='${make}' and b.fin_year='${fin_year}' and b.dist_id='${dist_id}' group by a.dl_id, c.dl_name`;
            let queryText = `select b.dl_name, b.dl_id from dist_dealer_mapping a inner join dl_master b on b.dl_id = a.dl_id where a.dist_id = '${dist_id}' and a.fin_year='${fin_year}'`;
            let result = await client.query(queryText);
            resolve(result.rows);
        } catch (e) {
            resolve([]);
            throw e
        } finally {
            client.release();
        }
    })
}
exports.getAccName = async(dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select acc_name from acc_master where dist_id = '${dist_id}'`;
        let response = await client.query(queryText);
        callback(response.rows[0]);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getDistName = async(dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select dist_name from "DistrictMaster" where dist_id = '${dist_id}'`;
        let response = await client.query(queryText);
        callback(response.rows[0]);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.addIndent = async(indent, permit_nos) => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            await client.query('BEGIN');
            let max = await client.query(`select max(cast(substr(indent_no, 4, length(indent_no)) as int )) from indent where substr(indent_no, 0, 3) = '${indent.dist_id}'`);
            let fin_year = getCurrentFinYear();
            let indent_no = max.rows[0].max == null ? `${indent.dist_id}-1` : `${indent.dist_id}-${(parseInt(max.rows[0].max) + 1)}`;

            let queryText = `INSERT INTO indent(indent_no, dist_id, dl_id, fin_year, indent_date, status, items, indent_ammount) VALUES($1, $2, $3, $4, $5, $6, $7, $8)`;
            let values = [indent_no, indent.dist_id, indent.dl_id, fin_year, 'NOW()', 'indentGenerated', indent.items, parseInt(indent.indent_ammount)];
            let addIndent = client.query(queryText, values);
            let queryText2 = `insert into indent_desc (indent_no, permit_no) values `;
            permit_nos.forEach(permit_no => {
                queryText2 += `('${indent_no}', '${permit_no}'), `;
            })
            await addIndent;
            let addIndentDesc = client.query(queryText2.substring(0, queryText2.length - 2));
            let condition = '';
            for (let i = 0; i < permit_nos.length; i++) {
                if (i == 0) condition = condition + `permit_no = '${permit_nos[i]}' `;
                else condition = condition + ` OR permit_no = '${permit_nos[i]}' `;
            }
            await addIndentDesc;
            await client.query(`update orders set status = 'indent_generated' where ${condition}`);
            await client.query('COMMIT');
            resolve(indent_no);
        } catch (e) {
            await client.query('ROLLBACK');
            reject('Server error.');
            throw e;
        } finally {
            client.release();
        }
    });
}
exports.cancelIndent = async(indent_no, indent_items) => {
        return new Promise(async(resolve, reject) => {
            const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
            try {

                let queryText = `select b.permit_no, c.status from indent a 
            inner join indent_desc b on b.indent_no = a.indent_no
            inner join orders c on c.permit_no = b.permit_no
            where a.indent_no = '${indent_no}' and c.status = 'indent_generated' `;
                let result1 = await client.query(queryText);
                let permit_nos = result1.rows;
                if (permit_nos.length == indent_items) {

                    await client.query('BEGIN');
                    let queryText2 = `UPDATE indent set status = 'cancel' where indent_no = '${indent_no}'`;
                    let cancel_status = client.query(queryText2);

                    let condition = '';
                    for (let i = 0; i < permit_nos.length; i++) {
                        if (i == 0) condition = condition + `permit_no = '${permit_nos[i].permit_no}' `;
                        else condition = condition + ` OR permit_no = '${permit_nos[i].permit_no}' `;
                    }
                    await cancel_status;
                    await client.query(`UPDATE orders set status = 'paid' where ${condition}`);
                    await client.query('COMMIT');
                    resolve(true);
                } else {
                    reject("Item mismatch");
                }
            } catch (e) {
                await client.query('ROLLBACK');
                reject("Server error.");
                throw e;
            } finally {
                client.release();
            }
        });
    }
    // Generated Indents Start
exports.getAllGeneratedIndents = async(dist_id, fin_year, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.indent_no, a.indent_date, a.indent_ammount, a.items, b.dl_name from indent a 
        inner join dl_master b on a.dl_id = b.dl_id
        where a.dist_id = '${dist_id}' and fin_year = '${fin_year}' and a.status != 'cancel'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllCancelledIndentList = async(dist_id, fin_year, callback) => {
        const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
        try {
            let queryText = `select a.indent_no, a.indent_date, a.indent_ammount, a.items, b.dl_name from indent a 
        left join dl_master b on a.dl_id = b.dl_id
        where a.dist_id = '${dist_id}' and fin_year = '${fin_year}' and a.status = 'cancel'`;
            let response = await client.query(queryText);
            callback(response.rows);
        } catch (e) {
            callback([]);
            throw e;
        } finally {
            client.release();
        }
    }
    // Generated Indents End
    // Generate MRR
exports.getAllInvoiceList = async(fin_year, dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.*, b.dl_name from invoice a
        inner join dl_master b on b.dl_id = a.dl_id
        where a.dist_id = '${dist_id}' and a.fin_year = '${fin_year}' and a.status = 'notReceived' order by invoice_date desc`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getOrdersForReceive = async(invoice_no, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select b.*, d.p_taxable_value, d.p_cgst_6, d.p_sgst_6, d.p_invoice_value, d.s_invoice_value from invoice_desc a
        inner join orders b on b.permit_no = a.permit_no
        inner join "ItemMaster" d on b.implement = d.implement and b.make = d.make and b.model = d.model
        where a.invoice_no = '${invoice_no}'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.addMRR = async(mrr, permit_nos, updateInvoice, bill) => {
        return new Promise(async(resolve, reject) => {
            const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
            try {
                await client.query('BEGIN');
                let max = await client.query(`select max(cast(substr(mrr_id, 12, length(mrr_id)) as int )) from mrr where substr(mrr_id, 0, 3) = '${mrr.dist_id}'`);
                let fin_year = getCurrentFinYear();
                let mrr_id = max.rows[0].max == null ? `${mrr.dist_id}/${fin_year}/1` : `${mrr.dist_id}/${fin_year}/${(parseInt(max.rows[0].max) + 1)}`;

                let queryText = `INSERT INTO mrr(mrr_id, dist_id, invoice_no, fin_year, dl_id, date, items) VALUES($1, $2, $3, $4, $5, $6, $7)`;
                let values = [mrr_id, mrr.dist_id, mrr.invoice_no, fin_year, mrr.dl_id, 'NOW()', mrr.items];
                let addMRR = client.query(queryText, values);

                let condition = '';
                for (let i = 0; i < permit_nos.length; i++) {
                    if (i == 0) condition = condition + `permit_no = '${permit_nos[i]}' `;
                    else condition = condition + ` OR permit_no = '${permit_nos[i]}' `;
                }
                let updateOrders = await client.query(`UPDATE orders set status = 'received' where ${condition}`);

                let queryText2 = `insert into mrr_desc (mrr_id, permit_no) values `;
                permit_nos.forEach(permit_no => {
                    queryText2 += `('${mrr_id}', '${permit_no}'), `;
                })
                let payment_max = await client.query(`select MAX(sl_no) from payment`);
                let from = `DL-${bill.dl_id}`;
                let to = `DS-${bill.dist_id}`;
                let transaction_id = 'YR' + fin_year + '-DS' + bill.dist_id + '-' + (payment_max.rows[0].max + 1);
                let queryText3 = `INSERT INTO payment(reference_no, transaction_id, "from", "to", ammount, date, purpose, fin_year, system)VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9)`;
                let values3 = [mrr_id, transaction_id, from, to, bill.amount, 'NOW()', 'advance_dealer_bill', fin_year, 'farm_mechanisation'];
                await client.query(queryText3, values3);

                await addMRR;
                let mrr_desc = client.query(queryText2.substring(0, queryText2.length - 2));
                if (updateInvoice) {
                    await client.query(`UPDATE invoice SET status = 'received' where invoice_no = '${mrr.invoice_no}'`);
                }
                await mrr_desc;
                await updateOrders;
                await client.query('COMMIT');
                resolve(mrr_id);
            } catch (e) {
                await client.query('ROLLBACK');
                reject('Server error.');
                throw e;
            } finally {
                client.release();
            }
        });
    } // Generate MRR  End
exports.getAllReceivedItems = async(dist_id, fin_year, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select * from orders where system = 'farm_mechanisation' and dist_id = '${dist_id}' and status = 'received' and fin_year = '${fin_year}'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getFinalListDeliverToCustomer = async(dist_id, fin_year, callback) => {
        const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
        try {
            let queryText = `select * from orders where system = 'farm_mechanisation' and dist_id = '${dist_id}' and status = 'delivered_to_customer' and fin_year = '${fin_year}'`;
            let response = await client.query(queryText);
            callback(response.rows);
        } catch (e) {
            callback([]);
            throw e;
        } finally {
            client.release();
        }
    }
    // Pay TO Delear
exports.getAllDistWiseDelear = async(fin_year, dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select b.dl_id, b.dl_name from dist_dealer_mapping a
        inner join dl_master b on a.dl_id = b.dl_id
        where dist_id = '${dist_id}' and fin_year = '${fin_year}' group by b.dl_id, b.dl_name`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getFinYearWiseInvoiceList = async(fin_year, dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.* from invoice a
        where a.fin_year='${fin_year}' and a.dist_id = '${dist_id}' and payment_status = 'pending'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}

exports.getInvoiceItemsForPay = async(invoice_no, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select c.*, d.p_taxable_value, d.p_invoice_value, d.p_cgst_6, d.p_sgst_6, d.p_cgst_1, d.p_sgst_1, e.approval_id, f.mrr_id
        from invoice a
        left join invoice_desc b on a.invoice_no = b.invoice_no
        left join orders c on b.permit_no = c.permit_no
        left join "ItemMaster" d on c.implement = d.implement and c.make = d.make and c.model = d.model
        left join approval_desc e on e.permit_no = c.permit_no
        left join mrr_desc f on f.permit_no = b.permit_no
        where a.invoice_no = '${invoice_no}'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getInvoiceDetailsByInvoiceNo = async(invoice_no, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.*, b.indent_date, b.indent_ammount from invoice a
        inner join indent b on b.indent_no = a.indent_no
        where a.invoice_no = '${invoice_no}'`;
        let response = await client.query(queryText);
        callback(response.rows[0]);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.addPaymentApproval = async(approval, permit_nos, updateInvoice) => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            await client.query('BEGIN');
            let max = await client.query(`select MAX(sl_no) from approval`);
            let fin_year = getCurrentFinYear();
            let approval_id = (max.rows.length == 0) ? `${approval.dist_id}/${fin_year}/1` : `${approval.dist_id}/${fin_year}/${(max.rows[0].max + 1)}`;
            let payment_status = approval.sub_total == approval.pay_now ? 'Complete' : 'Pending';
            let queryText = `INSERT INTO approval(fin_year, dist_id, dl_id, invoice_no, indent_no, approval_id, pp_id, approval_date, ammount, status, deduction_amount, pay_now_amount, paid_amount, payment_status, pp_status, remark) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)`;
            let values = [approval.fin_year, approval.dist_id, approval.dl_id, approval.invoice_no, approval.indent_no, approval_id, '1', 'NOW()', approval.sub_total, 'pending_at_dm', approval.deduction_amount, approval.pay_now, approval.pay_now, payment_status, true, approval.remark];
            let add_approval = client.query(queryText, values);

            let queryText2 = `insert into approval_desc (approval_id, permit_no) values `;
            permit_nos.forEach(permit_no => {
                queryText2 += `('${approval_id}', '${permit_no}'), `;
            });
            await add_approval;
            let add_approval_desc = client.query(queryText2.substring(0, queryText2.length - 2));
            if (updateInvoice) {
                let queryText3 = `UPDATE invoice SET payment_status = 'paid' where invoice_no = '${approval.invoice_no}'`;
                await client.query(queryText3);
            }
            await add_approval_desc;
            await client.query('COMMIT');
            resolve(approval_id);
        } catch (e) {
            await client.query('ROLLBACK');
            reject('Server error');
            throw e;
        } finally {
            client.release();
        }
    });
}
exports.getFinYearWisePendingApprovalList = async(fin_year, dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.*, b.desc as status_desc, c.indent_date, c.indent_ammount, d.invoice_date, d.invoice_ammount from approval a
        inner join approval_status_desc b on b.status_id = a.status
        inner join indent c on c.indent_no = a.indent_no
        inner join invoice d on d.invoice_no = a.invoice_no
        where a.fin_year='${fin_year}' and a.dist_id = '${dist_id}' and a.payment_status = 'Payble' and a.pp_status = 'true' or a.fin_year='${fin_year}' and a.dist_id = '${dist_id}' and a.payment_status = 'Pending' and a.pp_status = 'true' order by a.approval_date desc`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getApprovalItemsForPay = async(approval_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select b.permit_no, c.implement, c.make, c.model, c.p_taxable_value, c.p_cgst_6, c.p_sgst_6, c.p_invoice_value, c.p_sgst_1, c.p_cgst_1, c.s_invoice_value, d.mrr_id from approval_desc a
        inner join orders b on b.permit_no = a.permit_no
        inner join "ItemMaster" c on c.implement = b.implement and c.make = b.make and c.model = b.model
        inner join mrr_desc d on d.permit_no = a.permit_no
        where a.approval_id = '${approval_id}'
        group by b.permit_no, c.implement, c.make, c.model, c.p_taxable_value, c.p_cgst_6, c.p_sgst_6, c.p_invoice_value, c.p_sgst_1, c.p_cgst_1, c.s_invoice_value, d.mrr_id`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getFinYearWiseApprovalList = async(fin_year, dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.*, b.desc as status_desc, c.indent_date, d.invoice_date, c.indent_ammount, d.invoice_ammount from approval a
        inner join approval_status_desc b on b.status_id = a.status
        inner join indent c on c.indent_no = a.indent_no
        inner join invoice d on d.invoice_no = a.invoice_no
        where a.fin_year='${fin_year}' and a.dist_id = '${dist_id}' order by a.approval_date desc`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.updatePartPaymentApproval = async(apr) => {
        return new Promise(async(resolve, reject) => {
            const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
            try {
                await client.query('BEGIN');
                let max = await client.query(`select MAX(pp_id) from approval where approval_id = '${apr.approval_id}'`);
                let fin_year = getCurrentFinYear();
                let pp_id = `${ parseInt(max.rows[0].max) + 1}`;
                let status = apr.pending_amount == apr.pay_now ? 'Complete' : 'Pending';
                let paid_amount = parseFloat(apr.paid_amount) + parseFloat(apr.pay_now);
                let queryText = `INSERT INTO approval(fin_year, dist_id, dl_id, invoice_no, indent_no, approval_id, pp_id, approval_date, ammount, status, deduction_amount, pay_now_amount, paid_amount, payment_status, pp_status, remark) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)`;
                let values = [fin_year, apr.dist_id, apr.dl_id, apr.invoice_no, apr.indent_no, apr.approval_id, pp_id, 'NOW()', apr.sub_total, 'pending_at_dm', apr.deduction_amount, apr.pay_now, paid_amount, status, true, apr.remark];
                let add_approval = client.query(queryText, values);
                let queryText2 = `UPDATE approval set pp_status = false where approval_id = '${apr.approval_id}' and pp_id = '${apr.pp_id}'`;
                await client.query(queryText2);
                await add_approval;
                await client.query('COMMIT');
                resolve(true);
            } catch (e) {
                reject('Server error.');
                throw e;
            } finally {
                client.release();
            }
        });
    }
    // Pay To Deler End
exports.getAllOrders = async(dist_id, fin_year, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select * from orders where system = 'farm_mechanisation' and dist_id = '${dist_id}' and fin_year = '${fin_year}'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllDebitLedgers = async(fin_year, dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select * from payment where fin_year = '${fin_year}' and "from" = 'DS-${dist_id}'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllCreditLedgers = async(fin_year, dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select * from payment where fin_year = '${fin_year}' and "to" = 'DS-${dist_id}'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllDelearLedgers = async(fin_year, dist_id, dl_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.*, CONCAT(c.dl_name, d.dist_name) as from_name, CONCAT(e.dl_name, f.dist_name) as to_name from payment a
        left join dl_master c on c.dl_id = substring(a.from, 4, length(a.from))
        left join "DistrictMaster" d on d.dist_id = substring(a.from, 4, length(a.from))
        left join dl_master e on e.dl_id = substring(a.to, 4, length(a.to))
		left join "DistrictMaster" f on f.dist_id = substring(a.to, 4, length(a.to))
        where a.fin_year = '${fin_year}' and (a.from = 'DS-${dist_id}' and a.to = 'DL-${dl_id}') or (a.from = 'DL-${dl_id}' and a.to = 'DS-${dist_id}') order by a.date desc`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getIteimPrice = async(implement, make, model, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select * from "ItemMaster" where make = '${make}' and model = '${model}' and implement = '${implement}'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllPermitNos = async(dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
    try {
        let response = await client.query(`select permit_no as reference_no from orders where system = 'farm_mechanisation' and dist_id = '${dist_id}' and c_fin_year = '${getCurrentFinYear()}' order by permit_no`);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllClusterIdsForExpenditure = async(dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
    try {
        let response = await client.query(`select cluster_id as reference_no from jn_orders where system = 'jalanidhi' and dist_id = '${dist_id}' and fin_year = '${getCurrentFinYear()}' group by cluster_id`);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllSchema = () => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            let response = await client.query(`SELECT * FROM schem_master`);
            resolve(response.rows);
        } catch (e) {
            reject("SERVER ERROR.");
            throw e;
        } finally {
            client.release();
        }
    })
}
exports.getAllHeads = async callback => {
    const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
    try {
        let response = await client.query(`select * from head_master`);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllSubheads = async(head_id, callback) => {
    const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
    try {
        let response = await client.query(`select * from subheads where head_id = '${head_id}'`);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.addExpenditurePayment = async(payment_data) => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            let system, purpose;
            switch (payment_data.schem_id) {
                case "1":
                    {
                        system = 'farm_mechanisation';
                        purpose = 'pay_against_expenditure'
                        break;
                    }
                case "2":
                    {
                        system = 'jalanidhi'
                        purpose = 'pay_against_expenditure_jn'
                        break;
                    }
            }
            await client.query('BEGIN');
            let max = await client.query(`select MAX(sl_no) from payment`);
            let fin_year = getCurrentFinYear();
            let transaction_id = max.rows.length == 0 ? 'YR' + fin_year + '-DS' + payment_data.dist_id + '-1' : 'YR' + fin_year + '-DS' + payment_data.dist_id + '-' + (max.rows[0].max + 1);
            let from = `DS-${payment_data.dist_id}`;

            let queryText = `INSERT INTO payment(fin_year, date, transaction_id, reference_no, system, purpose, "from", "to", ammount, payment_type, payment_no, payment_date, remark) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)`;
            let values = [fin_year, 'NOW()', transaction_id, payment_data.ref_no, system, purpose, from, payment_data.to, payment_data.ammount, payment_data.payment_mode, payment_data.payment_no, 'NOW()', payment_data.remark];
            let addPayment = client.query(queryText, values);

            let queryText2 = `INSERT INTO dept_expenditure_payment_desc(reference_no, transaction_id, schem_id, head_id, subhead_id) VALUES($1, $2, $3, $4, $5)`;
            let values2 = [payment_data.ref_no, transaction_id, payment_data.schem_id, payment_data.head_id, payment_data.subhead_id];
            await client.query(queryText2, values2);
            await addPayment;

            await client.query('COMMIT');
            resolve(true);
        } catch (e) {
            await client.query('ROLLBACK');
            reject('Server error.');
            throw e;
        } finally {
            client.release();
        }
    });
}
exports.getCashBookData = async(permit_no, callback) => {
    const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
    try {
        // let queryText = `select a.*, c.desc as purpose from payment a 
        // inner join payment_purpose_desc c on c.purpose_id = a.purpose
        // where a.reference_no = '${permit_no}'`;
        let queryText = `select a.*, b.desc as purpose, 
        case when left(a.from, 6)='farmer' then c.farmer_name 
        when left(a.from, 2)='DS' then d.dist_name end as from_name,
        case when left(a.to, 2)='DS' then f.dist_name 
        when a.purpose='pay_against_expenditure' then a.to end as to_name from payment a 
        inner join payment_purpose_desc b on b.purpose_id = a.purpose
        left join orders c on c.permit_no = a.reference_no
        left join "DistrictMaster" d on d.dist_id = substr(a.from, 4, length(a.from))
        left join "DistrictMaster" f on f.dist_id = substr(a.to, 4, length(a.to))
        where a.reference_no = '${permit_no}'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getInvoiceDetails = async(callback) => {
    const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
    try {
        let queryText = `select * from invoice`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllDistMRRIds = async(fin_year, dist_id, callback) => {
        const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
        try {
            let queryText = `select a.mrr_id, a.date, a.invoice_no, a.items, a.dl_id, b.invoice_path from mrr a
        inner join invoice b on b.invoice_no = a.invoice_no
        where a.fin_year = '${fin_year}' and a.dist_id = '${dist_id}'`;
            let response = await client.query(queryText);
            callback(response.rows);
        } catch (e) {
            callback([]);
            throw e;
        } finally {
            client.release();
        }
    }
    // Farmer Payment For Show Recipt
exports.getFarmerPaymentsForReceipt = (fin_year, dist_id) => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
        try {
            let queryText = `select a.*, b.farmer_name, b.farmer_id, b.implement, b.make, b.model from payment a left join orders b on a.reference_no = b.permit_no
        where a.fin_year = '${fin_year}' and a."to" = 'DS-${dist_id}' and a.purpose = 'farmerAdvancePayment' order by a.date desc`;
            let response = await client.query(queryText);
            resolve(response.rows);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    })
}
exports.getDepartmentPaymentsForReceipt = async(fin_year, dist_id) => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
        try {
            let queryText = `select a.*, c.source_name, d.schem_name, e.comp_name from payment a
        left join dept_expenditure_payment_desc b on a.reference_no = b.reference_no
        left join source_master c on b.source_id = c.source_id
        left join schem_master d on b.schem_id = d.schem_id
        left join components e on b.comp_id = e.comp_id
        where a.fin_year = '${fin_year}' and a."to" = 'ADMIN' and a.purpose = 'received_from_dept'
        order by a.date desc`;
            let response = await client.query(queryText);
            resolve(response.rows);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    })
}
exports.getDepartmentPaymentsForReceiptJN = async(fin_year, dist_id) => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
        try {
            let queryText = `select a.*, b.scheme_name, b.comp_id from payment a
            left join jalanidhi_dept_expnd_payment_desc b on a.transaction_id = b.transaction_id
            where a.fin_year = '${fin_year}' and a."to" = 'DS-${dist_id}' and a.purpose = 'received_from_dept_jn'
            order by a.date desc`;
            let response = await client.query(queryText);
            resolve(response.rows);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    });
}
exports.getJalanidhiFarmerPaymentsForReceipt = (fin_year, dist_id) => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
        try {
            let queryText = `select a.*, b.farmer_name, b.farmer_id, b.implement, b.make, b.model
            from payment a
        inner join jalanidhi_payment_desc b on a.transaction_id = b.transaction_id
        where a.fin_year = '${fin_year}' and a."to" = 'DS-${dist_id}' and a.purpose = 'farmer_advance_payment_jn' order by a.date desc`;
            let response = await client.query(queryText);
            resolve(response.rows);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    })
}
exports.getReceiptDetailsByPermitNo = async(permit_no, callback) => {
        const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
        try {
            let response = await client.query(`select * from farmer_receipt where permit_no = '${permit_no}'`);
            callback(response.rows[0]);
        } catch (e) {
            callback([]);
            throw e;
        } finally {
            client.release();
        }
    }
    // Expenditure Payments Payments FARM MECHANISATION
exports.expenditurePayments = (fin_year, dist_id) => {
        return new Promise(async resolve => {
            const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
            try {
                let queryText = `select a.*, f.desc as system, c.schem_name, d.head_name, e.subhead_name from payment a
            left join dept_expenditure_payment_desc b on a.reference_no = b.reference_no
            left join schem_master c on b.schem_id = c.schem_id
            left join head_master d on b.head_id = d.head_id
            left join subheads e on b.subhead_id = e.subhead_id
            inner join system_desc f on f.system_id = a.system
            where a.fin_year = '${fin_year}' and a."from" = 'DS-${dist_id}' and a.purpose = 'pay_against_expenditure' order by a.date desc`;
                let response = await client.query(queryText);
                resolve(response.rows);
            } catch (e) {
                resolve([]);
                throw e;
            } finally {
                client.release();
            }
        })
    }
    // Expenditure Payments Payments JALANIDHHI
exports.jnExpenditurePayments = (fin_year, dist_id) => {
        return new Promise(async resolve => {
            const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
            try {
                let queryText = `select a.*, b.head_name, b.subhead_name from payment a
            inner join dept_expenditure_payment_desc b on a.transaction_id = b.transaction_id
            where a.fin_year = '${fin_year}' and a."from" = 'DS-${dist_id}' and system = 'jalanidhhi' and a.purpose = 'pay_against_expenditure_jn' order by a.date desc`;
                let response = await client.query(queryText);
                resolve(response.rows);
            } catch (e) {
                resolve([]);
                throw e;
            } finally {
                client.release();
            }
        })
    }
    // Dealer Payments
exports.delearPayments = (fin_year, dist_id) => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
        try {
            let queryText = `select a.*, f.desc as system, c.dl_name as to from payment a
            inner join dl_master c on c.dl_id = substring(a.to, 4, length(a.to))
            inner join system_desc f on f.system_id = a.system
            where a.fin_year = '${fin_year}' and a."from" = 'DS-${dist_id}' and a.purpose = 'pay_against_bill' order by a.date desc`;
            let response = await client.query(queryText);
            resolve(response.rows);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    })
}
exports.getAllDelearPaymentsJN = (fin_year, dist_id) => {
    return new Promise(async resolve => {
        const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
        try {
            let queryText = `select a.* from payment a
            where a.fin_year = '${fin_year}' and a."from" = 'DS-${dist_id}' and a.purpose = 'pay_against_bill_jn' order by a.date desc`;
            let response = await client.query(queryText);
            resolve(response.rows);
        } catch (e) {
            resolve([]);
            throw e;
        } finally {
            client.release();
        }
    })
}
exports.getAllPaidOpeningBalance = (fin_year, dist_id) => {
        return new Promise(async resolve => {
            const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
            try {
                let queryText = `select a.*, a.payment_date as date, f.desc as system from opening_balance a
            inner join system_desc f on f.system_id = a.system
            where a.fin_year = '${fin_year}' and a.dist_id = '${dist_id}' and a.purpose = 'paid_opening_balance' order by a.date desc`;
                let response = await client.query(queryText);
                resolve(response.rows);
            } catch (e) {
                resolve([]);
                throw e;
            } finally {
                client.release();
            }
        });
    }
    // Deliver To Customer START

exports.getItemsForDeliverToCustomer = async(dist_id, fin_year, callback) => {
    const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
    try {
        let queryText = `select a.*, b.p_taxable_value, b.p_cgst_6, b.p_sgst_6, b.p_invoice_value from orders a 
        inner join "ItemMaster" b on b.implement = a.implement and b.make = a.make and b.model = a.model
        where a.system = 'farm_mechanisation' and a.dist_id = '${dist_id}' and a.c_fin_year = '${fin_year}' and a.status != 'delivered_to_customer'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getPermitDetail = async(permit_no, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let query1 = `select b.indent_no, b.indent_date, d.mrr_id, d.date as mrr_date, f.invoice_no, f.invoice_date from indent_desc a 
        inner join indent b on a.indent_no = b.indent_no
        inner join mrr_desc c on a.permit_no = c.permit_no
        inner join mrr d on c.mrr_id = d.mrr_id
        inner join invoice_desc e on a.permit_no = e.permit_no
        inner join invoice f on f.invoice_no = e.invoice_no
        where a.permit_no = '${permit_no}'`;
        let response = await client.query(query1);
        callback(response.rows[0]);
    } catch (e) {
        callback([]);
        throw e
    } finally {
        client.release();
    }
}
exports.updateDeliverToCustomerStatus = async(permit_no, remark, expected_delivery_date) => {
        return new Promise(async(resolve, reject) => {
            const client = await pool.connect().catch(e => { reject('Database Connection Failed') })
            try {
                let queryText = `UPDATE orders SET status = 'delivered_to_customer', remark = '${remark}', expected_delivery_date =  '${new Date(expected_delivery_date).toLocaleString()}', delivery_date = 'NOW()' where permit_no = '${permit_no}'`;
                await client.query(queryText);
                resolve(true);
            } catch (e) {
                reject('Server error.');
                throw e;
            } finally {
                client.release();
            }
        });
    }
    // Deliver To Customer END
    // Delivered To Customer START
exports.getAllDeliveredToCustomerOrders = async(dist_id, fin_year, callback) => {
        const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
        try {
            let queryText = `select * from orders where system = 'farm_mechanisation' and dist_id = '${dist_id}' and c_fin_year = '${fin_year}' and status = 'delivered_to_customer'`;
            let response = await client.query(queryText);
            callback(response.rows);
        } catch (e) {
            callback([]);
            throw e;
        } finally {
            client.release();
        }
    }
    // Delivered To Customer END
    // STOCK
exports.getAllStocks = async(fin_year, dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let fm_stock_query = `SELECT * FROM orders WHERE dist_id = '${dist_id}' and c_fin_year = '${fin_year}' and status = 'received' or dist_id = '${dist_id}' and c_fin_year = '${fin_year}' and status = 'delivered_to_customer'`;
        let waiting_fm_stock = client.query(fm_stock_query);
        let jn_stock_query = `SELECT * FROM jn_stock WHERE dist_id = '${dist_id}' and fin_year = '${fin_year}' and status = 'received' or dist_id = '${dist_id}' and fin_year = '${fin_year}' and status = 'delivered_to_customer'`;

        let jn_stock = await client.query(jn_stock_query);
        let fm_stock = await waiting_fm_stock;
        callback(fm_stock.rows.concat(jn_stock.rows));
    } catch (e) {
        callback([]);
        throw e
    } finally {
        client.release();
    }
};
// JOB BOOK
exports.getFarmerPayments = async(cluster_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let result1 = await client.query(`select farmer_id from jn_orders where status = 'not_paid' and cluster_id = '${cluster_id}'`);
        if (result1.rows.length > 0) {
            callback([])
        } else {
            let query2 = `select b.farmer_name, b.farmer_id, a.ammount from payment a
        inner join jn_orders b on b.cluster_id = '${cluster_id}' and b.farmer_id = substring(a.from, 8)
            where a.reference_no = '${cluster_id}' and a.system = 'jalanidhi' and a.purpose = 'farmer_advance_payment' group by b.farmer_name, b.farmer_id, a.ammount`;
            let farmer_list = await client.query(query2);
            callback(farmer_list.rows);
        }
    } catch (e) {
        callback([]);
        throw e
    } finally {
        client.release();
    }
}
exports.getJalanidhiGovtShare = async(fin_year, callback) => {
    const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
    try {
        let queryText = `select govt_share_ammount from govt_share_config where head='jalanidhi' and fin_year='${fin_year}'`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllClusterIds = async(fin_year, dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let query1 = `select cluster_id from jn_orders where dist_id = '${dist_id}' and fin_year='${fin_year}' group by cluster_id`;
        let result = await client.query(query1);
        callback(result.rows);
    } catch (e) {
        callback([]);
        throw e
    } finally {
        client.release();
    }
}
exports.getAllExpenditueAmmountsForJobBook = async(fin_year, dist_id, cluster_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let query1 = `select a.ammount, c.*, d.*, e.* from payment a 
        inner join dept_expenditure_payment_desc b on b.transaction_id = a.transaction_id
        inner join schem_master c on b.schem_id = c.schem_id
        inner join head_master d on d.head_id = b.head_id
        inner join subheads e on e.subhead_id = b.subhead_id
        where a.from= 'DS-${dist_id}' and system='jalanidhi' and a.fin_year = '${fin_year}'
        and a.purpose='pay_against_expenditure_jn' and a.reference_no = '${cluster_id}'`;
        let result = await client.query(query1);
        callback(result.rows);
    } catch (e) {
        callback([]);
        throw e
    } finally {
        client.release();
    }
}
exports.getAllMiscellaneousAmmountsForJobBook = async(fin_year, dist_id, cluster_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let query1 = `select a.ammount, c.*, b.head_name from payment a 
        inner join dept_expenditure_payment_desc b on b.transaction_id = a.transaction_id
        inner join schem_master c on b.schem_id = c.schem_id
        where a.from= 'DS-${dist_id}' and system='jalanidhi' and a.fin_year = '${fin_year}'
        and a.purpose='miscellaneous' and b.reference_no = '${cluster_id}'`;
        let result = await client.query(query1);
        callback(result.rows);
    } catch (e) {
        callback([]);
        throw e
    } finally {
        client.release();
    }
}
exports.getAvailableBalanceDetail = async(dist_id, fin_year, callback) => {
        const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
        try {
            let query1 = `select SUM(ammount) from payment where fin_year='${fin_year}'and "to"='DS-${dist_id}' and  "system" = 'jalanidhi' and purpose='received_from_dept'`;
            let result = await client.query(query1);
            let query2 = `select count(*) from jn_orders where status = 'paid' and fin_year='${fin_year}' and dist_id = '${dist_id}'`;
            let result2 = await client.query(query2);
            callback({ total_receive_balance: result.rows[0].sum, paid_farmers: result2.rows[0].count });
        } catch (e) {
            callback([]);
            throw e
        } finally {
            client.release();
        }
    }
    // Project Wise Ledger
exports.getClusterWiseCBData = async(cluster_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let query1 = ``;
        let result1 = await client.query(query1);
        callback(result1.rows);
    } catch (e) {
        callback([]);
        throw e
    } finally {
        client.release();
    }
}
exports.addReceivedOpeningBalance = async(data) => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            let max = await client.query(`select max(cast(substr(transaction_id, 12, length(transaction_id)) as int )) from opening_balance`);
            let fin_year = getCurrentFinYear();
            let transaction_id = max.rows[0].max == null ? `${fin_year}-${data.dist_id}-1` : `${fin_year}-${data.dist_id}-${(parseInt(max.rows[0].max) + 1)}`;
            if (data.payment_type == 'Cash') {
                data.payment_no = transaction_id;
            }
            let queryText = `INSERT INTO opening_balance(fin_year, date, transaction_id, dist_id, reference_no, system, purpose, ammount, remark, "from", "to", head, subhead, payment_type, payment_date, payment_no) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)`;
            let values = [fin_year, 'NOW()', transaction_id, data.dist_id, data.order_no, data.system, 'receive_opening_balance', data.amount, data.remark, `${data.from}`, `DS-${data.dist_id}`, data.head, data.subhead, data.payment_type, new Date(data.payment_date).toLocaleDateString(), data.payment_no];
            await client.query(queryText, values);
            resolve(transaction_id);
        } catch (e) {
            reject('Server error');
            throw e
        } finally {
            client.release();
        }
    })
}
exports.getOpeningBalanceOrderNos = async(system, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let query1 = `select reference_no as order_no from opening_balance where system = '${system}' group by reference_no`;
        let result1 = await client.query(query1);
        callback(result1.rows);
    } catch (e) {
        callback([]);
        throw e
    } finally {
        client.release();
    }
}
exports.addPaidOpeningBalance = async(data) => {
    return new Promise(async(resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            let max = await client.query(`select max(cast(substr(transaction_id, 12, length(transaction_id)) as int )) from opening_balance`);
            let fin_year = getCurrentFinYear();
            let transaction_id = max.rows[0].max == null ? `${fin_year}-${data.dist_id}-1` : `${fin_year}-${data.dist_id}-${(parseInt(max.rows[0].max) + 1)}`;
            let queryText = `INSERT INTO opening_balance(fin_year, date, transaction_id, dist_id, reference_no, system, purpose, ammount, remark, "from", "to", head, subhead, payment_date) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)`;
            let values = [fin_year, 'NOW()', transaction_id, data.dist_id, data.order_no, data.system, 'paid_opening_balance', data.amount, data.remark, `DS-${data.dist_id}`, `${data.to}`, data.head, data.subhead, data.payment_date];
            await client.query(queryText, values);
            resolve(transaction_id);
        } catch (e) {
            reject('Server error.');
            throw e
        } finally {
            client.release();
        }
    });
}