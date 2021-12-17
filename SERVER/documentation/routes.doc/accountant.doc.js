// exports.getAvailableOrders = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getDMDetails:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get all DM details when an accountant wants to generate Material Receipt Report(MRR) against invoice.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getDMDetails = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get global ledger details.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.allLedgers = (req, res, next) => next();


/**
 * @swagger
 * /accountant/getItemSellingPrices:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getItemSellingPrices = (req, res, next) => next();

/**
 * @swagger
 * /accountant/addPaymentOrderReceipt:
 *  post:
 *    tags: ['Accountant Module']
 *    description: Add payment order receipt.
 *    parameters:
 *      -   in: body
 *          name: paymentDetails
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: orderDetails
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: receiptDetails
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.addPaymentOrderReceipt = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getAllImplements:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Load all implements while entering item details in generating money receipt other than permit.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllImplements = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getAllMakesByImplment:
 *  post:
 *    tags: ['Accountant Module']
 *    description: Load all makes by implement type while entering item details in generating money receipt other than permit.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllMakesByImplment = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getAllModelsByImplmentAndMake:
 *  post:
 *    tags: ['Accountant Module']
 *    description: Load all models by implement type and make type while entering item details in generating money receipt other than permit.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllModelsByImplmentAndMake = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getSaleInvoiceValueOfItem:
 *  post:
 *    tags: ['Accountant Module']
 *    description: Load the sale invoice value of an item after accountant selects the model type by implment and make.
 *    parameters:
 *      -   in: body
 *          name: make
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: model 
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: implement
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getSaleInvoiceValueOfItem = (req, res, next) => next();

/**
 * @swagger
 * /accountant/addDirectSaleToFarmerDetail:
 *  post:
 *    tags: ['Accountant Module']
 *    description: Add direct sale to farmers details.
 *    parameters:
 *      -   in: body
 *          name: paymentDetails
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: orderDetails
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: receiptDetails
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.addDirectSaleToFarmerDetail = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getDistList:
 *  post:
 *    tags: ['Accountant Module']
 *    description: Load all districts when accountants logs in to his/her accountant.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getDistList = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getBlockList:
 *  post:
 *    tags: ['Accountant Module']
 *    description: Load all blocks when accountants logs in to his/her accountant.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getBlockList = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getGpList:
 *  post:
 *    tags: ['Accountant Module']
 *    description: Load all GPs when accountants logs in to his/her accountant.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getGpList = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getPendingPaymentOrders:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get all pending payment order list while generating money receipt.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getPendingPaymentOrders = (req, res, next) => next();

/**
 * @swagger
 * /accountant/updateFarmerPendingPayment:
 *  post:
 *    tags: ['Accountant Module']
 *    description: Update the partly payment money receipt that is received by accountant.
 *    parameters:
 *      -   in: body
 *          name: paymentDetails
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: orderDetails
 *          schema:
 *              type: string
 *          required: true
 *      -   in: body
 *          name: receiptDetails
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.updateFarmerPendingPayment = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getAllOrdersForGI:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get all orders for GI.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllOrdersForGI = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getDelearDetails: 
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get the dealer details while initiating Purchase Order(P.O).
 *    parameters:
 *      -   in: query
 *          name: VendorID
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getDelearDetails = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getAccName:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get all accountant's name.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAccName = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getDistName:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get districts name.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getDistName = (req, res, next) => next();

/**
 * @swagger
 * /accountant/addIndent:
 *  post:
 *    tags: ['Accountant Module']
 *    description: Add the subsidy indent after Purchase Order(P.O) is initiated by the accountant.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.addIndent = (req, res, next) => next();

/**
 * @swagger
 * /accountant/cancelIndent:
 *  post:
 *    tags: ['Accountant Module']
 *    description: Cancel the Purchase Order(P.O.) if the accountant wants to cancel it after it is initiated.
 *    parameters:
 *      -   in: body
 *          name: indent_no
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.cancelIndent = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getAllInvoiceList:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get all invoice list to accountant.
 *    parameters:
 *      -   in: query
 *          name: fin_year
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllInvoiceList = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getOrdersForReceive:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get all orders list for generating MRR(Material Receipt Report) after invoice is generated .
 *    parameters:
 *      -   in: query
 *          name: invoiceNo
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getOrdersForReceive = (req, res, next) => next();

/**
 * @swagger
 * /accountant/addMRR:
 *  post:
 *    tags: ['Accountant Module']
 *    description: add MRR(Material Receipt Report) after receiving by accountant.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.addMRR = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getAllReceivedItems:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get all received items.
 *    parameters:
 *      -   in: query
 *          name: distcode
 *          schema:
 *              type: string
 *          required: true
 *      -   in: query
 *          name: finYear
 *          schema:
 *              type: string
 *          required: true
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllReceivedItems = (req, res, next) => next();

/**
 * @swagger
 * /accountant/getFinalListDeliverToCustomer:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getFinalListDeliverToCustomer = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllOrders = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllCreditLedgers = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllDebitLedgers = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getDistWiseAllDealerLedger = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllDelearLedgers = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.itemPrices = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAlldelears= (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllPermitNos= (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllClusterIdsForExpenditure= (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllSchema= (req, res, next) => next();  

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllHeads= (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllSubheads= (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.addExpenditurePayment= (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getCashBookData = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getInvoiceDetails = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllGeneratedIndents = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllCancelledIndentList = (req, res, next) => next();

// Generated indents END

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllDistWiseDelear = (req, res, next) => next();

    // Pay To Delear Start

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getFinYearWiseInvoiceList = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getInvoiceItemsForPay = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getApprovalDetail = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getInvoiceDetailsByInvoiceNo = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.addPaymentApproval = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getFinYearWisePendingApprovalList = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getApprovalItemsForPay = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.updatePartPaymentApproval = (req, res, next) => next();

// Pay To Delear End

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getFinYearWiseApprovalList = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllDistMRRIds = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getMRRDetails = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getFarmerReceiptsByFinYear = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getReceiptDetails = (req, res, next) => next();

// Receipt Ledger

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getReceiptDetailsByPermitNo = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllCreditLedgersForReceipt = (req, res, next) => next();

// Payments Ledger

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllDebitLedgersForPayments = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getItemsForDeliverToCustomer = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.updateDeliverToCustomerStatus = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllDeliveredToCustomerOrders = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllStocks = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getFarmerPayments = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getJalanidhiGovtShare = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllClusterIds = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllExpenditueAmmountsForJobBook = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAllMiscellaneousAmmountsForJobBook = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getAvailableBalanceDetail = (req, res, next) => next();

// Project Wise Ledger

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getClusterWiseCBData = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.addReceivedOpeningBalance = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getOpeningBalanceOrderNos = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.addPaidOpeningBalance = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getDivisionList = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getImplementList = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getMakeList = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getModelList = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getModelDetails = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getPackageUnits = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.addNonSubsidyPurchaseOrder = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getCustomerDetails = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getDistrictWiseVendorList = (req, res, next) => next();

/**
 * @swagger
 * /accountant/allLedgers:
 *  get:
 *    tags: ['Accountant Module']
 *    description: Get item selling price.
 *    responses:
 *      '200':
 *        description: A successful response.
 *      '403':
 *        description: Unauthorized user.
 *      '400':
 *        description: Parameter validation error.
 *      '500':
 *        description: Unexpected error.
 */
exports.getDistrictWiseCustomerList = (req, res, next) => next();

