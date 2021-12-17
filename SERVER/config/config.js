const Pool = require('pg').Pool;
const pool = new Pool({
  host: 'localhost',
  port: 5432,
  user: 'postgres',
  database: 'oaic',
  password: "postgres",
  // password: '1234',
  
});
exports.pool = pool;






const { Sequelize, Model, DataTypes } = require('sequelize');
const user = 'postgres';
const host = 'localhost';
const database = 'oaic';

const password = 'postgres'
// const password = '1234';
const port = 5432;
const sequelize = new Sequelize(database, user, password, {
  host,
  port,
  dialect: 'postgres',
  logging: false
})
exports.sequelize = sequelize;
exports.Op = Sequelize.Op;

const db = {};
db.Sequelize = Sequelize;
db.sequelize = sequelize;
db.Model = Model;
db.DataTypes = DataTypes;

db.StateMaster = require('../models/StateMaster.model');
db.VendorContactPerson = require('../models/VendorContactPerson.model');
db.VendorPrincipalPlace = require('../models/VendorPrincipalPlace.model');
db.VendorBankAccount = require('../models/VendorBankAccount.model');
db.VendorServices = require('../models/VendorServices.models');
db.VendorDistrictMapping = require('../models/VendorDistrictMapping.model');
db.VendorMaster= require('../models/VendorMaster.model');
db.Users = require('../models/User.model');
db.DistrictMaster = require('../models/DistrictMaster.model');
db.POMasterModel = require('../models/POMaster.model');
db.PONonSubsidyModel = require('../models/PONonSubsidy.model');
db.InvoiceMaster = require('../models/InvoiceMaster.model');
db.MRRMaster = require('../models/MRRMaster.model');
db.OrderMasterModel = require('../models/Orders.model');
db.ItemMasterModel = require('../models/ItemMaster.model');
db.ItemPackageMasterModel = require('../models/ItemPacketsMaster.model');
db.ItemPackageSizeMasterModel = require('../models/ItemPackageSizeMaster.model');
db.DivisionMaster = require('../models/DivisionMaster.model');
db.AccountantMaster = require('../models/AccMaster.model');
db.DMMaster = require('../models/DMMaster.model');
db.CustomerMaster= require('../models/CustomerMaster.model');
db.CustomerContactPerson = require('../models/CustomerContactPerson.model');
db.CustomerPrincipalPlace = require('../models/CustomerPrincipalPlace.model');
db.CustomerBankAccount = require('../models/CustomerBankDetails.model');
db.CustomerDistrictMappingModel = require('../models/CustomerDistrictMapping.model');
db.CustomerInvoiceMasterModel = require('../models/CustomerInvoiceMaster.model');
db.BankMasterModel = require('../models/BankMaster.model');


exports.db = db;