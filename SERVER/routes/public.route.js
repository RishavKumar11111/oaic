const express = require('express');
const router = express.Router();
const sha256 = require('sha256');
const crypto = require('crypto');
const format = require('biguint-format');

const accController = require('../controller/accountant.controller');
const dmController = require('../controller/dm.controller');
const vendorController = require('../controller/vendor.controller');
const publicController = require('../controller/public.controller');
const logController = require('../controller/log.controller');

const requestIP = require('request-ip');
const UAParser = require('ua-parser-js');
const parser = new UAParser();
const createError = require('http-errors');

const validation = require('../validation/public/public.validation');
const { signAccessToken, verifyAccessToken } = require('../helpers/jwt.helper');

function randomC(qty) {
    var x = crypto.randomBytes(qty);
    return format(x, 'dec');
}

function random(low, high) {
    return randomC(4) / Math.pow(2, 4 * 8 - 1) * (high - low) + low;
}
router.get('/', (req, res) => {
    res.redirect('/login');
});
router.get('/login', (req, res) => {
    res.render('login', { err: req.query.status, csrfToken: "req.csrfToken()" });
});
router.get('/changePassword', verifyAccessToken, (req, res) => {
    if(req.payload.role) {
        res.render('changePassword', { csrfToken: "req.csrfToken()", userId: req.payload.user_id, moduleName: `${req.payload.role} / Change Password` });
    } else {
        res.redirect('/login');
    }
})
router.get('/logout', verifyAccessToken, (req, res) => {
    logController.addAuditLog(req.payload.user_id, "logout", "success", 'Sign out.', req.url, req.route.path, requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    res.cookie('accessToken', null).redirect('/login');
});
router.post('/login', async (req, res) => {
        try {
            const result = await publicController.getUserDetails(req.body.username);
            if (!result) {
                res.redirect('/login?status=Wrong Credetinal');
                logController.addAuditLog(req.body.username, "login", "failure", 'User id not found.', req.url, req.route.path, requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
            } else {
                if (req.body.pass == sha256(result.password)) {
                    const userDetails = {
                        userId: result.user_id,
                        user_id: result.user_id
                    }
                    switch (result.role) {
    
                        case 'accountant':
                            {
                                accController.getUserDetailsByUserId(result.user_id, async user => {
                                    userDetails.AccID = user[0].acc_id;
                                    userDetails.DistrictID = user[0].dist_id;
                                    userDetails.UserName = user[0].dist_name;
                                    userDetails.DMID = user[0].dm_id;
                                    userDetails.role = 'ACCOUNTANT';
                                    const accessToken = await signAccessToken(userDetails);
                                    res.cookie('accessToken', accessToken).redirect('/user-login');
                            });
                                break;
                            }
                        case 'Vendor':
                            {
                                vendorController.getUserDetailsByUserCode(result.user_id, async user => {
                                    userDetails.role = 'DEALER';
                                    userDetails.VendorID = user[0].VendorID;
                                    const accessToken = await signAccessToken(userDetails);
                                    res.cookie('accessToken', accessToken).redirect('/user-login');
                                });
                                break;
                            }
                        case 'dm':
                            {
                                dmController.getUserDetailsByUserId(result.user_id, async user => {
                                    userDetails.DMID = user.dm_id;
                                    userDetails.DistrictID = user.dist_id;
                                    userDetails.role = 'DM';
                                    const accessToken = await signAccessToken(userDetails);
                                    res.cookie('accessToken', accessToken).redirect('/user-login');
                                });
                                break;
                            }
                        case 'ADMIN':
                            {
                                userDetails.role = 'ADMIN';
                                const accessToken = await signAccessToken(userDetails);
                                res.cookie('accessToken', accessToken).redirect('/user-login');
                                break;
                            }
                        case 'accHead':
                            {
                                userDetails.role = 'ACC-HEAD';
                                const accessToken = await signAccessToken(userDetails);
                                res.cookie('accessToken', accessToken).redirect('/accHead/dealerGlobalLedger');
                                break;
                            }
                        case 'bank':
                            {
                                userDetails.role = 'BANK';
                                const accessToken = await signAccessToken(userDetails);
                                res.cookie('accessToken', accessToken).redirect('/user-login');
                                break;
                            }
                        default:
                            {
                                res.redirect('/login?status=Wrong Credetinal');
                                break;
                            }
                    }
                    logController.addAuditLog(req.body.username, "login", "success", 'Successfully login.', req.url, req.route.path, requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
                } else {
                    res.redirect('/login?status=Wrong Credetinal');
                    logController.addAuditLog(req.body.username, "login", "failure", 'Password mismatch.', req.url, req.route.path, requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
                }
            }
        } catch(e) {
            next(createError.InternalServerError());
            console.error(e);
        }
    
})
router.post('/changePassword', verifyAccessToken, publicController.changePassword);



router.get('/vendorRegistration', publicController.vendorRegistration);
router.post('/registerVendor', publicController.registerVendor);
router.get('/getStateList', validation.getStateList, publicController.getStateList);
router.get('/getDistrictList', validation.getDistrictList, publicController.getDistrictList);
router.get('/getBankList', validation.getDistrictList, publicController.getBankList);






router.get('/changeItemMasterData', publicController.changeItemMasterData);
router.get('/AddDivisionMasterData', publicController.AddDivisionMasterData);
router.get('/UpdatePOType', publicController.UpdatePOType);
router.get('/mergeIndentAndPO', publicController.mergeIndentAndPO);
router.get('/mergeInvoiceAndInvoiceMaster', publicController.mergeInvoiceAndInvoiceMaster);
router.get('/updateDistrictMasterCode', publicController.updateDistrictMasterCode);
router.get('/addItempackageSizeMasterData', publicController.addItempackageSizeMasterData);
router.post('/mergeFullCost', publicController.mergeFullCost);
router.get('/mergePaymentDetails', publicController.mergePaymentDetails);
router.get('/mergePaymentDetails2', publicController.mergePaymentDetails2);
router.get('/mergeSubsidyFullCost', publicController.mergeSubsidyFullCost);
router.get('/mergeMRNo', publicController.mergeMRNo);
router.get('/addBank', publicController.addBank);
router.get('/removeUserTableData', publicController.removeUserTableData);
router.get('/mergeCustomerInvoiceData', publicController.mergeCustomerInvoiceData);
router.get('/removeMergeCusInvoiceData', publicController.removeMergeCusInvoiceData);





router.get('/signOut', verifyAccessToken, (req, res) => {
    logController.addAuditLog(req.payload.user_id, "logout", "success", 'Sign out.', req.url, req.route.path, requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    res.cookie('accessToken', null).send(true);
});


module.exports = router;