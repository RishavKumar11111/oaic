const router = require('express').Router();
const accHeadController = require('../controller/accHead.controller');
const logController = require('../controller/log.controller');
const requestIP = require('request-ip');
const UAParser = require('ua-parser-js');
const parser = new UAParser();
const createError = require('http-errors');
module.exports = router;

const c_year = new Date().getFullYear().toString();
const c_month = new Date().getMonth();
const cFinYear = c_month >= 3 ? c_year + "-" + (parseInt(c_year.slice(2, 4)) + 1).toString() : (parseInt(c_year) - 1).toString() + "-" + c_year.slice(2, 4);

router.get('/dealerGlobalLedger', (req, res) => {
    res.render('accHead/dealerGlobalLedger', { csrfToken: req.csrfToken(), userId: req.payload.user_id, c_fin_year: cFinYear, moduleName: "Global ledger of Dealers" });
});
router.get('/districtLedger', (req, res) => {
    res.render('accHead/districtLedger', { csrfToken: req.csrfToken(), userId: req.payload.user_id, c_fin_year: cFinYear, moduleName: "Global ledger of Districts" });
});
router.get('/tdsLedger', (req, res) => {
    res.render('accHead/tdsLedger', { csrfToken: req.csrfToken(), userId: req.payload.user_id, c_fin_year: cFinYear, moduleName: "TDS" });
});





// ========================================= DEALER GLOBAL LEDGER PART STARTS =========================================

router.get('/getAllDistList', accHeadController.getAllDistList);
router.get('/getAllDelears', accHeadController.getAllDelears);
router.get('/getDistWiseDealerLedger', accHeadController.getDistWiseDealerLedger);




