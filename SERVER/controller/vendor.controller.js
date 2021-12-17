const { db } = require('../config/config');
const createError = require('http-errors');



function getCurrentFinYear() {
    return new Promise(resolve => {
        var year = new Date().getFullYear().toString();
        var month = new Date().getMonth();
        var finYear = month >= 3 ? year + "-" + (parseInt(year.slice(2, 4)) + 1).toString() : (parseInt(year) - 1).toString() + "-" + year.slice(2, 4);
        resolve(finYear);
    })
}
exports.getUserDetailsByUserCode = async (UserID, callback) => {
    try {
        const result = await db.VendorMaster.findAll({ 
            where: { EmailID: UserID },
            raw: true 
        } );
        callback(result);
    } catch (e) {
        callback([]);
        throw e
    }
}
exports.getDealerDists = async (req, res, next) => {
    try {
        let queryText = `select b.dist_id, b.dist_name from "VendorDistrictMapping" a
        inner join "DistrictMaster" b on a."DistrictID" = b.dist_id
        where a."VendorID" = '${req.payload.VendorID}' group by b.dist_id, b.dist_name`;
        let response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getAllDistIndent = async (req, res, next) => {
    try {
        let response = await db.POMasterModel.findAll({
            raw: true,
            where: {
                FinYear: req.query.fin_year,
                VendorID: req.payload.VendorID
                // IsDelivered: false
            },
            order: [
                ['ApprovedDate', 'DESC']
            ],
            attributes: ["PONo", "FinYear", "NoOfItemsInPO", "POAmount" , "ApprovedDate", 'POType', 'DistrictID', 'DistrictName','Implement','Make','Model','IsDelivered',
            [ db.Sequelize.fn('SUM', db.Sequelize.cast(db.Sequelize.col('DeliveredQuantity'), 'INT') ), "TotalDeliveredQuantity" ],
            [ db.Sequelize.fn('SUM', db.Sequelize.cast(db.Sequelize.col('PendingQuantity'), 'INT') ), "TotalPendingQuantity" ]
            ],
            group: ['PONo', 'FinYear', 'NoOfItemsInPO', 'POAmount' , 'ApprovedDate', 'POType', 'DistrictID', 'DistrictName','Implement','Make','Model','IsDelivered'] ,
        })
        res.send(response);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getIndentOrdersForDeliver = async (req, res, next) => {
    try {
        const PONo = req.query.PONo;
        const response = await db.POMasterModel.findAll({
            raw: true,
            where: {
                PONo: PONo
            }
        });
        res.send(response);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getDMDetails = async (dist_id, callback) => {
    try {
        let queryText = `select * from "DMMaster" where dist_id = '${dist_id}'`;
        let response = await db.sequelize.query(queryText);
        callback(response[0][0]);
    } catch (e) {
        callback([]);
        throw e
    }
}
exports.checkInvoiceNoIsExist = (invoice_no) => {
    return new Promise( async resolve => {
        try {
            const response = await db.InvoiceMaster.findOne({
                raw: true,
                where: {
                    InvoiceNo: invoice_no
                }
            })
            response ?  resolve(true) : resolve(false);
        } catch (e) {
            console.error(e);
            resolve(false);
        }
    })
}
exports.addInvoice = async (invoice, deliver_items, UserID) => {
    return new Promise(async (resolve, reject) => {
        try {
            const FinYear = await getCurrentFinYear();
            const InvoiceData =  deliver_items.map(e => {
                e.PONo = invoice.PONo;
                e.InvoiceNo = invoice.InvoiceNo;
                e.DistrictID = invoice.DistrictID;
                e.WayBillDate = invoice.WayBillDate;
                e.InvoiceDate = invoice.InvoiceDate;
                e.NoOfOrderInPO = invoice.NoOfOrderInPO;
                e.NoOfOrderDeliver = invoice.NoOfOrderDeliver;
                e.InvoiceAmount = invoice.InvoiceAmount;
                e.POType = invoice.POType;
                e.InvoicePath = invoice.InvoicePath;
                e.Discount = invoice.Discount
                e.FinYear = FinYear;
                e.VendorID = UserID;
              return e
            })
            await db.InvoiceMaster.bulkCreate(InvoiceData);
            resolve(true);
        } catch (e) {
            console.error(e);
            reject("Server error.");
        }
    });
}
// Generated Invoices
exports.getAllInvoices = async (req, res, next) => {
    try {
        const fin_year = req.query.fin_year;
        const response = await db.InvoiceMaster.findAll({
            raw: true,
            where: {
                FinYear: fin_year,
                VendorID: req.payload.VendorID
            },
            order: [
                ['InvoiceDate', 'DESC']
            ],
            attributes: ["InvoiceNo", "InvoiceDate", "Status", "NoOfOrderDeliver"],
            group: ['InvoiceNo', 'InvoiceDate', 'Status', 'NoOfOrderDeliver']
        });
        res.send(response);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getInvoiceDetailsByInvoiceNo = async (req, res, next) => {
    try {
        const invoice_no = req.query.invoice_no;
        let queryText = `SELECT a.*, b.*, e.* FROM "InvoiceMaster" a 
        INNER JOIN "POMaster" b on a."PONo" = b."PONo" AND a."OrderReferenceNo" = b."OrderReferenceNo"
        INNER JOIN "DMMaster" e on a."DistrictID" = e.dist_id
        WHERE a."InvoiceNo" = '${invoice_no}'`;
        let response = await db.sequelize.query(queryText);
        res.send( { invoiceItemsList: response[0] } );
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getFinYearWisePendingApprovalList = async (req, res, next) => {
    try {
        const fin_year = req.query.fin_year;
        let queryText = `select a.*, b.desc as status_desc, c.indent_date, c.indent_ammount, d.invoice_date, d.invoice_ammount from approval a
        inner join approval_status_desc b on b.status_id = a.status
        inner join indent c on c.indent_no = a.indent_no
        inner join invoice d on d.invoice_no = a.invoice_no
        where a.fin_year='${fin_year}' and a.dl_id = '${req.payload.VendorID}' and a.payment_status = 'Pending' and a.pp_status = 'true' order by a.approval_date desc`;
        let response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.updateApprovalToPayble = async (approval_id, dl_remark) => {
    return new Promise(async(resolve, reject) => {
        try {
            let queryText = `update approval set payment_status = 'Payble', dl_remark = '${dl_remark}'  where approval_id = '${approval_id}'`;
            await db.sequelize.query(queryText);
            resolve(true);
        } catch (e) {
            console.error(e);
            reject("Server error.");
        }
    });
}
