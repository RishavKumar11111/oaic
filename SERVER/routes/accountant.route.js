const router = require('express').Router();
const accountantController = require('../controller/accountant.controller');
const logController = require('../controller/log.controller');
const requestIP = require('request-ip');
const UAParser = require('ua-parser-js');
const parser = new UAParser();
const createError = require('http-errors');
module.exports = router;

const c_year = new Date().getFullYear().toString();
const c_month = new Date().getMonth();
const c_fin_year = c_month >= 3 ? c_year + "-" + (parseInt(c_year.slice(2, 4)) + 1).toString() : (parseInt(c_year) - 1).toString() + "-" + c_year.slice(2, 4);


router.get('/receivePendingMoney', async(req, res) => {
    res.render('accountant/farmerPartPayment', { csrfToken: req.csrfToken(), userId: req.payload.userDetails.acc_id, distcode: req.payload.userDetails.dist_id, cDate: new Date(), c_fin_year: c_fin_year, moduleName: "Money Receipt / Partly Receive" });
});
router.get('/deliverToCustomer', async(req, res) => {
    res.render('accountant/deliverToCustomer', { csrfToken: req.csrfToken(), userId: req.payload.userDetails.acc_id, distcode: req.payload.userDetails.dist_id, c_fin_year: c_fin_year, moduleName: "Invoice / Deliver & Generate Invoice" });
});
router.get('/deliveredToCustomer', async(req, res) => {
    res.render('accountant/deliveredToCustomer', { csrfToken: req.csrfToken(), userId: req.payload.userDetails.acc_id, distcode: req.payload.userDetails.dist_id, c_fin_year: c_fin_year, moduleName: "Invoice / Re-Print Invoice" });
});
router.get('/payToDelear', async(req, res) => {
    res.render('accountant/payToDelear', { csrfToken: req.csrfToken(), userId: req.payload.userDetails.acc_id, distcode: req.payload.userDetails.dist_id, c_fin_year: c_fin_year, moduleName: "Dealer pay / Pay to dealer" });
});
router.get('/dealerPartPayment', async(req, res) => {
    res.render('accountant/dealerPartPayment', { csrfToken: req.csrfToken(), userId: req.payload.userDetails.acc_id, distcode: req.payload.userDetails.dist_id, c_fin_year: c_fin_year, moduleName: "Dealer pay / Part payment to dealer" });
});
router.get('/payToDelearReport', async(req, res) => {
    res.render('accountant/payToDelearReport', { csrfToken: req.csrfToken(), userId: req.payload.userDetails.acc_id, distcode: req.payload.userDetails.dist_id, c_fin_year: c_fin_year, moduleName: "Dealer pay / Report" });
});
router.get('/receiveOpeningBalance', (req, res) => {
    res.render('accountant/receiveOpeningBalance', { csrfToken: req.csrfToken(), userId: req.payload.userDetails.acc_id, distcode: req.payload.userDetails.dist_id, cDate: new Date(), moduleName: "Backlog balance / Receive money" });
});
router.get('/paidOpeningBalance', (req, res) => {
    res.render('accountant/paidOpeningBalance', { csrfToken: req.csrfToken(), userId: req.payload.userDetails.acc_id, distcode: req.payload.userDetails.dist_id, cDate: new Date(), moduleName: "Backlog balance / Pay money" });
});




router.get('/getDMDetails', accountantController.getDMDetails);

router.get('/allLedgers', (req, res) => {
    accountantController.getAllLedgers(req.query.fin_year, req.query.dist_id, result => {
        res.send(result);
    })
});
router.get('/getItemSellingPrices', (req, res) => {
    accountantController.getItemSellingPrices(result => {
        res.send(result);
    });
});
router.get('/getAvailableOrders', accountantController.getAllAvailableOrders);

