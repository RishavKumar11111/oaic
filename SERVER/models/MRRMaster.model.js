const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class MRRMasterModel extends Model {}

MRRMasterModel.init({
    MRRNo: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
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
    FinYear: {
        type: DataTypes.STRING,
        allowNull: false
    },
    ItemQuantity: {
        type: DataTypes.INTEGER,
        allowNull: true
    },
    MRRAmount: {
        type: DataTypes.INTEGER,
        allowNull: true
    },
    NoOfItemReceived: {
        type: DataTypes.STRING,
        allowNull: true
    },
    VendorID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    DistrictID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    DMID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    AccID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    PaymentStatus: {
        type: DataTypes.STRING,
        defaultValue: 'Pending',
        allowNull: true
    },
    POType: {
        type: DataTypes.STRING,
        allowNull: true
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
    ReceivedQuantity: {
        type: DataTypes.INTEGER,
        allowNull: true
    }
}, {
    sequelize,
    modelName: 'MRRMasterModel',
    tableName: 'MRRMaster',
    timestamps: false
});


module.exports = MRRMasterModel;