const createError = require('http-errors');
const { pool, db } = require('../config/config');
const logBal = require('./log.controller');
const requestIP = require('request-ip');
const UAParser = require('ua-parser-js');
const parser = new UAParser();

exports.getUserDetailsByUserId = async (user_id, callback) => {
    try {
        const response = await db.DMMaster.findByPk(user_id,{ raw: true } );
        callback(response);
    } catch (e) {
        callback([]);
        throw e
    }
}
exports.getAllPaymentApprovals = async (req, res, next) => {
    try {
        const { fin_year } = req.query;
        const queryText = `select * from approval where fin_year = '${fin_year}' and dist_id = '${req.payload.DistrictID}' and status = 'pending_at_dm'`;
        const response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getApprovalDetails = async (req, res, next) => {
    try {
        const { approval_id } = req.query;
        let queryText1 = `select e.permit_no, f.implement, f.make, f.model, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, f.p_invoice_value, f.p_cgst_1, f.p_sgst_1, g.mrr_id
        from approval a
        left join approval_desc d on d.approval_id = a.approval_id
        left join orders e on e.permit_no = d.permit_no
        left join "ItemMaster" f on f.implement = e.implement and f.make = e.make and f.model = e.model
        left join mrr_desc g on g.permit_no = d.permit_no
        where a.approval_id = '${approval_id}'
        group by e.permit_no, f.implement, f.make, f.model, f.p_taxable_value, f.p_cgst_6, f.p_sgst_6, f.p_invoice_value, f.p_cgst_1, f.p_sgst_1, g.mrr_id`;
        let response1 = db.sequelize.query(queryText1);

        let queryText2 = `select a.invoice_no, a.indent_no, indt."ApprovedDate", b.invoice_date, indt."POAmount", b.invoice_ammount from approval a
        inner join "POMaster" indt on indt."PONo" = a.indent_no
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
exports.forwardToBank = async (req, res, next) => {
        try {
            const { approval_ids: approvals } = req.body;
            let condition = '';
            for (let i = 0; i < approvals.length; i++) {
                if (i == 0) condition = condition + `(approval_id = '${approvals[i].approval_id}' and pp_id = '${approvals[i].pp_id}') `;
                else condition = condition + ` OR (approval_id = '${approvals[i].approval_id}' and pp_id = '${approvals[i].pp_id}') `;
            }
            let queryText = `UPDATE approval set status = 'pending_at_bank', dm_approved_on = 'NOW()' where ${condition}`;
            await db.sequelize.query(queryText);
            res.send(true);
            logBal.addAuditLog(req.payload.user_id, "Approval forward to bank by DM.", "success", 'Successfully dealer pay approval forwarded to bank.', req.originalUrl.split("?").shift(), '/DM', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
            console.error(e);
            next(createError.InternalServerError());
            logBal.addAuditLog(req.payload.user_id, "Approval forward to bank by DM.", "failure", 'Approval failed to forward bank.', req.originalUrl.split("?").shift(), '/DM', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
}
exports.getApprovedPayments = async (req, res, next) => {
    try {
        const { fin_year } = req.query;
        const { DistrictID } = req.payload;
        let queryText = `select a.*, b.desc as status_desc from approval a 
        inner join approval_status_desc b on b.status_id = a.status
        where a.fin_year = '${fin_year}' and a.dist_id = '${DistrictID}' and a.status != 'pending_at_dm'`
        let response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getPendinglistOfGenerateIndent = async (req, res, next) => {
    try {
        const { fin_year } = req.query
        const { DistrictID } = req.payload
        let queryText = `SELECT a."PONo", a."InsertedDate", a."NoOfItemsInPO", a."POAmount", a."FinYear",
        dl."LegalBussinessName" from "POMaster" a 
        inner join "VendorMaster" dl on a."VendorID" = dl."VendorID"        
        where a."FinYear" = '${fin_year}' and a."DistrictID" = '${DistrictID}' and a."Status" = 'indentInitiated' group by a."PONo",
        a."InsertedDate", a."NoOfItemsInPO", a."POAmount", a."FinYear", dl."LegalBussinessName" ORDER BY a."InsertedDate" DESC`
        let response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getPendinglistOfCancelIndent = async (req, res, next) => {
    try {
        const { fin_year } = req.query
        const { dist_id } = req.payload
        let queryText = `select  a."PONo", a."InsertedDate", a."NoOfItemsInPO", a."POAmount", a."FinYear",
        dl."LegalBussinessName" from "POMaster" a 
        inner join "VendorMaster" dl on a."VendorID" = dl."VendorID"        
        where a."FinYear" = '${fin_year}' and a."DistrictID" = '${dist_id}' and a."Status" = 'cancelInitiated' group by a."PONo", a."InsertedDate", a."NoOfItemsInPO", a."POAmount", a."FinYear",
        dl."LegalBussinessName"`
        let response = await db.sequelize.query(queryText);
        res.send(response[0]);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.GenerateIndent = async (req, res, next) => {
        try {
            const { PONoList, PermitNoList } = req.body;
            let updateQuey = {
                status: 'indentGenerated',
                Status: 'indentGenerated',
                UpdateDate: new Date(),
                UpdateBy: req.payload.user_id,
                IsApproved: true,
                ApprovalStatus: "Approved",
                ApprovedDate: new Date()
            }
            await db.POMasterModel.update(updateQuey, {
                where: {
                    PONo: PONoList
                }
            });
            await db.OrderMasterModel.update({ status: 'indent_generated' }, {
                where: {
                    permit_no: PermitNoList
                }
            });
            res.send(true);
            logBal.addAuditLog(req.payload.user_id, "Approve generate indent.", "success", 'Successfully approved Generate Indents.', req.originalUrl.split("?").shift(), '/DM', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        } catch (e) {
            console.error(e);
            next(createError.InternalServerError());
            logBal.addAuditLog(req.payload.user_id, "Approve generate indent.", "failure", 'Failed to approve Generate Indents', req.originalUrl.split("?").shift(), '/DM', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        }
}
exports.CancelIndent = async (req, res, next) => {
    try {
        const { PONoList, PermitNoList } = req.body;        
        let updateQuey = {
            status: 'cancel',
            Status: 'cancel',
            UpdateDate: new Date(),
            UpdateBy: req.payload.user_id,
            IsCancelled: false,
            CancellationStatus: "Reject",
            CancelledDate: new Date(),
            CancelledBy: req.payload.user_id,
        }
        await db.POMasterModel.update(updateQuey, {
            where: {
                PONo: PONoList
            }
        });
        await db.OrderMasterModel.update({ status: 'paid' }, {
            where: {
                permit_no: PermitNoList
            }
        });
        res.send(true);
        logBal.addAuditLog(req.payload.user_id, "Approve Cancellation of Indent.", "success", 'Successfully pprove the cancelled Indents.', req.originalUrl.split("?").shift(), '/DM', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
        logBal.addAuditLog(req.payload.user_id, "Approve Cancellation of Indent", "failure", 'Failed to approve Cancelled Indents.', req.originalUrl.split("?").shift(), '/DM', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
}