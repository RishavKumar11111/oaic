const router = require('express').Router();
const adminController = require('../controller/admin.controller');
const logController = require('../controller/log.controller');
const requestIP = require('request-ip');
const UAParser = require('ua-parser-js');
const parser = new UAParser();
const createError = require('http-errors');
module.exports = router;


router.get('/getAllDistricts', adminController.getAllDistricts);
router.get('/getDMList', adminController.getDMList);
router.post('/modifyDMDetail', adminController.modifyDMDetail);
router.get('/getAccList', adminController.getAccList);
router.post('/modifyAccDetail', adminController.modifyAccDetail);
router.get('/getAllDlList', adminController.getAllDlList);
router.get('/getDistWiseDealerList', adminController.getDistWiseDealerList);
router.get('/getDlAllDetailByDlId', async(req, res) => {
    try {
        let result = await adminController.getDlAllDetailByDlId(req.query.VendorID);
        res.send(result);
    } catch (e) {
        res.send({});
    }
});
router.get('/getAllItemList', adminController.getAllItemList);
router.get('/getDivisionList', adminController.getDivisionList);
router.post('/updateItemDetail', adminController.updateItemDetail);
router.post('/removeItem', adminController.removeItem);
router.post('/addItem', adminController.addItem);
router.post('/updateDealerDetail', async(req, res) => {
    try {
        let result = await adminController.updateDealerDetail(req.body.dl_id, req.body.dealerDetail, req.body.dealerDistList, req.body.dealerItems);
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Update dealer detail.", "success", 'Successfully update dealer detail.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Update dealer detail.", "failure", 'Failed to update dealer detail.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.post('/removeDealer', adminController.removeDealer);
router.get('/getAllImplementsForAddItem', adminController.getAllImplementsForAddItem);
router.post('/getAvlMakesForAddItem', adminController.getAvlMakesForAddItem);
router.post('/addCustomerDetails', adminController.addCustomerDetails);
router.get('/getCustomerList', adminController.getCustomerList);
router.post('/removeCustomer', adminController.removeCustomer);

// ===================================== RECEIVE PAYMENT PART START =====================================

router.get('/getAllSource', adminController.getAllSource);
router.get('/getAllSchema', adminController.getAllSchema);
router.get('/getComponentsOfSchema', adminController.getComponentsOfSchema);
router.post('/addReceivedPayment', async(req, res) => {
    try {
        let result = await adminController.addReceivedPayment(req.body.payment_data, req.body.payment_desc_data)
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Receive payment from source.", "success", 'Payment received successfully.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Receive payment from source.", "failure", 'Failed to receive payment.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.post('/getDateWiseAuditLogData', adminController.getDateWiseAuditLogData);
router.get('/getAllAppliedDealerList', adminController.getAllAppliedDealerList);
router.post('/approvDealers', adminController.approvDealers);
router.post('/rejectDealers', adminController.rejectDealers);
router.post('/updateVendorBasicDetails',  adminController.updateVendorBasicDetails);
router.post('/updateVendorServices',  adminController.updateVendorServices);
router.post('/updateVendorContactPersonDetails',  adminController.updateVendorContactPersonDetails);
router.post('/updateVendorPrincipalPlaces',  adminController.updateVendorPrincipalPlaces);
router.post('/updateVendorBankDetails',  adminController.updateVendorBankDetails);
router.get('/getCustomerDetails', adminController.getCustomerDetails);
router.post('/updateCustomerDetails/:CustomerID', adminController.updateCustomerDetails);










// ================================================= CHAT BOT PART START ================================================= 

const request = require('request');
router.post('/sendChatBotMessage', async(req, res) => {
    try {
        const id = req.body.id == undefined ? (Math.floor(Math.random() * 1000) + 10) : req.body.id;
        const data = {
            sender: id,
            message: req.body.newMessage
        }
        request.post({
            headers: { 'content-type': 'application/json' },
            url: 'http://164.100.140.200/webhooks/rest/webhook',
            // url:     'http://localhost:5005/webhooks/rest/webhook',
            body: JSON.stringify(data)
        }, function(error, response, body) {
            try {
                let rData = JSON.parse(body);
                res.send({ message: rData, id: id });
            } catch (e) {
                console.error(e);
            }
        });
    } catch (e) {
        console.error(e)
    }
});

// ================================================= CHAT BOT PART ENDS  =================================================