const { pool, sequelize, Op, db } = require('../config/config');
const LogModel = require('../models/Log.model');
const logBal = require('./log.controller');
const requestIP = require('request-ip');
const UAParser = require('ua-parser-js');
const parser = new UAParser();
const multer = require('multer');
const path = require('path');
const createError = require('http-errors');

function getCurrentFinYear() {
        const year = new Date().getFullYear().toString();
        const month = new Date().getMonth();
        const finYear = month >= 3 ? year + "-" + (parseInt(year.slice(2, 4)) + 1).toString() : (parseInt(year) - 1).toString() + "-" + year.slice(2, 4);
        return finYear;
}
exports.getAllDistricts = async (req, res, next) => {
    try {
        const result = await db.DistrictMaster.findAll({ 
            order: [ ['dist_name', 'ASC'] ],
            raw: true 
        } );
        return res.send(result);
    } catch (e) {
        console.error(e);
        return next(createError.InternalServerError());
    }
}
exports.getDMList = async (req, res, next) => {
        try {
            let response = await db.DMMaster.findAll({
                order: [ ['dist_name', 'ASC'] ],
                raw: true 
            });
            return res.send(response);
        } catch (e) {
            console.error(e);
            return next(createError.InternalServerError());
        }
}
exports.modifyDMDetail = async (req, res, next) => {
        try {
            const data = req.body.u_data;
            const updateQuery = {
                dm_name: data.name,
                dm_address: data.address,
                dm_mobile_no: data.mobile_no,
                EmailID: data.EmailID,
                BankName: data.BankName,
                BranchName: data.BranchName,
                AccountNumber: data.AccountNumber,
                IFSCCode: data.IFSCCode,
                UpdateBy: req.payload.user_id,
                UpdateOn: new Date()
            };
            const condition = { dm_id: req.body.dm_id };
            const result = await db.DMMaster.update(updateQuery, { where: condition });
            await db.AccountantMaster.update({acc_address: data.address, UpdateOn: new Date(), UpdateBy: req.payload.user_id}, {
                where: {  dist_id: req.body.DistrictID }
            })
            res.send(result[0] ? true : false);
            logBal.addAuditLog(req.payload.user_id, "Update DM detail.", "success", 'Successfully updated DM details.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        } catch (e) {
            next(createError.InternalServerError());
            console.error(e);
            logBal.addAuditLog(req.payload.user_id, "Update DM detail.", "failure", 'Failed to update DM details.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        }
}
exports.getAccList = async (req, res, next) => {
        try {
                const result = await db.AccountantMaster.findAll({ 
                    order: [ ['dist_name', 'ASC'] ],
                    raw: true 
                } );
                res.send(result);
        } catch (e) {
            next(createError.InternalServerError());
            console.error(e);
        }
}
exports.modifyAccDetail = async (req, res, next) => {
        try {
            const data = req.body.u_data;
            const updateQuery = {
                acc_name: data.acc_name,
                acc_address: data.acc_address,
                acc_mobile_no: data.acc_mobile_no,
                UpdateBy: req.payload.user_id
            };
            const condition = { acc_id: req.body.acc_id };
            const result = await db.AccountantMaster.update(updateQuery, { where: condition });
            await db.DMMaster.update({dm_address: data.acc_address, UpdateOn: new Date(), UpdateBy: req.payload.user_id}, {
                where: {  dist_id: req.body.DistrictID }
            })
            res.send(result[0] ? true : false);
            logBal.addAuditLog(req.payload.user_id, "Update Accountant detail.", "success", 'Successfully updated Accountant details.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        } catch (e) {
            console.error(e);
            next(createError.InternalServerError());
            logBal.addAuditLog(req.payload.user_id, "Update Accountant detail.", "failure", 'Failed to update Accountant details.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        }
}
exports.getAllDlList = async (req, res, next) => {
        try {
            const result = await db.VendorMaster.findAll({ 
                order: [ ["LegalBussinessName", 'ASC'] ],
                where: {
                    ApprovalStatus: 'Approved'
                },
                attributes: ['VendorID', "LegalBussinessName", 'EmailID', 'ContactNumber', 'TradeName', 'PAN'],
                raw: true 
            } );
            res.send(result);
        } catch (e) {
            next(createError.InternalServerError());
            console.error(e);
        }
}
exports.getDistWiseDealerList = async (req, res, next) => {
    try {
        const dist_id = req.query.dist_id
        let result = await sequelize.query(`select b.* from "VendorDistrictMapping" a inner join dl_master b on b.dl_id = a.dl_id where a.dist_id='${dist_id}'`);
        res.send(result[0]);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);;
    }
}

exports.getDlAllDetailByDlId = (VendorID) => {
    return new Promise( async (resolve, reject) => {
        try {
                    const venderDetails = await db.VendorMaster.findAll({
                        raw: true,
                        where: { VendorID: VendorID }
                    })
                    const ContactPersonList = await db.VendorContactPerson.findAll({
                        raw: true,
                        where: { VendorID: VendorID }
                    })

                    const PrincipalPlacesList = await db.VendorPrincipalPlace.findAll({
                        raw: true,
                        where: { VendorID: VendorID }
                    })
                    const BankAccountsList = await db.VendorBankAccount.findAll({
                        raw: true,
                        where: { VendorID: VendorID }
                    })
                    const AppliedDistrictList = await db.VendorDistrictMapping.findAll({
                        raw: true,
                        where: { VendorID: VendorID },
                        attributes: [
                            "DistrictID",
                            [db.sequelize.literal('"DistrictMasterModel".dist_name'), 'DistrictName']
                        ],
                        include: [{
                            model: db.DistrictMaster,
                            attributes: []
                        }]
                    })
                    const GoodsOrServicesList = await db.VendorServices.findAll({
                        raw: true,
                        where: { VendorID: VendorID }
                    })
                    const Data = venderDetails[0];
                    Data.ContactPersonList = ContactPersonList;
                    Data.PrincipalPlacesList = PrincipalPlacesList;
                    Data.BankAccountsList = BankAccountsList;
                    Data.AppliedDistrictList = AppliedDistrictList;
                    Data.GoodsOrServicesList = GoodsOrServicesList;
                    resolve(Data)
        } catch(e) {
            console.error(e);
            reject({});
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
            console.error(e);;
        }
}
exports.getAllItemList = async (req, res, next) => {
        try {
            let result = await db.sequelize.query(`SELECT b."DivisionName", a.* FROM "ItemMaster" a
            INNER JOIN "DivisionMaster" b on a."DivisionID" = b."DivisionID"
            order by a."Implement"`);
            res.send(result[0]);
        } catch (e) {
            next(createError.InternalServerError());
            console.error(e);;
        }
}
exports.updateItemDetail = async (req, res, next) => {
        try {
            const condition = req.body.originalItem;
            const updateData = req.body.updateData;
            const data = {
                Implement: updateData.Implement,
                Make: updateData.Make,
                Model: updateData.Model,
                DivisionID: updateData.DivisionID,
                HSN: updateData.HSN,
                UnitOfMeasurement: updateData.UnitOfMeasurement,
                GSTApplicability: updateData.GSTApplicability,
                Taxability: updateData.Taxability,
                TaxRate: updateData.TaxRate,
                PurchaseInvoiceValue: updateData.PurchaseInvoiceValue,
                PurchaseTaxableValue: updateData.PurchaseTaxableValue,
                PurchaseCGST: updateData.PurchaseCGST,
                PurchaseSGST: updateData.PurchaseSGST,
                PurchaseIGST: updateData.PurchaseIGST,
                PurchaseSGSTOnePercent: (parseFloat(updateData.PurchaseTaxableValue)/100).toFixed(2),
                PurchaseCGSTOnePercent: (parseFloat(updateData.PurchaseTaxableValue)/100).toFixed(2),
                SellCGST: updateData.SellCGST,
                SellSGST: updateData.SellSGST,
                SellIGST: updateData.SellIGST,
                SellInvoiceValue: updateData.SellInvoiceValue,
                SellTaxableValue: updateData.SellTaxableValue,
                UpdatedDate: new Date(),
                UpdateBy: req.payload.user_id
            }
            await db.ItemMasterModel.update(data, { where: condition });

            await db.ItemPackageMasterModel.destroy({ where: condition });
            const packageList = updateData.packagesList.map(e => {
                e.DivisionID = updateData.DivisionID;
                e.Implement = updateData.Implement;
                e.Make = updateData.Make;
                e.Model = updateData.Model;
                e.InsertedBy = req.payload.user_id;
                return e;
            })
            await db.ItemPackageMasterModel.bulkCreate(packageList);
            res.send(true);
            logBal.addAuditLog(req.payload.user_id, "Update item.", "success", 'Successfully update item.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
            console.error(e);
            next(createError.InternalServerError());
            logBal.addAuditLog(req.payload.user_id, "Update item.", "failure", 'Failed to update item.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        }
}
exports.removeItem = async (req, res, next) => {
        try {
            const Implement = req.body.Implement;
            const Make = req.body.Make;
            const Model = req.body.Model;
            await db.ItemMasterModel.destroy({
                where: {
                    Implement: Implement,
                    Make: Make,
                    Model: Model
                }
            })
            await db.ItemPackageMasterModel.destroy({
                where: {
                    Implement: Implement,
                    Make: Make,
                    Model: Model
                }
            })
            res.send(true);
            logBal.addAuditLog(req.payload.user_id, "Remove item.", "success", 'Successfully removed item detail.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        } catch (e) {
            next(createError.InternalServerError());
            console.error(e);
            logBal.addAuditLog(req.payload.user_id, "Remove item.", "failure", 'Failed to remove item detail.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
        }
}
exports.addItem = async (req, res, next) => {
        try {
            const data = req.body;
            data.PurchaseSGSTOnePercent = (parseFloat(data.PurchaseTaxableValue)/100).toFixed(2);
            data.PurchaseCGSTOnePercent = (parseFloat(data.PurchaseTaxableValue)/100).toFixed(2);
            data.InsertedBy = req.payload.user_id;
            // data.implement = data.Implement;
            // data.make = data.Make;
            // data.model = data.Model;
            await db.ItemMasterModel.create(data);
            const packageList = data.packagesList.map(e => {
                e.DivisionID = data.DivisionID;
                e.Implement = data.Implement;
                e.Make = data.Make;
                e.Model = data.Model;
                e.InsertedBy = req.payload.user_id;
                return e;
            })
            await db.ItemPackageMasterModel.bulkCreate(packageList);
            res.send(true);
            logBal.addAuditLog(req.payload.user_id, "Add new item.", "success", 'Successfully added new item.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
            console.error(e);
            next(createError.InternalServerError());
            logBal.addAuditLog(req.payload.user_id, "Add new item.", "failure", 'Failed to add new item.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
}
exports.updateDealerDetail = (dl_id, dl, distList, itemList) => {
    return new Promise( async (resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            await client.query('BEGIN');
            let fin_year = getCurrentFinYear();
            let queryText = `UPDATE "VendorMaster" SET modify_date='NOW()', "LegalBussinessName"='${dl.dl_name}', bank_name='${dl.bank_name}', dl_ac_no='${dl.dl_ac_no}', dl_ifsc_code='${dl.dl_ifsc_code}', dl_mobile_no='${dl.dl_mobile_no}', dl_email='${dl.dl_email}', dl_address='${dl.dl_address}' 
            where dl_id='${dl_id}'`;
            let update_dl_master = client.query(queryText);
            
            await client.query(`DELETE FROM dist_dealer_mapping where dl_id = '${dl_id}'`);
            let queryText2 = `insert into dist_dealer_mapping (fin_year, dl_id, dist_id) values `;
            distList.forEach(dist => {
                queryText2 += `('${fin_year}', '${dl_id}', '${dist.dist_id}'), `;
            });
            let update_dist_dealer_mapping = client.query(queryText2.substring(0, queryText2.length - 2));

            await client.query(`DELETE FROM dl_item_map where dl_id = '${dl_id}'`);
            let queryText3 = `insert into dl_item_map (fin_year, dl_id, implement, make, model) values `;
            itemList.forEach(item => {
                queryText3 += `('${fin_year}', '${dl_id}', '${item.implement}', '${item.make}', '${item.model}'), `;
            });
            await client.query(queryText3.substring(0, queryText3.length - 2));
            await update_dl_master;
            await update_dist_dealer_mapping;
            await client.query('COMMIT');
            resolve(true);
        } catch (e) {
            await client.query('ROLLBACK');
            reject(false);
            console.error(e);;
        } finally {
            client.release();
        }
    });
}
exports.removeDealer = async (req, res, next) => {
        try {
            const VendorID = req.body.VendorID;
            let dist_dl_map =  db.sequelize.query(`DELETE FROM dist_dealer_mapping where 'VendorID' = '${VendorID}'`);
            let dl_item_map =  db.sequelize.query(`DELETE FROM dl_item_map where 'VendorID' = '${VendorID}'`);

            await db.VendorContactPerson.destroy({ where: { VendorID: VendorID } });
            await db.VendorPrincipalPlace.destroy({ where: { VendorID: VendorID } });
            await db.VendorServices.destroy({ where: { VendorID: VendorID } });
            await db.VendorBankAccount.destroy({ where: { VendorID: VendorID } });
            await db.VendorDistrictMapping.destroy({ where: { VendorID: VendorID } });

            const VendorEMailID = await db.VendorMaster.findByPk(VendorID, {raw: true, attributes: ['EmailID']});
            await db.Users.destroy({ where: { user_id: VendorEMailID.EmailID } });
            await db.VendorMaster.destroy({ where: { VendorID: VendorID } });
            await dist_dl_map;
            await dl_item_map;

            res.send(true);
            logBal.addAuditLog(req.payload.user_id, "Remove Vendor.", "success", 'Successfully removed vendor detail.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
            console.error(e);
    } catch (e) {
            console.error(e);
            logBal.addAuditLog(req.payload.user_id, "Remove Vendor.", "failure", 'Failed to remove vendor detail.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
            next(createError.InternalServerError());
        }
}
exports.getAllImplementsForAddItem = async (req, res, next) => {
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
exports.getAvlMakesForAddItem = async (req, res, next) => {
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

// ============================================================== RECEIVE PAYMENT PART START ==============================================================

exports.getAllSource = async (req, res, next) => {
        try {
            let response = await sequelize.query(`SELECT * FROM source_master`);
            res.send(response[0]);
        } catch (e) {
            next(createError.InternalServerError());
            console.error(e);
        }
}
exports.getAllSchema = async (req, res, next) => {
        try {
            let response = await sequelize.query(`SELECT * FROM schem_master`);
            res.send(response[0]);
        } catch (e) {
            next(createError.InternalServerError());
            console.error(e);
        }
}
exports.getComponentsOfSchema = async (req, res, next) => {
        try {
            const schemaId = req.query.schemaId;
            let response = await sequelize.query(`select * from components where schema_id = '${schemaId}'`);
            res.send(response[0]);
        } catch (e) {
            next(createError.InternalServerError());
            console.error(e);
        }
}
exports.addReceivedPayment = (payment_data, desc_data) => {
    return new Promise( async (resolve, reject) => {
        const client = await pool.connect().catch(e => { reject("Database Connection Error!!!!!") });
        try {
            let system;
            switch (desc_data.schem_id) {
                case "1": {
                    system = 'farm_mechanisation'
                    break;
                }
                case "2": {
                    system = 'jalanidhi'
                    break;
                }
            }
            await client.query('BEGIN');
            let max = await client.query(`SELECT MAX(sl_no) from payment`);
            let fin_year = getCurrentFinYear();
            let transction_id = max.rows.length == 0 ? 'YR' + fin_year + '-OD' + '-1' : 'YR' + fin_year + '-OD' + '-' + (max.rows[0].max + 1);
            let from = `dept-${payment_data.source_id}`;
            let queryText = `INSERT INTO payment(fin_year, date, transaction_id, reference_no, system, purpose, "from", "to", ammount, payment_date, payment_type, payment_no, remark) VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)`;
            let values = [fin_year, 'NOW()', transction_id, payment_data.ref_no, system, 'received_from_dept', from, "ADMIN", payment_data.amount, new Date(payment_data.payment_date), payment_data.payment_mode, payment_data.payment_no, payment_data.remark];
            let addPayment = client.query(queryText, values);

            let queryText2 = `INSERT INTO dept_expenditure_payment_desc(reference_no, transaction_id, source_id, schem_id, comp_id) VALUES($1, $2, $3, $4, $5)`;
            let values2 = [desc_data.ref_no, transction_id, desc_data.source_id, desc_data.schem_id, desc_data.comp_id];
            await client.query(queryText2, values2);
            await addPayment;
            await client.query('COMMIT');
            resolve(true);
        } catch (e) {
            await client.query('ROLLBACK');
            reject("SERVER ERROR.");
            console.error(e);
        } finally {
            client.release();
        }
    });
}
exports.getDateWiseAuditLogData = async (req, res, next) => {
        try {
            const data = req.body;
            const result = await LogModel.findAll(
                {
                    where: {
                        date_time: {
                            [Op.lte]: new Date(data.toDate),
                            [Op.gte]: new Date(data.fromDate)
                        }
                    },
                    order:[
                        ['date_time', 'DESC']
                    ],
                    raw: true
                }
            );
            res.send(result);
        } catch (e) {
            res.status(500).send(e)
            console.error(e);
        }
}
exports.getAllAppliedDealerList = async (req, res, next) => {
    try {
        const result = await db.VendorMaster.findAll({ 
            where: {
                IsDeleted: false,
                ApprovalStatus: "Pending"
            },
            order: [ ['LegalBussinessName', 'ASC'] ],
            attributes: ['VendorID', 'InsertedDate', "LegalBussinessName", "TradeName", "BussinessConstitution", "IncorporationDate", "ContactNumber", 'EmailID', 'PAN'],
            raw: true 
        } );
        res.send(result);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.approvDealers = async (req, res, next) => {
    try {
        const VendorIDs = req.body;
        const UsersData = [];

        for(let i = 0; i < VendorIDs.length; i++ ) {
            const getUserPasword = await db.VendorMaster.findAll({
                raw: true,
                attributes: ['Password', 'EmailID'],
                where: {
                    VendorID: VendorIDs[i]
                }
            })
            UsersData.push({ user_id: getUserPasword[0].EmailID, password: getUserPasword[0].Password, role: 'Vendor' })
        }
        
        const updateQuery = {
            ApprovalStatus: "Approved",
            ApproveOrRejectDate: new Date(),
            ApproveOrRejectBy: req.payload.user_id
        };
        const condition = { VendorID: VendorIDs };
        await db.VendorMaster.update(updateQuery, { where: condition });
        await db.Users.bulkCreate(UsersData);
        res.send(true);
        logBal.addAuditLog(req.payload.user_id, "Update DM detail.", "success", 'Successfully updated DM details.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
        logBal.addAuditLog(req.payload.user_id, "Update DM detail.", "failure", 'Failed to update DM details.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
}
exports.rejectDealers = async (req, res, next) => {
    try {
        const DealerIDs = req.body;
        const updateQuery = {
            ApprovalStatus: "Reject",
            ApproveOrRejectDate: new Date(),
            ApproveOrRejectBy: req.payload.user_id
        };
        const condition = { VendorID: DealerIDs };
        const result = await db.VendorMaster.update(updateQuery, { where: condition });
        res.send(result[0] ? true : false);
        logBal.addAuditLog(req.payload.user_id, "Update DM detail.", "success", 'Successfully updated DM details.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
        logBal.addAuditLog(req.payload.user_id, "Update DM detail.", "failure", 'Failed to update DM details.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
    }
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
exports.updateVendorBasicDetails = (req, res, next) => {
    upload(req, res, async err => {
        try {
                if (err) throw err;
                let body = JSON.parse(req.body.Name1);
                const VendorID = req.query.VendorID;
                await db.VendorMaster.update(body, { where: { VendorID: VendorID } });

                const response = {message: 'Basic details updated successfully', isSuccess: true };
                res.send(response);
            } catch (e) {
                res.status(500).send({message: 'Try letter', isSuccess: false });
                console.error(e);
            }
    });
}
exports.updateVendorServices = async (req, res, next) => {
        try {
                const body = req.body;
                const VendorID = req.query.VendorID;
                const serviceDetails = body.serviceDetails;
                let gg = await db.VendorMaster.update(serviceDetails, {
                    where: {
                        VendorID: VendorID
                    }
                });
                const districtList = body.districtList.filter(e => {
                    e.VendorID = VendorID;
                    e.DistrictID = e.dist_id;
                    return e;
                });
                const serviceList = body.servicesList.map(e => {
                    let value = {
                        Service: e,
                        VendorID: VendorID,
                        InsertedBy: req.payload.user_id
                    }
                    return value;
                });
                await db.VendorDistrictMapping.destroy({ where: { VendorID: VendorID } });
                await db.VendorDistrictMapping.bulkCreate(districtList);

                await db.VendorServices.destroy({ where: { VendorID: VendorID } });
                await db.VendorServices.bulkCreate(serviceList);

                const response = {message: 'Vendor Services Updated Successfully', isSuccess: true, userID: VendorID };
                res.send(response);
            } catch (e) {
                res.status(500).send({message: 'Try letter', isSuccess: false });
                console.error(e);
            }
}
exports.updateVendorContactPersonDetails = async (req, res, next) => {
    try {
        const VendorID = req.query.VendorID;
        const contactPeronList = req.body.map(e => {
            e.VendorID = VendorID;
            e.InsertedBy = VendorID;
            return e;
        })
        await db.VendorContactPerson.destroy({ where: { VendorID: VendorID } });
        await db.VendorContactPerson.bulkCreate(contactPeronList);
        
        const response = {message: 'Contact person details updated successfully', isSuccess: true };
        res.send(response);
    } catch (e) {
        res.status(500).send({message: 'Try letter', isSuccess: false });
        console.error(e);
    }
}
exports.updateVendorPrincipalPlaces = async (req, res, next) => {
    try {
        const VendorID = req.query.VendorID;
        const principalPlaceList = req.body.map(e => {
            e.VendorID = VendorID;
            e.InsertedBy = VendorID;
            return e;
        })
        await db.VendorPrincipalPlace.destroy({ where: { VendorID: VendorID } });
        await db.VendorPrincipalPlace.bulkCreate(principalPlaceList);
        
        const response = {message: 'Principlan places are updated successfully', isSuccess: true };
        res.send(response);
    } catch (e) {
        res.status(500).send({message: 'Try letter', isSuccess: false });
        console.error(e);
    }
}
exports.updateVendorBankDetails = async (req, res, next) => {
    try {
        const originalItem = req.body.originalItem;
        const bankDetails = req.body.updateData;
        bankDetails.UpdatedDate = new Date();
        bankDetails.UpdatedBy = req.payload.user_id;
        await db.VendorBankAccount.update(bankDetails, { where: { VendorID: originalItem.VendorID, AccountNumber: originalItem.AccountNumber } });
        
        const response = {message: 'Bank details updated successfully', isSuccess: true };
        res.send(response);
    } catch (e) {
        res.status(500).send({message: 'Try letter', isSuccess: false });
        console.error(e);
    }
}


exports.addCustomerDetails = async (req, res, next) => {
    try {
        
        const data = req.body;
        var CustomerDetails = {};
        var ContactPersonList = [];
        var PrincipalPlaceList = [];
        var BankAccountList = [];
        CustomerDetails.LegalCustomerName = data.CustomerName;
        CustomerDetails.TradeName = data.TradeName;
        CustomerDetails.BussinessConstitution = data.BussinessConstitution;
        CustomerDetails.ContactNumber = data.contactNumber;
        CustomerDetails.EmailID = data.CustomerEmailID;
        CustomerDetails.PAN = data.PANnum;
        CustomerDetails.GSTN = data.GSTNnum;
        CustomerDetails.InsertedBy = req.payload.user_id;
      
        SavedCustomerDetails = await db.CustomerMaster.create(CustomerDetails);
        CustomerID = SavedCustomerDetails.CustomerID;
        
        userID = req.payload.user_id;
        ContactPersonList = data.ContactPersonList.map(e => {
            e.CustomerID = CustomerID;
            e.InsertedBy = userID;
            return e;
        })
        await db.CustomerContactPerson.bulkCreate(ContactPersonList);


        PrincipalPlaceList = data.PrincipalPlaceList.map(e => {
            e.CustomerID = CustomerID;
            e.InsertedBy = userID;
            return e;
        });
        await db.CustomerPrincipalPlace.bulkCreate(PrincipalPlaceList);

        BankAccountList = data.BankAccountList.map(e => {
            e.CustomerID = CustomerID;
            e.InsertedBy = userID;
            return e;
        });
        await db.CustomerBankAccount.bulkCreate(BankAccountList);

        
        const DistrictList = data.DistrictList.map(e => {
            e.CustomerID = CustomerID;
            e.DistrictID = e.dist_id;
            e.InsertedBy = userID;
            return e;
        });
        await db.CustomerDistrictMappingModel.bulkCreate(DistrictList);



        res.send(true);
        
    } catch (e) {
        console.error(e);
        next(createError.InternalServerError());
        // logBal.addAuditLog(req.payload.user_id, "Add new item.", "failure", 'Failed to add new item.', req.originalUrl.split("?").shift(), '/admin', requestIP.getClientIp(req), parser.setUA(req.headers['user-agent']).getBrowser().name, parser.setUA(req.headers['user-agent']).getBrowser().version);
}
}

exports.getCustomerList = async (req,res) => {
    try {
        const result = await db.CustomerMaster.findAll({ 
            raw: true 
        });
        res.send(result);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}

exports.removeCustomer = async (req,res) => {
    try {
        const CustomerID = req.body.CustomerID;

        await db.CustomerMaster.destroy({ where: { CustomerID: CustomerID } });
        await db.CustomerContactPerson.destroy({ where: { CustomerID: CustomerID } });
        await db.CustomerPrincipalPlace.destroy({ where: { CustomerID: CustomerID } });
        await db.CustomerBankAccount.destroy({ where: { CustomerID: CustomerID } });
        res.send(true);
} catch (e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}
exports.getCustomerDetails = async (req, res, next) => {
    try {
        const CustomerID = req.query.CustomerID;
        const result = await db.CustomerMaster.findOne({ 
            raw: true,
            where: {
                CustomerID: CustomerID
            }
        });
        result.ContactPersonList = await db.CustomerContactPerson.findAll({ raw: true, where: { CustomerID: CustomerID } });
        result.PrincipalPlaceList = await db.CustomerPrincipalPlace.findAll({ raw: true, where: { CustomerID: CustomerID } });
        result.BankAccountList = await db.CustomerBankAccount.findAll({ raw: true, where: { CustomerID: CustomerID } });
        result.DistrictList = await db.CustomerDistrictMappingModel.findAll({ 
            raw: true, 
            where: { CustomerID: CustomerID },
            attributes: [
                "DistrictID",
                [db.sequelize.literal('"DistrictMasterModel".dist_name'), 'dist_name']
            ],
            include: [{
                model: db.DistrictMaster,
                attributes: []
            }]
        });
        res.send(result);
    } catch (e) {
        next(createError.InternalServerError());
        console.error(e);
    }
}
exports.updateCustomerDetails = async (req, res, next) => {
    try {
        const CustomerID = req.params.CustomerID;
        const userID = req.payload.user_id;
        const condition = { CustomerID: CustomerID };
        const data = req.body;
        var CustomerDetails = {};
        var ContactPersonList = [];
        var PrincipalPlaceList = [];
        var BankAccountList = [];
        CustomerDetails.LegalCustomerName = data.CustomerName;
        CustomerDetails.TradeName = data.TradeName;
        CustomerDetails.BussinessConstitution = data.BussinessConstitution;
        CustomerDetails.ContactNumber = data.contactNumber;
        CustomerDetails.EmailID = data.CustomerEmailID;
        CustomerDetails.PAN = data.PANnum;
        CustomerDetails.GSTN = data.GSTNnum;
        CustomerDetails.UpdatedDate =  new Date();
        CustomerDetails.UpdateBy =  userID;
      
        await db.CustomerMaster.update(CustomerDetails, { where: condition });
        
        ContactPersonList = data.ContactPersonList.map(e => {
            e.CustomerID = CustomerID;
            e.InsertedBy = userID;
            return e;
        })
        await db.CustomerContactPerson.destroy({ where: condition });
        await db.CustomerContactPerson.bulkCreate(ContactPersonList);


        PrincipalPlaceList = data.PrincipalPlaceList.map(e => {
            e.CustomerID = CustomerID;
            e.InsertedBy = userID;
            return e;
        });
        await db.CustomerPrincipalPlace.destroy({ where: condition });
        await db.CustomerPrincipalPlace.bulkCreate(PrincipalPlaceList);

        BankAccountList = data.BankAccountList.map(e => {
            e.CustomerID = CustomerID;
            e.InsertedBy = userID;
            return e;
        });
        await db.CustomerBankAccount.destroy({ where: condition });
        await db.CustomerBankAccount.bulkCreate(BankAccountList);



        const DistrictList = data.DistrictList.map(e => {
            e.CustomerID = CustomerID;
            e.InsertedBy = userID;
            e.DistrictID = e.dist_id;
            return e;
        });
        await db.CustomerDistrictMappingModel.destroy({ where: condition });
        await db.CustomerDistrictMappingModel.bulkCreate(DistrictList);



        



        res.send(true);
    } catch(e) {
        console.error(e);
        next(createError.InternalServerError());
    }
}