router.post('/addPaymentOrderReceipt', accountantController.addPaymentOrderReceipt);
router.get('/getAllImplements', accountantController.getAllImplements);
router.post('/getAllMakesByImplment', async(req, res) => {
    let result = await accountantController.getAllMakesByImplment(req.body.implement);
    res.send(result);
});
router.post('/getAllModelsByImplmentAndMake', async(req, res) => {
    let result = await accountantController.getAllModelsByImplmentAndMake(req.body.implement, req.body.make);
    res.send(result);
});
router.post('/getSaleInvoiceValueOfItem', async(req, res) => {
    let response = await accountantController.getSaleInvoiceValueOfItem(req.body.implement, req.body.make, req.body.model)
    res.send(response);
});
router.post('/getDistList', async(req, res) => {
    let result = await accountantController.getDistList();
    res.send(result);
});
router.post('/getBlockList', async(req, res) => {
    let result = await accountantController.getBlockList(req.body.dist_code);
    res.send(result);
});
router.post('/getGpList', async(req, res) => {
    let result = await accountantController.getGpList(req.body.dist_code, req.body.block_code);
    res.send(result);
});
router.get('/getPendingPaymentOrders', accountantController.getPendingPaymentOrders);
router.post('/updateFarmerPendingPayment', accountantController.updateFarmerPendingPayment);
router.get('/getAllOrdersForGI', (req, res) => {
    accountantController.getAllOrdersForGI(req.payload.DistrictID, req.query.finYear, async(response) => {
        for (let i = 0; i < response.length; i++) {
            let dealerDetail = await accountantController.getDlDetailOfEachOrder(response[i].dist_id);
            response[i].dealers = dealerDetail;
        }
        res.send(response);
    });
});
router.get('/getDelearDetails', accountantController.getDealerDetails);
router.get('/getAccName', accountantController.getAccName);
router.get('/getDistName', accountantController.getDistName);
router.post('/addIndent', accountantController.addIndent);
router.post('/cancelIndent', async(req, res) => {
    try {
        let result = await accountantController.cancelIndent(req.body.indent_no, req.body.indent_items);
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Cancel Indent.", "success", 'Successfully indent cancelled.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Cancel Indent.", "failure", 'Server error.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.get('/getAllInvoiceList', accountantController.getAllInvoiceList);
router.get('/getOrdersForReceive', accountantController.getOrdersForReceive);
router.post('/addMRR', accountantController.addMRR);
router.get('/getAllReceivedItems', (req, res) => {
    accountantController.getAllReceivedItems(req.query.distcode, req.query.finYear, response => {
        res.send(response);
    });
});
router.get('/getFinalListDeliverToCustomer', (req, res) => {
    accountantController.getFinalListDeliverToCustomer(req.query.distcode, req.query.finYear, (result) => {
        res.send(result);
    });
});
router.get('/getAllOrders', (req, res) => {
    accountantController.getAllOrders(req.query.distcode, req.query.finYear, response => {
        res.send(response);
    });
});
router.get('/getAllCreditLedgers', (req, res) => {
    accountantController.getAllCreditLedgers(req.query.fin_year, req.query.dist_id, result => {
        res.send(result);
    });
});
router.get('/getAllDebitLedgers', (req, res) => {
    accountantController.getAllDebitLedgers(req.query.fin_year, req.query.dist_id, result => {
        res.send(result);
    });
});
router.get('/getDistWiseAllDealerLedger', (req, res) => {
    accountantController.getDistWiseAllDealerLedger(req.query.fin_year, req.query.dist_id, result => {
        res.send(result);
    });
});
router.get('/getAllDelearLedgers', (req, res) => {
    accountantController.getAllDelearLedgers(req.query.fin_year, req.query.dist_id, req.query.dl_id, result => {
        res.send(result);
    });
});
router.get('/itemPrices', async(req, res) => {
    let allItems = JSON.parse(req.query.items);
    let newArray = [];
    allItems.forEach((element) => {
        accountantController.getIteimPrice(element.implement, element.make, element.model, (response) => {
            newArray.push(response);
        });
    });
    res.send(newArray);
});
router.get('/getAlldelears', accountantController.getAllDelears);
router.get('/getAllPermitNos', accountantController.getAllPermitNos);
router.get('/getAllClusterIdsForExpenditure', accountantController.getAllClusterIdsForExpenditure);
router.get('/getAllSchema', async(req, res) => {
    try {
        let result = await accountantController.getAllSchema()
        res.send(result);
    } catch (e) { next(createError.InternalServerError()); }
});
router.get('/getAllHeads', (req, res) => {
    try {
        accountantController.getAllHeads(result => {
            res.send(result);
        })
    } catch (error) { console.error(error) }
});
router.get('/getAllSubheads', (req, res) => {
    try {
        accountantController.getAllSubheads(req.query.headId, result => {
            res.send(result);
        })
    } catch (error) { console.error(error) }
});
router.post('/addExpenditurePayment', async(req, res) => {
    try {
        let result = await accountantController.addExpenditurePayment(req.body);
        res.send(result);
        logController.addAuditLog(req.payload.user_id, "Miscellaneous expenses.", "success", 'Successfully added miscelleneous expenses.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Miscellaneous expenses.", "failure", 'Failed to add miscelleneous expenses.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.get('/getCashBookData', (req, res) => {
    try {
        accountantController.getCashBookData(req.query.permit_no, result => {
            res.send(result);
        })
    } catch (error) { console.error(error) }
});
router.get('/getInvoiceDetails', (req, res) => {
    accountantController.getInvoiceDetails(result => {
        res.send(result);
    });
});
router.get('/getAllGeneratedIndents', accountantController.getAllGeneratedIndents);

router.get('/getAllCancelledIndentList', (req, res) => {
    accountantController.getAllCancelledIndentList(req.query.dist_id, req.query.fin_year, (response) => {
        res.send(response);
    });
});
// Generated indents END
router.get('/getAllDistWiseDelear', accountantController.getAllDistWiseDelear)
    // Pay To Delear Start
router.get('/getFinYearWiseInvoiceList', accountantController.getFinYearWiseInvoiceList);
router.get('/getInvoiceItemsForPay', accountantController.getInvoiceItemsForPay);
router.get('/getApprovalDetail', accountantController.getApprovalDetail);

router.get('/getInvoiceDetailsByInvoiceNo', (req, res) => {
    accountantController.getInvoiceDetailsByInvoiceNo(req.query.invoice_no, (response) => {
        res.send(response)
    });
});
router.post('/addPaymentApproval', async(req, res) => {
    try {
        let approval_id = await accountantController.addPaymentApproval(req.body);
        res.send({approval_id: approval_id});
        logController.addAuditLog(req.payload.user_id, "Approval for dealer pay forwarded to DM.", "success", 'Successfully approval forwarded to DM.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Approval for dealer pay forwarded to DM.", "failure", 'Failed to forward approval.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.get('/getFinYearWisePendingApprovalList', (req, res) => {
    accountantController.getFinYearWisePendingApprovalList(req.query.fin_year, req.query.dist_id, result => {
        res.send(result);
    });
});
router.get('/getApprovalItemsForPay', (req, res) => {
    accountantController.getApprovalItemsForPay(req.query.approval_id, (response) => {
        res.send(response);
    });
});
router.post('/updatePartPaymentApproval', async(req, res) => {
    try {
        let apr = req.body;
        if (apr.pay_now <= apr.pending_amount) {
            let result = await accountantController.updatePartPaymentApproval(apr);
            res.send(result);
            logController.addAuditLog(req.payload.user_id, "Dealer part payment.", "success", 'Dealer part payment successfully done.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        }
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Dealer part payment.", "failure", 'Failed to part payment to dealer.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
// Pay To Delear End
router.get('/getFinYearWiseApprovalList', async(req, res) => {
    try {
        let result = await accountantController.getFinYearWiseApprovalList(req.query.fin_year, req.query.dist_id);
        res.send(result);
    } catch (e) {
        next(createError.InternalServerError());
        throw e;
    }
});
router.get('/getAllDistMRRIds', accountantController.getAllDistMRRIds);
router.get('/getMRRDetails', accountantController.getMRRDetails);
router.get('/getFarmerReceiptsByFinYear', accountantController.getFarmerReceiptsByFinYear);
router.get('/getReceiptDetails', async (req, res) => {
    try {
        let result = await accountantController.getReceiptDetails(req.query);
        res.send(result);
    } catch (e) {
        next(createError.InternalServerError());
    }
});
// Receipt Ledger
router.get('/getReceiptDetailsByPermitNo', (req, res) => {
    accountantController.getReceiptDetailsByPermitNo(req.query.permit_no, result => {
        res.send(result);
    });
});
router.get('/getAllCreditLedgersForReceipt', async(req, res) => {
    let farmerPayments = await accountantController.getFarmerPaymentsForReceipt(req.query.fin_year, req.query.dist_id);
    let departmentPayments = await accountantController.getDepartmentPaymentsForReceipt(req.query.fin_year, req.query.dist_id);
    let jalanidhiPayments = await accountantController.getJalanidhiFarmerPaymentsForReceipt(req.query.fin_year, req.query.dist_id);
    let jalanidhiDeptPayments = await accountantController.getDepartmentPaymentsForReceiptJN(req.query.fin_year, req.query.dist_id);
    farmerPayments.forEach(element => {
        departmentPayments.push(element);
    })
    jalanidhiPayments.forEach(element => {
        departmentPayments.push(element);
    })
    jalanidhiDeptPayments.forEach(element => {
        departmentPayments.push(element);
    });

    res.send(departmentPayments);
});
// Payments Ledger
router.get('/getAllDebitLedgersForPayments', async(req, res) => {
    let expenditurePayments = await accountantController.expenditurePayments(req.query.fin_year, req.query.dist_id);
    let jnExpenditurePayments = await accountantController.jnExpenditurePayments(req.query.fin_year, req.query.dist_id);
    let delearPayments = await accountantController.delearPayments(req.query.fin_year, req.query.dist_id);
    let delearPaymentsJN = await accountantController.getAllDelearPaymentsJN(req.query.fin_year, req.query.dist_id);
    let openingBalance = await accountantController.getAllPaidOpeningBalance(req.query.fin_year, req.query.dist_id);
    jnExpenditurePayments.forEach(element => {
        delearPayments.push(element);
    });
    expenditurePayments.forEach(element => {
        delearPayments.push(element);
    });
    delearPaymentsJN.forEach(element => {
        delearPayments.push(element);
    });
    openingBalance.forEach(element => {
        delearPayments.push(element);
    });
    res.send(delearPayments);
});
router.get('/getItemsForDeliverToCustomer', accountantController.getItemsForDeliverToCustomer);
router.get('/getAllDeliveredToCustomerOrders', (req, res) => {
    accountantController.getAllDeliveredToCustomerOrders(req.query.dist_id, req.query.fin_year, result => {
        res.send(result);
    });
});
router.get('/getAllStocks', accountantController.getAllStocks);
router.get('/getFarmerPayments', (req, res) => {
    accountantController.getFarmerPayments(req.query.cluster_id, result => {
        res.send(result);
    });
});
router.get('/getJalanidhiGovtShare', (req, res) => {
    accountantController.getJalanidhiGovtShare(req.query.fin_year, result => {
        res.send(result);
    });
});
router.get('/getAllClusterIds', accountantController.getAllClusterIds);
router.get('/getAllExpenditueAmmountsForJobBook', accountantController.getAllExpenditueAmmountsForJobBook);
router.get('/getAllMiscellaneousAmmountsForJobBook', accountantController.getAllMiscellaneousAmmountsForJobBook);
router.get('/getAvailableBalanceDetail', accountantController.getAvailableBalanceDetail);
// Project Wise Ledger
router.get('/getClusterWiseCBData', (req, res) => {
    accountantController.getClusterWiseCBData(req.query.cluster_id, result => {
        res.send(result);
    });
});
// router.get('/getAllProjectNos', (req, res) => {
//     accountantController.getAllProjectNos(req.query.fin_year, req.query.dist_id, result => {
//         res.send(result);
//     });
// });
// router.get('/getPermitDetail', accountantController.getPermitDetail)
router.post('/addReceivedOpeningBalance', async(req, res) => { // Receive Opening Balace
    try {
        let response = await accountantController.addReceivedOpeningBalance(req.body);
        res.send(response);
        logController.addAuditLog(req.payload.user_id, "Receive backlog Balance.", "success", 'Backlog balance received successfully.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Receive backlog Balance.", "failure", 'Failed to receive backlog balance.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});
router.get('/getOpeningBalanceOrderNos', (req, res) => { // Paid Opening Balace
    accountantController.getOpeningBalanceOrderNos(req.query.system, response => {
        res.send(response);
    });
});
router.post('/addPaidOpeningBalance', async(req, res) => {
    try {
        let response = await accountantController.addPaidOpeningBalance(req.body);
        res.send(response);
        logController.addAuditLog(req.payload.user_id, "Add paid backlog Balance.", "success", 'Paid backlog money added successfully.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        logController.addAuditLog(req.payload.user_id, "Add paid backlog Balance.", "failure", 'Failed to add paid backlog balance.', req.originalUrl.split("?").shift(), '/accountant', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
});




router.get('/getDivisionList', accountantController.getDivisionList);
router.get('/getImplementList', accountantController.getImplementList);
router.post('/getMakeList', accountantController.getMakeList);
router.post('/getModelList', accountantController.getModelList);
router.post('/getModelDetails', accountantController.getModelDetails);
router.post('/getPackageUnits', accountantController.getPackageUnits);
router.post('/addNonSubsidyPurchaseOrder', accountantController.addNonSubsidyPurchaseOrder);
router.get('/getDistrictWiseVendorList', accountantController.getDistrictWiseVendorList);
router.get('/getDistrictWiseCustomerList', accountantController.getDistrictWiseCustomerList);


router.get('/getStockDivisionList', accountantController.getStockDivisionList);
router.get('/getStockImplementList', accountantController.getStockImplementList);
router.post('/getStockMakeList', accountantController.getStockMakeList);
router.post('/getStockModelList', accountantController.getStockModelList);
router.post('/getStockModelDetails', accountantController.getStockModelDetails);
router.post('/getStockUnitOfMeasurementList', accountantController.getStockUnitOfMeasurementList);
router.post('/getStockPackageUnits', accountantController.getStockPackageUnits);
router.post('/addCustomerInvoice', accountantController.addCustomerInvoice);
router.post('/addCustomerDetails', accountantController.addCustomerDetails);
router.get('/getCustomerDetailsForInvoice', accountantController.getCustomerDetailsForInvoice);
router.post('/addPaymentReceipt', accountantController.addPaymentReceipt);
router.get('/getCustomerLedgerByCustomerID', accountantController.getCustomerLedgerByCustomerID);
router.get('/getInvoiceListByCusID', accountantController.getInvoiceListByCusID);
router.get('/getCusInvoiceDetailsByInvoiceID', accountantController.getCusInvoiceDetailsByInvoiceID);
router.get('/getCustomerInvoiceDetails', accountantController.getCustomerInvoiceDetails);
