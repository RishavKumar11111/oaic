const { pool, db } = require('../config/config');

const logController = require('./log.controller');
const requestIP = require('request-ip');
const UAParser = require('ua-parser-js');
const parser = new UAParser();
const createError = require('http-errors');


exports.getUserDetailsByUserId = async (user_id, callback) => {
    try {
        let response = await db.sequelize.query(`select AC.*, DM.dm_id from "AccountantMaster" AC
        INNER JOIN "DMMaster" DM ON DM.dist_id = AC.dist_id
         where AC.acc_id = '${user_id}'`);
        callback(response[0]);
    } catch (e) {
        callback([]);
        throw e
    }
}
exports.getDMDetails = async (req, res, next) => {
    try {
        let response = await db.DMMaster.findOne({
            raw: true,
            where: {
                dm_id: req.payload.DMID
            }
        })
        res.send(response);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
function getCurrentFinYear() {
    var year = new Date().getFullYear().toString();
    var month = new Date().getMonth();
    var finYear = month >= 3 ? year + "-" + (parseInt(year.slice(2, 4)) + 1).toString() : (parseInt(year) - 1).toString() + "-" + year.slice(2, 4);
    return finYear;
}
exports.getItemSellingPrices = async (callback) => {
    try {
        let order_detail = await db.sequelize.query(`select * from "ItemMaster"`);
        callback(order_detail[0]);
    } catch (e) {
        callback([]);
        throw e;
    }
};
exports.getAllAvailableOrders = async (req, res, next) => {
    try {
        const FINYear = req.query.fin_year
        const result = await db.OrderMasterModel.findAll({
            raw: true,
            where: {
                system: 'farm_mechanisation',
                dist_id: req.payload.DistrictID,
                fin_year: FINYear
            }
        });
        res.send(result);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.addPaymentOrderReceipt = async (req, res, next) => {
    const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
    try {
        const payment_data = req.body.paymentDetails
        const order = req.body.orderDetails
        const receipt = req.body.receiptDetails
        await client.query('BEGIN')
        const max = await client.query(`select MAX(sl_no) from payment`)
        const fin_year = getCurrentFinYear()
        const { DistrictID } = req.payload
        const transction_id = max.rows.length == 0 ? 'YR' + fin_year + '-DS' + payment_data.dist_id + '-1' : 'YR' + fin_year + '-DS' + payment_data.dist_id + '-' + (max.rows[0].max + 1)
        const from = `farmer-${payment_data.farmer_id}`
        const to = `DS-${payment_data.dist_id}`
        const purpose = 'farmerAdvancePayment'

        const queryText = `INSERT INTO payment(fin_year, date, transaction_id, reference_no, system, purpose, "from", "to", ammount, payment_type, payment_no, payment_date, source_bank, remark, "DivisionID", "Implement", "PayFrom", "PayTo", "PayFromID", "PayToID") VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20) RETURNING "MoneyReceiptNo"`;
        const values = [fin_year, payment_data.payment_date, transction_id, payment_data.permit_no, 'farm_mechanisation', purpose, from, to, payment_data.amount.toFixed(2), payment_data.payment_type, payment_data.payment_no, payment_data.payment_date, receipt.source_bank, payment_data.remark, 'DV2', order.Implement, 'FARMER', 'OAIC', order.FARMER_ID, DistrictID];
        const addFarmerPayment = client.query(queryText, values);

        const order_status = payment_data.amount == order.FULL_COST ? 'paid' : 'pending';
        const queryText2 = `INSERT INTO orders(c_fin_year, date, system, permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, ammount, paid_amount, status, dist_id, fin_year, order_type, "FullCost", "PendingCost") VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24)`;
        const values2 = [fin_year, 'NOW()', 'farm_mechanisation', order.PERMIT_ORDER, order.DT_PERMIT, order.DT_P_VALIDITY, order.FARMER_ID, order.VCHFARMERNAME, order.VCHFATHERNAME, order.Dist_Name, order.block_name, order.vch_GPName, order.vch_VillageName, order.Implement, order.Make, order.Model, order.SUB_AMNT, order.paid_amount, order_status, order.dist_id, order.fin_year, "API", order.FULL_COST.toFixed(2), order.FULL_COST.toFixed(2) - order.paid_amount];
        const addOrder = client.query(queryText2, values2);

        const response = await addFarmerPayment
        await addOrder
        await client.query('COMMIT')
        res.send({ receiptNo: response.rows[0].MoneyReceiptNo })
        logController.addAuditLog(req.payload.user_id, "Receive farmer adv payment.", "success", 'Payment received seccessfully.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        await client.query('ROLLBACK')
        console.error(e)
        next(createError.InternalServerError())
        logController.addAuditLog(req.payload.user_id, "Receive farmer adv payment.", "failure", 'Server error(BAL).', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } finally {
        client.release()
    }
}
exports.getAllImplements = async (req, res, next) => {
    try {
        let response = await db.ItemMasterModel.findAll({
            raw: true,
            attributes: ['Implement'],
            order: [['Implement', 'ASC']],
            group: ['Implement']
        })
        res.send(response);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getAllMakesByImplment = (implement) => {
    return new Promise(async resolve => {
        try {
            let queryText = `SELECT "Make" from "ItemMaster" WHERE "Implement"= '${implement}' group by "Make" order by "Make"`;
            let response = await db.sequelize.query(queryText);
            resolve(response[0]);
        } catch (e) {
            resolve([]);
            throw e;
        }
    })
}
exports.getAllModelsByImplmentAndMake = (implement, make) => {
    return new Promise(async resolve => {
        try {
            let queryText = `select "Model" from "ItemMaster" where "Implement"= '${implement}' and "Make" = '${make}' group by "Model" order by "Model"`;
            let response = await db.sequelize.query(queryText);
            resolve(response[0]);
        } catch (e) {
            resolve([]);
            throw e;
        }
    })
}
exports.getSaleInvoiceValueOfItem = (implement, make, model) => {
    return new Promise(async resolve => {
        try {
            let queryText = `select "SellInvoiceValue" from "ItemMaster" where "Implement"= '${implement}' and "Make" = '${make}' and "Model" = '${model}'`;
            let response = await db.sequelize.query(queryText);
            resolve(response[0][0]);
        } catch (e) {
            resolve([]);
            throw e;
        }
    })
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







exports.getPendingPaymentOrders = async (req, res, next) => {
    try {
        const districtID = req.payload.DistrictID;
        const finYear = req.query.fin_year;
        const queryText = `SELECT a.*, a.ammount as s_invoice_value FROM orders a 
        WHERE a.system = 'farm_mechanisation' AND a.dist_id = '${districtID}' AND a.c_fin_year = '${finYear}' AND a.status = 'pending'`;
        const response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.updateFarmerPendingPayment = async (req, res, next) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            const payment_data = req.body.paymentDetails
            const order = req.body.orderDetails
            const receipt = req.body.receiptDetails
            const { DistrictID } = req.payload
            if (!(order.selling_price - order.paid_amount) >= order.amount_pay_now) {
                return next(createError.BadRequest('Invalid data'))
            }
            await client.query('BEGIN');

            let max = await client.query(`select MAX(sl_no) from payment`);
            let fin_year = getCurrentFinYear();
            let transction_id = max.rows.length == 0 ? 'YR' + fin_year + '-DS' + payment_data.dist_id + '-1' : 'YR' + fin_year + '-DS' + payment_data.dist_id + '-' + (max.rows[0].max + 1);
            let from = `farmer-${payment_data.farmer_id}`;
            let to = `DS-${payment_data.dist_id}`;

            const queryText = `INSERT INTO payment(fin_year, date, transaction_id, reference_no, system, purpose, "from", "to", ammount, payment_type, payment_no, payment_date, source_bank, remark, "DivisionID", "Implement", "PayFrom", "PayTo", "PayFromID", "PayToID") VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20) RETURNING "MoneyReceiptNo"`;
            const values = [fin_year, 'NOW()', transction_id, payment_data.permit_no, 'farm_mechanisation', 'farmerAdvancePayment', from, to, payment_data.amount, payment_data.payment_type, payment_data.payment_no, payment_data.payment_date, receipt.source_bank, payment_data.remark, 'DV2', receipt.implement, 'FARMER', 'OAIC', receipt.farmer_id, DistrictID];
            const response = await client.query(queryText, values);

            const totalPaidAmount = order.paid_amount + order.amount_pay_now;
            let order_status = totalPaidAmount == order.selling_price ? 'paid' : 'pending';
            let queryText2 = `UPDATE orders set status = '${order_status}', paid_amount='${totalPaidAmount}', "PendingCost"=${order.selling_price - totalPaidAmount} where permit_no='${receipt.permit_no}'`;
            let updateOrder = client.query(queryText2);

            await updateOrder;
            await client.query('COMMIT');
            res.send({ receiptNo: response.rows[0].MoneyReceiptNo });
            logController.addAuditLog(req.payload.user_id, "Receive farmer part payment.", "success", 'Part payment received seccessfully.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        } catch (e) {
            await client.query('ROLLBACK');
            console.error(e);
            next(createError.InternalServerError())
            logController.addAuditLog(req.payload.user_id, "Receive farmer part payment.", "failure", 'Server error.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        } finally {
            client.release();
        }
}
exports.getFarmerReceiptsByFinYear = async (req, res, next) => {
    try {
        const { fin_year } = req.query
        const { DistrictID } = req.payload
        let queryText = `SELECT 
        a.purpose, a.ammount as amount, a."MoneyReceiptNo", a."PayFromID", a.reference_no, a.payment_date as date, 
        a."Implement",
        CASE WHEN a."purpose" = 'farmerAdvancePayment' THEN b.farmer_name
        ELSE c."TradeName" END as "CustomerName"
        FROM payment a
        LEFT JOIN orders b ON b.permit_no = a.reference_no
		LEFT JOIN "CustomerMaster" c ON c."CustomerID" = a."PayFromID"
        WHERE 
		a.fin_year = '${fin_year}' AND a."PayToID" = '${DistrictID}' AND 
		( a.purpose = 'farmerAdvancePayment' OR a.purpose = 'advanceCustomerPayment' OR a.purpose = 'customerPaymentAgainstInvoice' )
        order by a.date desc`
        let response = await db.sequelize.query(queryText)
        res.send(response[0])
    } catch (e) {
        console.error(e)
        next(createError.InternalServerError())
    }
}
exports.getReceiptDetails = async ({ receipt_no }) => {
    return new Promise(async (resolve, reject) => {
        const client = await pool.connect().catch(e => { reject('Database Connection Failed') })
        try {
            const queryText = `SELECT a.*, c.*, 
            CASE WHEN a."purpose" = 'farmerAdvancePayment' THEN c.farmer_name
            ELSE d."TradeName" END as farmer_name,
            CASE WHEN a."purpose" = 'farmerAdvancePayment' THEN c.farmer_id
            ELSE d."CustomerID" END as farmer_id,
            a."MoneyReceiptNo" as receipt_no, a.ammount as full_ammount, a.payment_type as payment_mode, a.payment_date as date, a."Implement" as implement, b.acc_name from payment a
            LEFT JOIN "AccountantMaster" b on b.dist_id = a."PayToID" 
            LEFT JOIN "orders" c ON c.permit_no = a.reference_no
            LEFT JOIN "CustomerMaster" d On d."CustomerID" = a."PayFromID"
            where a."MoneyReceiptNo" = '${receipt_no}'`;

            const response = await client.query(queryText);
            resolve(response.rows[0]);
        } catch (e) {
            console.error(e);
            reject(`Unexpected error`);
        } finally {
            client.release();
        }
    });
}
exports.getReceiptDetailsByPermitNo = async (permit_no, callback) => {
    const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
    try {
        let queryText = `select a.*, b.acc_name from payment a
            inner join "AccountantMaster" b on b.dist_id = a."PayToID" where a."MoneyReceiptNo" = '${permit_no}'`;
        let response = await client.query(queryText);
        callback(response.rows[0]);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllOrdersForGI = async (dist_id, fin_year, callback) => {
    try {
        let queryText = `SELECT a.*, c.* FROM orders a 
        LEFT JOIN "ItemMaster" c ON a.make = c."Make" AND a.model = c."Model" AND a.implement = c."Implement"
        WHERE a.system='farm_mechanisation' AND a.dist_id = '${dist_id}' AND a.status = 'paid' AND a.c_fin_year = '${fin_year}'`;
        let result = await db.sequelize.query(queryText);
        callback(result[0]);
    } catch (e) {
        callback([]);
        throw e
    }
}
exports.getDlDetailOfEachOrder = (DistrictID) => {
    return new Promise(async resolve => {
        try {
            let result = await db.VendorDistrictMapping.findAll({
                raw: true,
                where: { DistrictID: DistrictID },
                attributes: [
                    [db.sequelize.literal('"VendorMasterModel"."TradeName"'), 'TradeName'],
                    [db.sequelize.literal('"VendorMasterModel"."VendorID"'), 'VendorID']
                ],
                include: [{
                    model: db.VendorMaster,
                    attributes: []
                }]
            });
            resolve(result);
        } catch (e) {
            resolve([]);
            throw e
        }
    })
}
exports.getDealerDetails = async (req, res, next) => {
    try {
        const response = await db.VendorMaster.findAll({
            where: { VendorID: req.query.VendorID },
            raw: true
        });
        const VendorAddress = await db.VendorPrincipalPlace.findOne({
            raw: true,
            attributes: ['Address'],
            where: {
                VendorID: req.query.VendorID
            }
        })
        const BankAccount = await db.VendorBankAccount.findOne({
            raw: true,
            where: { VendorID: req.query.VendorID }
        })
        response[0].Address = VendorAddress.Address;
        response[0] = {
            ...response[0],
            ...BankAccount
        }
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getAccName = async (req, res, next) => {
    try {
        let response = await db.AccountantMaster.findOne({
            raw: true,
            where: {
                dist_id: req.payload.DistrictID
            }
        })
        res.send(response);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getDistName = async (req, res, next) => {
    try {
        const response = await db.DistrictMaster.findOne({
            raw: true,
            where: {
                dist_id: req.payload.DistrictID
            }
        })
        res.send(response);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.addIndent = async (req, res, next) => {
    try {
        const orderList = req.body;
        const fin_year = getCurrentFinYear();
        const max = await db.sequelize.query(`SELECT max(cast(substr("PONo", 16, length("PONo")) as int )) from "POMaster" where "FinYear"='${fin_year}'`);
        const PONumber = max[0][0].max == null ? `SLR/PO/${fin_year}/1` : `SLR/PO/${fin_year}/${(parseInt(max[0][0].max) + 1)}`;

        const POAmount = orderList.reduce((a, b) => a + +b.TotalPurchaseInvoiceValue, 0);
        orderList.forEach((e, i) => {
            e.DeliveredQuantity = 0;
            e.PendingQuantity = e.ItemQuantity;
            e.PONo = PONumber;
            e.FinYear = fin_year;
            e.InsertedBy = req.payload.user_id;
            e.DistrictID = req.payload.DistrictID;
            e.AccID = req.payload.user_id;
            e.DMID = req.payload.DMID;
            e.InsertedDate = new Date();
            e.POAmount = POAmount;
            if (e.POType == 'NonSubsidy') {
                e.OrderReferenceNo = `ORD-${i + 1}`
            }
        })
        const POInsertResult = await db.POMasterModel.bulkCreate(orderList);

        res.send({ PONo: POInsertResult[0].PONo });
        logController.addAuditLog(req.payload.user_id, "PO Initiated.", "success", 'Purchase Order Intitiated Successfully.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
        logController.addAuditLog(req.payload.user_id, "PO Initiated.", "failure", 'Server error.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
}
exports.cancelIndent = async (indent_no, indent_items) => {
    return new Promise(async (resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            let queryText2 = `UPDATE indent set status = 'cancelInitiated' where indent_no = '${indent_no}'`;
            let cancel_status = client.query(queryText2);
            await cancel_status;
            resolve(true);
        } catch (e) {
            reject("Server error.");
            throw e;
        } finally {
            client.release();
        }
    });
}
// Generated Indents Start
exports.getAllGeneratedIndents = async (req, res, next) => {
    try {
        const fin_year = req.query.fin_year;
        let queryText = `select a."PONo", a."InsertedDate", a."POAmount", b."VendorID", b."LegalBussinessName", a."ApprovalStatus", a."ApprovedDate", a."Status" from "POMaster" a 
        inner join "VendorMaster" b on a."VendorID" = b."VendorID"
        where a."IsApproved" = true and a."DistrictID" = '${req.payload.DistrictID}' and a."FinYear" = '${fin_year}' and a."Status" != 'cancel' 
        group by a."PONo", a."InsertedDate", a."POAmount", b."VendorID", b."LegalBussinessName", a."ApprovalStatus", a."ApprovedDate", a."Status"
        ORDER BY "ApprovedDate" DESC`;
        let response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getAllCancelledIndentList = async (dist_id, fin_year, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.indent_no, a.indent_date, a.indent_ammount, a.items, b."LegalBussinessName" from indent a 
        left join "VendorMaster" b on a.dl_id = b."VendorID"
        where a."DistrictID" = '${dist_id}' and "FinYear" = '${fin_year}' and a."Status" = 'cancel'`;
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
exports.getAllInvoiceList = async (req, res, next) => {
    try {
        const fin_year = req.query.fin_year;
        const dist_id = req.payload.DistrictID;
        let queryText = `SELECT a.*, b."LegalBussinessName", i."InsertedDate", i."ApprovedDate" FROM "InvoiceMaster" a
        INNER JOIN "VendorMaster" b on b."VendorID" = a."VendorID"
        INNER JOIN "POMaster" i on i."PONo" = a."PONo" AND a."OrderReferenceNo" = i."OrderReferenceNo"
        WHERE a."DistrictID" = '${dist_id}' AND a."FinYear" = '${fin_year}' AND a."IsReceived" = false order by a."InvoiceDate" desc`;
        let response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getOrdersForReceive = async (req, res, next) => {
    try {
        const invoiceNo = req.query.invoiceNo;
        const queryText = `SELECT 
        b."Implement",
        b."Make",
        b."Model",
        b."PurchaseTaxableValue",
        a."TotalPurchaseTaxableValue",
        a."TotalPurchaseCGST",
        a."TotalPurchaseSGST",
        a."TotalPurchaseInvoiceValue",
        b."TaxRate",
        b."OrderReferenceNo",
        b."UnitOfMeasurement",
        b."ItemQuantity" as "POItemQuantity",
        b."PackageSize",
        b."PackageQuantity",
        b."PackageUnitOfMeasurement",
        b."POType",
        a."InvoiceNo",
        a."IsReceived",
        a."SupplyQuantity",
        a."SupplyPackageQuantity",
        a."Discount"
        FROM "InvoiceMaster" a
        INNER JOIN "POMaster" b ON a."PONo" = b."PONo" AND a."OrderReferenceNo" = b."OrderReferenceNo"
        WHERE a."InvoiceNo" = '${invoiceNo}'`
        const response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.addMRR = async (req, res, next) => {
    const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
    try {
        await client.query('BEGIN');
        const { MRRData, updateInvoice, dealer_bill: bill } = req.body;
        const DistrictID = req.payload.DistrictID;
        let max = await client.query(`select max(cast(substr("MRRNo", 12, length("MRRNo")) as int )) from "MRRMaster" where substr("MRRNo", 0, 3) = '${DistrictID}'`);
        let fin_year = getCurrentFinYear();
        let mrr_id = max.rows[0].max == null ? `${DistrictID}/${fin_year}/1` : `${DistrictID}/${fin_year}/${(parseInt(max.rows[0].max) + 1)}`;

        MRRData.forEach(e => {
            e.ItemQuantity = e.ReceivedQuantity
            e.MRRNo = mrr_id
            e.FinYear = fin_year
            e.DistrictID = req.payload.DistrictID
            e.DMID = req.payload.DMID
            e.AcccID = req.payload.user_id
            e.InsertedBy = req.payload.user_id
        })
        await db.MRRMaster.bulkCreate(MRRData);

        let payment_max = await client.query(`select MAX(sl_no) from payment`);
        let from = `DL-${bill.dl_id}`;
        let to = `DS-${bill.dist_id}`;
        let transaction_id = 'YR' + fin_year + '-DS' + bill.dist_id + '-' + (payment_max.rows[0].max + 1);
        let queryText3 = `INSERT INTO payment(reference_no, transaction_id, "from", "to", ammount, date, purpose, fin_year, system)VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9)`;
        let values3 = [mrr_id, transaction_id, from, to, bill.amount, 'NOW()', 'advance_dealer_bill', fin_year, 'farm_mechanisation'];
        await client.query(queryText3, values3);


        await client.query('COMMIT');
        res.send({ MRRNo: mrr_id });
        logController.addAuditLog(req.payload.user_id, "Generate MRR.", "success", 'MRR generated successfully.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        console.error(e);
        await client.query('ROLLBACK');
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Generate MRR.", "failure", 'Failed to generate MRR.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } finally {
        client.release();
    }
}
exports.getAllReceivedItems = async (dist_id, fin_year, callback) => {
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
exports.getFinalListDeliverToCustomer = async (dist_id, fin_year, callback) => {
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
exports.getAllDistWiseDelear = async (req, res, next) => {
    try {
        const fin_year = req.query.fin_year;
        const dist_id = req.payload.DistrictID;
        let queryText = `select b."VendorID", b."LegalBussinessName" from "VendorDistrictMapping" a
        inner join "VendorMaster" b on a."VendorID" = b."VendorID"
        where a."DistrictID" = '${dist_id}' group by b."VendorID", b."LegalBussinessName"`;
        let response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getFinYearWiseInvoiceList = async (req, res, next) => {
    try {
        const fin_year = req.query.fin_year;
        const DistrictID = req.payload.DistrictID
        let queryText = `SELECT b."LegalBussinessName", b."TradeName", c."PONo", c."ApprovedDate", c."POType", c."POAmount", a.* FROM invoice a
        INNER JOIN "VendorMaster" b ON b."VendorID" = a.dl_id
        INNER JOIN indent c ON c."PONo" = a.indent_no
        WHERE a.fin_year='${fin_year}' AND a.dist_id = '${DistrictID}' AND payment_status = 'pending'`;
        let response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}

exports.getInvoiceItemsForPay = async (req, res, next) => {
    try {
        const invoiceNo = req.query.invoice_no;
        //         const queryText = `SELECT  
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."Implement"
        //             ELSE c.implement END as "Implement",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."Make"
        //             ELSE c.make END as "Make",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."Model"
        //             ELSE c.model END as "Model",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."PurchaseTaxableValue"
        //             ELSE d."PurchaseTaxableValue" END as "PurchaseTaxableValue",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."PurchaseCGST"
        //             ELSE d."PurchaseCGST" END as "PurchaseCGST",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."PurchaseSGST"
        //             ELSE d."PurchaseSGST" END as "PurchaseSGST",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."PurchaseInvoiceValue"
        //             ELSE d."PurchaseInvoiceValue" END as "PurchaseInvoiceValue",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."SellTaxableValue"
        //             ELSE d."SellTaxableValue" END as "SellTaxableValue",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."SellCGST"
        //             ELSE d."SellCGST" END as "SellCGST",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."SellSGST"
        //             ELSE d."SellSGST" END as "SellSGST",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."SellInvoiceValue"
        //             ELSE d."SellInvoiceValue" END as "SellInvoiceValue",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."TaxRate"
        //             ELSE d."TaxRate" END as "TaxRate",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."OrderReferenceNo"
        //                 ELSE c."permit_no" END as "OrderReferenceNo",
        //         CASE WHEN a."POType" = 'NonSubsidy' THEN e."UnitOfMeasurement"
        //                 ELSE d."UnitOfMeasurement" END as "UnitOfMeasurement",
        // c.*, ad.approval_id, f.mrr_id
        //         FROM invoice a
        //         LEFT JOIN invoice_desc b ON a.invoice_no = b.invoice_no
        //         LEFT JOIN orders c ON b.permit_no = c.permit_no
        //         LEFT JOIN "ItemMaster" d ON c.implement = d.implement AND c.make = d.make AND c.model = d.model
        // 		LEFT JOIN "NonSubsidyPODetails" e ON e."PONo" = a."indent_no"
        //         LEFT JOIN approval_desc ad ON ad.permit_no = c.permit_no
        //         LEFT JOIN mrr_desc f ON f.permit_no = b.permit_no
        //         WHERE a.invoice_no = '${invoiceNo}'`
        //         let response = await db.sequelize.query(queryText);
        //         res.send(response[0]);
        const queryText = `SELECT a.*,
        CASE WHEN a."POType" = 'NonSubsidy' THEN e."Implement" ELSE c.implement END as "Implement",
        CASE WHEN a."POType" = 'NonSubsidy' THEN e."Make" ELSE c.make END as "Make",
        CASE WHEN a."POType" = 'NonSubsidy' THEN e."Model" ELSE c.model END as "Model",
        CASE WHEN a."POType" = 'NonSubsidy' THEN e."PurchaseTaxableValue" ELSE d."PurchaseTaxableValue" END as "PurchaseTaxableValue",
        CASE WHEN a."POType" = 'NonSubsidy' THEN e."PurchaseCGST" ELSE d."PurchaseCGST" END as "PurchaseCGST",
        CASE WHEN a."POType" = 'NonSubsidy' THEN e."PurchaseSGST" ELSE d."PurchaseSGST" END as "PurchaseSGST",
        CASE WHEN a."POType" = 'NonSubsidy' THEN e."PurchaseInvoiceValue" ELSE d."PurchaseInvoiceValue" END as "PurchaseInvoiceValue",
        CASE WHEN a."POType" = 'NonSubsidy' THEN e."TaxRate" ELSE d."TaxRate" END as "TaxRate"
        FROM "MRRMaster" a
        LEFT JOIN orders c ON c.permit_no = a."OrderReferenceNo"
        LEFT JOIN "ItemMaster" d ON c.implement = d."Implement" AND c.make = d."Make" AND c.model = d."Model"
        LEFT JOIN "NonSubsidyPODetails" e ON e."PONo" = a."PONo"
        WHERE a."InvoiceNo"='${invoiceNo}' AND a."PaymentStatus" = 'Pending'`;
        const response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getInvoiceDetailsByInvoiceNo = async (invoice_no, callback) => {
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
exports.addPaymentApproval = async ({ approval, apDesc, updateInvoice }) => {
    return new Promise(async (resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            await client.query('BEGIN');
            let max = await client.query(`select MAX(sl_no) from approval`);
            let fin_year = getCurrentFinYear();
            let approval_id = (max.rows.length == 0) ? `${approval.dist_id}/${fin_year}/1` : `${approval.dist_id}/${fin_year}/${(max.rows[0].max + 1)}`;
            let payment_status = approval.deduction_amount === 0 ? 'Complete' : 'Pending';
            let queryText = `INSERT INTO approval(fin_year, dist_id, dl_id, invoice_no, indent_no, approval_id, pp_id, approval_date, ammount, status, deduction_amount, pay_now_amount, paid_amount, payment_status, pp_status, remark, items) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)`;
            let values = [approval.fin_year, approval.dist_id, approval.dl_id, approval.invoice_no, approval.indent_no, approval_id, '1', 'NOW()', approval.sub_total, 'pending_at_dm', approval.deduction_amount, approval.pay_now, approval.pay_now, payment_status, true, approval.remark, apDesc.length];
            let add_approval = client.query(queryText, values);

            let queryText2 = `insert into approval_desc (approval_id, permit_no, mrr_id) values `;
            apDesc.forEach(e => {
                queryText2 += `('${approval_id}', '${e.permit_no}', '${e.mrr_id}'), `;
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
exports.getFinYearWisePendingApprovalList = async (fin_year, dist_id, callback) => {
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
exports.getApprovalItemsForPay = async (approval_id, callback) => {
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
exports.getFinYearWiseApprovalList = (fin_year, dist_id) => {
    return new Promise(async (resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            // let queryText = `SELECT a.*, b.desc as status_desc, c.indent_date, d.invoice_date, c.indent_ammount, d.invoice_ammount FROM approval a
            // INNER JOIN approval_status_desc b ON b.status_id = a.status
            // INNER JOIN indent c ON c.indent_no = a.indent_no
            // INNER JOIN invoice d ON d.invoice_no = a.invoice_no
            // WHERE a.fin_year='${fin_year}' AND a.dist_id = '${dist_id}' ORDER BY a.approval_date DESC`;
            let queryText = `SELECT a.approval_id, a.approval_date, a.pay_now_amount as approval_amount, a.invoice_no, a.dl_id, a.pp_id, a.status, b.desc as status_desc FROM approval a
                            INNER JOIN approval_status_desc b ON b.status_id = a.status
                            WHERE a.fin_year='${fin_year}' AND a.dist_id = '${dist_id}' ORDER BY a.approval_date DESC`;
            let response = await client.query(queryText);
            resolve(response.rows);
        } catch (e) {
            reject('Server error');
            throw e;
        } finally {
            client.release();
        }
    });
}
exports.getApprovalDetail = async (req, res, next) => {
    try {
        const approval_id = req.query.approval_id;
        let queryText1 = `SELECT e.permit_no, f.implement, f.make, f.model, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, 
                            f.p_invoice_value, f.p_cgst_1, f.p_sgst_1, g.mrr_id
                            FROM approval a
                            INNER JOIN approval_desc d ON d.approval_id = a.approval_id
                            INNER JOIN orders e ON e.permit_no = d.permit_no
                            INNER JOIN "ItemMaster" f ON f.implement = e.implement and f.make = e.make and f.model = e.model
                            INNER JOIN mrr_desc g ON g.permit_no = d.permit_no
                            WHERE a.approval_id = '${approval_id}'
                            GROUP BY e.permit_no, f.implement, f.make, f.model, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, f.p_invoice_value, f.p_cgst_1, f.p_sgst_1, g.mrr_id`;
        let response1 = await db.sequelize.query(queryText1);

        let queryText2 = `SELECT a.approval_date, a.ammount as full_amount, a.deduction_amount, a.pay_now_amount, a.paid_amount, a.remark, 
                            b."LegalBussinessName", b."ContactNumber", b."EmailID", 
                            c.invoice_no, c.invoice_date, c.invoice_ammount, c.invoice_path, d.indent_no, d.indent_date, d.indent_ammount
                            FROM approval a 
                            INNER JOIN "VendorMaster" b ON b."VendorID" = a.dl_id
                            INNER JOIN invoice c ON c.invoice_no = a.invoice_no
                            INNER JOIN indent d ON d.indent_no = a.indent_no
                            WHERE a.approval_id = '${approval_id}'`;
        let response2 = await db.sequelize.query(queryText2);
        res.send({ apprItems: response1[0], aprDetail: response2[0][0] });
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.updatePartPaymentApproval = async (apr) => {
    return new Promise(async (resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            await client.query('BEGIN');
            let max = await client.query(`SELECT MAX(pp_id) FROM approval WHERE approval_id = '${apr.approval_id}'`);
            let fin_year = getCurrentFinYear();
            let pp_id = `${parseInt(max.rows[0].max) + 1}`;
            let status = apr.deduction_amount === 0 ? 'Complete' : 'Pending';
            let paid_amount = parseFloat(apr.paid_amount) + parseFloat(apr.pay_now);
            let queryText = `INSERT INTO approval(fin_year, dist_id, dl_id, invoice_no, indent_no, approval_id, pp_id, approval_date, ammount, status, deduction_amount, pay_now_amount, paid_amount, payment_status, pp_status, remark) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)`;
            let values = [fin_year, apr.dist_id, apr.dl_id, apr.invoice_no, apr.indent_no, apr.approval_id, pp_id, 'NOW()', apr.sub_total, 'pending_at_dm', apr.deduction_amount, apr.pay_now, paid_amount, status, true, apr.remark];
            let add_approval = client.query(queryText, values);
            let queryText2 = `UPDATE approval SET pp_status = false WHERE approval_id = '${apr.approval_id}' AND pp_id = '${apr.pp_id}'`;
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
exports.getAllOrders = async (dist_id, fin_year, callback) => {
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
exports.getAllLedgers = async (fin_year, dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.*, i.desc as purpose, j.desc as system, case when left(a.from,2)='DS' then d.dist_name when left(a.from,2)='DL' 
        then c."LegalBussinessName" when left(a.from,6)='farmer' then b.farmer_name when left(a.from, 4)='dept' then e.schem_name end as from_name, 
        a.to, case when left(a.to, 2)='DL' then f."LegalBussinessName" when left(a.to, 2)='DS' then g.dist_name
        when a.purpose='pay_against_expenditure' then a.to end as to_name 
        from payment a
        inner join payment_purpose_desc i on i.purpose_id = a.purpose
        inner join system_desc j on j.system_id = a.system
        left join orders b on b.permit_no = a.reference_no
        left join "VendorMaster" c on c."VendorID" = substr(a.from, 4, length(a.from))
        left join "DistrictMaster" d on d.dist_id = substr(a.from, 4, length(a.from))
        left join schem_master e on e.schem_id = substr(a.from, 6, length(a.from))
        
        left join "VendorMaster" f on f."VendorID" = substr(a.to, 4, length(a.to))
        left join "DistrictMaster" g on g.dist_id = substr(a.to, 4, length(a.to))
        where a.fin_year = '${fin_year}' and a.from = 'DS-${dist_id}' or a.fin_year = '${fin_year}' and a.to = 'DS-${dist_id}' order by a.date desc`
        let response = await client.query(queryText);

        let queryText2 = `select a.*, a.payment_date as date, b.desc as purpose, c.desc as system,
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
        callback(response2.rows.concat(response.rows));
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllDebitLedgers = async (fin_year, dist_id, callback) => {
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
exports.getAllCreditLedgers = async (fin_year, dist_id, callback) => {
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
exports.getDistWiseAllDealerLedger = async (fin_year, dist_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.*, CONCAT(c."LegalBussinessName", d.dist_name) as from_name, CONCAT(e."LegalBussinessName", f.dist_name) as to_name from payment a
        left join "VendorMaster" c on c."VendorID" = substring(a.from, 4, length(a.from))
        left join "DistrictMaster" d on d.dist_id = substring(a.from, 4, length(a.from))
        left join "VendorMaster" e on e."VendorID" = substring(a.to, 4, length(a.to))
		left join "DistrictMaster" f on f.dist_id = substring(a.to, 4, length(a.to))
        where a.fin_year = '${fin_year}' and ((a.from = 'DS-${dist_id}' and a.purpose = 'pay_against_bill') or ( a.purpose = 'advance_dealer_bill' and a.to = 'DS-${dist_id}')) order by a.date desc`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getAllDelearLedgers = async (fin_year, dist_id, dl_id, callback) => {
    const client = await pool.connect().catch(e => { callback("Database Connection Error!!!!!") });
    try {
        let queryText = `select a.*, CONCAT(c."LegalBussinessName", d.dist_name) as from_name, CONCAT(e."LegalBussinessName", f.dist_name) as to_name from payment a
        left join "VendorMaster" c on c."VendorID" = substring(a.from, 4, length(a.from))
        left join "DistrictMaster" d on d.dist_id = substring(a.from, 4, length(a.from))
        left join "VendorMaster" e on e."VendorID" = substring(a.to, 4, length(a.to))
		left join "DistrictMaster" f on f.dist_id = substring(a.to, 4, length(a.to))
        where a.fin_year = '${fin_year}' and ((a.from = 'DS-${dist_id}' and a.to = 'DL-${dl_id}') or (a.from = 'DL-${dl_id}' and a.to = 'DS-${dist_id}')) order by a.date desc`;
        let response = await client.query(queryText);
        callback(response.rows);
    } catch (e) {
        callback([]);
        throw e;
    } finally {
        client.release();
    }
}
exports.getIteimPrice = async (implement, make, model, callback) => {
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
exports.getAllDelears = async (req, res, next) => {
    try {
        let response = await db.VendorMaster.findAll({
            raw: true,
            where: {
                ApprovalStatus: 'Approved'
            }
        });
        res.send(response);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getAllPermitNos = async (req, res, next) => {
    try {
        let response = await db.sequelize.query(`select permit_no as reference_no from orders where system = 'farm_mechanisation' and dist_id = '${req.payload.DistrictID}' and c_fin_year = '${getCurrentFinYear()}' order by permit_no`);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getAllClusterIdsForExpenditure = async (req, res, next) => {
    try {
        let response = await db.sequelize.query(`select cluster_id as reference_no from jn_orders where system = 'jalanidhi' and dist_id = '${req.payload.DistrictID}' and fin_year = '${getCurrentFinYear()}' group by cluster_id`);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getAllSchema = () => {
    return new Promise(async (resolve, reject) => {
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
exports.getAllSubheads = async (head_id, callback) => {
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
exports.addExpenditurePayment = async (payment_data) => {
    return new Promise(async (resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            let system, purpose;
            switch (payment_data.schem_id) {
                case "1": {
                    system = 'farm_mechanisation';
                    purpose = 'pay_against_expenditure'
                    break;
                }
                case "2": {
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
exports.getCashBookData = async (permit_no, callback) => {
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
exports.getInvoiceDetails = async (callback) => {
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
exports.getAllDistMRRIds = async (req, res, next) => {
    try {
        const { fin_year } = req.query;
        const { DistrictID } = req.payload;
        let queryText = `SELECT a."MRRNo", a."InsertedDate", a."InvoiceNo", a."NoOfItemReceived", a."VendorID", a."PONo", b."InvoicePath" from "MRRMaster" a
        inner join "InvoiceMaster" b on b."InvoiceNo" = a."InvoiceNo"
        where a."FinYear" = '${fin_year}' and a."DistrictID" = '${DistrictID}' ORDER BY "InsertedDate" DESC`;
        let response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getMRRDetails = async (req, res, next) => {
    try {
        const mrr_id = req.query.mrr_id;
        const VendorID = req.query.dl_id;
        let response2 = db.VendorMaster.findAll({
            raw: true,
            where: {
                VendorID: VendorID
            }
        });
        let VendorAddress = await db.VendorPrincipalPlace.findOne({
            raw: true,
            attributes: ['Address'],
            where: {
                VendorID: VendorID
            }
        })
        let queryText3 = `SELECT 
                            a."ReceivedQuantity", a."InsertedDate", 
                            c.*, 
                            d."ApprovedDate", d."Implement", d."Make", d."Model", d."EngineNumber", d."ChassicNumber", d."ItemQuantity" as "POItemQuantity",
                            d."UnitOfMeasurement", d."PurchaseTaxableValue", d."TaxRate" 
                            FROM "MRRMaster" a 
							INNER JOIN "InvoiceMaster" c ON a."InvoiceNo" = c."InvoiceNo" 
							INNER JOIN "POMaster" d ON d."PONo" = a."PONo"
							WHERE a."MRRNo" = '${mrr_id}'`;
        let response3 = db.sequelize.query(queryText3);

        let response22 = await response2;
        response22[0].Address = VendorAddress.Address;
        let response33 = await response3;

        res.send({ invoice: response33[0][0], dl: response22[0], data: response33[0] });
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
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
exports.getDepartmentPaymentsForReceipt = async (fin_year, dist_id) => {
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
exports.getDepartmentPaymentsForReceiptJN = async (fin_year, dist_id) => {
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
            let queryText = `select a.*, f.desc as system, c."LegalBussinessName" as to from payment a
            inner join "VendorMaster" c on c."VendorID" = substring(a.to, 4, length(a.to))
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

exports.getItemsForDeliverToCustomer = async (req, res, next) => {
    try {
        const districtID = req.payload.DistrictID;
        const finYear = req.query.fin_year;
        let queryText = `SELECT A.*, 
        B.permit_no, B.farmer_father_name, B.gp_name, B.farmer_name, B.farmer_id, B."FullCost", B.block_name, B.dist_name, B.village_name
        FROM "POMaster" A
        INNER JOIN orders B ON A."OrderReferenceNo" = B.permit_no
        WHERE A."DistrictID"= '${districtID}' AND A."FinYear" = '${finYear}' AND A."POType" = 'Subsidy' AND 
        A."IsReceived" = true AND A."IsDeliveredToCustomer" = false`;
        let response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
// exports.getPermitDetail = async (req, res, next) => {
//     try {
//         const permit_no = req.query.permit_no;
//         let query1 = `select a.indent_no, a.indent_date, d.mrr_id, d.date as mrr_date, f.invoice_no, f.invoice_date from indent a 
//         inner join mrr_desc c on a."PermitNumber" = c.permit_no
//         inner join mrr d on c.mrr_id = d.mrr_id
//         inner join invoice_desc e on a."PermitNumber" = e.permit_no
//         inner join invoice f on f.invoice_no = e.invoice_no
//         where a."PermitNumber" = '${permit_no}'`;
//         let response = await db.sequelize.query(query1);
//         res.send(response[0][0]);
//     } catch (e) {
//         console.error(e);
//         next(createError.InternalServerError());
//     }
// }
//TODO: Remove update in Order table
// exports.updateDeliverToCustomerStatus = async (req, res, next) => {
//     try {
//         const permit_no = req.query.permit_no;
//         const remark = req.query.remark;
//         const expected_delivery_date = req.query.expected_delivery_date;
//         const orderUpdateQuery = {
//             status: 'delivered_to_customer',
//             remark: remark,
//             expected_delivery_date: new Date(expected_delivery_date),
//             delivery_date: new Date()
//         }
//         const orderCondition = { permit_no: permit_no }
//         await db.OrderMasterModel.update(orderUpdateQuery, { where: orderCondition });

//         const data = req.body;
//         const POCondition = {
//             PONo: data.PONo,
//             OrderReferenceNo: data.OrderReferenceNo
//         }
//         await db.POMasterModel.update({ IsDeliveredToCustomer: true }, { where: POCondition });
//         res.status(200).send(true);
//         logController.addAuditLog(req.payload.user_id, "Deliver to customer.", "success", 'Delivered to customer successfully.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
//     } catch (e) {
//         console.error(e);
//         next(createError.InternalServerError());
//         logController.addAuditLog(req.payload.user_id, "Deliver to customer.", "failure", 'Failed to deliver to customer.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
//     }
// }
// Deliver To Customer END
// Delivered To Customer START
exports.getAllDeliveredToCustomerOrders = async (dist_id, fin_year, callback) => {
    const client = await pool.connect().catch(e => { callback('Database Connection Failed') })
    try {
        // let queryText = `select * from orders where system = 'farm_mechanisation' and dist_id = '${dist_id}' and c_fin_year = '${fin_year}' and status = 'delivered_to_customer'`;
        let queryText = `select a.*, d.*, b.*, c."DivisionName",
        CASE WHEN a."POType" = 'Subsidy' THEN d.farmer_name
        ELSE b."LegalCustomerName" END as "LegalCustomerName"
        from public."CustomerInvoiceMaster" a
        left join public."CustomerMaster" b on a."CustomerID" = b."CustomerID"  
        left join public."DivisionMaster" c on a."DivisionID" = c."DivisionID" 
		left join public.orders d on a."OrderReferenceNo" = d.permit_no
        where a."DistrictID" = '${dist_id}' and a."FinYear" = '${fin_year}'`
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
exports.getAllStocks = async (req, res, next) => {
    try {
        const fin_year = req.query.fin_year;
        const dist_id = req.payload.DistrictID;
        let fm_stock_query = `SELECT * FROM orders WHERE dist_id = '${dist_id}' and c_fin_year = '${fin_year}' and status = 'received' or dist_id = '${dist_id}' and c_fin_year = '${fin_year}' and status = 'delivered_to_customer'`;
        let waiting_fm_stock = db.sequelize.query(fm_stock_query);
        let jn_stock_query = `SELECT * FROM jn_stock WHERE dist_id = '${dist_id}' and fin_year = '${fin_year}' and status = 'received' or dist_id = '${dist_id}' and fin_year = '${fin_year}' and status = 'delivered_to_customer'`;

        let jn_stock = await db.sequelize.query(jn_stock_query);
        let fm_stock = await waiting_fm_stock;
        res.send(fm_stock[0].concat(jn_stock[0]));
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
};
// JOB BOOK
exports.getFarmerPayments = async (cluster_id, callback) => {
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
exports.getJalanidhiGovtShare = async (fin_year, callback) => {
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
exports.getAllClusterIds = async (req, res, next) => {
    try {
        const query1 = `select cluster_id from jn_orders where dist_id = '${req.payload.DistrictID}' and fin_year='${req.query.fin_year}' group by cluster_id`;
        const result = await db.sequelize.query(query1);
        res.send(result[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getAllExpenditueAmmountsForJobBook = async (req, res, next) => {
    try {
        const fin_year = req.query.fin_year;
        const dist_id = req.payload.DistrictID;
        const cluster_id = req.query.cluster_id;
        const query1 = `select a.ammount, c.*, d.*, e.* from payment a 
        inner join dept_expenditure_payment_desc b on b.transaction_id = a.transaction_id
        inner join schem_master c on b.schem_id = c.schem_id
        inner join head_master d on d.head_id = b.head_id
        inner join subheads e on e.subhead_id = b.subhead_id
        where a.from= 'DS-${dist_id}' and system='jalanidhi' and a.fin_year = '${fin_year}'
        and a.purpose='pay_against_expenditure_jn' and a.reference_no = '${cluster_id}'`;
        const result = await db.sequelize.query(query1);
        res.send(result[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getAllMiscellaneousAmmountsForJobBook = async (req, res, next) => {
    try {
        const fin_year = req.query.fin_year;
        const dist_id = req.payload.DistrictID;
        const cluster_id = req.query.cluster_id;
        const query1 = `select a.ammount, c.*, b.head_name from payment a 
        inner join dept_expenditure_payment_desc b on b.transaction_id = a.transaction_id
        inner join schem_master c on b.schem_id = c.schem_id
        where a.from= 'DS-${dist_id}' and system='jalanidhi' and a.fin_year = '${fin_year}'
        and a.purpose='miscellaneous' and b.reference_no = '${cluster_id}'`;
        const result = await db.sequelize.query(query1);
        res.send(result[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getAvailableBalanceDetail = async (req, res, next) => {
    try {
        const dist_id = req.payload.DistrictID;
        const fin_year = req.query.fin_year;
        let query1 = `select SUM(ammount) from payment where fin_year='${fin_year}'and "to"='DS-${dist_id}' and  "system" = 'jalanidhi' and purpose='received_from_dept'`;
        let result = await db.sequelize.query(query1);
        let query2 = `select count(*) from jn_orders where status = 'paid' and fin_year='${fin_year}' and dist_id = '${dist_id}'`;
        let result2 = await db.sequelize.query(query2);
        res.send({ total_receive_balance: result[0][0].sum, paid_farmers: result2[0][0].count });
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
// Project Wise Ledger
exports.getClusterWiseCBData = async (cluster_id, callback) => {
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
exports.addReceivedOpeningBalance = async (data) => {
    return new Promise(async (resolve, reject) => {
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
exports.getOpeningBalanceOrderNos = async (system, callback) => {
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
exports.addPaidOpeningBalance = async (data) => {
    return new Promise(async (resolve, reject) => {
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


exports.getDivisionList = async (req, res, next) => {
    try {
        let result = await db.DivisionMaster.findAll({
            raw: true,
            order: [
                ['DivisionName', 'ASC']
            ],
        });
        res.send(result);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getImplementList = async (req, res, next) => {
    try {
        const response = await db.ItemMasterModel.findAll({
            raw: true,
            order: [['Implement', 'ASC']],
            group: ['Implement'],
            attributes: ['Implement'],
            where: {
                DivisionID: req.query.DivisionID
            }
        })
        res.send(response);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getMakeList = async (req, res, next) => {
    try {
        const response = await db.ItemMasterModel.findAll({
            raw: true,
            order: [['Make', 'ASC']],
            group: ['Make'],
            attributes: ['Make'],
            where: {
                DivisionID: req.body.DivisionID,
                Implement: req.body.Implement
            }
        })
        res.send(response);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getModelList = async (req, res, next) => {
    try {
        const response = await db.ItemMasterModel.findAll({
            raw: true,
            order: [['Model', 'ASC']],
            group: ['Model'],
            attributes: ['Model'],
            where: {
                DivisionID: req.body.DivisionID,
                Implement: req.body.Implement,
                Make: req.body.Make
            }
        })
        res.send(response);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getModelDetails = async (req, res, next) => {
    try {
        const modelDetails = await db.ItemMasterModel.findOne({
            raw: true,
            where: {
                DivisionID: req.body.DivisionID,
                Implement: req.body.Implement,
                Make: req.body.Make,
                Model: req.body.Model
            }
        })
        const packageList = await db.ItemPackageMasterModel.findAll({
            raw: true,
            attributes: ['PackageSize'],
            where: {
                DivisionID: req.body.DivisionID,
                Implement: req.body.Implement,
                Make: req.body.Make,
                Model: req.body.Model
            },
            group: ['PackageSize']
        })
        res.send({ modelDetails: modelDetails, packageList: packageList });
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getPackageUnits = async (req, res, next) => {
    try {
        const packageUnitList = await db.ItemPackageMasterModel.findAll({
            raw: true,
            attributes: ['UnitOfMeasurement'],
            where: {
                DivisionID: req.body.DivisionID,
                Implement: req.body.Implement,
                Make: req.body.Make,
                Model: req.body.Model,
                PackageSize: req.body.PackageSize
            }
        })
        res.send(packageUnitList);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}

exports.addNonSubsidyPurchaseOrder = async (req, res, next) => {
    try {
        const PODetails = req.body;
        let fin_year = getCurrentFinYear();
        let max = await db.sequelize.query(`select max(cast(substr(indent_no, 16, length(indent_no)) as int )) from indent where fin_year='${fin_year}'`);
        let PONumber = max[0][0].max == null ? `SLR/PO/${fin_year}/1` : `SLR/PO/${fin_year}/${(parseInt(max[0][0].max) + 1)}`;

        const POData = {
            PONo: PONumber,
            FinYear: fin_year,
            fin_year: fin_year,
            indent_no: PONumber,
            CustomerID: PODetails.CustomerID,
            VendorID: PODetails.VendorID,
            POAmount: PODetails.POAmount,
            DistrictID: req.payload.DistrictID,
            DMID: req.payload.DMID,
            AccID: req.payload.AccID,
            InsertedBy: req.payload.user_id,
            POType: 'NonSubsidy',
            items: PODetails.Quantity
        }
        await db.POMasterModel.create(POData);

        PODetails.PONo = PONumber;
        PODetails.indent_no = PONumber;
        PODetails.InsertedBy = req.payload.user_id;
        PODetails.OrderReferenceNumber = PODetails.OrderReferenceNo;
        PODetails.ItemQuantity = PODetails.Quantity;

        await db.PONonSubsidyModel.create(PODetails);

        res.send(PONumber);
        logController.addAuditLog(req.payload.user_id, "Generate Non-Subsidy Purchase Order.", "success", 'Indent generated seccessfully.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
        logController.addAuditLog(req.payload.user_id, "Generate Non-Subsidy Purchase Order.", "failure", 'Server error.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
}

exports.getDistrictWiseVendorList = async (req, res, next) => {
    try {
        const districtID = req.payload.DistrictID;
        const queryText = `SELECT b.*
        FROM public."VendorDistrictMapping" a 
        INNER JOIN "VendorMaster" b ON a."VendorID" = b."VendorID"
        WHERE a."DistrictID" = '${districtID}'`;
        const response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}

exports.getDistrictWiseCustomerList = async (req, res, next) => {
    try {
        const districtID = req.payload.DistrictID;
        const queryText = `SELECT b.*
        FROM public."CustomerDistrictMapping" a 
        INNER JOIN "CustomerMaster" b ON a."CustomerID" = b."CustomerID"
        WHERE a."DistrictID" = '${districtID}'`;
        const response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}

// NEW
exports.getStockDivisionList = async (req, res, next) => {
    try {
        let result = await db.sequelize.query(`SELECT "DivisionID", "DivisionName" FROM "StockMaster" WHERE "DistrictID" = '${req.payload.DistrictID}' GROUP BY "DivisionID", "DivisionName"`)
        res.send(result[0]);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getStockImplementList = async (req, res, next) => {
    try {
        const { DivisionID } = req.query;
        const response = await db.sequelize.query(`SELECT "Implement" FROM "StockMaster" WHERE "DivisionID" = '${DivisionID}' AND "DistrictID" = '${req.payload.DistrictID}'
        GROUP BY "Implement" ORDER BY "Implement" ASC`)
        res.send(response[0]);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getStockMakeList = async (req, res, next) => {
    try {
        const { DivisionID, Implement } = req.body;
        const response = await db.sequelize.query(`SELECT "Make" FROM "StockMaster" 
        WHERE "DivisionID" = '${DivisionID}' AND "Implement" = '${Implement}' AND "DistrictID" = '${req.payload.DistrictID}'
        GROUP BY "Make" ORDER BY "Make" ASC`)
        res.send(response[0]);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getStockModelList = async (req, res, next) => {
    try {
        const { DivisionID, Implement, Make } = req.body;
        const response = await db.sequelize.query(`SELECT "Model" FROM "StockMaster" 
        WHERE "DivisionID" = '${DivisionID}' AND "Implement" = '${Implement}' AND "Make" = '${Make}' AND "DistrictID" = '${req.payload.DistrictID}'
        GROUP BY "Model" ORDER BY "Model" ASC`)
        res.send(response[0]);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getStockUnitOfMeasurementList = async (req, res, next) => {
    try {
        const { DivisionID, Implement, Make, Model } = req.body;
        const response = await db.sequelize.query(`SELECT "UnitOfMeasurement" FROM "StockMaster" 
        WHERE "DivisionID" = '${DivisionID}' AND "Implement" = '${Implement}' AND "Make" = '${Make}' AND "Model" = '${Model}' AND "DistrictID" = '${req.payload.DistrictID}'
        GROUP BY "UnitOfMeasurement" ORDER BY "UnitOfMeasurement" ASC`)
        res.send(response[0]);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getStockModelDetails = async (req, res, next) => {
    try {
        const { DivisionID, Implement, Make, Model, UnitOfMeasurement } = req.body;
        const quantityDetails = await db.sequelize.query(`SELECT "ReceivedQuantity", "DeliveredQuantity", "AvailableQuantity" FROM "StockMaster" 
        WHERE "DivisionID" = '${DivisionID}' AND "Implement" = '${Implement}' AND "Make" = '${Make}' AND "Model" = '${Model}' AND "UnitOfMeasurement" = '${UnitOfMeasurement}' AND "DistrictID" = '${req.payload.DistrictID}'`)

        const packageList = await db.sequelize.query(`SELECT "PackageSize" FROM "StockMaster" 
        WHERE "PackageSize" IS NOT NULL AND "DivisionID" = '${DivisionID}' AND "Implement" = '${Implement}' AND "Make" = '${Make}' AND "Model" = '${Model}' AND "UnitOfMeasurement" = '${UnitOfMeasurement}' AND "DistrictID" = '${req.payload.DistrictID}'
        GROUP BY "PackageSize" ORDER BY "PackageSize" ASC`)

        const modelPriceDetails = await db.ItemMasterModel.findOne({
            raw: true,
            where: { DivisionID, Implement, Make, Model }
        })
        const modelDetails = {
            ...modelPriceDetails,
            ...quantityDetails[0][0]
        }

        res.send({ modelDetails: modelDetails, packageList: packageList[0] });
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getStockPackageUnits = async (req, res, next) => {
    try {
        const { DivisionID, Implement, Make, Model, UnitOfMeasurement, PackageSize } = req.body;
        const packageUnitList = await db.sequelize.query(`SELECT "PackageUnitOfMeasurement" FROM "StockMaster" 
        WHERE "DivisionID" = '${DivisionID}' AND "Implement" = '${Implement}' AND "Make" = '${Make}' AND "Model" = '${Model}' 
        AND "UnitOfMeasurement" = '${UnitOfMeasurement}' AND "PackageSize" = '${PackageSize}' AND "DistrictID" = '${req.payload.DistrictID}'
        GROUP BY "PackageUnitOfMeasurement" ORDER BY "PackageUnitOfMeasurement" ASC`)
        res.send(packageUnitList[0]);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.addCustomerInvoice = async (req, res, next) => {
    try {
        const orderList = req.body;
        const fin_year = getCurrentFinYear();
        const max = await db.sequelize.query(`SELECT max(cast(substr("CustomerInvoiceNo", 16, length("CustomerInvoiceNo")) as int )) from "CustomerInvoiceMaster" where "FinYear"='${fin_year}'`);
        const CustomerInvoiceNo = max[0][0].max == null ? `SLR/IN/${fin_year}/1` : `SLR/IN/${fin_year}/${(parseInt(max[0][0].max) + 1)}`;

        const invoiceAmount = orderList.reduce((a, b) => a + +b.TotalSellInvoiceValue, 0);
        orderList.forEach((e, i) => {
            e.CustomerInvoiceNo = CustomerInvoiceNo;
            if (e.POType == 'Subsidy')
                e.MRRNo = e.MRRID

            e.NoOfOrderDeliver = orderList.length
            e.FinYear = fin_year;
            e.InsertedBy = req.payload.userId;
            e.DistrictID = req.payload.DistrictID;
            e.AccID = req.payload.userId;
            e.DMID = req.payload.DMID;
            e.InsertedDate = new Date();
            e.InvoiceAmount = invoiceAmount;
            e.OrderReferenceNo = e.POType == 'Subsidy' ? e.permit_no : `OrderReferenceNo-${i + 1}`
        })
        const result = await db.CustomerInvoiceMasterModel.bulkCreate(orderList);

        res.send({ CustomerInvoiceNo: result[0].CustomerInvoiceNo, InsertedDate: result[0].InsertedDate });
        logController.addAuditLog(req.payload.user_id, "Add Customer Invoice.", "success", 'Customer Invoice Added Successfully.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
        logController.addAuditLog(req.payload.user_id, "Add Customer Invoice.", "failure", 'Server error.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
}


exports.addCustomerDetails = async (req, res, next) => {
    try {
        const data = req.body;
        var CustomerDetails = {};
        CustomerDetails.LegalCustomerName = data.legalname;
        CustomerDetails.TradeName = data.tradename;
        CustomerDetails.BussinessConstitution = data.BussinessConstitution;
        CustomerDetails.ContactNumber = data.contactnumber;
        CustomerDetails.EmailID = data.email;
        CustomerDetails.InsertedBy = req.payload.user_id;
        const result = await db.CustomerMaster.create(CustomerDetails);
        const distMapData = {
            CustomerID: result.CustomerID,
            DistrictID: req.payload.DistrictID,
            InsertedBy: req.payload.user_id
        }
        await db.CustomerDistrictMappingModel.create(distMapData);

        res.send(true);

    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}

exports.getCustomerDetailsForInvoice = async (req, res, next) => {
    try {
        const response = await db.CustomerMaster.findOne({
            raw: true,
            where: {
                CustomerID: req.query.CustomerID
            }
        })
        res.send(response);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.addPaymentReceipt = async (req, res, next) => {
    try {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        const data = req.body
        const CustomerID = data.customerID
        const { DistrictID } = req.payload
        const referenceNo = data.paymentMode === 'Advanced' ? data.customerID : data.customerInvoiceNo
        const purpose = data.paymentMode === 'Advanced' ? `advanceCustomerPayment` : `customerPaymentAgainstInvoice`
        const fin_year = getCurrentFinYear()
        const payment_max = await client.query(`select MAX(sl_no) from payment`)
        const from = `CS-${CustomerID}`
        const to = `DS-${DistrictID}`
        const transaction_id = 'YR' + fin_year + '-DS' + DistrictID + '-' + (payment_max.rows[0].max + 1);

        const queryText = `INSERT INTO payment(fin_year, date, transaction_id, reference_no, system, purpose, "from", "to", ammount, payment_type, payment_no, payment_date, source_bank, remark, "DivisionID", "Implement", "PayFrom", "PayTo", "PayFromID", "PayToID" ) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20) RETURNING "MoneyReceiptNo"`
        const values = [fin_year, 'NOW()', transaction_id, referenceNo, 'farm_mechanisation', purpose, from, to, data.paymentReceived.toFixed(2), data.paymentType, data.paymentNo, data.paymentDate, data.sourceBank, data.remark, data.division, data.productCategory, 'CUSTOMER', 'OAIC', data.customerID, DistrictID]
        const response = await client.query(queryText, values)

        res.send({ moneyReceiptNo: response.rows[0].MoneyReceiptNo })
    }
    catch (e) {
        console.error(e);
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "failure", 'Server error.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
}
exports.getCustomerLedgerByCustomerID = async (req, res, next) => {
    try {
        const { finYear, customerID } = req.query
        const dist_id = req.payload.DistrictID
        let queryText = `select a.* from payment a
        where 
        a.fin_year = '${finYear}' and a.from = 'DS-${dist_id}'  and a.to='CS-${customerID}' 
        or 
        a.fin_year = '${finYear}' and a.to = 'DS-${dist_id}'  and a.from='CS-${customerID}'
        order by a.date desc`
        const response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError())
    }
}
exports.getInvoiceListByCusID = async (req, res, next) => {
    try {
        const { finYear, customerID } = req.query
        const { DistrictID } = req.payload
        const response = await db.CustomerInvoiceMasterModel.findAll({
            raw: true,
            attributes: ['CustomerInvoiceNo'],
            where: {
                FinYear: finYear,
                DistrictID: DistrictID,
                CustomerID: customerID
            }
        })
        res.send(response);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError())
    }
}
exports.getCusInvoiceDetailsByInvoiceID = async (req, res, next) => {
    try {
        const { customerInvoiceNo } = req.query
        const response = await db.CustomerInvoiceMasterModel.findOne({
            raw: true,
            attributes: [
                'InvoiceAmount',
                `NoOfOrderDeliver`
            ],
            where: {
                CustomerInvoiceNo: customerInvoiceNo
            }
        })
        res.send(response);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError())
    }
}


exports.getCustomerInvoiceDetails = async (req, res, next) => {
    try {
        const { CustomerInvoiceNo } = req.query
        const response = await db.CustomerInvoiceMasterModel.findAll({
            raw: true,
            where: {
                CustomerInvoiceNo: CustomerInvoiceNo
            }
        })
        res.send(response);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError())
    }
}