router.get('/getAdvanceDlBillDetail', accHeadController.getAdvanceDlBillDetail);
router.get('/getPayAgainstBillDetail', async(req, res) => {
    try {
        let result = await accHeadController.getPayAgainstBillDetail(req.query);
        res.send(result);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
});
router.get('/getIndentDetailsByIndentNo', async(req, res) => {
    try {
        let result = await accHeadController.getIndentDetailsByIndentNo(req.query);
        res.send(result);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
});
router.get('/getMRRDetails', async(req, res) => {
    try {
        let result = await accHeadController.getMRRDetails(req.query);
        res.send(result);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
});
router.get('/getApprovalDetail', async(req, res) => {
    try {
        let result = await accHeadController.getApprovalDetail(req.query);
        res.send(result);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
});

// ========================================= DEALER GLOBAL LEDGER PART ENDS =========================================

// ========================================= ALL DISTRICT LEDGER PART STARTS =========================================

router.get('/getAllDistrictLedgerData', async(req, res) => {
    try {
        let result = await accHeadController.getAllDistrictLedgerData(req.query);
        res.send(result);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
});
router.get('/getAllLedgers', async(req, res) => {
    try {
        let result = await accHeadController.getAllLedgers(req.query);
        res.send(result);
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
});

// ========================================= ALL DISTRICT LEDGER PART ENDS =========================================
















router.get('/updateDmDetail', (req, res) => {
    res.render('admin/updateDmDetail', { moduleName: "District Managers" });
});
router.get('/updateAccDetail', (req, res) => {
    res.render('admin/updateAccDetail', { moduleName: "District accountants" });
});
router.get('/addNewDealer', (req, res) => {
    res.render('admin/addNewDealer', { moduleName: "Dealer / Add new dealer" });
});
router.get('/updateDealer', (req, res) => {
    res.render('admin/updateDealer', { moduleName: "Dealer / Update dealer" });
});
router.get('/addItem', (req, res) => {
    res.render('admin/addItem', { moduleName: "Dealer / Add new item" });
});
router.get('/updateItem', (req, res) => {
    res.render('admin/updateItem', { moduleName: "Dealer / Update item detail" });
});
router.get('/paymentReceived', (req, res) => {
    res.render('admin/paymentReceived', { user_id: req.payload.user_id, c_date: new Date(), moduleName: "Receive payment" })
});
router.get('/auditLog', (req, res) => {
    res.render('admin/auditLog', { user_id: req.payload.user_id, c_date: new Date(), cFinYear: cFinYear, moduleName: "Audit log" })
});


router.get('/getAllDistricts', (req, res) => {
    adminBal.getAllDistricts(result => {
        res.send(result);
    });
});
router.get('/getDMList', async(req, res) => {
    let result = await adminBal.getDMList();
    res.send(result);
});
router.post('/modifyDMDetail', async(req, res) => {
    try {
        let result = await adminBal.modifyDMDetail(req.body.dm_id, req.body.u_data);
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Update DM detail.", "success", 'Successfully updated DM details.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Update DM detail.", "failure", 'Failed to update DM details.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.get('/getAccList', async(req, res) => {
    let result = await adminBal.getAccList();
    res.send(result);
});
router.post('/modifyAccDetail', async(req, res) => {
    try {
        let result = await adminBal.modifyAccDetail(req.body.acc_id, req.body.u_data);
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Update Accountant detail.", "success", 'Successfully updated Accountant details.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Update Accountant detail.", "failure", 'Failed to update Accountant details.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.get('/getAllDlList', async(req, res) => {
    let result = await adminBal.getAllDlList();
    res.send(result);
});
router.get('/getDistWiseDealerList', (req, res) => {
    adminBal.getDistWiseDealerList(req.query.dist_id, result => {
        res.send(result);
    });
});
router.get('/getDlAllDetailByDlId', async(req, res) => {
    try {
        let result = await adminBal.getDlAllDetailByDlId(req.query.dl_id);
        res.send(result);
    } catch (e) {
        res.send({});
    }
});
router.get('/getAllImplementsForDealerReg', async(req, res) => {
    let result = await adminBal.getAllImplementsForDealerReg();
    res.send(result);
});
router.post('/getMakesForDealerReg', async(req, res) => {
    let result = await adminBal.getMakesForDealerReg(req.body.implement);
    res.send(result);
});
router.post('/getModelsForDealerReg', async(req, res) => {
    let result = await adminBal.getModelsForDealerReg(req.body.implement, req.body.make);
    res.send(result);
});
router.post('/addNewDealer', async(req, res) => {
    try {
        let result = await adminBal.addNewDealer(req.body.dealerDetail, req.body.dealerDistList, req.body.dealerItems);
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Add new dealer.", "success", 'Successfully added new dealer.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Add new dealer.", "failure", 'Failed to add new dealer.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.get('/getAllItemList', async(req, res) => {
    let result = await adminBal.getAllItemList();
    res.send(result);
});
router.post('/updateItemDetail', async(req, res) => {
    try {
        let result = await adminBal.updateItemDetail(req.body.originalItem, req.body.updateData);
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Update item.", "success", 'Successfully update item.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Update item.", "failure", 'Failed to update item.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.post('/removeItem', async(req, res) => {
    try {
        let result = await adminBal.removeItem(req.body.implement, req.body.make, req.body.model);
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Remove item.", "success", 'Successfully removed item detail.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Remove item.", "failure", 'Failed to remove item detail.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }

});
router.post('/addItem', async(req, res) => {
    try {
        let result = await adminBal.addItem(req.body);
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Add new item.", "success", 'Successfully added new item.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Add new item.", "failure", 'Failed to add new item.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.post('/updateDealerDetail', async(req, res) => {
    try {
        let result = await adminBal.updateDealerDetail(req.body.dl_id, req.body.dealerDetail, req.body.dealerDistList, req.body.dealerItems);
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Update dealer detail.", "success", 'Successfully update dealer detail.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Update dealer detail.", "failure", 'Failed to update dealer detail.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.post('/removeDealer', async(req, res) => {
    try {
        let result = await adminBal.removeDealer(req.body.dl_id);
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Remove dealer.", "success", 'Successfully removed dealer detail.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Remove dealer.", "failure", 'Failed to remove dealer detail.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.get('/getAllImplementsForAddItem', async(req, res) => {
    let result = await adminBal.getAllImplementsForAddItem();
    res.send(result);
});
router.post('/getAvlMakesForAddItem', async(req, res) => {
    let result = await adminBal.getAvlMakesForAddItem(req.body.imp);
    res.send(result);
});


// ===================================== RECEIVE PAYMENT PART START =====================================

router.get('/getAllSource', async(req, res) => {
    try {
        let result = await adminBal.getAllSource();
        res.send(result);
    } catch (e) { next(createError.InternalServerError()); }
});
router.get('/getAllSchema', async(req, res) => {
    try {
        let result = await adminBal.getAllSchema()
        res.send(result);
    } catch (e) { next(createError.InternalServerError()); }
});
router.get('/getComponentsOfSchema', async(req, res) => {
    try {
        let result = await adminBal.getComponentsOfSchema(req.query.schemaId)
        res.send(result);
    } catch (e) { next(createError.InternalServerError()); }
});
router.post('/addReceivedPayment', async(req, res) => {
    try {
        let result = await adminBal.addReceivedPayment(req.body.payment_data, req.body.payment_desc_data)
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Receive payment from source.", "success", 'Payment received successfully.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Receive payment from source.", "failure", 'Failed to receive payment.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});

// ===================================== RECEIVE PAYMENT PART ENDS =====================================

// ===================================== RECEIVE PAYMENT PART START =====================================

router.post('/getDateWiseAuditLogData', async(req, res) => {
    try {
        let result = await adminBal.getDateWiseAuditLogData(req.body.fromDate, req.body.toDate);
        res.send(result);
    } catch (e) {
        next(createError.InternalServerError());
    }
});

// ===================================== RECEIVE PAYMENT PART ENDS =====================================