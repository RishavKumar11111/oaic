const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class InvoiceMasterModel extends Model { }

InvoiceMasterModel.init({

    InvoiceNo: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    PONo: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    OrderReferenceNo: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    InvoiceDate: {
        type: DataTypes.DATE,
        allowNull: false
    },
    WayBillNo: {
        type: DataTypes.STRING,
        allowNull: true
    },
    WayBillDate: {
        type: DataTypes.DATE,
        allowNull: true
    },
    TruckNo: {
        type: DataTypes.STRING,
        allowNull: true
    },
    FinYear: {
        type: DataTypes.STRING,
        allowNull: true
    },
    DistrictID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    VendorID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    Status: {
        type: DataTypes.STRING,
        defaultValue: 'notReceived',
        allowNull: true
    },
    PaymentStatus: {
        type: DataTypes.STRING,
        defaultValue: 'pending',
        allowNull: true
    },
    InvoiceAmount: {
        type: DataTypes.STRING,
        allowNull: true
    },
    InvoicePath: {
        type: DataTypes.STRING,
        allowNull: true
    },
    POType: {
        type: DataTypes.STRING,
        allowNull: false
    },
    NoOfOrderInPO: {
        type: DataTypes.STRING,
        allowNull: false
    },
    NoOfOrderDeliver: {
        type: DataTypes.STRING,
        allowNull: false
    },
    InsertedDate: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        allowNull: true
    },
    InsertedBy: {
        type: DataTypes.STRING,
        allowNull: true
    },
    UpdatedDate: {
        type: DataTypes.DATE,
        allowNull: true
    },
    UpdatedBy: {
        type: DataTypes.STRING,
        allowNull: true
    },
    IsReceived: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
        allowNull: true
    },
    ReceivedDate: {
        type: DataTypes.DATE,
        allowNull: true
    },
    EngineNumber: {
        type: DataTypes.STRING,
        allowNull: true
    },
    ChassicNumber: {
        type: DataTypes.STRING,
        allowNull: true
    },
    MRRNo: {
        type: DataTypes.STRING,
        allowNull: true
    },
    TotalPurchaseTaxableValue: {
        type: DataTypes.STRING,
        allowNull: true
    },
    TotalPurchaseInvoiceValue: {
        type: DataTypes.STRING,
        allowNull: true
    },
    TotalPurchaseCGST: {
        type: DataTypes.STRING,
        allowNull: true
    },
    TotalPurchaseSGST: {
        type: DataTypes.STRING,
        allowNull: true
    },
    TotalPurchaseIGST: {
        type: DataTypes.STRING,
        allowNull: true
    },
    SupplyQuantity: {
        type: DataTypes.STRING,
        allowNull: true
    },
    SupplyPackageQuantity: {
        type: DataTypes.STRING,
        allowNull: true
    },
    Discount: {
        type: DataTypes.STRING,
        defaultValue: 0,
        allowNull: true
    }
}, {
    sequelize,
    modelName: 'InvoiceMasterModel',
    tableName: 'InvoiceMaster',
    timestamps: false
});


module.exports = InvoiceMasterModel;