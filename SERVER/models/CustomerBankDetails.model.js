const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class CustomerBankAccountModel extends Model {}

CustomerBankAccountModel.init({

    CustomerID: {
        type: DataTypes.STRING,
        allowNull: true,
        // references: {
        //     model: DLMasterModel,
        //     key: 'CustomerID'
        // }
    },
    BankAccountID: {
        type: DataTypes.INTEGER,
        // autoIncrement: true,
        // primaryKey: true,
        allowNull: true
    },
    bankAccountNo: {
        type: DataTypes.STRING,
        allowNull: false
    },
    accountType: {
        type: DataTypes.STRING,
        allowNull: false
    },
    bankName: {
        type: DataTypes.STRING,
        allowNull: false
    },
    branchName: {
        type: DataTypes.STRING,
        allowNull: false
    },
    ifscCode: {
        type: DataTypes.STRING,
        allowNull: false
    },
    // BankDocument: {
    //     type: DataTypes.STRING,
    //     allowNull: false
    // },
    InsertedDate: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        allowNull: false
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
    }
}, {
    sequelize,
    modelName: 'CustomerBankAccountModel',
    tableName: 'CustomerBankAccount',
    timestamps: false
});

// CustomerBankAccountModel.belongsTo(DLMasterModel, { foreignKey: 'CustomerID' });
// CustomerMasterModel.belongsTo(DLMasterModel, { foreignKey: 'CustomerID' });
// CustomerMasterModel.belongsTo(StateMasterModel, { foreignKey: 'StateCode' });

module.exports = CustomerBankAccountModel;