const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

const DLMasterModel = require('./VendorMaster.model');

class VendorBankAccountModel extends Model {}

VendorBankAccountModel.init({
    VendorID: {
        type: DataTypes.STRING,
        allowNull: false,
        references: {
            model: DLMasterModel,
            key: 'VendorID'
        }
    },
    BankAccountID: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
        allowNull: false
    },
    AccountNumber: {
        type: DataTypes.STRING,
        allowNull: false
    },
    AccountType: {
        type: DataTypes.STRING,
        allowNull: false
    },
    BankName: {
        type: DataTypes.STRING,
        allowNull: false
    },
    BranchName: {
        type: DataTypes.STRING,
        allowNull: false
    },
    IFSCCode: {
        type: DataTypes.STRING,
        allowNull: false
    },
    BankDocument: {
        type: DataTypes.STRING,
        allowNull: false
    },
    InsertedDate: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        allowNull: false
    }, 
    InsertedBy: {
        type: DataTypes.STRING,
        allowNull: false
    },
    UpdatedDate: {
        type: DataTypes.DATE,
        allowNull: true
    }, 
    UpdatedBy: {
        type: DataTypes.STRING,
        allowNull: true
    }
}, {
    sequelize,
    modelName: 'VendorBankAccountModel',
    tableName: 'VendorBankAccount',
    timestamps: false
});

VendorBankAccountModel.belongsTo(DLMasterModel, { foreignKey: 'VendorID' });

module.exports = VendorBankAccountModel;