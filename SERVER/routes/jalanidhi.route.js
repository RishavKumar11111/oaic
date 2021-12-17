var express = require('express');
var router = express.Router();
var jalanidhiController = require('../controller/jalanidhi.controller');
const logController = require('../controller/log.controller');
const requestIP = require('request-ip');
const UAParser = require('ua-parser-js');
const parser = new UAParser();
module.exports = router;


/**
 * @swagger
 * /jalanidhi/addCluster:
 *  post:
 *    tags: ['Jalanidhi Module']
 *    description: addCluster 
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.post('/addCluster', (req, res) => {
    let data = req.body;
    if( ((data.dist_id && data.cluster_id && data.dist_name) != "") && data.farmers.length >= 3) {
        jalanidhiController.addCluster(req.body, result => {
            res.send(result);
        })
    } else {
        res.send("Blank Value Detected. Plese Fill All The Required Detail");
    }
})

// router.post('/sendPaymentDetail', (req, res) => {
//     switch (req.body.purpose) {
//         case "farmerAdvancePaymentJN": {
//             let data = req.body;
//             if ((data.cluster_id && data.farmer_id && data.payment_date && data.dist_id && data.ammount
//                 && data.payment_type && data.payment_no && data.remark) != "") {
//                 jalanidhiController.addFarmerPaymentFromJalanidhi(req.body, (result) => {
//                     res.send(result);
//                 });
//             } else {
//                 res.send('Blank Value Detected. Plese Fill All The Required Detail');
//             }
//             break;
//         }
//         case "billFromDealerJN": {
//             let data = req.body;
//             if ((data.dist_id && data.ammount && data.dl_id && data.remark
//                 && data.po_no) != "" && data.cluster_ids.length != 0) {
//                 jalanidhiController.addBillFromDealerJN(req.body, req.body.cluster_ids, (result) => {
//                     res.send(result);
//                 });
//             } else {
//                 res.send('Blank Value Detected. Plese Fill All The Required Detail');
//             }
//             break;
//         }
//         case "payToDealerJN": {
//             let data = req.body;
//             if ((data.dist_id && data.ammount && data.dl_id && data.po_no && data.remark)
//                 != "" && data.cluster_ids.length != 0) {
//                 jalanidhiController.addPayToDelearJN(req.body, req.body.cluster_ids, (result) => {
//                     res.send(result);
//                 });
//             } else {
//                 res.send('Blank Value Detected. Plese Fill All The Required Detail');
//             }
//             break;
//         }
//         case "expenditureOnHead": {
//             let data = req.body;
//             if ((data.dist_id && data.dl_id && data.head && data.po_no && data.cluster_id && data.ammount && data.remark) != "" && data.items.length != 0) {
//                 jalanidhiController.addExpenditureOnHead(req.body, result => {
//                     res.send(result);
//                 });
//             } else {
//                 res.send('Blank Value Detected. Plese Fill All The Required Detail');
//             }
//             break;
//         }
//         default: {
//             res.send('Sorry Your Payment Purpose is MisMatch');
//         }
//     }
// });

/**
 * @swagger
 * /jalanidhi/addReceivedOrder:
 *  post:
 *    tags: ['Jalanidhi Module']
 *    description: addCluster 
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.post('/addReceivedOrder', (req, res) => {
    let data = req.body;
    if ((data.dist_id && data.dl_id && data.dl_name && data.po_no && data.cluster_id && data.farmer_id && data.farmer_name && data.implement && data.make && data.model ) != "") {
        jalanidhiController.addReceivedOrder(req.body, result => {
            res.send(result);
        });
    } else {
        res.send('Blank Value Detected. Plese Fill All The Required Detail');
    }
});

/**
 * @swagger
 * /jalanidhi/orderDeliveredToCustomer:
 *  post:
 *    tags: ['Jalanidhi Module']
 *    description: addCluster 
 *    responses:
 *      '200':
 *        description: A successful response
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
router.post('/orderDeliveredToCustomer', (req, res) => {
    let data = req.body;
    if ((data.po_no && data.cluster_id && data.farmer_id && data.implement && data.make && data.model) != "") {
        jalanidhiController.orderDeliveredToCustomer(req.body, result => {
            res.send(result);
        });
    } else {
        res.send('Blank Value Detected. Plese Fill All The Required Detail');
    }
});