const UserModel = require('../models/User.model');
const logBal = require('./log.controller');
var sha256 = require('sha256');
var requestIP = require('request-ip');
var UAParser = require('ua-parser-js');
var parser = new UAParser();
var multer = require('multer');
var path = require('path');
const createError = require('http-errors');

const { sequelize, db } = require('../config/config');



exports.getUserDetails = (user_id) => {
    return new Promise( async (resolve, reject) => {
        try {
            let response = await UserModel.findOne({ where: { user_id: { [db.Sequelize.Op.iLike]: user_id} }, raw: true });
            resolve(response);
        } catch (e) {
            reject(e);
        }
    })
}
exports.changePassword = async (req, res, next) => {
    try {
        const response = {};
        if (!req.payload.user_id) {
            response.isSuccess = false;
            response.message = 'Wrong user. Try after login.';
            res.send(response);
            logBal.addAuditLog(req.payload.user_id, "Change Password", "failure", 'User id not found.', req.url, req.route.path, requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        } else {
            const result = await UserModel.findOne({ where: { user_id: req.payload.user_id }, raw: true });
            if (req.body.oldPassword == result.password) {
                const newPassword = sha256(req.body.newPassword);
                await UserModel.update({ password: newPassword }, { where: { user_id: req.payload.user_id } });
                response.isSuccess = true;
                response.message = 'Successfully update your passwod';
                res.send(response);
                logBal.addAuditLog(req.payload.user_id, "Change Password", "success", 'Successfully login.', req.url, req.route.path, requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
            } else {
                response.isSuccess = false;
                response.message = 'Old password is wrong. Try again.';
                res.send(response);
                logBal.addAuditLog(req.payload.user_id, "Change Password", "failure", 'Password mismatch.', req.url, req.route.path, requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
            }
        }
    } catch(e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.vendorRegistration = (req, res, next) => {
    res.render('vendorRegistration', { csrfToken: "req.csrfToken()" });
}














let invoiceStorage = multer.diskStorage({
    destination: function(req, file, callback) {
        callback(null, './public/uploads');
    },
    filename: function(req, file, callback) {
        callback(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
    }
});
let fileFilter = (req, file, callback) => {
    if (file.mimetype == 'application/pdf') {
        callback(null, true);
    } else {
        callback(new Error('File Format Should be PDF'));
    }
}
var upload = multer({ storage: invoiceStorage, fileFilter: fileFilter }).fields([
    { name: 'PANDocument', maxCount: 1 },
    { name: 'GSTNDocument', maxCount: 1 },
    { name: 'MSMECertificate', maxCount: 1 },
    { name: 'SSIUnitRegistrationCertificate', maxCount: 1 },
    { name: 'bankAccountDocument', maxCount: 10 }
]);
exports.registerVendor = async (req, res, next) => {
    upload(req, res, async err => {
        try {
                if (err) throw err;

                let body = JSON.parse(req.body.Name1);

                let basicDetails = body.basicDetails;                
                let serviceData =  body.serviceData;
                let contactPersonData =  body.contactPersonData;
                let principalPlaceData =  body.principalPlaceData;
                let bankAccountData =  body.bankAccountData;
                let password =  body.password;
                basicDetails.Password = password.newPassword;


                let allfiles = req.files;
                

                const verifyPAN = await db.VendorMaster.findAll({
                    raw: true,
                    where: {
                        PAN: basicDetails.PAN
                    }
                })
                const verifyEmailID = await db.VendorMaster.findAll({
                    raw: true,
                    where: {
                        EmailID: basicDetails.EmailID
                    }
                })

                if(verifyPAN.length == 0) {
                    if(verifyEmailID.length == 0) {
                        basicDetails.PANDocument = allfiles.PANDocument[0].path.replace('public', '');
                        basicDetails.GSTNDocument = allfiles.GSTNDocument[0].path.replace('public', '');
                        if(basicDetails.WhetherMSME == 'Yes') {
                            basicDetails.MSMECertificate = allfiles.MSMECertificate[0].path.replace('public', '');
                        }
                        if(basicDetails.WhetherSSIUnit == 'Yes') {
                            basicDetails.SSIUnitRegistrationCertificate = allfiles.SSIUnitRegistrationCertificate[0].path.replace('public', '');
                        }
                        let max = await sequelize.query(`select max(cast(substr("VendorID", 12, length("VendorID")) as int )) from public."VendorMaster"`);
                        const VendorID = max[0][0].max == null ? `VR/2021-22/1` : `VR/2021-22/${(parseInt(max[0][0].max) + 1)}`;
                        basicDetails.VendorID = VendorID;
                        basicDetails.InsertedBy = VendorID;
        
                        await db.VendorMaster.create(basicDetails);
            
                        // STEP 1 END
                        // STEP 2 START
                        const serviceDetails = serviceData.serviceDetails;
                        await db.VendorMaster.update(serviceDetails, {
                            where: {
                                VendorID: VendorID
                            }
                        });
                        const districtList = serviceData.districtList.filter(e => {
                            e.VendorID = VendorID;
                            e.DistrictID = e.dist_id;
                            return e;
                        });
                        const serviceList = serviceData.servicesList.map(e => {
                            let value = {
                                Service: e,
                                VendorID: VendorID,
                                InsertedBy: VendorID
                            }
                            return value;
                        });
                        await db.VendorDistrictMapping.destroy({ where: { VendorID: VendorID } });
                        await db.VendorDistrictMapping.bulkCreate(districtList);
        
                        await db.VendorServices.destroy({ where: { VendorID: VendorID } });
                        await db.VendorServices.bulkCreate(serviceList);
    
                                // STEP 2 END
                                // STEP 3 START
    
    
                                const contactPeronList = contactPersonData.map(e => {
                                    e.VendorID = VendorID;
                                    e.InsertedBy = VendorID;
                                    return e;
                                })
                                await db.VendorContactPerson.destroy({ where: { VendorID: VendorID } });
                                await db.VendorContactPerson.bulkCreate(contactPeronList);
                                
                                // STEP 3 END
                                // STEP 4 START
    
                                const principalPlaceList = principalPlaceData.map(e => {
                                    e.VendorID = VendorID;
                                    e.InsertedBy = VendorID;
                                    return e;
                                })
                                await db.VendorPrincipalPlace.destroy({ where: { VendorID: VendorID } });
                                await db.VendorPrincipalPlace.bulkCreate(principalPlaceList);
                                
                                // STEP 4 END
                                // STEP 5 START
    
                                bankAccountData.forEach((e, index) => {
                                        e.BankDocument = allfiles.bankAccountDocument[index].path.replace('public', '');
                                        e.VendorID = VendorID;
                                        e.InsertedBy = VendorID;
                                    })
                                    
                                    await db.VendorBankAccount.destroy({ where: { VendorID: VendorID } });
                                    await db.VendorBankAccount.bulkCreate(bankAccountData);
    
                                    // STEP 5 END
                                    
    
                                const response = {message: 'Registered successfully', isSuccess: true, userID: VendorID };
                                res.send(response);
                    } else {
                        res.send({message: 'EmailID Already registered', isSuccess: false });
                    }
                } else {
                    res.send({message: 'Permanent Account Number  (PAN) Already registered', isSuccess: false });
                }

            } catch (e) {
                res.status(500).send({message: 'Try letter', isSuccess: false });
                console.error(e);
            }
    });
}


exports.getStateList = async (req, res, next) => {
    try {
        const response = await db.StateMaster.findAll();
        res.send(response)
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getDistrictList = async (req, res, next) => {
    try {
        const response = await db.DistrictMaster.findAll();
        res.send(response)
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.getBankList = async (req, res, next) => {
    try {
        const response = await db.BankMasterModel.findAll({
            raw: true,
            order: [['BankName', 'ASC']]
        });
        res.send(response)
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}


















































exports.changeItemMasterData = async (req, res, next) => {
    const itemList = await db.ItemMasterModel.findAll({raw: true});
    itemList.forEach(e => {
        const updateData = {
            Implement: e.implement,
            Make: e.make,
            Model:e.model,
            PurchaseInvoiceValue: e.p_invoice_value,
            PurchaseTaxableValue: e.p_taxable_value,
            PurchaseCGST: e.p_cgst_6,
            PurchaseSGST: e.p_sgst_6,
            PurchaseIGST: e.p_igst_12,
            PurchaseSGSTOnePercent: e.p_sgst_1,
            PurchaseCGSTOnePercent: e.p_cgst_1,
            SellInvoiceValue: e.s_invoice_value,
            SellTaxableValue: e.s_taxable_value,
            SellCGST: e.s_cgst_6,
            SellSGST: e.s_sgst_6,
            SellIGST: e.s_igst_12,
            DivisionID: 'DV2'
        }
        if(e.implement != null) {
            db.ItemMasterModel.update(updateData, { where: { implement: e.implement, make: e.make, model: e.model} });
        }
    })
    res.send('Done')
}


const divisionMasterData  = [
    { DivisionID: "DV1", 	DivisionName: "Energisation"},
    { DivisionID: "DV2", 	DivisionName: "Agro Machinery"},
    { DivisionID: "DV3", 	DivisionName: "Agro Input"},
    { DivisionID: "DV4", 	DivisionName: "Feed"}
];

exports.AddDivisionMasterData = async (req, res, next) => {
    try{
        await db.DivisionMaster.bulkCreate(divisionMasterData);
        res.send('done');
    } catch(e) {
        console.error(e);
        res.send(e);
    }
}
exports.UpdatePOType = async (req, res, next) => {
    const itemList = await db.POMasterModel.findAll({raw: true, where: { POType: null }});
    itemList.forEach(e => {
            db.POMasterModel.update({ POType: "Subsidy" }, { where: { PONo: e.PONo } });
    })
    res.send('Done')
}
exports.mergeIndentAndPO = async (req, res, next) => {

    const response = await db.sequelize.query(`SELECT a.*, b.*, c.* 
    FROM indent a 
    INNER JOIN orders b on b.permit_no = a."PermitNumber" 
    INNER JOIN "ItemMaster" c ON b.make = c.make and b.model = c.model and b.implement = c.implement`);

    response[0].forEach(e => {
        // console.log(e);
        const newObject = {
            FinYear: e.fin_year,
            PONo: e.indent_no,
            OrderReferenceNo: e.PermitNumber,
            // CustomerID:
            // CustomerOrderRefence
            VendorID: e.VendorID,
            DistrictID: e.DistrictID,
            DMID: e.DMID,
            AccID: e.AccID,
            DivisionID: e.DivisionID,
            Implement: e.Implement,
            Make: e.Make,
            Model: e.Model,
            UnitOfMeasurement: e.UnitOfMeasurement,
            HSN: e.HSN,
            TaxRate: e.TaxRate,
            PurchaseInvoiceValue: e.PurchaseInvoiceValue,
            PurchaseTaxableValue: e.PurchaseTaxableValue,
            PurchaseCGST: e.PurchaseCGST,
            PurchaseSGST: e.PurchaseSGST,
            PurchaseIGST: e.PurchaseIGST,
            TotalPurchaseInvoiceValue: e.PurchaseInvoiceValue,
            TotalPurchaseTaxableValue: e.PurchaseTaxableValue,
            TotalPurchaseCGST: e.PurchaseCGST,
            TotalPurchaseSGST: e.PurchaseSGST,
            SellCGST: e.SellCGST,
            SellSGST: e.SellSGST,
            SellIGST: e.SellIGST,
            SellInvoiceValue: e.SellInvoiceValue,
            SellTaxableValue: e.SellTaxableValue,
            TotalSellCGST: e.SellCGST,
            TotalSellSGST: e.SellSGST,
            TotalSellIGST: e.SellIGST,
            TotalSellInvoiceValue: e.SellInvoiceValue,
            TotalSellTaxableValue: e.SellTaxableValue,
            POAmount: e.POAmount,
            NoOfItemsInPO: 1,
            ItemQuantity: 1,
            EngineNumber: e.engine_no,
            ChassicNumber: e.chassic_no,
            IsDelivered: e.IsDelivered,
            IsReceived: e.IsReceived,
            IsDeliveredToCustomer: e.IsDeliveredToCustomer,
            Status: e.status,
            InsertedDate: new Date(e.InsertedDate),
            InsertedBy: e.InsertedBy,
            IsApproved: e.IsApproved,
            ApprovalStatus: e.ApprovalStatus,
            ApprovedDate: new Date(e.ApprovedDate),
            ApprovedBy: e.ApprovedBy,
            POType: 'Subsidy'
        }
        db.POMasterModel.create(newObject)

    
    })
    res.send('Done');
}
exports.mergeInvoiceAndInvoiceMaster = async (req, res, next) => {
    try {

    const response = await db.sequelize.query(`SELECT a.*, b.*, c.engine_no, c.chassic_no
    FROM invoice a 
    INNER JOIN invoice_desc b on b.invoice_no = a."invoice_no"
    INNER JOIN orders c ON c.permit_no = b.permit_no`);

    response[0].forEach(e => {
            const newObject = {
                InvoiceNo: e.invoice_no,
                PONo: e.indent_no,
                OrderReferenceNo: e.permit_no,
                InvoiceDate: new Date(e.bill_date),
                WayBillNo: e.rr_way_bill_no,
                WayBillDate: new Date(e.rr_way_bill_date),
                TruckNo: e.wagon_truck_no,
                FinYear: e.fin_year,
                DistrictID: e.dist_id,
                VendorID: e.dl_id,
                Status: e.status,
                PaymentStatus: e.payment_status,
                InvoiceAmount: e.invoice_ammount,
                InvoicePath: e.invoice_path,
                POType: 'Subsidy',
                NoOfOrderInPO: 1,
                NoOfOrderDeliver: e.status == 'received' ? 1 : 0,
                InsertedDate: new Date(e.invoice_date),
                InsertedBy: e.dl_id,
                // UpdatedDate: e.,
                // UpdatedBy: e.,
                IsReceived: e.status == 'received' ? true : false,
                // ReceivedDate: e.,
                EngineNumber: e.engine_no,
                ChassicNumber: e.chassic_no,
            }
            // console.log(newObject);
            db.InvoiceMaster.create(newObject);
        })
        res.send('done')
    } catch (e) {
        console.error(e);
    }
}
exports.updateDistrictMasterCode = async (req, res, next) => {

    const distList = [
        { dist_id: "01", dist_name: "ANGUL", DistCode: 'ANL' },
        { dist_id: "02", dist_name: "BALASORE", DistCode: 'BLS' },
        { dist_id: "03", dist_name: "BARGARH", DistCode: '' },
        { dist_id: "04", dist_name: "BHADRAK", DistCode: 'BHD' },
        { dist_id: "05", dist_name: "BOLANGIR", DistCode: 'BLG' },
        { dist_id: "06", dist_name: "BOUDH", DistCode: 'BDH' },
        { dist_id: "07", dist_name: "CUTTACK", DistCode: 'CTC' },
        { dist_id: "08", dist_name: "DEOGARH", DistCode: '' },
        { dist_id: "09", dist_name: "DHENKANAL", DistCode: '' },
        { dist_id: "10", dist_name: "GAJAPATI", DistCode: '' },
        { dist_id: "11", dist_name: "GANJAM", DistCode: 'GJM' },
        { dist_id: "12", dist_name: "JAGATSINGHPUR", DistCode: '' },
        { dist_id: "13", dist_name: "JAJPUR", DistCode: 'JPR' },
        { dist_id: "14", dist_name: "JHARSUGUDA", DistCode: 'JGD' },
        { dist_id: "15", dist_name: "KALAHANDI", DistCode: '' },
        { dist_id: "16", dist_name: "KENDRAPARA", DistCode: 'KDR' },
        { dist_id: "17", dist_name: "KEONJHAR", DistCode: '' },
        { dist_id: "18", dist_name: "KHURDA", DistCode: 'KHD' },
        { dist_id: "19", dist_name: "KORAPUT", DistCode: '' },
        { dist_id: "20", dist_name: "MALKANGIRI", DistCode: '' },
        { dist_id: "21", dist_name: "MAYURBHANJ", DistCode: '' },
        { dist_id: "22", dist_name: "NAWARANGPUR", DistCode: '' },
        { dist_id: "23", dist_name: "NAYAGARH", DistCode: '' },
        { dist_id: "24", dist_name: "NUAPADA", DistCode: 'NPD' },
        { dist_id: "25", dist_name: "PHULBANI", DistCode: '' },
        { dist_id: "26", dist_name: "PURI", DistCode: 'PUR' },
        { dist_id: "27", dist_name: "RAYAGADA", DistCode: '' },
        { dist_id: "28", dist_name: "SAMBALPUR", DistCode: 'SLR' },
        { dist_id: "29", dist_name: "SONEPUR", DistCode: 'SNP' },
        { dist_id: "30", dist_name: "SUNDARGARH", DistCode: '' }
    ]

    distList.forEach(e => {
        db.DistrictMaster.update({ DistCode: e.DistCode }, { where: { dist_id: e.dist_id } })
    })
    res.send('DONE');
}
exports.addItempackageSizeMasterData = async (req, res, next) => {

    const packageList = [
        { PackageSize: 1 },
        { PackageSize: 5 },
        { PackageSize: 8 },
        { PackageSize: 10 },
        { PackageSize: 15 },
        { PackageSize: 20 },
        { PackageSize: 30 },
        { PackageSize: 50 },
        { PackageSize: 80 },
        { PackageSize: 100 },
        { PackageSize: 120 },
        { PackageSize: 200 },
        { PackageSize: 250 },
        { PackageSize: 500 },
        { PackageSize: 1000 },
        { PackageSize: 3000 },
        { PackageSize: 5000 },
        { PackageSize: 10000 },
    ]

    await db.ItemPackageSizeMasterModel.bulkCreate(packageList);
    res.send('DONE');
}
exports.mergeFullCost = async (req, res, next) => {
    const apiData = req.body;
    const localData = await db.OrderMasterModel.findAll({ raw: true });
    let count =1;
    apiData.forEach(element => {
        localData.forEach(local => {
            if(element.PERMIT_ORDER ==  local.permit_no) {
                // console.log(element.PERMIT_ORDER, element.FULL_COST, count++);
                console.log({ FullCost: element.FULL_COST, PendingCost: (element.FULL_COST - local.paid_amount), paid: local.paid_amount, status: local.status });
                db.OrderMasterModel.update({ FullCost: element.FULL_COST, PendingCost: (element.FULL_COST - local.paid_amount) }, {
                    where: { permit_no: local.permit_no }
                })
            }
        })
    })
    res.send({msg: "done"})
}
exports.mergePaymentDetails = async (req, res, next) => {
    try {
        const response = await db.sequelize.query(`SELECT receipt_no, permit_no, source_bank, implement FROM farmer_receipt`)
        const FRresult = response[0]
        
        const newResponse = await db.sequelize.query(`SELECT transaction_id, reference_no, "from", "to", purpose FROM payment where purpose = 'farmerAdvancePayment'`)
        const Paymentresult = newResponse[0]
        
        for(let i = 0; i < Paymentresult.length; i++) {
            const index = FRresult.findIndex(e => e.permit_no == Paymentresult[i].reference_no )
            const query = `UPDATE payment set 
            "MoneyReceiptNo" = '${FRresult[index].receipt_no}',
            "source_bank" = '${FRresult[index].source_bank}',
            "Implement" = '${FRresult[index].implement}',
            "DivisionID" = 'DV2'
            where transaction_id = '${Paymentresult[i].transaction_id}'`
            db.sequelize.query(query)
            // console.log(query);
            // break
        }
        res.send({msg: "done"})
    } catch(e) {
        console.error(e)
        next(createError.InternalServerError())
    }
}
exports.mergeSubsidyFullCost = async (req, res, next) => {
    try {        
        const newResponse = await db.sequelize.query(`select a."PONo", a."OrderReferenceNo", a."TaxRate", b."FullCost" 
        from "POMaster" a 
        inner join orders b on b.permit_no = a."OrderReferenceNo"
        where a."POType"='Subsidy'`)
        const Paymentresult = newResponse[0]
        
        for(let i = 0; i < Paymentresult.length; i++) {
            const taxRate = Paymentresult[i].TaxRate || 12
            const totalTaxableValue = (Paymentresult[i].FullCost / ( 100 + +taxRate ) ) * 100
            const totalCGST = (totalTaxableValue / 100) * ( taxRate / 2 )
            const totalSGST = (totalTaxableValue / 100) * ( taxRate / 2 )
            const totalInvoiceValue = Paymentresult[i].FullCost || 0
            
            const query = `UPDATE "POMaster" set 
            "TotalSellTaxableValue" = '${ totalTaxableValue }',
            "TotalSellCGST" = '${ totalCGST }',
            "TotalSellSGST" = '${ totalSGST }',
            "TotalSellIGST" = '0',
            "TotalSellInvoiceValue" = '${totalInvoiceValue}'
            where "PONo" = '${Paymentresult[i].PONo}' AND "OrderReferenceNo" = '${Paymentresult[i].OrderReferenceNo}'`
            db.sequelize.query(query)
            // console.log(query);
            // break
        }
        console.log(`update done`);
        res.send({msg: "done"})
    } catch(e) {
        console.error(e)
        next(createError.InternalServerError())
    }
}
exports.mergePaymentDetails2 = async (req, res, next) => {
    try {        
        const newResponse = await db.sequelize.query(`SELECT transaction_id, reference_no, "from", "to", purpose FROM payment`)
        const Paymentresult = newResponse[0]
        
        for(let i = 0; i < Paymentresult.length; i++) {
            let PayFrom = ''
            let PayTo = ''
            let PayFromID = ''
            let PayToID = ''
            switch(Paymentresult[i].purpose) {
                case 'farmerAdvancePayment': {
                    PayFrom = `FARMER`
                    PayTo = `OAIC`
                    PayFromID = Paymentresult[i].from.split("farmer-")[1]
                    PayToID = Paymentresult[i].to.split("DS-")[1]
                    break
                }
                case 'advance_dealer_bill': {
                    PayFrom = `VENDOR`
                    PayTo = `OAIC`
                    PayFromID = Paymentresult[i].from.split("DL-")[1]
                    PayToID = Paymentresult[i].to.split("DS-")[1]
                    break
                }
                case 'pay_against_bill': {
                    PayFrom = `OAIC`
                    PayTo = `VENDOR`
                    PayFromID = Paymentresult[i].from.split("DS-")[1]
                    PayToID = Paymentresult[i].to.split("DL-")[1]
                    break
                }
                case 'received_from_dept': {
                    PayFrom = `DEPARTMENT`
                    PayTo = `OAIC`
                    PayFromID = Paymentresult[i].from.split("dept-")[1]
                    PayToID = Paymentresult[i].to == 'ADMIN' ? Paymentresult[i].to : Paymentresult[i].to.split("DS-")[1]
                    break
                }
                case 'pay_against_expenditure': {
                    PayFrom = `OAIC`
                    PayTo = `EXPENDITURE`
                    PayFromID = Paymentresult[i].from.split("DS-")[1]
                    PayToID = Paymentresult[i].to
                    break
                }
                case 'advanceCustomerBill': {
                    PayFrom = `CUSTOMER`
                    PayTo = `OAIC`
                    PayFromID = Paymentresult[i].from.split("CS-")[1]
                    PayToID = Paymentresult[i].to.split("DS-")[1]
                    break
                }
                case 'customerPaymentAgainstInvoice': {
                    PayFrom = `CUSTOMER`
                    PayTo = `OAIC`
                    PayFromID = Paymentresult[i].from.split("CS-")[1]
                    PayToID = Paymentresult[i].to.split("DS-")[1]
                    break
                }
                default: {
                    console.log(Paymentresult[i].purpose);
                }
            }
            const query = `UPDATE payment set 
            "PayFrom" = '${PayFrom}',
            "PayTo" = '${PayTo}',
            "PayFromID" = '${PayFromID}',
            "PayToID" = '${PayToID}'
            where transaction_id = '${Paymentresult[i].transaction_id}'`
            db.sequelize.query(query)
            // console.log(query);
            // break
        }
        console.log(`update done`);
        res.send({msg: "done"})
    } catch(e) {
        console.error(e)
        next(createError.InternalServerError())
    }
}
exports.mergeMRNo = async (req, res, next) => {
    try {        
        const newResponse = await db.sequelize.query(`select a.transaction_id, a."MoneyReceiptNo", a."PayToID", a."PayFromID" from "payment" a`)
        const distResult = await db.sequelize.query(`select * from "DistrictMaster"`)
        const districts = distResult[0]
        const result = newResponse[0].filter(e => e.MoneyReceiptNo)
        for(x of result) {
            if(x.MoneyReceiptNo.split('/')[0] == 'MR') {
                const distCode = districts[districts.findIndex(e => e.dist_id == x.PayToID)].DistCode
                const newMRNo = `${distCode}/${x.MoneyReceiptNo}`
                const query = `UPDATE payment set 
                "MoneyReceiptNo" = '${newMRNo}'
                where transaction_id = '${x.transaction_id}'`
                db.sequelize.query(query)
                // console.log(query);
            }
        }
        console.log(`update done`);
        res.send({msg: "done"})
    } catch(e) {
        console.error(e)
        next(createError.InternalServerError())
    }
}
exports.addBank = async (req, res, next) => {

    const bankList = [
        { BankName: 'State Bank of India'  },
        { BankName: 'Bank of Baroda (Including Vijaya Bank and Dena  Bank)' },
        { BankName: 'Bank of India'  },
        { BankName: 'Bank of Maharashtra'  },
        { BankName: 'Canara Bank (Including Syndicate Bank)' },
        { BankName: 'Central Bank of India'  },
        { BankName: 'Indian Bank (Including Allahabad Bank)' },
        { BankName: 'Indian Overseas Bank'  },
        { BankName: 'Punjab National Bank (including Oriental Bank)' },
        { BankName: 'Commerce and United Bank of India)' },
        { BankName: 'Punjab & Sind Bank'  },
        { BankName: 'Union Bank of India (including Andhra Bank and Corporation Bank)' },
        { BankName: 'UCO Bank'  },
        { BankName: 'Axis Bank Ltd.' },
        { BankName: 'Catholic Syrian Bank Ltd.' },
        { BankName: 'City Union Bank Ltd.' },
        { BankName: 'Development Credit Bank Ltd.' },
        { BankName: 'Dhanlaxmi Bank Ltd.' },
        { BankName: 'Federal Bank Ltd.' },
        { BankName: 'HDFC Bank Ltd.' },
        { BankName: 'ICICI Bank Ltd.' },
        { BankName: 'IndusInd Bank Ltd.' },
        { BankName: 'Jammu & Kashmir Bank Ltd.' },
        { BankName: 'Karnataka Bank Ltd.' },
        { BankName: 'Karur Vysya Bank Ltd.' },
        { BankName: 'Kotak Mahindra Bank Ltd.' },
        { BankName: 'IDBI Bank.' }
    ]

    // bankList = bankList.sort((a, b) => (a.BankName > b.BankName) ? 1 : ((b.BankName > a.BankName) ? -1 : 0))
    // console.log(bankList);

    await db.BankMasterModel.bulkCreate(bankList);
    res.send('DONE');
}
exports.removeUserTableData = async (req, res, next) => {

    const response = await db.sequelize.query(`SELECT * from "users"`)
    const result = response[0].filter(e => e.role == 'dealer')
    for(x of result) {
        const query = `DELETE from "users" WHERE user_id='${x.user_id}'`
        // console.log(query);
        await db.sequelize.query(query)
        // break
    }
    res.send('DONE');
}
exports.mergeCustomerInvoiceData = async (req, res, next) => {

    const POResponse = await db.sequelize.query(`SELECT A.*, 
    B.permit_no, B.farmer_father_name, B.gp_name, B.farmer_name, B.farmer_id, B."FullCost", B.block_name, B.dist_name, B.village_name
    FROM "POMaster" A
    INNER JOIN orders B ON A."OrderReferenceNo" = B.permit_no WHERE "POType"='Subsidy' AND "IsDeliveredToCustomer"=true`)
    const InvoiceResponse = await db.sequelize.query(`SELECT * from "CustomerInvoiceMaster" WHERE "POType"='Subsidy'`)
    const invoiceResult = InvoiceResponse[0]
    const result = POResponse[0].filter(e => !invoiceResult.map(el => el.OrderReferenceNo).includes(e.OrderReferenceNo) )
    console.log(POResponse[0].length, InvoiceResponse[0].length, result.length);

    adInvoice(result)
    res.send('DONE');
}
const adInvoice = async (data) => {
        const orderList = data;
        const fin_year = '2021-22';
        const max = await db.sequelize.query(`SELECT max(cast(substr("CustomerInvoiceNo", 16, length("CustomerInvoiceNo")) as int )) from "CustomerInvoiceMaster" where "FinYear"='${fin_year}'`);
        const CustomerInvoiceNo = max[0][0].max == null ? `SLR/IN/${fin_year}/1` : `SLR/IN/${fin_year}/${(parseInt(max[0][0].max) + 1)}`;

        const invoiceAmount = orderList.reduce((a, b) => a + +b.TotalSellInvoiceValue, 0);
        orderList.forEach((e, i) => {
            e.CustomerInvoiceNo = CustomerInvoiceNo;
            if (e.POType == 'Subsidy')
                e.MRRNo = e.MRRID

            e.NoOfOrderDeliver = orderList.length
            e.FinYear = fin_year;
            e.InsertedBy = e.AccID;
            e.DistrictID = e.DistrictID;
            e.AccID = e.AccID;
            e.DMID = e.DMID;
            e.InsertedDate = new Date();
            e.InvoiceAmount = invoiceAmount;
            e.OrderReferenceNo = e.POType == 'Subsidy' ? e.permit_no : `OrderReferenceNo-${i + 1}`
            // console.log(e);
        })
        const result = await db.CustomerInvoiceMasterModel.bulkCreate(orderList);
        // console.log(result);
        return true

}
exports.removeMergeCusInvoiceData = async (req, res, next) => {

    const previousDay = new Date().setDate(new Date().getDate() - 1)
    const POResponse = await db.sequelize.query(`SELECT * FROM "CustomerInvoiceMaster" WHERE "InsertedDate" > '${new Date(previousDay).toDateString()}'`)
    const result = POResponse[0]
    for(x of result) {
        if(x.InsertedDate.toLocaleString() == '11/16/2021, 10:44:54 AM') {
            const query = `DELETE FROM "CustomerInvoiceMaster" WHERE "CustomerInvoiceNo"='${x.CustomerInvoiceNo}' AND "OrderReferenceNo"='${x.OrderReferenceNo}' AND "PONo"='${x.PONo}'`
            const poQuery = `UPDATE "POMaster" SET "IsDeliveredToCustomer"='false' WHERE "OrderReferenceNo"='${x.OrderReferenceNo}' AND "PONo"='${x.PONo}'`
            await db.sequelize.query(query)
            await db.sequelize.query(poQuery)
            // console.log(x.DistrictID);
            // break
        }

    }

    res.send('DONE');
}


async function removeUserTableData() {
    try {
        const previousDay = new Date().setDate(new Date().getDate() - 1)
        const POResponse = await db.sequelize.query(`SELECT * FROM "CustomerInvoiceMaster" WHERE "InsertedDate" > '${new Date(previousDay).toDateString()}'`)
        const result = POResponse[0]
        console.log(result.length);
        for(x of result) {
            if(x.InsertedDate.toLocaleString() == '11/16/2021, 10:44:54 AM') {
                const query = `DELETE FROM "CustomerInvoiceMaster" WHERE "CustomerInvoiceNo"='${x.CustomerInvoiceNo}' AND "OrderReferenceNo"='${x.OrderReferenceNo}' AND "PONo"='${x.PONo}'`
                const poQuery = `UPDATE "POMaster" SET "IsDeliveredToCustomer"='false' WHERE "OrderReferenceNo"='${x.OrderReferenceNo}' AND "PONo"='${x.PONo}'`
                await db.sequelize.query(query)
                await db.sequelize.query(poQuery)
                console.log(query);
                // break
            }

        }
        console.log(`update done`);
    } catch(e) {
        console.error(e);
    }

}
removeUserTableData()